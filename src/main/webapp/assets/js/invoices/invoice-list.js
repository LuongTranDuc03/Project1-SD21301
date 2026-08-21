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

function applyFilter(trangThai) {
  var hiddenTrangThai = document.getElementById("hiddenTrangThai");
  if (trangThai === null) {
    hiddenTrangThai.disabled = true; // Bỏ trangThai khỏi form (Tất cả)
  } else {
    hiddenTrangThai.disabled = false;
    hiddenTrangThai.value = trangThai;
  }
  clearTimeout(window._searchTimer);
  document.getElementById("searchForm").submit();
}

(function () {
  var input = document.getElementById("searchInput");
  var form = document.getElementById("searchForm");
  if (input && form) {
    // Tự động focus lại vào ô tìm kiếm nếu có giá trị, hoặc vừa tìm kiếm với chuỗi rỗng (xoá hết từ khoá)
    var urlParams = new URLSearchParams(window.location.search);
    if (input.value.length > 0 || urlParams.has("q")) {
      input.focus();
      input.setSelectionRange(input.value.length, input.value.length);
    }

    input.addEventListener("input", function () {
      clearTimeout(window._searchTimer);
      window._searchTimer = setTimeout(function () {
        form.submit();
      }, 450);
    });

    input.addEventListener("keydown", function (e) {
      if (e.key === "Escape") {
        input.value = "";
        clearTimeout(window._searchTimer);
        form.submit();
      }
      if (e.key === "Enter") {
        e.preventDefault();
        clearTimeout(window._searchTimer);
        form.submit();
      }
    });
  }
})();

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
