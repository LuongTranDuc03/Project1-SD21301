<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.Product" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Quản lý sản phẩm</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
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

            <!-- 2. Thân trang hiển thị danh sách sản phẩm -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý sản phẩm</h1>
                        <div class="subtitle">Tổng 8 sản phẩm</div>
                    </div>
                    <div style="display: flex; align-items: center;">
                        <div class="view-toggles">
                            <button class="toggle-view-btn active" title="Xem dạng lưới">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            </button>
                            <button class="toggle-view-btn" title="Xem dạng danh sách">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>
                            </button>
                        </div>
                        <button class="btn-export" style="background-color: #E11D48; border-color: #E11D48; display: inline-flex; align-items: center; gap: 8px;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            <span>Thêm sản phẩm</span>
                        </button>
                    </div>
                </div>

                <!-- 4 Ô thống kê trạng thái sản phẩm -->
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box blue" style="background-color: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">8</div>
                        <div class="metric-label">Tổng sản phẩm</div>
                        <div class="metric-trend">Danh mục cửa hàng</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box green" style="background-color: rgba(16, 185, 129, 0.1); color: #10b981;">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            </div>
                        </div>
                        <div class="metric-value">5</div>
                        <div class="metric-label">Còn hàng</div>
                        <div class="metric-trend">Sẵn sàng phục vụ</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box yellow" style="background-color: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">2</div>
                        <div class="metric-label">Sắp hết</div>
                        <div class="metric-trend">Cần nhập thêm hàng</div>
                    </div>

                    <div class="metric-card">
                        <div class="metric-header">
                            <div class="metric-icon-box pink" style="background-color: rgba(239, 68, 68, 0.1); color: #ef4444;">
                                <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                            </div>
                        </div>
                        <div class="metric-value">1</div>
                        <div class="metric-label">Hết hàng</div>
                        <div class="metric-trend">Tạm dừng giao dịch</div>
                    </div>
                </div>

                <!-- Thanh tìm kiếm & bộ lọc danh mục -->
                <div class="filter-search-container">
                    <div class="search-input-group">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" class="search-input" placeholder="Tìm theo tên, mã sản phẩm...">
                    </div>
                    <div class="filter-pills">
                        <button class="filter-pill active">Tất cả</button>
                        <button class="filter-pill">Áo khoác da</button>
                        <button class="filter-pill">Áo bomber</button>
                        <button class="filter-pill">Áo denim</button>
                        <button class="filter-pill">Áo phao</button>
                        <button class="filter-pill">Áo gió</button>
                        <button class="filter-pill">Áo len</button>
                    </div>
                </div>

                <!-- Lưới danh sách sản phẩm (Grid layout) -->
                <div class="products-grid">
                    <%
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            for (Product prod : products) {
                                String statusLabel = "";
                                String statusClass = "";
                                if ("AVAILABLE".equals(prod.getStatus())) {
                                    statusLabel = "Còn hàng";
                                    statusClass = "available";
                                } else if ("LOW_STOCK".equals(prod.getStatus())) {
                                    statusLabel = "Sắp hết";
                                    statusClass = "low_stock";
                                } else if ("OUT_OF_STOCK".equals(prod.getStatus())) {
                                    statusLabel = "Hết hàng";
                                    statusClass = "out_of_stock";
                                }
                                
                                String priceFormatted = String.format("%,.0fđ", prod.getPrice()).replace(",", ".");
                                String oldPriceFormatted = prod.getOldPrice() > 0 ? String.format("%,.0fđ", prod.getOldPrice()).replace(",", ".") : "";
                    %>
                    <div class="product-card">
                        <!-- Khối hình ảnh visual có màu nền -->
                        <div class="product-visual" style="background-color: <%= prod.getBgColor() %>;">
                            <span class="product-badge <%= statusClass %>"><%= statusLabel %></span>
                            <div class="product-visual-text"><%= prod.getEnglishName() %></div>
                        </div>

                        <!-- Khối thông tin chi tiết -->
                        <div class="product-info">
                            <span class="product-cat"><%= prod.getCategory() %></span>
                            <h3 class="product-name"><%= prod.getName() %></h3>
                            <span class="product-code">Mã: <%= prod.getId() %></span>

                            <!-- Dòng hiển thị giá và chiết khấu -->
                            <div class="product-price-row">
                                <span class="product-price"><%= priceFormatted %></span>
                                <% if (prod.getOldPrice() > 0) { %>
                                    <span class="product-old-price"><%= oldPriceFormatted %></span>
                                    <span class="product-discount"><%= prod.getDiscountPercent() %>%</span>
                                <% } %>
                            </div>

                            <!-- Lưới thống kê tồn kho, đã bán, đánh giá -->
                            <div class="product-details-grid">
                                <div class="detail-item">
                                    <span>Tồn kho:</span>
                                    <span class="detail-val"><%= prod.getStock() %></span>
                                </div>
                                <div class="detail-item">
                                    <span>Đã bán:</span>
                                    <span class="detail-val"><%= prod.getSold() %></span>
                                </div>
                                <div class="detail-item">
                                    <span>Đánh giá:</span>
                                    <span class="detail-val rating">
                                        <svg viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                        <%= prod.getRating() %>
                                    </span>
                                </div>
                            </div>

                            <!-- Dải màu sắc tùy chọn -->
                            <div class="product-colors">
                                <% if (prod.getColorCircles() != null) {
                                    for (String colorHex : prod.getColorCircles()) { %>
                                        <div class="color-circle" style="background-color: <%= colorHex %>;"></div>
                                <%  }
                                } %>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="grid-column: span 4; text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu sản phẩm.</div>
                    <%
                        }
                    %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
