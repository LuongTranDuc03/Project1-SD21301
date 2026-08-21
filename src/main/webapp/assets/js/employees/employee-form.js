window.onerror = function (msg, url, line, col, error) {
  console.error("Lỗi JS: ", msg, url, line);
  return false;
};
window.addEventListener("unhandledrejection", function (event) {
  console.error("Lỗi Promise: ", event.reason);
});

let html5QrCode = null;
let isScannerRunning = false;

function startCameraScan() {
  if (isScannerRunning) return;

  const modal = document.getElementById("qrCameraModal");
  modal.style.display = "flex";

  html5QrCode = new Html5Qrcode("qrReader");

  const config = {
    fps: 30,
    qrbox: { width: 300, height: 300 },
    aspectRatio: 1.0,
    experimentalFeatures: {
      useBarCodeDetectorIfSupported: true,
    },
    rememberLastUsedCamera: false,
  };

  const onScanSuccess = (decodedText) => {
    stopCameraScan();
    handleScannedData(decodedText);
  };

  html5QrCode
    .start({ facingMode: "environment" }, config, onScanSuccess, () => {})
    .then(() => {
      isScannerRunning = true;
    })
    .catch(() => {
      html5QrCode
        .start({ facingMode: "user" }, config, onScanSuccess, () => {})
        .then(() => {
          isScannerRunning = true;
        })
        .catch((err2) => {
          console.error("Không mở được camera:", err2);
          modal.style.display = "none";
          Swal.fire({
            icon: "error",
            title: "Không thể mở Camera",
            html: "Vui lòng:<br>• Cho phép trình duyệt truy cập camera<br>• Kiểm tra camera có đang dùng bởi app khác không<br>• Thử tải lại trang (F5)",
            confirmButtonColor: "#3b82f6",
          });
        });
    });
}

let torchOn = false;
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

async function handleScannedData(qrText) {
  try {
    const cccdData =
      typeof parseCccdString === "function"
        ? parseCccdString(qrText)
        : { cccd: qrText };
    await fillCccdData(cccdData);
    Swal.fire({
      icon: "success",
      title: "✅ Thành công!",
      text: "Đã quét và điền thông tin CCCD.",
      timer: 2000,
      showConfirmButton: false,
    });
  } catch (e) {
    console.error(e);
    Swal.fire({
      icon: "warning",
      title: "QR không hợp lệ",
      text: "Mã QR không đúng định dạng CCCD Việt Nam. Vui lòng thử lại.",
      confirmButtonColor: "#3b82f6",
    });
  }
}

async function fillCccdData(data) {
  if (!data) return;
  const safeSet = (selector, value, byId) => {
    const el = byId
      ? document.getElementById(selector)
      : document.querySelector(selector);
    if (el && value !== undefined && value !== null) el.value = value;
  };
  if (data.cccd) safeSet("cccdInput", data.cccd, true);
  if (data.fullName) safeSet('input[name="fullName"]', data.fullName);
  if (data.dob) safeSet('input[name="birthday"]', data.dob);
  if (data.gender !== undefined && data.gender !== null) {
    const radio = document.querySelector(
      'input[name="gender"][value="' + data.gender + '"]',
    );
    if (radio) radio.checked = true;
  }
  if (data.address) {
    await setAddressCascading(data.address);
  }
  validateAllFieldsLive();
}

function previewImage(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      document.getElementById("avatarPreview").src = e.target.result;
    };
    reader.readAsDataURL(input.files[0]);
  }
}
