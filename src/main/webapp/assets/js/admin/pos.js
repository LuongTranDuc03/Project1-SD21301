function showCouponChangedModal(message) {
  document.getElementById("couponChangedMessage").textContent = message;
  document.getElementById("couponChangedModal").classList.add("active");
}

function showCustomAlert(message) {
  document.getElementById("customAlertMessage").textContent = message;
  document.getElementById("customAlertModal").classList.add("active");
}

function closeCustomAlert() {
  document.getElementById("customAlertModal").classList.remove("active");
}

let confirmCallback = null;
function showCustomConfirm(message, callback) {
  document.getElementById("customConfirmMessage").textContent = message;
  confirmCallback = callback;
  document.getElementById("customConfirmModal").classList.add("active");
}

function closeCustomConfirm(result) {
  document.getElementById("customConfirmModal").classList.remove("active");
  if (confirmCallback) {
    confirmCallback(result);
    confirmCallback = null;
  }
}

function getDbStock(variantCode) {
  const row = document.querySelector(
    '.variant-row[data-code="' + variantCode.replace(/"/g, '\\"') + '"]',
  );
  if (row) {
    return parseInt(row.getAttribute("data-stock")) || 0;
  }
  let fallbackStock = 0;
  orders.forEach((o) => {
    if (o.items) {
      o.items.forEach((i) => {
        if (i.code === variantCode && i.stock) fallbackStock = i.stock;
      });
    }
  });
  return fallbackStock;
}

function getAvailableStock(variantCode) {
  return getDbStock(variantCode);
}

function updateAvailableStockDisplay() {
  const rows = document.querySelectorAll(".variant-row");
  rows.forEach((row) => {
    const code = row.getAttribute("data-code");
    const available = getAvailableStock(code);
    // Dùng class 'td-stock' để chọn chính xác cột Số lượng, tránh lỗi index cứng
    const stockTd = row.querySelector(".td-stock");
    if (stockTd) {
      stockTd.textContent = available;
    }
  });
}

// Override default alert globally in this page to catch all alerts
window.alert = showCustomAlert;

let html5QrCode = null;
let isScannerRunning = false;
let torchOn = false;

function startCameraScan() {
  if (!currentOrderId) {
    showCustomAlert("Vui lòng tạo đơn hàng trước khi quét sản phẩm!");
    return;
  }

  if (isScannerRunning) return;

  const modal = document.getElementById("qrCameraModal");
  modal.style.display = "flex";

  html5QrCode = new Html5Qrcode("qrReader");

  const config = {
    fps: 10,
    qrbox: { width: 450, height: 250 },
    aspectRatio: 1.0,
    experimentalFeatures: {
      useBarCodeDetectorIfSupported: true,
    },
    rememberLastUsedCamera: false,
  };

  const onScanSuccess = async (decodedText) => {
    stopCameraScan();
    // Tận dụng hàm addVariantToOrder đã có sẵn trong pos.jsp
    await addVariantToOrder(decodedText, true);
  };

  html5QrCode
    .start({ facingMode: "environment" }, config, onScanSuccess, () => {})
    .then(() => {
      isScannerRunning = true;
    })
    .catch(() => {
      // Nếu camera sau lỗi thì dùng camera trước
      html5QrCode
        .start({ facingMode: "user" }, config, onScanSuccess, () => {})
        .then(() => {
          isScannerRunning = true;
        })
        .catch((err) => {
          console.error("Không mở được camera:", err);
          modal.style.display = "none";
          showCustomAlert(
            "Không thể mở Camera. Vui lòng kiểm tra quyền truy cập.",
          );
        });
    });
}

async function toggleTorch() {
  if (!html5QrCode) return;
  try {
    torchOn = !torchOn;
    await html5QrCode.applyVideoConstraints({ advanced: [{ torch: torchOn }] });
    const btn = document.getElementById("btnToggleTorch");
    btn.textContent = torchOn ? "🔦 Tắt Đèn" : "🔦 Bật Đèn";
    btn.style.background = torchOn ? "#fde047" : "#fef9c3";
  } catch (e) {
    console.log("Torch not supported");
  }
}

function stopCameraScan() {
  const modal = document.getElementById("qrCameraModal");
  modal.style.display = "none";
  isScannerRunning = false;

  if (html5QrCode) {
    const instance = html5QrCode;
    html5QrCode = null;
    instance
      .stop()
      .then(() => instance.clear())
      .catch(() => {
        try {
          instance.clear();
        } catch (e) {}
      });
  }
}

function showPosToast(message, type = "success") {
  const container = document.getElementById("posToastContainer");
  const toast = document.createElement("div");
  toast.className = "pos-toast" + (type !== "success" ? " " + type : "");
  toast.innerHTML = "<span>" + message + "</span>";
  container.appendChild(toast);
  setTimeout(() => {
    toast.style.animation = "posToastFadeOut 0.3s ease forwards";
    setTimeout(() => toast.remove(), 300);
  }, 3000);
}
