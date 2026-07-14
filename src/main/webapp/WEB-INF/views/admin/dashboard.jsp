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
    <title>FamiCoats Admin - Tổng quan hệ thống</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom của Dashboard -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
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
                    <span>FamiCoats Admin</span> / <span class="active-crumb">Thống kê</span>
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

            <!-- 2. Thân trang hiển thị số liệu -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang -->
                <div class="page-header">
                    <h1>Tổng quan hệ thống</h1>
                    <div class="subtitle">Cập nhật lần cuối: 30/06/2026 - 09:45</div>
                </div>

                <!-- 4 Ô thống kê chính (Metrics Grid) -->
                <div class="metrics-grid">
                    <!-- Doanh thu -->
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box pink">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                            </div>
                        </div>
                        <div class="metric-value">190M đ</div>
                        <div class="metric-label">Doanh thu tháng này</div>
                        <div class="metric-trend">Tháng 12/2025</div>
                    </div>

                    <!-- Đơn hàng -->
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box blue">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            </div>
                        </div>
                        <div class="metric-value">2,401</div>
                        <div class="metric-label">Đơn hàng</div>
                        <div class="metric-trend">Tổng đơn tháng này</div>
                    </div>

                    <!-- Khách hàng mới -->
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box purple">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                        </div>
                        <div class="metric-value">348</div>
                        <div class="metric-label">Khách hàng mới</div>
                        <div class="metric-trend">Tháng này</div>
                    </div>

                    <!-- Phiếu giảm giá -->
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box yellow">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">127</div>
                        <div class="metric-label">Phiếu giảm giá đã dùng</div>
                        <div class="metric-trend">Đang hoạt động: 24</div>
                    </div>
                </div>

                <!-- Lưới hiển thị chi tiết (2 cột: Sản phẩm bán chạy & Đơn hàng gần đây) -->
                <div class="dashboard-grid">
                    <!-- Cột trái: Sản phẩm bán chạy -->
                    <div class="card">
                        <div class="card-title-bar">
                            <div class="card-title">Top sản phẩm bán chạy</div>
                        </div>
                        <div class="product-list">
                            <div class="product-item">
                                <div class="product-info-wrapper">
                                    <div class="product-rank">#1</div>
                                    <div>
                                        <div class="product-name">Áo khoác da nam Premium</div>
                                        <div class="product-sales">Đã bán: 324 sản phẩm</div>
                                    </div>
                                </div>
                                <div class="product-revenue">48.6M</div>
                            </div>
                            <div class="product-item">
                                <div class="product-info-wrapper">
                                    <div class="product-rank">#2</div>
                                    <div>
                                        <div class="product-name">Bomber jacket oversize</div>
                                        <div class="product-sales">Đã bán: 287 sản phẩm</div>
                                    </div>
                                </div>
                                <div class="product-revenue">43.1M</div>
                            </div>
                            <div class="product-item">
                                <div class="product-info-wrapper">
                                    <div class="product-rank">#3</div>
                                    <div>
                                        <div class="product-name">Áo denim wash nữ</div>
                                        <div class="product-sales">Đã bán: 241 sản phẩm</div>
                                    </div>
                                </div>
                                <div class="product-revenue">36.2M</div>
                            </div>
                            <div class="product-item">
                                <div class="product-info-wrapper">
                                    <div class="product-rank">#4</div>
                                    <div>
                                        <div class="product-name">Áo phao siêu nhẹ</div>
                                        <div class="product-sales">Đã bán: 198 sản phẩm</div>
                                    </div>
                                </div>
                                <div class="product-revenue">29.7M</div>
                            </div>
                            <div class="product-item">
                                <div class="product-info-wrapper">
                                    <div class="product-rank">#5</div>
                                    <div>
                                        <div class="product-name">Khoác gió windbreaker</div>
                                        <div class="product-sales">Đã bán: 176 sản phẩm</div>
                                    </div>
                                </div>
                                <div class="product-revenue">26.4M</div>
                            </div>
                        </div>
                    </div>

                    <!-- Cột phải: Đơn hàng gần đây -->
                    <div class="card">
                        <div class="card-title-bar">
                            <div class="card-title">Đơn hàng gần đây</div>
                            <a href="#" class="card-link">Xem tất cả</a>
                        </div>
                        <div class="order-list">
                            <!-- Đơn hàng 1 -->
                            <div class="order-item">
                                <div class="order-top">
                                    <span class="order-code">#HD-2401</span>
                                    <span class="order-time">2 phút trước</span>
                                </div>
                                <div class="order-customer">Nguyễn Văn A</div>
                                <div class="order-product">Áo khoác da nam</div>
                                <div class="order-bottom">
                                    <span class="order-price">1.850.000đ</span>
                                    <span class="status-pill success">Hoàn thành</span>
                                </div>
                            </div>
                            <!-- Đơn hàng 2 -->
                            <div class="order-item">
                                <div class="order-top">
                                    <span class="order-code">#HD-2400</span>
                                    <span class="order-time">15 phút trước</span>
                                </div>
                                <div class="order-customer">Trần Thị B</div>
                                <div class="order-product">Bomber jacket</div>
                                <div class="order-bottom">
                                    <span class="order-price">1.290.000đ</span>
                                    <span class="status-pill warning">Đang giao</span>
                                </div>
                            </div>
                            <!-- Đơn hàng 3 -->
                            <div class="order-item">
                                <div class="order-top">
                                    <span class="order-code">#HD-2399</span>
                                    <span class="order-time">1 giờ trước</span>
                                </div>
                                <div class="order-customer">Lê Minh C</div>
                                <div class="order-product">Áo denim nữ</div>
                                <div class="order-bottom">
                                    <span class="order-price">890.000đ</span>
                                    <span class="status-pill info">Chờ xử lý</span>
                                </div>
                            </div>
                            <!-- Đơn hàng 4 -->
                            <div class="order-item">
                                <div class="order-top">
                                    <span class="order-code">#HD-2398</span>
                                    <span class="order-time">2 giờ trước</span>
                                </div>
                                <div class="order-customer">Phạm Lan D</div>
                                <div class="order-product">Áo phao siêu nhẹ</div>
                                <div class="order-bottom">
                                    <span class="order-price">2.100.000đ</span>
                                    <span class="status-pill success">Hoàn thành</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
