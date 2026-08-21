<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - ${requestScope.pageTitle}</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/under-construction.css">
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
                    <span>FamiCoats</span> / <span class="active-crumb">${requestScope.pageTitle}</span>
                </div>
                <div class="navbar-right">
                    <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                    <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                    <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
                </div>
            </header>

            <!-- 2. Thân trang -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang -->
                <div class="page-header">
                    <h1>${requestScope.pageTitle}</h1>
                    <div class="subtitle">Hệ thống quản lý FamiCoats</div>
                </div>

                <!-- Card báo trạng thái đang phát triển -->
                <div class="under-construction-card">
                    <div class="construction-icon-wrapper">
                        <svg viewBox="0 0 24 24" width="40" height="40" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path>
                        </svg>
                    </div>
                    <h2>Chức năng đang phát triển</h2>
                    <p>
                        Giao diện của phần <strong>${requestScope.pageTitle}</strong> đang được xây dựng hệ thống và liên kết cơ sở dữ liệu. Vui lòng quay lại sau!
                    </p>
                    <div class="status-badge-progress">
                        <span class="dot-pulse"></span>
                        <span>Đang hoàn thiện</span>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

