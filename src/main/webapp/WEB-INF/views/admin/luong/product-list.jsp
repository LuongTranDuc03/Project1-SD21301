<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
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
        /* Custom card style with border radius and header */
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
        .toggle-filter-btn {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 12px;
            cursor: pointer;
            font-weight: 500;
            transition: color 0.2s;
        }
        .toggle-filter-btn:hover {
            color: #ffffff;
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

        /* Filter Grid Layout */
        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 16px 24px;
        }
        @media (max-width: 992px) {
            .filter-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
        @media (max-width: 576px) {
            .filter-grid {
                grid-template-columns: 1fr;
            }
        }
        .filter-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .filter-field label {
            font-size: 12px;
            font-weight: 600;
            color: #475569;
        }
        .filter-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            height: 38px;
            border-radius: 6px;
            font-size: 13px;
            font-family: inherit;
            color: #1e293b;
            background: #ffffff;
            outline: none;
            transition: all 0.2s;
            box-sizing: border-box;
        }
        .filter-control:focus {
            border-color: #12192D;
            box-shadow: 0 0 0 3px rgba(18, 25, 45, 0.08);
        }

        /* Dual price slider */
        .price-slider-container {
            position: relative;
            width: 100%;
            height: 20px;
            margin-top: 5px;
        }
        .price-slider-container input[type="range"] {
            position: absolute;
            width: 100%;
            height: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            pointer-events: none;
            -webkit-appearance: none;
            appearance: none;
            margin: 0;
            z-index: 2;
        }
        .price-slider-container input[type="range"]::-webkit-slider-runnable-track {
            background: transparent;
            border: none;
        }
        .price-slider-container input[type="range"]::-moz-range-track {
            background: transparent;
            border: none;
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
            position: absolute;
            width: 100%;
            height: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #cbd5e1;
            border-radius: 5px;
            z-index: 1;
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

        /* Modern Switch Styling */
        .switch {
            position: relative;
            display: inline-block;
            width: 34px;
            height: 18px;
            flex-shrink: 0;
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
            transition: .2s;
            border-radius: 18px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 12px;
            width: 12px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .2s;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(15,23,42,0.25);
        }
        input:checked + .slider {
            background-color: #10b981;
        }
        input:checked + .slider:before {
            transform: translateX(16px);
        }
        /* Align table headers in one line and shrink font size if too big */
        .invoice-table th {
            white-space: nowrap !important;
            font-size: 11px !important;
            padding: 12px 20px !important;
        }

        /* Action Buttons Styling */
        .action-icon-btn.edit-btn,
        .action-icon-btn.details-btn {
            width: 32px !important;
            height: 32px !important;
            border-radius: 8px !important;
            border: 1px solid #e2e8f0 !important;
            background-color: #ffffff !important;
            color: #475569 !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            transition: all 0.2s ease !important;
            flex-shrink: 0 !important;
        }
        .action-icon-btn.edit-btn:hover,
        .action-icon-btn.details-btn:hover {
            background-color: #f1f5f9 !important;
            color: #0f172a !important;
            border-color: #cbd5e1 !important;
            transform: translateY(-1px) !important;
        }
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
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                int totalProducts = (products != null) ? products.size() : 0;

                java.util.Set<String> categories = new java.util.TreeSet<>();
                java.util.Set<String> brands = new java.util.TreeSet<>();

                // Tính giá thấp nhất / cao nhất theo biến thể trên toàn bộ sản phẩm
                double globalMinPrice = Double.MAX_VALUE;
                double globalMaxPrice = 0.0;
                if (products != null) {
                    for (Product p : products) {
                        if (p.getCategory() != null && !p.getCategory().trim().isEmpty()) {
                            categories.add(p.getCategory().trim());
                        }
                        if (p.getBrand() != null && !p.getBrand().trim().isEmpty()) {
                            brands.add(p.getBrand().trim());
                        }

                        // Xác định giá min/max của sản phẩm này (dựa theo biến thể nếu có)
                        double pMin = p.getPrice();
                        double pMax = p.getPrice();
                        if (p.getDetails() != null && !p.getDetails().isEmpty()) {
                            pMin = Double.MAX_VALUE; pMax = 0.0;
                            for (ProductDetail d : p.getDetails()) {
                                if (d.getPrice() < pMin) pMin = d.getPrice();
                                if (d.getPrice() > pMax) pMax = d.getPrice();
                            }
                        }
                        if (pMin < globalMinPrice) globalMinPrice = pMin;
                        if (pMax > globalMaxPrice) globalMaxPrice = pMax;
                    }
                }
                // Chống trường hợp không có dữ liệu / min == max
                if (globalMinPrice == Double.MAX_VALUE) globalMinPrice = 0.0;
                if (globalMaxPrice < globalMinPrice) globalMaxPrice = globalMinPrice;
                long sliderMin = (long) Math.floor(globalMinPrice);
                long sliderMax = (long) Math.ceil(globalMaxPrice);
                if (sliderMax <= sliderMin) sliderMax = sliderMin + 1;
            %>
            <!-- Tiêu đề trang -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <div>
                    <h1>Quản lý sản phẩm</h1>
                    <div class="subtitle">Tổng <%= totalProducts %> sản phẩm</div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/admin/products?action=exportExcel" class="btn-export" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="8" y1="13" x2="16" y2="13"></line><line x1="8" y1="17" x2="16" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <span>Xuất Excel</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-export" style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; height: 38px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Thêm sản phẩm</span>
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
                            <input type="text" id="searchInput" class="filter-control" placeholder="Tìm theo mã SP, tên sản phẩm..." oninput="applyFilters()">
                        </div>
                        <!-- Danh mục -->
                        <div class="filter-field">
                            <label for="categoryFilter">Danh mục</label>
                            <select id="categoryFilter" class="filter-control" onchange="applyFilters()">
                                <option value="">-- Chọn Danh mục --</option>
                                <% for (String cat : categories) { %>
                                <option value="<%= cat %>"><%= cat %></option>
                                <% } %>
                            </select>
                        </div>
                        <!-- Thương hiệu -->
                        <div class="filter-field">
                            <label for="brandFilter">Thương hiệu</label>
                            <select id="brandFilter" class="filter-control" onchange="applyFilters()">
                                <option value="">-- Chọn Thương hiệu --</option>
                                <% for (String br : brands) { %>
                                <option value="<%= br %>"><%= br %></option>
                                <% } %>
                            </select>
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
                        <!-- Đặt lại -->
                        <div class="filter-field" style="justify-content: flex-end; align-items: flex-end;">
                            <button type="button" class="btn-reset-filter" onclick="resetFilters()" id="resetBtn" style="display: none; align-items: center; gap: 6px; padding: 10px 16px; font-weight: 600; border-radius: 6px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; cursor: pointer; transition: all 0.2s; font-size: 13px; width: fit-content; box-sizing: border-box; height: 38px;">
                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 .49-3.5"></path></svg>
                                Đặt lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bảng danh sách sản phẩm (Table layout) -->
            <div class="custom-card">
                <div class="card-header-bar">
                    <span class="card-header-title">&#8226; Bảng dữ liệu sản phẩm</span>
                </div>
                    <table class="invoice-table" style="table-layout: fixed; width: 100%;">
                        <thead>
                        <tr>
                            <th style="text-align: center; width: 50px;">STT</th>
                            <th style="text-align: left; width: 120px;">Mã sản phẩm</th>
                            <th style="text-align: left; width: 240px;">Tên sản phẩm</th>
                            <th style="text-align: left; width: 130px;">Danh mục</th>
                            <th style="text-align: left; width: 130px;">Thương hiệu</th>
                            <th style="text-align: left; width: 150px;">Khoảng giá</th>
                            <th style="text-align: center; width: 120px;">Tổng số lượng</th>
                            <th style="text-align: center; width: 120px;">Trạng thái</th>
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
                                    String pStatus = prod.getStatus();
                                    if (pStatus == null || pStatus.trim().isEmpty() || pStatus.equals("Hoạt động")) {
                                        pStatus = prod.getStock() > 0 ? "AVAILABLE" : "OUT_OF_STOCK";
                                    }
                                    if ("AVAILABLE".equals(pStatus)) {
                                        statusLabel = "Còn hàng";
                                        statusClass = "available";
                                    } else if ("OUT_OF_STOCK".equals(pStatus)) {
                                        statusLabel = "Hết hàng";
                                        statusClass = "out_of_stock";
                                    }
                                    double minPrice = prod.getPrice(); double maxPrice = prod.getPrice();
                                    if (prod.getDetails() != null && !prod.getDetails().isEmpty()) {
                                        minPrice = Double.MAX_VALUE; maxPrice = Double.MIN_VALUE; for (ProductDetail d : prod.getDetails()) {
                                            if (d.getPrice() < minPrice) {
                                                minPrice = d.getPrice(); } if (d.getPrice() > maxPrice) { maxPrice = d.getPrice();
                                            }
                                        }
                                    }
                        %>
                        <tr data-id="<%= prod.getId() %>" data-name="<%= prod.getName() != null ? prod.getName().toLowerCase() : "" %>" data-category="<%= prod.getCategory() %>" data-brand="<%= prod.getBrand() != null ? prod.getBrand().toLowerCase() : "" %>" data-status="<%= prod.getStatus() != null ? prod.getStatus() : "" %>" data-min-price="<%= minPrice %>" data-max-price="<%= maxPrice %>" data-stock="<%= prod.getStock() %>">
                            <td style="text-align: center; font-weight: 500; color: #64748b;"><%= stt++ %></td>
                            <td>
                                <span class="product-id-text"><%= prod.getId() %></span>
                            </td>
                            <td>
                                <span class="product-name-text"><%= prod.getName() != null ? prod.getName() : "" %></span>
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
                                <span style="font-weight: 600; color: #475569;"><%= prod.getStock() %></span>
                            </td>
                            <td style="text-align: center;">
                                <span class="badge-status <%= statusClass %>"><%= statusLabel %></span>
                            </td>
                            <td style="text-align: center;">
                                <div style="display: flex; gap: 4px; justify-content: center; align-items: center;">
                                    <!-- Chi tiết -->
                                    <a href="${pageContext.request.contextPath}/admin/products?id=<%= prod.getId() %>" class="action-icon-btn details-btn" title="Chi tiết">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                    </a>
                                    <!-- Sửa -->
                                    <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= prod.getId() %>" class="action-icon-btn edit-btn" title="Chỉnh sửa" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                    </a>
                                    <!-- Toggle status -->
                                    <label class="switch" title="Chuyển trạng thái" style="margin-left: 4px;">
                                        <input type="checkbox" <%= !"OUT_OF_STOCK".equals(prod.getStatus()) ? "checked" : "" %>
                                               onchange="toggleProductStatus('<%= prod.getId() %>', this)">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>

                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu sản phẩm.</td>
                        </tr>
                        <%
                            }
                        %>
                        <tr id="noResultsRow" class="no-results-row" style="display:none;">
                            <td colspan="9" style="text-align: center; padding: 48px; color: #94a3b8;">
                                <svg viewBox="0 0 24 24" width="32" height="32" stroke="#cbd5e1" stroke-width="1.5" fill="none" style="margin-bottom:10px; display:block; margin-inline:auto;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                Không tìm thấy sản phẩm phù hợp với bộ lọc hiện tại.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    
                    <!-- Pagination Container -->
                    <div id="paginationContainer" class="pagination-container"></div>
            </div>
        </div>
    </main>
</div>

<script>
    // ===== TOGGLE STATUS =====
    window.toggleProductStatus = function(productId, checkboxEl) {
        const row = document.querySelector('#productTbody tr[data-id="' + productId + '"]');
        const badge = row ? row.querySelector('.badge-status') : null;

        // Store old state for rollback
        const oldChecked = !checkboxEl.checked;
        let oldStatus = 'AVAILABLE';
        let oldBadgeText = 'Còn hàng';
        let oldBadgeClass = 'available';

        if (badge) {
            if (badge.classList.contains('out_of_stock')) {
                oldStatus = 'OUT_OF_STOCK';
                oldBadgeText = 'Hết hàng';
                oldBadgeClass = 'out_of_stock';
            }
        }

        // Optimistically update the UI immediately
        const isChecked = checkboxEl.checked;
        const optStatus = isChecked ? 'AVAILABLE' : 'OUT_OF_STOCK';
        const optText = isChecked ? 'Còn hàng' : 'Hết hàng';
        const optClass = isChecked ? 'available' : 'out_of_stock';

        if (row) {
            row.dataset.status = optStatus;
        }
        if (badge) {
            badge.className = 'badge-status ' + optClass;
            badge.textContent = optText;
        }

        applyFilters();

        const formData = new URLSearchParams();
        formData.append('id', productId);

        fetch('${pageContext.request.contextPath}/admin/products?action=toggleStatus', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
            .then(res => {
                if (!res.ok) throw new Error('Network response was not ok');
                return res.json();
            })
            .then(data => {
                if (data.success) {
                    // Confirmed by server. Update row state if server status is different
                    if (row) {
                        row.dataset.status = data.newStatus;
                    }
                    if (badge) {
                        badge.className = 'badge-status';
                        if (data.newStatus === 'AVAILABLE') {
                            badge.classList.add('available');
                            badge.textContent = 'Còn hàng';
                        } else if (data.newStatus === 'OUT_OF_STOCK') {
                            badge.classList.add('out_of_stock');
                            badge.textContent = 'Hết hàng';
                        }
                    }
                    applyFilters();
                    if (window.showToast) window.showToast('Cập nhật trạng thái sản phẩm thành công!', 'success');
                } else {
                    // Rollback on failure
                    checkboxEl.checked = oldChecked;
                    if (row) row.dataset.status = oldStatus;
                    if (badge) {
                        badge.className = 'badge-status ' + oldBadgeClass;
                        badge.textContent = oldBadgeText;
                    }
                    applyFilters();
                    if (window.showToast) window.showToast('Không thể cập nhật trạng thái!', 'error');
                    else alert('Không thể cập nhật trạng thái!');
                }
            })
            .catch(err => {
                console.error(err);
                // Rollback on connection error
                checkboxEl.checked = oldChecked;
                if (row) row.dataset.status = oldStatus;
                if (badge) {
                    badge.className = 'badge-status ' + oldBadgeClass;
                    badge.textContent = oldBadgeText;
                }
                applyFilters();
                if (window.showToast) window.showToast('Có lỗi xảy ra khi kết nối server!', 'error');
                else alert('Có lỗi xảy ra khi kết nối server!');
            });
    };

    // ===== FILTER & SEARCH =====
    let currentCategory = '';
    const minPriceInput = document.getElementById('minPriceInput');
    const maxPriceInput = document.getElementById('maxPriceInput');
    const sliderTrack = document.querySelector('.slider-track');
    const priceRangeText = document.getElementById('priceRangeText');
    // Giới hạn giá lấy từ biến thể thấp nhất / cao nhất (tính ở server)
    const SLIDER_MIN = <%= sliderMin %>;
    const SLIDER_MAX = <%= sliderMax %>;
    const allRows = () => Array.from(document.querySelectorAll('#productTbody tr[data-id]'));
    const totalCount = allRows().length || 0; // captured before any filter

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
        let minVal = parseInt(minPriceInput.value);
        let maxVal = parseInt(maxPriceInput.value);

        // Không cho tay kéo min vượt qua tay kéo max và ngược lại
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



    function applyFilters_old() {
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

    function resetFilters_old() {
        document.getElementById('searchInput').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('sortSelect').value = '';
        currentCategory = '';
        document.querySelectorAll('.cat-pill').forEach(p => p.classList.remove('active'));
        document.querySelector('.cat-pill[data-cat=""]').classList.add('active');
        applyFilters();
    }

    document.addEventListener('DOMContentLoaded_old', () => {
        // Init result info
        applyFilters();
    });
    // ===== NEW FILTER IMPLEMENTATION WITH PAGINATION =====
    let currentPage = 1;
    const itemsPerPage = 10;

    function applyFilters(page = 1) {
        currentPage = page;
        const keyword = (document.getElementById('searchInput').value || '').toLowerCase().trim();
        const category = document.getElementById('categoryFilter').value;
        const brand = document.getElementById('brandFilter').value;
        const status = document.getElementById('statusFilter').value;
        const minPriceVal = parseFloat(minPriceInput.value);
        const maxPriceVal = parseFloat(maxPriceInput.value);

        const rows = allRows();
        let visible = [];

        rows.forEach(row => {
            const matchSearch = !keyword ||
                row.dataset.name.toLowerCase().includes(keyword) ||
                row.dataset.id.toLowerCase().includes(keyword) ||
                row.dataset.brand.toLowerCase().includes(keyword);

            const matchCat = !category || row.dataset.category === category;
            const matchBrand = !brand || row.dataset.brand.toLowerCase().includes(brand.toLowerCase());

            let matchStatus = true;
            if (status === 'AVAILABLE') {
                matchStatus = row.dataset.status === 'AVAILABLE';
            } else if (status === 'OUT_OF_STOCK') {
                matchStatus = row.dataset.status === 'OUT_OF_STOCK';
            }

            const rowMinPrice = parseFloat(row.dataset.minPrice || 0);
            const rowMaxPrice = parseFloat(row.dataset.maxPrice || 0);
            const matchPrice = (rowMinPrice <= maxPriceVal && rowMaxPrice >= minPriceVal);

            if (matchSearch && matchCat && matchBrand && matchStatus && matchPrice) {
                visible.push(row);
            } else {
                row.style.display = 'none'; // Hide non-matching rows immediately
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

        // No results row
        document.getElementById('noResultsRow').style.display = visible.length === 0 ? '' : 'none';

        // Reset button — show if any filter is active
        const hasFilter = keyword || category || brand || status || minPriceVal > SLIDER_MIN || maxPriceVal < SLIDER_MAX;
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
            // Basic logic to show limited pages if too many
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
        document.getElementById('categoryFilter').value = '';
        document.getElementById('brandFilter').value = '';
        document.getElementById('statusFilter').value = '';
        
        const defaultStatusRadio = document.querySelector('input[name="statusRadio"][value=""]');
        if (defaultStatusRadio) defaultStatusRadio.checked = true;

        minPriceInput.value = SLIDER_MIN;
        maxPriceInput.value = SLIDER_MAX;

        updateSlider();
    }

    document.addEventListener('DOMContentLoaded', () => {
        updateSlider();

        const priceContainer = document.querySelector('.price-slider-container');
        if (priceContainer && minPriceInput && maxPriceInput) {
            priceContainer.addEventListener('mousemove', (e) => {
                const rect = priceContainer.getBoundingClientRect();
                const mouseX = e.clientX - rect.left;
                const width = rect.width;
                const ratio = mouseX / width;
                const currentVal = SLIDER_MIN + ratio * (SLIDER_MAX - SLIDER_MIN);

                const distMin = Math.abs(parseFloat(minPriceInput.value) - currentVal);
                const distMax = Math.abs(parseFloat(maxPriceInput.value) - currentVal);

                if (distMin < distMax) {
                    minPriceInput.style.zIndex = '10';
                    maxPriceInput.style.zIndex = '2';
                } else {
                    maxPriceInput.style.zIndex = '10';
                    minPriceInput.style.zIndex = '2';
                }
            });
        }
    });
</script>

<%-- Toast thông báo dùng chung --%>
<jsp:include page="/WEB-INF/views/layout/toast.jsp" />

</body>
</html>
