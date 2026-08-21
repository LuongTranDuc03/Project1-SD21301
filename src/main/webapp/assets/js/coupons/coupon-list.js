// Khởi tạo ngày giờ hiện tại cho UI
(function () {
  var d = new Date();
  var days = [
    "Chủ Nhật",
    "Thứ Hai",
    "Thứ Ba",
    "Thứ Tư",
    "Thứ Năm",
    "Thứ Sáu",
    "Thứ Bảy",
  ];
  var dd = String(d.getDate()).padStart(2, "0");
  var mm = String(d.getMonth() + 1).padStart(2, "0");
  var el = document.getElementById("currentDate");
  if (el)
    el.textContent =
      days[d.getDay()] + ", " + dd + "/" + mm + "/" + d.getFullYear();
})();

// Xử lý tìm kiếm với delay (debounce)
(function () {
  var input = document.getElementById("searchInput");
  var form = document.getElementById("searchForm");
  var timer = null;

  if (input && form) {
    // Tự động focus lại vào ô tìm kiếm nếu có giá trị, hoặc vừa tìm kiếm với chuỗi rỗng (xoá hết từ khoá)
    var urlParams = new URLSearchParams(window.location.search);
    if (input.value.length > 0 || urlParams.has("q")) {
      input.focus();
      input.setSelectionRange(input.value.length, input.value.length);
    }

    input.addEventListener("input", function () {
      clearTimeout(timer);
      timer = setTimeout(function () {
        form.submit();
      }, 450);
    });

    input.addEventListener("keydown", function (e) {
      if (e.key === "Escape") {
        input.value = "";
        clearTimeout(timer);
        form.submit();
      }
      if (e.key === "Enter") {
        e.preventDefault();
        clearTimeout(timer);
        form.submit();
      }
    });
  }
})();

// Xử lý tự động ẩn thông báo thành công sau 3 giây
(function () {
  var banner = document.getElementById("toastSuccess");
  if (banner)
    setTimeout(function () {
      banner.style.transition = "opacity .4s";
      banner.style.opacity = "0";
      setTimeout(function () {
        banner.remove();
      }, 450);
    }, 3000);
})();

// Thu gọn/mở rộng card bộ lọc
function toggleFilterCard() {
  const body = document.getElementById("filterCardBody");
  const btn = document.getElementById("toggleFilterBtn");
  if (body.classList.contains("collapsed")) {
    body.classList.remove("collapsed");
    btn.textContent = "Nhấn để thu gọn";
  } else {
    body.classList.add("collapsed");
    btn.textContent = "Nhấn để mở rộng";
  }
}

// Hiển thị thông báo lỗi bằng toast
function showErrorToast(msg) {
  if (window.showToast) {
    window.showToast(msg, "error");
  } else {
    alert(msg);
  }
}

function toggleCouponStatus(couponId, isExpired, checkboxEl) {
  const isChecked = checkboxEl.checked;
  const willBeChecked = !isChecked; // Mong muốn thay đổi do đã bị preventDefault chặn

  if (isExpired && willBeChecked) {
    showErrorToast(
      "Phiếu giảm giá đã hết hạn, vui lòng gia hạn trước khi kích hoạt!",
    );
    return;
  }

  const targetStatusText = willBeChecked ? "hoạt động" : "vô hiệu hóa";

  Swal.fire({
    title: "Xác nhận",
    text:
      "Bạn có muốn thay đổi trạng thái của phiếu giảm giá thành " +
      targetStatusText +
      " hay không?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#3B82F6",
    cancelButtonColor: "#94A3B8",
    confirmButtonText: "Đồng ý",
    cancelButtonText: "Hủy",
  }).then((result) => {
    if (result.isConfirmed) {
      checkboxEl.checked = willBeChecked;
      // Đợi animation chạy xong (0.2s) rồi mới submit form
      setTimeout(() => {
        document.getElementById("toggleForm-" + couponId).submit();
      }, 250);
    }
  });
}
