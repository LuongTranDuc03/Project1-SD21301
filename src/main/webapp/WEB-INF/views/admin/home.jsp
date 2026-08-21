<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%@ page import="project.duan1_sd21301.model.huy.Employee" %>
<%
    String contextPath = request.getContextPath();
    Employee loggedInUser = (Employee) session.getAttribute("loggedInUser");
    String roleDisplay = "Admin";
    boolean isManager = false;
    if (loggedInUser != null && loggedInUser.getRoleName() != null && !loggedInUser.getRoleName().isEmpty()) {
        roleDisplay = loggedInUser.getRoleName();
    }
    if (loggedInUser != null && loggedInUser.getRoleId() == 1) {
        isManager = true;
    }
    
    // Định dạng ngày hiện tại bằng Tiếng Việt (Ví dụ: Thứ Bảy, 25/07/2026)
    Date now = new Date();
    SimpleDateFormat sdfDayOfWeek = new SimpleDateFormat("EEEE", new Locale("vi", "VN"));
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
    String dayOfWeekStr = sdfDayOfWeek.format(now);
    if (dayOfWeekStr != null && !dayOfWeekStr.isEmpty()) {
        dayOfWeekStr = dayOfWeekStr.substring(0, 1).toUpperCase() + dayOfWeekStr.substring(1);
    }
    String formattedDate = dayOfWeekStr + ", " + sdfDate.format(now);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Trang chủ</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom Admin -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/home.css">
</head>
<body>
    <div class="app-container">
        <!-- Nhúng Sidebar dùng chung -->
        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

        <!-- Khu vực nội dung chính bên phải -->
        <main class="main-content">
            <!-- 1. Thanh Navbar trên cùng -->
            <header class="navbar">
                <div class="breadcrumb">
                    <span>FamiCoats</span> / <span class="active-crumb">Trang chủ</span>
                </div>
                <div class="navbar-right">
                    <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                    <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                    <div class="profile-pill">
                        <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                    </div>
                </div>
            </header>

            <!-- 2. Thân trang chính chứa Banner Trang Chủ -->
            <div class="content-wrapper">
                <div class="home-banner-container">
                    <div class="home-banner-overlay">
                        <!-- Tag thương hiệu -->
                        <div class="banner-tag">
                            <span>☆ FAMICOATS FASHION BOUTIQUE</span>
                        </div>

                        <!-- Tiêu đề & Mô tả -->
                        <h1 class="banner-title">Hệ Thống Quản Lý Cửa Hàng Thời Trang FamiCoats</h1>
                        <p class="banner-subtitle">
                            Không gian mua sắm hiện đại, thời thượng & trải nghiệm đẳng cấp. Quản lý toàn bộ danh mục sản phẩm, khách hàng và nhân viên trên cùng một hệ thống đồng bộ.
                        </p>

                        <!-- Trạng thái cửa hàng -->
                        <div class="banner-status-row">
                            <div class="status-pill">
                                <span class="dot-red"></span>
                                <span>Cửa hàng đang hoạt động</span>
                            </div>
                        </div>

                        <!-- Nút tác vụ nhanh -->
                        <div class="banner-actions-row">
                            <a href="${pageContext.request.contextPath}/admin/pos" class="btn-glass">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="9" cy="21" r="1"></circle>
                                    <circle cx="20" cy="21" r="1"></circle>
                                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                                </svg>
                                <span>Bán Hàng Tại Quầy</span>
                            </a>
                            <% if (isManager) { %>
                            <a href="${pageContext.request.contextPath}/admin/products" class="btn-glass">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                                    <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                                    <line x1="12" y1="22.08" x2="12" y2="12"></line>
                                </svg>
                                <span>Quản Lý Sản Phẩm</span>
                            </a>
                            <% } %>
                            <a href="${pageContext.request.contextPath}/admin/customers" class="btn-glass">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <span>Quản Lý Khách Hàng</span>
                            </a>
                            <% if (isManager) { %>
                            <a href="${pageContext.request.contextPath}/admin/employees" class="btn-glass">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                <span>Quản Lý Nhân Viên</span>
                            </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
