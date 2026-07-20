<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.huy.Employee" %>
<%
    // Lấy URI hiện tại để so sánh và set active class cho menu
    String uri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    if (uri == null) {
        uri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    }
    if (uri == null) {
        uri = request.getRequestURI();
    }
    String contextPath = request.getContextPath();
%>
<style>
    .has-submenu .submenu {
        display: none;
        list-style: none;
        padding-left: 40px;
        margin: 4px 0 0 0;
    }
    .has-submenu.submenu-open .submenu {
        display: block;
    }
    .has-submenu.submenu-open .chevron-icon {
        transform: rotate(180deg);
    }
    .submenu li {
        margin-bottom: 4px;
    }
    .submenu a {
        display: block;
        padding: 8px 12px;
        color: #94a3b8;
        text-decoration: none;
        font-size: 13.5px;
        border: 1px solid transparent;
        border-radius: 6px;
        transition: all 0.2s;
    }
    .submenu a:hover {
        color: #ffffff;
        background-color: rgba(255, 255, 255, 0.05);
    }
    body.sidebar-collapsed .submenu {
        display: none !important;
    }
    body.sidebar-collapsed .chevron-icon {
        display: none !important;
    }
</style>
<aside class="sidebar">
    <!-- 1. Brand Header -->
    <div class="sidebar-header">
        <div class="brand">
            <div class="brand-logo">
                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20.38 3.46L16 2.14a2 2 0 0 0-1.16 0l-4.38 1.32a2 2 0 0 1-1.16 0L4.92 2.14a2 2 0 0 0-2.4 1.77L2 14a8 8 0 0 0 8 8h4a8 8 0 0 0 8-8l-.52-10.09a2 2 0 0 0-1.1-1.45z"></path>
                </svg>
            </div>
            <div class="brand-name">
                <h3>FamiCoats</h3>
                <span>Admin Panel</span>
            </div>
        </div>
        <button class="toggle-btn" id="sidebar-toggle" title="Thu gọn / Mở rộng Sidebar">
            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="15 18 9 12 15 6"></polyline>
            </svg>
        </button>
    </div>

    <!-- 2. Menu Navigation -->
    <nav class="sidebar-menu">
        <div class="menu-section">
            <span class="menu-title">MENU CHÍNH</span>
            <ul>
                <!-- Trang chủ -->
                <li class="<%= uri.endsWith("/admin/home") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/home">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                        </span>
                        <span class="menu-text">Trang chủ</span>
                    </a>
                </li>
                <!-- Thống kê -->
                <li class="<%= uri.endsWith("/admin/dashboard") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/dashboard">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                        </span>
                        <span class="menu-text">Thống kê</span>
                    </a>
                </li>
                <!-- Bán hàng tại quầy -->
                <li class="<%= uri.endsWith("/admin/pos") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/pos">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="8" rx="2" ry="2"></rect><rect x="6" y="20" width="12" height="4" rx="1" ry="1"></rect><path d="M12 12v8"></path></svg>
                        </span>
                        <span class="menu-text">Bán hàng tại quầy</span>
                    </a>
                </li>
                <!-- Quản lý hoá đơn -->
                <li class="<%= uri.endsWith("/admin/invoices") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/invoices">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        </span>
                        <span class="menu-text">Quản lý hoá đơn</span>
                    </a>
                </li>
                <!-- Quản lý sản phẩm (Dropdown) -->
                <li class="has-submenu <%= uri.contains("/admin/products") || uri.contains("/admin/variants") ? "submenu-open" : "" %>">
                    <a href="javascript:void(0)" class="submenu-toggle" onclick="this.parentElement.classList.toggle('submenu-open')">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                        </span>
                        <span class="menu-text">Quản lý sản phẩm</span>
                        <svg class="chevron-icon" viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-left: auto; transition: transform 0.2s;"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </a>
                    <ul class="submenu">
                        <li class="<%= uri.endsWith("/admin/products") && request.getParameter("action") == null ? "active" : "" %>">
                            <a href="<%= contextPath %>/admin/products">Danh sách sản phẩm</a>
                        </li>
                        <li class="<%= uri.endsWith("/admin/variants") ? "active" : "" %>">
                            <a href="<%= contextPath %>/admin/variants">Danh sách biến thể</a>
                        </li>
                    </ul>
                </li>
                <!-- Quản lý phiếu giảm giá -->
                <li class="<%= uri.endsWith("/admin/coupons") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/coupons">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                        </span>
                        <span class="menu-text">Quản lý phiếu giảm giá</span>
                    </a>
                </li>
                <!-- Quản lý khách hàng -->
                <li class="<%= uri.endsWith("/admin/customers") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/customers">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </span>
                        <span class="menu-text">Quản lý khách hàng</span>
                    </a>
                </li>
                <%
                    Employee loggedInUser = (Employee) session.getAttribute("loggedInUser");
                    boolean isAdmin = (loggedInUser != null && loggedInUser.getRoleName() != null && loggedInUser.getRoleName().equalsIgnoreCase("Admin"));
                    if (isAdmin) {
                %>
                <!-- Quản lý nhân viên -->
                <li class="<%= uri.endsWith("/admin/employees") ? "active" : "" %>">
                    <a href="<%= contextPath %>/admin/employees">
                        <span class="menu-icon">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </span>
                        <span class="menu-text">Quản lý nhân viên</span>
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- 3. Sidebar Footer -->
    <div class="sidebar-footer">
        <div class="footer-links">
            <a href="<%= contextPath %>/admin/settings" class="footer-item <%= uri.endsWith("/admin/settings") ? "active-footer-link" : "" %>" style="display: flex; align-items: center; gap: 10px; color: <%= uri.endsWith("/admin/settings") ? "#ffffff" : "#9ca3af" %>; text-decoration: none;">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                <span>Cài đặt</span>
            </a>
            <a href="<%= contextPath %>/logout" class="footer-item">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                <span>Đăng xuất</span>
            </a>
        </div>
        
        <!-- User Profile Card -->
        <div class="user-card">
            <% if (loggedInUser != null && loggedInUser.getAvatar() != null && !loggedInUser.getAvatar().isEmpty()) { %>
                <img src="<%= loggedInUser.getAvatar() %>" alt="Avatar" class="user-avatar" style="object-fit: cover; border-radius: 8px;">
            <% } else { %>
                <div class="user-avatar"><%= loggedInUser != null && loggedInUser.getFullName() != null && !loggedInUser.getFullName().isEmpty() ? loggedInUser.getFullName().substring(0, 1).toUpperCase() : "A" %></div>
            <% } %>
            <div class="user-info">
                <span class="user-name"><%= loggedInUser != null ? loggedInUser.getFullName() : "Admin" %></span>
                <span class="user-email"><%= loggedInUser != null ? loggedInUser.getEmail() : "admin@famicoats.vn" %></span>
            </div>
        </div>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const toggleBtn = document.getElementById("sidebar-toggle");
        
        // Kiểm tra xem trạng thái collapsed trước đó có được lưu trong localStorage không
        const isCollapsed = localStorage.getItem("sidebar-collapsed") === "true";
        if (isCollapsed) {
            document.body.classList.add("sidebar-collapsed");
            updateToggleIcon(true);
        }
        
        toggleBtn.addEventListener("click", function() {
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
    });
</script>
