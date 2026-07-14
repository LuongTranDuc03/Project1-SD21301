<<<<<<< HEAD
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.Product" %>
=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.Product" %>
<%@ page import="project.duan1_sd21301.model.ProductDetail" %>
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
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
<<<<<<< HEAD
=======
    <style>
        /* Tối giản màu sắc và cải thiện giao diện */
        .invoice-table th, .invoice-table td {
            border-bottom: 1px solid #f1f5f9;
        }
        .product-id-text {
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
        }
        .product-name-text {
            font-weight: 600;
            color: #0f172a;
        }
        .product-price-range {
            font-weight: 600;
            color: #1e293b;
        }
        .action-icon-btn {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            background-color: #ffffff;
            color: #64748b;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-right: 4px;
            text-decoration: none;
        }
        .action-icon-btn:hover {
            background-color: #f8fafc;
            color: #0f172a;
        }

        /* Chi tiết sản phẩm mở rộng */
        .detail-box-container {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 24px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin: 8px 0;
        }
        .detail-info-pane {
            border-right: 1px solid #e2e8f0;
            padding-right: 20px;
        }
        .detail-info-title {
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: auto 1fr;
            row-gap: 12px;
            column-gap: 16px;
            font-size: 13px;
            line-height: 1.5;
        }
        .info-label {
            font-weight: 600;
            color: #475569;
        }
        .info-value {
            color: #1e293b;
        }
        .detail-variants-pane {
            padding-left: 4px;
            overflow-x: auto;
        }
        .detail-variants-title {
            font-size: 14px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 16px;
        }
        .variant-mini-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        .variant-mini-table th {
            background-color: #f8fafc !important;
            color: #475569 !important;
            font-weight: 600 !important;
            text-transform: none !important;
            letter-spacing: normal !important;
            padding: 10px 12px !important;
            border-bottom: 1px solid #e2e8f0 !important;
        }
        .variant-mini-table td {
            padding: 10px 12px !important;
            color: #334155 !important;
            border-bottom: 1px solid #f1f5f9 !important;
        }
        .variant-mini-table tr:hover {
            background-color: #f8fafc !important;
        }
        .badge-status {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-status.available {
            background-color: #ecfdf5;
            color: #065f46;
        }
        .badge-status.low_stock {
            background-color: #fffbeb;
            color: #854d0e;
        }
        .badge-status.out_of_stock {
            background-color: #fef2f2;
            color: #991b1b;
        }
        /* Filter Bar */
        .filter-bar {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 16px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .filter-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .search-box {
            position: relative;
            width: 280px;
            min-width: 0;
            flex: none;
        }
        .search-box svg {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            color: #94a3b8;
        }
        .search-box input {
            width: 100%;
            padding: 9px 12px 9px 38px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
            font-family: inherit;
            color: #1e293b;
            background: #f8fafc;
            outline: none;
            transition: all 0.2s;
            box-sizing: border-box;
        }
        .search-box input:focus {
            border-color: #0f172a;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(15,23,42,0.08);
        }
        .filter-select {
            padding: 9px 32px 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
            font-family: inherit;
            color: #475569;
            background: #f8fafc;
            outline: none;
            cursor: pointer;
            transition: all 0.2s;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2.5'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
        }
        .filter-select:focus { border-color: #0f172a; background-color: #fff; }
        .no-results-row { display: none; }
        .btn-reset-filter {
            padding: 9px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #fff;
            color: #64748b;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: none;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .btn-reset-filter:hover { background: #f1f5f9; color: #0f172a; border-color: #94a3b8; }
        .category-pills { display: flex; gap: 6px; flex-wrap: wrap; }
        .cat-pill {
            padding: 5px 12px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            color: #64748b;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        .cat-pill:hover { border-color: #94a3b8; color: #334155; }
        .cat-pill.active {
            background: #0f172a;
            border-color: #0f172a;
            color: #ffffff;
            font-weight: 600;
        }
        .result-info {
            font-size: 12px;
            color: #94a3b8;
            margin-left: auto;
            white-space: nowrap;
        }
        .result-info strong { color: #0f172a; }
        .no-results-row { display: none; }
        /* Confirm Delete Modal */
        .delete-confirm-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background-color: rgba(15, 23, 42, 0.55);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }
        .delete-confirm-overlay.active { display: flex; }
        .delete-confirm-card {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.25);
            padding: 32px 28px 24px;
            width: 100%;
            max-width: 400px;
            text-align: center;
            animation: scaleIn 0.2s ease-out;
        }
        @keyframes scaleIn {
            from { opacity: 0; transform: scale(0.92); }
            to { opacity: 1; transform: scale(1); }
        }
        .delete-confirm-icon {
            width: 52px; height: 52px; border-radius: 50%;
            background-color: #fef2f2;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px;
        }
        .delete-confirm-title { font-size: 17px; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
        .delete-confirm-body { font-size: 13px; color: #64748b; line-height: 1.6; margin-bottom: 24px; }
        .delete-confirm-body strong { color: #1e293b; }
        .delete-confirm-actions { display: flex; gap: 10px; justify-content: center; }
        .btn-del-cancel {
            flex: 1; padding: 10px; border-radius: 8px;
            border: 1px solid #cbd5e1; background: #f8fafc; color: #475569;
            font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s;
        }
        .btn-del-cancel:hover { background: #e2e8f0; }
        .btn-del-confirm {
            flex: 1; padding: 10px; border-radius: 8px;
            border: 1px solid #dc2626; background: #dc2626; color: #ffffff;
            font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s;
        }
        .btn-del-confirm:hover { background: #b91c1c; border-color: #b91c1c; }
    </style>
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
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
<<<<<<< HEAD
=======
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    int totalProducts = (products != null) ? products.size() : 0;
                %>
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
                <!-- Tiêu đề trang -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý sản phẩm</h1>
<<<<<<< HEAD
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
=======
                        <div class="subtitle">Tổng <%= totalProducts %> sản phẩm</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-export" style="background-color: #E11D48; border-color: #E11D48; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; color: #ffffff;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Thêm sản phẩm</span>
                    </a>
                </div>

                <!-- Bộ lọc & tìm kiếm -->
                <div class="filter-bar">
                    <div class="filter-row">
                        <div class="search-box">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <input type="text" id="searchInput" placeholder="Tìm tên, mã, thương hiệu..." oninput="applyFilters()">
                        </div>
                        <select id="statusFilter" class="filter-select" onchange="applyFilters()">
                            <option value="">Tất cả trạng thái</option>
                            <option value="AVAILABLE">Còn hàng</option>
                            <option value="LOW_STOCK">Sắp hết hàng</option>
                            <option value="OUT_OF_STOCK">Hết hàng</option>
                        </select>
                        <select id="sortSelect" class="filter-select" onchange="applyFilters()">
                            <option value="">Sắp xếp mặc định</option>
                            <option value="name_asc">Tên A → Z</option>
                            <option value="name_desc">Tên Z → A</option>
                            <option value="price_asc">Giá tăng dần</option>
                            <option value="price_desc">Giá giảm dần</option>
                            <option value="stock_desc">Tồn kho nhiều nhất</option>
                        </select>
                        <button class="btn-reset-filter" onclick="resetFilters()" id="resetBtn">
                            <svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 .49-3.5"></path></svg>
                            Đặt lại
                        </button>
                    </div>
                    <div class="filter-row">
                        <div class="category-pills" id="categoryPills">
                            <button class="cat-pill active" data-cat="" onclick="selectCategory(this)">Tất cả</button>
                            <button class="cat-pill" data-cat="Áo khoác da" onclick="selectCategory(this)">Áo khoác da</button>
                            <button class="cat-pill" data-cat="Áo bomber" onclick="selectCategory(this)">Áo bomber</button>
                            <button class="cat-pill" data-cat="Áo denim" onclick="selectCategory(this)">Áo denim</button>
                            <button class="cat-pill" data-cat="Áo phao" onclick="selectCategory(this)">Áo phao</button>
                            <button class="cat-pill" data-cat="Áo gió" onclick="selectCategory(this)">Áo gió</button>
                            <button class="cat-pill" data-cat="Áo len" onclick="selectCategory(this)">Áo len</button>
                        </div>
                    </div>
                </div>

                <!-- Bảng danh sách sản phẩm (Table layout) -->
                <div class="card" style="padding: 0; overflow: hidden;">
                    <div class="table-responsive">
                        <table class="invoice-table" style="table-layout: fixed; width: 100%;">
                            <thead>
                                <tr>
                                    <th style="text-align: center; width: 60px;">STT</th>
                                    <th style="width: 140px;">Mã sản phẩm</th>
                                    <th style="width: 300px;">Tên sản phẩm</th>
                                    <th style="width: 140px;">Danh mục</th>
                                    <th style="width: 140px;">Thương hiệu</th>
                                    <th style="width: 160px;">Khoảng giá</th>
                                    <th style="text-align: center; width: 140px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="productTbody">
                                <%
                                    // products is declared at the top of content-wrapper
                                    if (products != null) {
                                        int stt = 1;
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
                                %>
                                <tr data-id="<%= prod.getId() %>" data-name="<%= prod.getName().toLowerCase() %>" data-category="<%= prod.getCategory() %>" data-brand="<%= prod.getBrand() != null ? prod.getBrand().toLowerCase() : "" %>" data-status="<%= prod.getStatus() != null ? prod.getStatus() : "" %>" data-price="<%= prod.getDetails() != null && !prod.getDetails().isEmpty() ? prod.getDetails().stream().mapToDouble(d -> d.getPrice()).min().orElse(prod.getPrice()) : prod.getPrice() %>" data-stock="<%= prod.getStock() %>">
                                    <td style="text-align: center; font-weight: 500; color: #64748b;"><%= stt++ %></td>
                                    <td>
                                        <span class="product-id-text"><%= prod.getId() %></span>
                                    </td>
                                    <td>
                                        <span class="product-name-text"><%= prod.getName() %></span>
                                    </td>
                                    <td>
                                        <span style="background-color: #f1f5f9; color: #475569; font-size: 11px; padding: 4px 8px; border-radius: 6px; font-weight: 500;"><%= prod.getCategory() %></span>
                                    </td>
                                    <td>
                                        <span style="color: #475569; font-weight: 500;"><%= prod.getBrand() != null ? prod.getBrand() : "N/A" %></span>
                                    </td>
                                    <td>
                                        <span class="product-price-range"><%= prod.getPriceRangeFormatted() %></span>
                                    </td>
                                    <td style="text-align: center;">
                                        <div style="display: flex; gap: 4px; justify-content: center; align-items: center;">
                                            <!-- Sửa -->
                                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= prod.getId() %>" class="action-icon-btn edit-btn" title="Chỉnh sửa" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            </a>
                                            <!-- Chi tiết -->
                                            <a href="${pageContext.request.contextPath}/admin/products?id=<%= prod.getId() %>" class="action-icon-btn details-btn" title="Chi tiết">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                            </a>
                                            <!-- Xóa -->
                                            <button class="action-icon-btn delete-btn" title="Xoá sản phẩm" type="button"
                                                    data-product-id="<%= prod.getId() %>"
                                                    data-product-name="<%= prod.getName() %>"
                                                    onclick="confirmDeleteProduct(this)">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>

                                <%
                                        }
                                    } else {
                                 %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu sản phẩm.</td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr id="noResultsRow" class="no-results-row" style="display:none;">
                                    <td colspan="7" style="text-align: center; padding: 48px; color: #94a3b8;">
                                        <svg viewBox="0 0 24 24" width="32" height="32" stroke="#cbd5e1" stroke-width="1.5" fill="none" style="margin-bottom:10px; display:block; margin-inline:auto;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                        Không tìm thấy sản phẩm phù hợp với bộ lọc hiện tại.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
                </div>
            </div>
        </main>
    </div>
<<<<<<< HEAD
=======

    <!-- Modal xác nhận xóa sản phẩm -->
    <div id="deleteProductModal" class="delete-confirm-overlay">
        <div class="delete-confirm-card">
            <div class="delete-confirm-icon">
                <svg viewBox="0 0 24 24" width="24" height="24" stroke="#dc2626" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    <line x1="10" y1="11" x2="10" y2="17"></line>
                    <line x1="14" y1="11" x2="14" y2="17"></line>
                </svg>
            </div>
            <div class="delete-confirm-title">Xác nhận xóa sản phẩm</div>
            <div class="delete-confirm-body">
                Bạn có chắc muốn xóa sản phẩm <strong id="deleteProductName"></strong>?<br>
                Tất cả biến thể của sản phẩm cũng sẽ bị xóa theo.<br>
                Hành động này <strong>không thể hoàn tác</strong>.
            </div>
            <div class="delete-confirm-actions">
                <button type="button" class="btn-del-cancel" onclick="closeDeleteProductModal()">Hủy bỏ</button>
                <form id="deleteProductForm" method="POST" action="${pageContext.request.contextPath}/admin/products?action=delete" style="flex:1;">
                    <input type="hidden" id="deleteProductIdInput" name="id" value="" />
                    <button type="submit" class="btn-del-confirm" style="width:100%;">Xóa sản phẩm</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // ===== DELETE CONFIRM =====
        window.confirmDeleteProduct = function(btn) {
            document.getElementById('deleteProductName').textContent = btn.getAttribute('data-product-name');
            document.getElementById('deleteProductIdInput').value = btn.getAttribute('data-product-id');
            document.getElementById('deleteProductModal').classList.add('active');
        };
        window.closeDeleteProductModal = function() {
            document.getElementById('deleteProductModal').classList.remove('active');
        };

        // ===== FILTER & SEARCH =====
        let currentCategory = '';
        const allRows = () => Array.from(document.querySelectorAll('#productTbody tr[data-id]'));
        const totalCount = allRows().length || 0; // captured before any filter

        function selectCategory(pillEl) {
            document.querySelectorAll('.cat-pill').forEach(p => p.classList.remove('active'));
            pillEl.classList.add('active');
            currentCategory = pillEl.getAttribute('data-cat');
            applyFilters();
        }

        function applyFilters() {
            const keyword = (document.getElementById('searchInput').value || '').toLowerCase().trim();
            const status  = document.getElementById('statusFilter').value;
            const sort    = document.getElementById('sortSelect').value;

            const rows = allRows();
            let visible = [];

            rows.forEach(row => {
                const matchSearch = !keyword ||
                    row.dataset.name.includes(keyword) ||
                    row.dataset.id.toLowerCase().includes(keyword) ||
                    row.dataset.brand.includes(keyword);
                const matchCat    = !currentCategory || row.dataset.category === currentCategory;
                const matchStatus = !status || row.dataset.status === status;

                if (matchSearch && matchCat && matchStatus) {
                    row.style.display = '';
                    visible.push(row);
                } else {
                    row.style.display = 'none';
                }
            });

            // Sort visible rows
            if (sort && visible.length > 0) {
                const tbody = document.getElementById('productTbody');
                visible.sort((a, b) => {
                    if (sort === 'name_asc')   return a.dataset.name.localeCompare(b.dataset.name, 'vi');
                    if (sort === 'name_desc')  return b.dataset.name.localeCompare(a.dataset.name, 'vi');
                    if (sort === 'price_asc')  return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                    if (sort === 'price_desc') return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                    if (sort === 'stock_desc') return parseInt(b.dataset.stock) - parseInt(a.dataset.stock);
                    return 0;
                });
                visible.forEach(row => tbody.appendChild(row));
            }

            // Update STT for visible rows
            visible.forEach((row, idx) => {
                const sttCell = row.querySelector('td:first-child');
                if (sttCell) sttCell.textContent = idx + 1;
            });

            // No results row
            document.getElementById('noResultsRow').style.display = visible.length === 0 ? '' : 'none';

            // Reset button — ẩn khi không lọc, hiện khi có filter
            const hasFilter = keyword || status || sort || currentCategory;
            document.getElementById('resetBtn').style.display = hasFilter ? 'flex' : 'none';
        }

        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('sortSelect').value = '';
            currentCategory = '';
            document.querySelectorAll('.cat-pill').forEach(p => p.classList.remove('active'));
            document.querySelector('.cat-pill[data-cat=""]').classList.add('active');
            applyFilters();
        }

        document.addEventListener('DOMContentLoaded', () => {
            // Init result info
            applyFilters();

            // Close delete modal on backdrop click
            document.getElementById('deleteProductModal').addEventListener('click', (e) => {
                if (e.target === document.getElementById('deleteProductModal')) closeDeleteProductModal();
            });
        });
    </script>

>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
</body>
</html>
