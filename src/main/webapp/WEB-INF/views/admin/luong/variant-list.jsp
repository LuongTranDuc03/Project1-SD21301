<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Quản lý biến thể</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .invoice-table th, .invoice-table td {
            border-bottom: 1px solid #f1f5f9;
        }
        .product-id-text {
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
        }
        .variant-attr-text {
            font-weight: 600;
            color: #0f172a;
        }
        .product-price {
            font-weight: 600;
            color: #1e293b;
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
        .badge-status.out_of_stock {
            background-color: #fef2f2;
            color: #991b1b;
        }
        .custom-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px !important;
            overflow: hidden !important;
            margin-bottom: 10px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .card-header-bar {
            background-color: #12192D;
            color: #ffffff;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header-title {
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .invoice-table th {
            white-space: nowrap !important;
            font-size: 12px !important;
            padding: 12px 20px !important;
        }
        /* Toggle Switch CSS */
        .switch {
            position: relative;
            display: inline-block;
            width: 36px;
            height: 20px;
        }
        .switch input { 
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #cbd5e1;
            transition: .4s;
            border-radius: 34px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 2px;
            bottom: 2px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
            box-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }
        input:checked + .slider {
            background-color: #10B981;
        }
        input:checked + .slider:before {
            transform: translateX(16px);
        }
        .card-body-content {
            padding: 20px;
            transition: all 0.3s ease;
            overflow: hidden;
            max-height: 1000px;
        }
        .card-body-content.collapsed {
            max-height: 0;
            padding-top: 0;
            padding-bottom: 0;
            border: none;
        }
        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 16px 24px;
        }
        @media (max-width: 992px) { .filter-grid { grid-template-columns: 1fr 1fr; } }
        @media (max-width: 576px) { .filter-grid { grid-template-columns: 1fr; } }
        .filter-field { display: flex; flex-direction: column; gap: 6px; }
        .filter-field label { font-size: 12px; font-weight: 600; color: #475569; }
        .filter-control {
            width: 100%; padding: 10px 12px; border: 1px solid #cbd5e1;
            border-radius: 6px; font-size: 13px; font-family: inherit; color: #1e293b; background: #ffffff;
            outline: none; transition: all 0.2s; box-sizing: border-box;
        }
        .filter-control:focus { border-color: #12192D; box-shadow: 0 0 0 3px rgba(18, 25, 45, 0.08); }
        .price-slider-container { position: relative; width: 100%; height: 20px; margin-top: 5px; }
        .price-slider-container input[type="range"] {
            position: absolute; width: 100%; height: 5px; top: 50%; transform: translateY(-50%);
            -webkit-appearance: none; background: transparent; pointer-events: none; margin: 0; padding: 0;
        }
        .price-slider-container input[type="range"]::-webkit-slider-thumb {
            height: 16px;
            width: 16px;
            border-radius: 50%;
            background: #10b981;
            cursor: pointer;
            pointer-events: auto;
            -webkit-appearance: none;
            box-shadow: 0 1px 3px rgba(0,0,0,0.3);
            border: 2px solid #ffffff;
        }
        .price-slider-container input[type="range"]::-moz-range-thumb {
            height: 16px;
            width: 16px;
            border-radius: 50%;
            background: #10b981;
            cursor: pointer;
            pointer-events: auto;
            box-shadow: 0 1px 3px rgba(0,0,0,0.3);
            border: 2px solid #ffffff;
        }
        .slider-track {
            position: absolute; width: 100%; height: 5px; top: 50%; transform: translateY(-50%);
            background-color: #cbd5e1; border-radius: 5px;
        }
        .toggle-filter-btn {
            background: none; border: none; color: #94a3b8; font-size: 12px; cursor: pointer; font-weight: 500; transition: color 0.2s;
        }
        .toggle-filter-btn:hover { color: #ffffff; }
        .btn-reset-filter:hover { background: #f8fafc; border-color: #94a3b8; }
        .no-results-row { display: none; }
        /* Pagination Styling */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 20px 0;
            margin-top: 10px;
        }
        .page-btn {
            min-width: 32px;
            height: 32px;
            padding: 0 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            background-color: #ffffff;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .page-btn:hover:not(:disabled) {
            background-color: #f1f5f9;
            color: #0f172a;
            border-color: #94a3b8;
        }
        .page-btn.active {
            background-color: #1e3a8a;
            color: #ffffff;
            border-color: #1e3a8a;
        }
        .page-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Nhúng Sidebar dùng chung -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <!-- Khu vực nội dung chính bên phải -->
    <main class="main-content">
        <!-- Thanh Navbar trên cùng -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span> / <a href="${pageContext.request.contextPath}/admin/products" style="color: inherit; text-decoration: none;">Quản lý sản phẩm</a> / <span class="active-crumb">Danh sách biến thể</span>
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

        <!-- Thân trang hiển thị danh sách biến thể -->
        <div class="content-wrapper">
            <%
                List<ProductDetail> variants = (List<ProductDetail>) request.getAttribute("variants");
                int totalVariants = (variants != null) ? variants.size() : 0;
                String filterProductId = (String) request.getAttribute("filterProductId");

                java.util.Set<String> sizes = new java.util.TreeSet<>();
                double globalMinPrice = Double.MAX_VALUE;
                double globalMaxPrice = 0.0;
                if (variants != null) {
                    for (ProductDetail v : variants) {
                        if (v.getSize() != null && !v.getSize().trim().isEmpty()) {
                            sizes.add(v.getSize().trim());
                        }
                        if (v.getPrice() < globalMinPrice) globalMinPrice = v.getPrice();
                        if (v.getPrice() > globalMaxPrice) globalMaxPrice = v.getPrice();
                    }
                }
                if (globalMinPrice == Double.MAX_VALUE) globalMinPrice = 0.0;
                if (globalMaxPrice < globalMinPrice) globalMaxPrice = globalMinPrice;
                long sliderMin = (long) Math.floor(globalMinPrice);
                long sliderMax = (long) Math.ceil(globalMaxPrice);
                if (sliderMax <= sliderMin) sliderMax = sliderMin + 1;
            %>
            <!-- Tiêu đề trang -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <div>
                    <h1>Quản lý biến thể</h1>
                    <div class="subtitle">
                        Tổng <%= totalVariants %> biến thể
                        <%= (filterProductId != null && !filterProductId.trim().isEmpty()) ? " của sản phẩm <strong>" + filterProductId + "</strong>" : " trên toàn hệ thống" %>
                    </div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <% if (filterProductId != null && !filterProductId.trim().isEmpty()) { %>
                        <a href="${pageContext.request.contextPath}/admin/variants" class="btn-export" style="background-color: #64748b; border: 1px solid #64748b; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <span>Xem tất cả biến thể</span>
                        </a>
                    <% } %>
                    <button type="button" onclick="showQRModal()" class="btn-export" style="background-color: #3B82F6; border: 1px solid #3B82F6; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none">
                            <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                        </svg>
                        <span>Mã QR</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/variants?action=exportExcel" class="btn-export" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; height: 38px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <span>Xuất Excel</span>
                    </a>
                </div>
            </div>

            <!-- Bộ lọc & tìm kiếm -->
            <div class="custom-card">
                <div class="card-header-bar">
                    <span class="card-header-title">&#8226; Bộ lọc tìm kiếm</span>
                    <button class="toggle-filter-btn" id="toggleFilterBtn" onclick="toggleFilterCard()">Nhấn để thu gọn</button>
                </div>
                <div class="card-body-content" id="filterCardBody">
                    <div class="filter-grid">
                        <!-- Tìm kiếm -->
                        <div class="filter-field">
                            <label for="searchInput">Tìm kiếm</label>
                            <input type="text" id="searchInput" class="filter-control" placeholder="Tìm theo mã SP, màu sắc..." oninput="applyFilters()">
                        </div>
                        <!-- Kích cỡ -->
                        <div class="filter-field">
                            <label for="sizeFilter">Kích cỡ</label>
                            <select id="sizeFilter" class="filter-control" onchange="applyFilters()">
                                <option value="">-- Tất cả kích cỡ --</option>
                                <% for (String s : sizes) { %>
                                <option value="<%= s %>"><%= s %></option>
                                <% } %>
                            </select>
                        </div>
                        <!-- Trạng thái -->
                        <div class="filter-field">
                            <label>Trạng thái</label>
                            <input type="hidden" id="statusFilter" value="">
                            <div style="display: flex; gap: 16px; align-items: center; padding: 10px 0; margin-left: 20px;">
                                <label style="display: flex; align-items: center; gap: 6px; font-size: 13px; cursor: pointer; color: #1e293b;">
                                    <input type="radio" name="statusRadio" value="" onchange="document.getElementById('statusFilter').value=this.value; applyFilters()" checked> Tất cả
                                </label>
                                <label style="display: flex; align-items: center; gap: 6px; font-size: 13px; cursor: pointer; color: #1e293b;">
                                    <input type="radio" name="statusRadio" value="AVAILABLE" onchange="document.getElementById('statusFilter').value=this.value; applyFilters()"> Còn hàng
                                </label>
                                <label style="display: flex; align-items: center; gap: 6px; font-size: 13px; cursor: pointer; color: #1e293b;">
                                    <input type="radio" name="statusRadio" value="OUT_OF_STOCK" onchange="document.getElementById('statusFilter').value=this.value; applyFilters()"> Hết hàng
                                </label>
                            </div>
                        </div>
                        <!-- Khoảng giá -->
                        <div class="filter-field">
                            <label id="priceLabel" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                                <span>Khoảng giá</span>
                                <span id="priceRangeText" style="font-weight: 700; color: #10b981; font-size: 11px;"></span>
                            </label>
                            <div class="price-slider-container">
                                <div class="slider-track"></div>
                                <input type="range" id="minPriceInput" min="<%= sliderMin %>" max="<%= sliderMax %>" step="1000" value="<%= sliderMin %>" oninput="updateSlider()">
                                <input type="range" id="maxPriceInput" min="<%= sliderMin %>" max="<%= sliderMax %>" step="1000" value="<%= sliderMax %>" oninput="updateSlider()">
                            </div>
                        </div>
                        <!-- Đặt lại -->
                        <div class="filter-field" style="grid-column: 3; justify-content: flex-end; align-items: flex-end;">
                            <button type="button" class="btn-reset-filter" onclick="resetFilters()" id="resetBtn" style="display: none; align-items: center; gap: 6px; padding: 10px 16px; font-weight: 600; border-radius: 6px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; cursor: pointer; transition: all 0.2s; font-size: 13px; width: fit-content; box-sizing: border-box; height: 38px;">
                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 .49-3.5"></path></svg>
                                Đặt lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bảng danh sách biến thể -->
            <div class="custom-card">
                <div class="card-header-bar">
                    <span class="card-header-title">&#8226; Bảng dữ liệu biến thể</span>
                </div>
                <div style="overflow-x: auto;">
                    <table class="invoice-table" style="width: 100%; min-width: 900px;">
                        <thead>
                        <tr>
                            <th style="text-align: center;">STT</th>
                            <th style="text-align: center;">Mã Sản Phẩm</th>
                            <th style="text-align: center;">Hình ảnh</th>
                            <th style="text-align: center;">Màu sắc</th>
                            <th style="text-align: center;">Kích cỡ</th>
                            <th style="text-align: center;">Đơn giá</th>
                            <th style="text-align: center;">Số lượng</th>
                            <th style="text-align: center;">Trạng thái</th>
                            <th style="text-align: center;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody id="variantTbody">
                        <%
                            if (variants != null && !variants.isEmpty()) {
                                int stt = 1;
                                for (ProductDetail v : variants) {
                                    String pStatus = v.getStatus();
                                    if (pStatus == null || pStatus.trim().isEmpty() || pStatus.equals("Hoạt động")) {
                                        pStatus = v.getStock() > 0 ? "Còn hàng" : "Hết hàng";
                                    }
                                    String statusClass = pStatus.equals("Còn hàng") || pStatus.equals("AVAILABLE") ? "available" : "out_of_stock";
                                    String statusLabel = pStatus.equals("Còn hàng") || pStatus.equals("AVAILABLE") ? "Còn hàng" : "Hết hàng";
                        %>
                        <tr class="variant-data-row" id="variant-row-<%= v.getId() %>" data-productcode="<%= (v.getProduct() != null && v.getProduct().getCode() != null) ? v.getProduct().getCode().replace("\"", "&quot;") : "" %>" data-color="<%= v.getColor() != null ? v.getColor().replace("\"", "&quot;") : "" %>" data-size="<%= v.getSize() != null ? v.getSize().replace("\"", "&quot;") : "" %>" data-price="<%= v.getPrice() %>" data-stock="<%= v.getStock() %>" data-status="<%= statusClass.equals("available") ? "AVAILABLE" : "OUT_OF_STOCK" %>">
                            <td style="text-align: center; font-weight: 500; color: #64748b;"><%= stt++ %></td>
                            <td style="text-align: center;">
                                <span class="product-id-text"><%= (v.getProduct() != null && v.getProduct().getCode() != null) ? v.getProduct().getCode() : "N/A" %></span>
                            </td>
                            <td style="text-align: center;">
                                <% if (v.getImages() != null && !v.getImages().isEmpty()) { %>
                                    <img src="${pageContext.request.contextPath}/assets/img/<%= v.getImages().get(0) %>" alt="Image" style="width: 36px; height: 36px; object-fit: cover; border-radius: 6px; border: 1px solid #e2e8f0; display: inline-block;">
                                <% } else { %>
                                    <div style="width: 36px; height: 36px; border-radius: 6px; background-color: #f1f5f9; display: inline-flex; align-items: center; justify-content: center; color: #94a3b8; margin: 0 auto;">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                    </div>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <span class="variant-attr-text"><%= v.getColor() != null ? v.getColor() : "" %></span>
                            </td>
                            <td style="text-align: center;">
                                <span style="background-color: #f1f5f9; color: #475569; font-size: 12px; padding: 4px 8px; border-radius: 4px; font-weight: 600;"><%= v.getSize() != null ? v.getSize() : "" %></span>
                            </td>
                            <td style="text-align: center;">
                                <span class="product-price"><%= String.format("%,.0f", v.getPrice()) %> đ</span>
                            </td>
                            <td style="text-align: center;">
                                <span style="font-weight: 600; color: #475569;"><%= v.getStock() %></span>
                            </td>
                            <td style="text-align: center;">
                                <span class="badge-status <%= statusClass %>"><%= statusLabel %></span>
                            </td>
                            <td style="text-align: center;">
                                <a href="javascript:void(0)" onclick="openEditVariantModal(this)" class="action-icon-btn edit-btn" title="Chỉnh sửa"
                                   data-productcode="<%= (v.getProduct() != null && v.getProduct().getCode() != null) ? v.getProduct().getCode() : "" %>"
                                   data-color="<%= v.getColor() != null ? v.getColor() : "" %>"
                                   data-size="<%= v.getSize() != null ? v.getSize() : "" %>"
                                   data-style="<%= v.getStyle() != null ? v.getStyle() : "" %>"
                                   data-price="<%= String.format("%.0f", v.getPrice()) %>"

                                   data-stock="<%= v.getStock() %>"
                                   data-weight="<%= v.getWeight() %>"
                                   data-length="<%= v.getLength() %>"
                                   data-width="<%= v.getWidth() %>"
                                   data-thickness="<%= v.getThickness() %>"
                                   style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 8px; border: 1px solid #e2e8f0; color: #475569; transition: all 0.2s; margin-right: 8px; vertical-align: middle;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                </a>
                                <label class="switch" title="Chuyển đổi trạng thái" style="vertical-align: middle;">
                                    <input type="checkbox" onchange="toggleVariantStatus(this)" <%= statusClass.equals("available") ? "checked" : "" %>>
                                    <span class="slider"></span>
                                </label>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu biến thể.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                    <!-- Pagination Container -->
                    <div id="paginationContainer" class="pagination-container"></div>
                </div>
            </div>
        </div>
        </div>
    </main>
</div>

<!-- Modal Chỉnh sửa Biến thể -->
<div id="editVariantModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div style="background: #ffffff; border-radius: 12px; width: 90%; max-width: 600px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); display: flex; flex-direction: column; max-height: 90vh;">
        <div style="padding: 16px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; border-radius: 12px 12px 0 0;">
            <h3 style="margin: 0; font-size: 16px; font-weight: 700; color: #1e293b;">Chỉnh sửa biến thể</h3>
            <button type="button" onclick="closeEditVariantModal()" style="background: none; border: none; cursor: pointer; color: #64748b; padding: 4px; display: flex; align-items: center; justify-content: center; border-radius: 6px; transition: background 0.2s;">
                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
        <div style="padding: 24px; overflow-y: auto;">
            <form id="editVariantForm" action="${pageContext.request.contextPath}/admin/variants" method="POST" onsubmit="return validateEditVariantForm()">
                <input type="hidden" name="action" value="edit">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Mã Sản Phẩm</label>
                        <input type="text" id="edit-productCode" name="productCode" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; background-color: #f1f5f9; color: #64748b; font-size: 13px;" readonly>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Kiểu Dáng</label>
                        <input type="text" id="edit-style" name="style" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Màu sắc</label>
                        <input type="text" id="edit-color" name="color" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; background-color: #f1f5f9; color: #64748b; font-size: 13px;" readonly>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Kích cỡ</label>
                        <input type="text" id="edit-size" name="size" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; background-color: #f1f5f9; color: #64748b; font-size: 13px;" readonly>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Đơn Giá (đ) <span style="color: red;">*</span></label>
                        <input type="text" id="edit-price" name="price" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" required oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/\B(?=(\d{3})+(?!\d))/g, ',')">
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Số Lượng <span style="color: red;">*</span></label>
                        <input type="number" id="edit-stock" name="stock" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" min="0" step="1" required>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Chiều Dài (cm)</label>
                        <input type="number" id="edit-length" name="length" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" min="0" step="0.1">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Chiều Rộng (cm)</label>
                        <input type="number" id="edit-width" name="width" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" min="0" step="0.1">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Độ Dày (cm)</label>
                        <input type="number" id="edit-thickness" name="thickness" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" min="0" step="0.1">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" style="font-size: 13px; margin-bottom: 6px; display: block; color: #475569; font-weight: 600;">Trọng Lượng (g)</label>
                        <input type="number" id="edit-weight" name="weight" style="width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px;" min="0" step="0.01">
                    </div>
                </div>
                <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px;">
                    <button type="button" onclick="closeEditVariantModal()" style="padding: 8px 16px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; border-radius: 8px; font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s;">Hủy bỏ</button>
                    <button type="submit" style="padding: 8px 16px; background-color: #1e3a8a; color: white; border: none; border-radius: 8px; font-weight: 600; font-size: 13px; cursor: pointer; transition: background 0.2s;">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleVariantStatus(checkbox) {
        var tr = checkbox.closest('tr');
        var statusBadge = tr.querySelector('.badge-status');
        
        var newStatusLabel = checkbox.checked ? 'Còn hàng' : 'Hết hàng';
        var newStatusData = checkbox.checked ? 'AVAILABLE' : 'OUT_OF_STOCK';

        if (checkbox.checked) {
            statusBadge.className = 'badge-status available';
            statusBadge.textContent = newStatusLabel;
            tr.dataset.status = newStatusData;
        } else {
            statusBadge.className = 'badge-status out_of_stock';
            statusBadge.textContent = newStatusLabel;
            tr.dataset.status = newStatusData;
        }
        
        var productCode = tr.dataset.productcode || '';
        var color = tr.dataset.color || '';
        var size = tr.dataset.size || '';
        
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "${pageContext.request.contextPath}/admin/variants", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    if (window.showToast) window.showToast('Cập nhật trạng thái biến thể thành công!', 'success');
                } else {
                    if (window.showToast) window.showToast('Có lỗi xảy ra khi cập nhật trạng thái!', 'error');
                }
            }
        };
        xhr.send("action=toggleStatus&productCode=" + encodeURIComponent(productCode) + "&color=" + encodeURIComponent(color) + "&size=" + encodeURIComponent(size) + "&status=" + encodeURIComponent(newStatusLabel));

        // Gọi lại hàm filter để đồng bộ nếu bộ lọc đang được áp dụng
        if (typeof applyFilters === 'function') {
            applyFilters();
        }
    }

    function openEditVariantModal(btn) {
        document.getElementById('edit-productCode').value = btn.getAttribute('data-productcode');
        document.getElementById('edit-color').value = btn.getAttribute('data-color');
        document.getElementById('edit-size').value = btn.getAttribute('data-size');
        document.getElementById('edit-style').value = btn.getAttribute('data-style');
        
        var rawPrice = btn.getAttribute('data-price');
        document.getElementById('edit-price').value = rawPrice ? rawPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '';
        

        document.getElementById('edit-stock').value = btn.getAttribute('data-stock');
        document.getElementById('edit-weight').value = btn.getAttribute('data-weight');
        document.getElementById('edit-length').value = btn.getAttribute('data-length');
        document.getElementById('edit-width').value = btn.getAttribute('data-width');
        document.getElementById('edit-thickness').value = btn.getAttribute('data-thickness');
        
        var modal = document.getElementById('editVariantModal');
        modal.style.display = 'flex';
    }
    
    function closeEditVariantModal() {
        document.getElementById('editVariantModal').style.display = 'none';
    }

    function validateEditVariantForm() {
        var priceStr = document.getElementById('edit-price').value.replace(/,/g, '');
        var stock = document.getElementById('edit-stock').value;
        var length = document.getElementById('edit-length').value;
        var width = document.getElementById('edit-width').value;
        var thickness = document.getElementById('edit-thickness').value;
        var weight = document.getElementById('edit-weight').value;

        if (priceStr === "" || parseFloat(priceStr) < 0) {
            alert("Đơn giá không được để trống và phải lớn hơn hoặc bằng 0.");
            return false;
        }
        if (stock === "" || parseInt(stock) < 0) {
            alert("Số lượng không được để trống và phải lớn hơn hoặc bằng 0.");
            return false;
        }
        if (length !== "" && parseFloat(length) < 0) {
            alert("Chiều dài phải lớn hơn hoặc bằng 0.");
            return false;
        }
        if (width !== "" && parseFloat(width) < 0) {
            alert("Chiều rộng phải lớn hơn hoặc bằng 0.");
            return false;
        }
        if (thickness !== "" && parseFloat(thickness) < 0) {
            alert("Độ dày phải lớn hơn hoặc bằng 0.");
            return false;
        }
        if (weight !== "" && parseFloat(weight) < 0) {
            alert("Trọng lượng phải lớn hơn hoặc bằng 0.");
            return false;
        }
        return true;
    }

    // ===== FILTER & SEARCH =====
    const minPriceInput = document.getElementById('minPriceInput');
    const maxPriceInput = document.getElementById('maxPriceInput');
    const sliderTrack = document.querySelector('.slider-track');
    const priceRangeText = document.getElementById('priceRangeText');
    const SLIDER_MIN = parseFloat(minPriceInput.min || 0);
    const SLIDER_MAX = parseFloat(minPriceInput.max || 1000000);

    function allVariantRows() {
        return Array.from(document.querySelectorAll('.variant-data-row'));
    }

    function toggleFilterCard() {
        const body = document.getElementById('filterCardBody');
        const btn = document.getElementById('toggleFilterBtn');
        if (body.classList.contains('collapsed')) {
            body.classList.remove('collapsed');
            btn.textContent = 'Nhấn để thu gọn';
        } else {
            body.classList.add('collapsed');
            btn.textContent = 'Nhấn để mở rộng';
        }
    }

    function updateSlider() {
        if(!minPriceInput || !maxPriceInput) return;
        let minVal = parseInt(minPriceInput.value);
        let maxVal = parseInt(maxPriceInput.value);

        if (minVal > maxVal) {
            if (document.activeElement === minPriceInput) {
                minVal = maxVal;
                minPriceInput.value = maxVal;
            } else {
                maxVal = minVal;
                maxPriceInput.value = minVal;
            }
        }

        const span = (SLIDER_MAX - SLIDER_MIN) || 1;
        const percent1 = ((minVal - SLIDER_MIN) / span) * 100;
        const percent2 = ((maxVal - SLIDER_MIN) / span) * 100;

        sliderTrack.style.background = 'linear-gradient(to right, #cbd5e1 ' + percent1 + '%, #10b981 ' + percent1 + '%, #10b981 ' + percent2 + '%, #cbd5e1 ' + percent2 + '%)';
        priceRangeText.innerHTML = minVal.toLocaleString('vi-VN') + ' đ - ' + maxVal.toLocaleString('vi-VN') + ' đ';

        applyFilters();
    }

    let currentPage = 1;
    const itemsPerPage = 10;

    function applyFilters(page = 1) {
        currentPage = page;
        const keyword = (document.getElementById('searchInput').value || '').toLowerCase().trim();
        const sizeFilter = document.getElementById('sizeFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const minPriceVal = parseFloat(minPriceInput.value);
        const maxPriceVal = parseFloat(maxPriceInput.value);

        const rows = allVariantRows();
        let visible = [];

        rows.forEach(row => {
            const rowProductId = (row.dataset.productid || '').toLowerCase();
            const rowColor = (row.dataset.color || '').toLowerCase();
            const matchSearch = !keyword ||
                rowProductId.includes(keyword) ||
                rowColor.includes(keyword);

            const matchSize = !sizeFilter || row.dataset.size === sizeFilter;

            let matchStatus = true;
            if (statusFilter === 'AVAILABLE') {
                matchStatus = row.dataset.status === 'AVAILABLE';
            } else if (statusFilter === 'OUT_OF_STOCK') {
                matchStatus = row.dataset.status === 'OUT_OF_STOCK';
            }

            const rowPrice = parseFloat(row.dataset.price || 0);
            const matchPrice = (rowPrice >= minPriceVal && rowPrice <= maxPriceVal);

            if (matchSearch && matchSize && matchStatus && matchPrice) {
                visible.push(row);
            } else {
                row.style.display = 'none';
            }
        });

        // Pagination Logic
        const totalItems = visible.length;
        const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;
        
        if (currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;

        // Display only rows for the current page
        visible.forEach((row, idx) => {
            if (idx >= startIndex && idx < endIndex) {
                row.style.display = '';
                // Update STT based on overall filtered index
                const sttCell = row.querySelector('td:first-child');
                if (sttCell) sttCell.textContent = idx + 1;
            } else {
                row.style.display = 'none';
            }
        });

        const noResultsRow = document.getElementById('noResultsRow');
        if (noResultsRow) {
            noResultsRow.style.display = visible.length === 0 ? '' : 'none';
        }

        const hasFilter = keyword || sizeFilter || statusFilter || minPriceVal > SLIDER_MIN || maxPriceVal < SLIDER_MAX;
        document.getElementById('resetBtn').style.display = hasFilter ? 'flex' : 'none';

        renderPagination(totalItems, totalPages);
    }

    function renderPagination(totalItems, totalPages) {
        const container = document.getElementById('paginationContainer');
        if (!container) return;
        
        container.innerHTML = '';
        
        if (totalItems === 0 || totalPages <= 1) {
            return; // No pagination needed
        }

        // Previous button
        const prevBtn = document.createElement('button');
        prevBtn.className = 'page-btn';
        prevBtn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="15 18 9 12 15 6"></polyline></svg>';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => applyFilters(currentPage - 1);
        container.appendChild(prevBtn);

        // Page buttons
        for (let i = 1; i <= totalPages; i++) {
            if (totalPages > 7) {
                if (i !== 1 && i !== totalPages && Math.abs(i - currentPage) > 1) {
                    if (i === 2 || i === totalPages - 1) {
                        const dots = document.createElement('span');
                        dots.innerHTML = '...';
                        dots.style.padding = '0 5px';
                        dots.style.color = '#94a3b8';
                        container.appendChild(dots);
                    }
                    continue;
                }
            }

            const pageBtn = document.createElement('button');
            pageBtn.className = 'page-btn' + (i === currentPage ? ' active' : '');
            pageBtn.textContent = i;
            pageBtn.onclick = () => applyFilters(i);
            container.appendChild(pageBtn);
        }

        // Next button
        const nextBtn = document.createElement('button');
        nextBtn.className = 'page-btn';
        nextBtn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="9 18 15 12 9 6"></polyline></svg>';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => applyFilters(currentPage + 1);
        container.appendChild(nextBtn);
    }

    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('sizeFilter').value = '';
        document.getElementById('statusFilter').value = '';
        
        // Reset radio buttons
        const radios = document.getElementsByName('statusRadio');
        for(let i = 0; i < radios.length; i++) {
            if(radios[i].value === '') radios[i].checked = true;
        }

        // Reset sliders
        minPriceInput.value = SLIDER_MIN;
        maxPriceInput.value = SLIDER_MAX;
        
        updateSlider(); // also calls applyFilters()
    }

    document.addEventListener('DOMContentLoaded', () => {
        updateSlider(); // Initialize slider UI & apply initial filters
    });
</script>

<!-- Thư viện QRCode.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

<!-- Modal hiển thị QR Code Biến Thể -->
<div id="qrModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div style="background: #ffffff; border-radius: 12px; width: 90%; max-width: 400px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); display: flex; flex-direction: column;">
        <div style="padding: 16px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; border-radius: 12px 12px 0 0;">
            <h3 style="margin: 0; font-size: 16px; font-weight: 700; color: #1e293b;">Mã QR Biến Thể</h3>
            <button type="button" onclick="closeQRModal()" style="background: none; border: none; cursor: pointer; color: #64748b; padding: 4px; display: flex; align-items: center; justify-content: center;">
                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
        </div>
        <div style="padding: 24px; display: flex; flex-direction: column; align-items: center; justify-content: center;">
            <div id="qrcode" style="margin-bottom: 16px; padding: 10px; background: white; border: 1px solid #e2e8f0; border-radius: 8px;"></div>
            <p style="text-align: center; color: #64748b; font-size: 13px; margin: 0;">Quét mã này để xem danh sách biến thể ngay trên điện thoại.</p>
        </div>
    </div>
</div>

<script>
    function removeAccents(str) {
        return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
    }

    function showQRModal() {
        document.getElementById('qrModal').style.display = 'flex';
        const qrContainer = document.getElementById('qrcode');
        qrContainer.innerHTML = '';

        // Lấy các dòng biến thể đang hiển thị trên bảng
        const rows = document.querySelectorAll('#variantTbody tr');
        let text = "DANH SACH BIEN THE\n\n";
        let count = 0;

        for (let i = 0; i < rows.length; i++) {
            if (rows[i].style.display === 'none') continue;
            const id   = rows[i].dataset.productid || '';
            const size  = removeAccents(rows[i].dataset.size || '');
            const color = removeAccents(rows[i].dataset.color || '');
            const price = parseInt(rows[i].dataset.price || 0).toLocaleString('vi-VN');
            const stock = rows[i].dataset.stock || '0';

            text += "SP: " + id + " | " + size + " / " + color + "\n";
            text += "Gia: " + price + "d | Ton: " + stock + "\n";
            text += "------------------\n";
            count++;
            if (count >= 5) {
                text += "(Hien " + count + " bien the dau)\n";
                break;
            }
        }
        if (count === 0) text += "Khong co bien the nao.";

        try {
            new QRCode(qrContainer, {
                text: text,
                width: 250,
                height: 250,
                colorDark: "#0f172a",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.M
            });
        } catch(e) {
            qrContainer.innerHTML = '<p style="color:red;text-align:center">Lỗi tạo mã QR.</p>';
        }
    }

    function closeQRModal() {
        document.getElementById('qrModal').style.display = 'none';
    }
</script>

<jsp:include page="/WEB-INF/views/layout/toast.jsp" />
</body>
</html>
