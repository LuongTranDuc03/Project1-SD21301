// Execute immediately to prevent FOUC (Flash of Unstyled Content)
if (localStorage.getItem("sidebar-collapsed") === "true") {
  document.body.classList.add("sidebar-collapsed");
}

document.addEventListener("DOMContentLoaded", function () {
  const toggleBtn = document.getElementById("sidebar-toggle");

  // Cập nhật icon dựa trên trạng thái hiện tại đã được set bởi inline script phía trên
  if (document.body.classList.contains("sidebar-collapsed")) {
    updateToggleIcon(true);
  }

  toggleBtn.addEventListener("click", function () {
    const collapsedNow = document.body.classList.toggle("sidebar-collapsed");
    localStorage.setItem("sidebar-collapsed", collapsedNow);
    updateToggleIcon(collapsedNow);
  });

  function updateToggleIcon(collapsed) {
    if (collapsed) {
      // Đổi icon sang chevron-right (>) khi bị thu nhỏ
      toggleBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                `;
    } else {
      // Đổi icon sang chevron-left (<) khi mở rộng
      toggleBtn.innerHTML = `
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                `;
    }
  }

  // Quản lý trạng thái mở/đóng của submenu Quản lý sản phẩm
  const productSubmenu = document.getElementById("product-submenu");
  if (productSubmenu) {
    const savedState = localStorage.getItem("product-submenu-open");
    if (savedState === "true") {
      productSubmenu.classList.add("submenu-open");
    } else if (savedState === "false") {
      productSubmenu.classList.remove("submenu-open");
    }
  }

  window.toggleProductSubmenu = function (el, e) {
    const li = el.parentElement;
    // Prevent event from bubbling up if it's a nested toggle
    if (li.id !== "product-submenu" && e) {
      e.stopPropagation();
    }
    const isNowOpen = li.classList.toggle("submenu-open");
    localStorage.setItem("product-submenu-open", isNowOpen);
  };

  // Quản lý trạng thái mở/đóng của submenu Quản lý thuộc tính
  const attributeSubmenu = document.getElementById("attribute-submenu");
  if (attributeSubmenu) {
    const savedState = localStorage.getItem("attribute-submenu-open");
    if (savedState === "true") {
      attributeSubmenu.classList.add("submenu-open");
    } else if (savedState === "false") {
      attributeSubmenu.classList.remove("submenu-open");
    }
  }

  window.toggleAttributeSubmenu = function (el, e) {
    // Prevent triggering the parent product-submenu toggle
    if (e) e.stopPropagation();
    const li = el.parentElement;
    const isNowOpen = li.classList.toggle("submenu-open");
    localStorage.setItem("attribute-submenu-open", isNowOpen);
  };

  // Quản lý trạng thái mở/đóng của submenu Thống kê
  const statsSubmenu = document.getElementById("stats-submenu");
  if (statsSubmenu) {
    const savedStatsState = localStorage.getItem("stats-submenu-open");
    if (savedStatsState === "true") {
      statsSubmenu.classList.add("submenu-open");
    } else if (savedStatsState === "false") {
      statsSubmenu.classList.remove("submenu-open");
    }
  }

  window.toggleStatsSubmenu = function (el) {
    const li = el.parentElement;
    const isNowOpen = li.classList.toggle("submenu-open");
    localStorage.setItem("stats-submenu-open", isNowOpen);
  };
});
