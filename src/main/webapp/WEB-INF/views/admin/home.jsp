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

    <style>
        .home-banner-container {
            position: relative;
            width: 100%;
            min-height: calc(100vh - 130px);
            border-radius: 8px;
            overflow: hidden;
            background: #0f172a url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
        }

        .home-banner-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(15, 23, 42, 0.95) 0%, rgba(15, 23, 42, 0.65) 50%, rgba(15, 23, 42, 0.3) 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 56px 40px;
        }

        .banner-tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: #ffffff;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            margin: 0 auto 20px auto;
            width: fit-content;
        }

        .banner-title {
            color: #ffffff;
            font-size: 48px;
            font-weight: 800;
            line-height: 1.2;
            margin: 0 auto 20px auto;
            max-width: 980px;
            letter-spacing: -0.5px;
            text-align: center;
        }

        .banner-subtitle {
            color: #cbd5e1;
            font-size: 17px;
            line-height: 1.7;
            margin: 0 auto 32px auto;
            max-width: 820px;
            font-weight: 400;
            text-align: center;
        }

        .banner-status-row {
            display: flex;
            gap: 16px;
            margin: 0 auto 44px auto;
            flex-wrap: wrap;
            justify-content: center;
        }

        .status-pill {
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            color: #f1f5f9;
            padding: 8px 20px;
            border-radius: 30px;
            font-size: 13.5px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .dot-red {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #f43f5e;
            box-shadow: 0 0 10px #f43f5e;
        }

        .dot-blue {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #38bdf8;
            box-shadow: 0 0 10px #38bdf8;
        }

        .banner-actions-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 16px;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }

        .btn-glass {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.14);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            color: #ffffff;
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 14.5px;
            font-weight: 700;
            transition: all 0.25s ease;
            text-decoration: none;
            flex: 1 1 200px;
            max-width: 260px;
            text-align: center;
        }

        .btn-glass:hover {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.4);
            transform: translateY(-2px);
            color: #ffffff;
        }

        .btn-pos {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: linear-gradient(135deg, #f43f5e 0%, #fb7185 100%);
            color: #ffffff;
            padding: 14px 20px;
            border-radius: 12px;
            font-size: 14.5px;
            font-weight: 700;
            box-shadow: 0 8px 20px rgba(244, 63, 94, 0.4);
            transition: all 0.25s ease;
            text-decoration: none;
            width: 100%;
            text-align: center;
        }

        .btn-pos:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(244, 63, 94, 0.6);
            color: #ffffff;
        }

        /* Responsive overrides */
        @media (max-width: 768px) {
            .home-banner-overlay {
                padding: 32px 24px;
            }
            .banner-title {
                font-size: 28px;
            }
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
                    <span>FamiCoats</span> / <span class="active-crumb">Trang chủ</span>
                </div>
                <div class="navbar-right">
                    <button class="notif-btn">
                        <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                        <span class="notif-badge"></span>
                    </button>
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
