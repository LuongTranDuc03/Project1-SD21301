function toggleFilterCard() {
  var filterCardBody = document.getElementById("filterCardBody");
  var btn = document.getElementById("toggleFilterBtn");
  if (filterCardBody.classList.contains("collapsed")) {
    filterCardBody.classList.remove("collapsed");
    btn.innerHTML = "Nhấn để thu gọn";
  } else {
    filterCardBody.classList.add("collapsed");
    btn.innerHTML = "Nhấn để mở rộng";
  }
}

document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.getElementById("searchQuery");
  if (searchInput) {
    // Focus lại ô tìm kiếm nếu trước đó vừa thao tác tìm kiếm
    if (sessionStorage.getItem("inventorySearchFocused") === "true") {
      searchInput.focus();
      const val = searchInput.value;
      if (val) {
        // Đưa con trỏ chuột về cuối văn bản
        searchInput.setSelectionRange(val.length, val.length);
      }
      // Xoá cờ để không bị focus mãi nếu người dùng chuyển tab/tải lại trang tự nhiên
      sessionStorage.removeItem("inventorySearchFocused");
    }

    // Debounce live search
    let debounceTimer = null;
    searchInput.addEventListener("input", function () {
      // Lưu trạng thái đang focus để khi trang load lại vẫn giữ được focus
      sessionStorage.setItem("inventorySearchFocused", "true");

      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(function () {
        document.getElementById("invFilterForm").submit();
      }, 500); // Đợi 500ms sau khi ngừng gõ mới submit
    });
  }
});
