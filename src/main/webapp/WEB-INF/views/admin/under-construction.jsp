<<<<<<< HEAD
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
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
    <style>
        .under-construction-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 80px 40px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid #f3f4f6;
            margin-top: 20px;
        }

        .construction-icon-wrapper {
            background-color: #fefbeb;
            color: #d97706;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
            box-shadow: 0 10px 15px -3px rgba(217, 119, 6, 0.1);
            animation: pulse 2s infinite ease-in-out;
        }

        .under-construction-card h2 {
            font-size: 22px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 12px;
        }

        .under-construction-card p {
            font-size: 14px;
            color: #6b7280;
            max-width: 400px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .status-badge-progress {
            background-color: #fef3c7;
            color: #d97706;
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .dot-pulse {
            width: 6px;
            height: 6px;
            background-color: #d97706;
            border-radius: 50%;
            animation: bounce 1.2s infinite ease-in-out;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        @keyframes bounce {
            0%, 100% { transform: scale(0.6); opacity: 0.5; }
            50% { transform: scale(1.2); opacity: 1; }
        }
    </style>
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
                    <span>FamiCoats Admin</span> / <span class="active-crumb">${requestScope.pageTitle}</span>
                </div>
                <div class="navbar-right">
                    <button class="notif-btn">
                        <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                        <span class="notif-badge"></span>
                    </button>
                    <div class="date-pill">Thứ Ba, 30/06/2026</div>
                    <div class="profile-pill">
                        <span class="profile-avatar-mini">A</span>
                        <span>Admin</span>
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
