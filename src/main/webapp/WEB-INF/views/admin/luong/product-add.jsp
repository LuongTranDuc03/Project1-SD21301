<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%
    Product product = (Product) request.getAttribute("product");
    boolean isEdit = (product != null && !"true".equals(request.getAttribute("isValidationAddError")));
    String pageTitleStr = (String) request.getAttribute("pageTitle");
    if (pageTitleStr == null) {
        pageTitleStr = isEdit ? "Chỉnh sửa sản phẩm " + product.getId() : "Thêm sản phẩm mới";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitleStr %> - FamiCoats Admin</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .form-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            overflow: visible;
            margin-bottom: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .form-card-title {
            background-color: #12192D;
            color: #ffffff;
            padding: 12px 20px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 8px;
            border-radius: 8px 8px 0 0;
        }
        .form-card-title svg {
            color: #ffffff !important;
        }
        .form-card-body {
            padding: 24px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px 24px;
        }
        @media (max-width: 992px) {
            .form-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-label {
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-input, .form-select, .form-textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 13px;
            color: #1e293b;
            font-family: inherit;
            outline: none;
            transition: all 0.2s ease;
            background-color: #ffffff;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: #0f172a;
            box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.15);
        }
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }
        .variant-card {
            background-color: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 16px;
            position: relative;
            animation: slideDown 0.25s ease-out;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .variant-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            border-bottom: 1px dashed #e2e8f0;
            padding-bottom: 8px;
        }
        .variant-title {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-remove-variant {
            background: none;
            border: none;
            color: #ef4444;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 6px;
            transition: background-color 0.2s;
        }
        .btn-remove-variant:hover {
            background-color: #fef2f2;
        }
        .variant-row {
            display: grid;
            gap: 12px 16px;
            margin-bottom: 14px;
        }
        .variant-row-3 {
            grid-template-columns: repeat(3, 1fr);
        }
        .variant-row-4 {
            grid-template-columns: repeat(4, 1fr);
        }
        .variant-row-1 {
            grid-template-columns: 1fr;
        }
        @media (max-width: 768px) {
            .variant-row-3, .variant-row-4 {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .variant-row-3, .variant-row-4 {
                grid-template-columns: 1fr;
            }
        }
        .btn-add-variant {
            background-color: #f1f5f9;
            border: 1px dashed #94a3b8;
            color: #475569;
            width: 100%;
            padding: 14px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 24px;
        }
        .btn-add-variant:hover {
            background-color: #e2e8f0;
            color: #0f172a;
            border-color: #64748b;
        }
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid #e2e8f0;
            padding-top: 20px;
        }
        .btn-submit {
            background-color: #FB7185;
            color: #ffffff;
            border: 1px solid #FB7185;
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-submit:hover {
            background-color: #f43f5e;
            border-color: #f43f5e;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.25);
        }
        .btn-cancel {
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            color: #475569;
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .custom-select-trigger:hover {
            border-color: #0f172a;
        }
        .custom-select-wrapper.open .custom-select-trigger,
        .custom-select-wrapper:focus-within .custom-select-trigger {
            border-color: #0f172a;
            box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.15);
        }
        .custom-select-wrapper.open svg {
            transform: rotate(180deg);
        }
        .custom-select-option:hover {
            background-color: #fff1f2;
            color: #E11D48 !important;
        }

        .basic-select-option:hover {
            background-color: #0056b3;
            color: white !important;
        }

        .btn-add-img:hover {
            border-color: #FB7185 !important;
            background-color: #fff1f2 !important;
        }
        .btn-add-img:hover svg {
            stroke: #FB7185 !important;
        }
        .btn-add-img:hover span {
            color: #FB7185 !important;
        }

        /* Back to list button styling */
        .back-btn {
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            color: #334155;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }
        .back-btn:hover {
            background-color: #f8fafc;
            border-color: #94a3b8;
            color: #0f172a;
        }

        /* Confirm Modal Style */
        .confirm-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(8px);
            z-index: 2000;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s ease;
        }
        .confirm-modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }
        .confirm-modal-card {
            background-color: #ffffff;
            border-radius: 12px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border: 1px solid #e2e8f0;
            padding: 24px;
            text-align: center;
            transform: scale(0.95);
            transition: transform 0.25s ease;
        }
        .confirm-modal-overlay.active .confirm-modal-card {
            transform: scale(1);
        }
        .confirm-modal-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }
        .confirm-title {
            margin: 0;
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
        }
        .confirm-modal-body {
            font-size: 13px;
            color: #475569;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .confirm-modal-footer {
            display: flex;
            justify-content: center;
            gap: 12px;
        }
        .confirm-btn-no {
            background-color: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #334155;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .confirm-btn-no:hover {
            background-color: #e2e8f0;
        }
        .confirm-btn-yes {
            background-color: #e11d48;
            border: 1px solid #e11d48;
            color: #ffffff;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .confirm-btn-yes:hover {
            background-color: #be123c;
            border-color: #be123c;
        }
        .confirm-btn-danger {
            background-color: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #475569;
            cursor: pointer;
            transition: all 0.2s;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
        }
        .confirm-btn-danger:hover {
            background-color: #e2e8f0;
            color: #0f172a;
        }

        /* Styles for Automatic Variant Generation */
        .tag-pill {
            background-color: #f1f5f9;
            color: #1e3a8a;
            border-radius: 16px;
            padding: 4px 10px;
            font-size: 13px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .tag-pill .remove-tag {
            cursor: pointer;
            color: #64748b;
            display: flex;
            align-items: center;
        }
        .tag-pill .remove-tag:hover {
            color: #ef4444;
        }
        .color-group-header {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            padding: 12px 16px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
            color: #1e293b;
        }
        .color-group-body {
            border: 1px solid #e2e8f0;
            border-top: none;
            border-radius: 0 0 8px 8px;
            padding: 16px;
            margin-bottom: 24px;
            background: #ffffff;
        }
        .variant-table {
            width: 100%;
            border-collapse: collapse;
        }
        .variant-table th {
            text-align: left;
            font-size: 13px;
            color: #334155;
            font-weight: 700;
            padding-bottom: 12px;
        }
        .variant-table td {
            padding: 8px 8px 8px 0;
            vertical-align: middle;
        }
        .btn-apply-group {
            background-color: #1e3a8a;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: background 0.2s;
        }
        .btn-apply-group:hover {
            background-color: #1e40af;
        }
        .img-by-color-card {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            width: 140px;
            display: flex;
            flex-direction: column;
            background: #ffffff;
            overflow: hidden;
        }
        .img-by-color-header {
            padding: 8px 12px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .img-by-color-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            height: 100px;
        }
        .img-by-color-body:hover {
            background-color: #f8fafc;
        }
        .img-preview-box {
            width: 100%;
            height: 100%;
            object-fit: contain;
            display: none;
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Nhúng Sidebar dùng chung -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <!-- Khu vực nội dung chính bên phải -->
    <main class="main-content">
        <!-- Navbar trên cùng -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span> / <a href="${pageContext.request.contextPath}/admin/products" style="color: inherit; text-decoration: none;">Quản lý sản phẩm</a> / <span class="active-crumb"><%= isEdit ? "Chỉnh sửa" : "Thêm mới" %></span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                    <span class="notif-badge"></span>
                </button>
                <div class="date-pill">Thứ Sáu, 10/07/2026</div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <!-- Thân trang -->
        <div class="content-wrapper">
            <!-- Tiêu đề trang & Nút Quay lại -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <div>
                    <h1><%= pageTitleStr %></h1>
                    <div class="subtitle"><%= isEdit ? "Cập nhật các thông tin thuộc tính và biến thể sản phẩm" : "Khởi tạo sản phẩm mới cùng các thuộc tính và biến thể hàng hóa" %></div>
                </div>
                <div>
                    <% if (isEdit) { %>
                    <a href="javascript:void(0)" onclick="handleEditBack(event)" class="back-btn">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        <span>Quay lại danh sách</span>
                    </a>
                    <% } else { %>
                    <a href="javascript:void(0)" onclick="confirmBackToList(event)" class="back-btn">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                        <span>Quay lại danh sách</span>
                    </a>
                    <% } %>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/admin/products" method="POST" id="productForm" onsubmit="return validateForm()">
                    <% if (request.getAttribute("errorMessage") != null) { %>
                <div style="background-color: #fee2e2; color: #b91c1c; padding: 12px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; border: 1px solid #f87171; font-weight: 500;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: text-bottom; margin-right: 4px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <%= request.getAttribute("errorMessage") %>
                </div>
                    <% } %>
                    <% if (isEdit) { %>
                <input type="hidden" name="isEdit" value="true">
                    <% } %>
                <!-- 1. Thông tin chung sản phẩm -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        Thông tin chung sản phẩm
                    </div>
                    <div class="form-card-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="id">Mã sản phẩm <span style="color: red;">*</span></label>
                                <input type="text" id="id" name="id" class="form-input" placeholder="Ví dụ: SP001" value="<%= product != null && product.getId() != null ? product.getId() : "" %>" <%= isEdit ? "readonly style='background-color: #f1f5f9; cursor: not-allowed;'" : "" %> required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="name">Tên sản phẩm <span style="color: red;">*</span></label>
                                <input type="text" id="name" name="name" class="form-input" placeholder="Nhập tên sản phẩm..." value="<%= product != null && product.getName() != null ? product.getName() : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="category">Danh mục</label>
                                <select id="category" name="category" class="form-select" required>
                                    <option value="Áo khoác da" <%= product != null && "Áo khoác da".equals(product.getCategory()) ? "selected" : "" %>>Áo khoác da</option>
                                    <option value="Áo bomber" <%= product != null && "Áo bomber".equals(product.getCategory()) ? "selected" : "" %>>Áo bomber</option>
                                    <option value="Áo denim" <%= product != null && "Áo denim".equals(product.getCategory()) ? "selected" : "" %>>Áo denim</option>
                                    <option value="Áo phao" <%= product != null && "Áo phao".equals(product.getCategory()) ? "selected" : "" %>>Áo phao</option>
                                    <option value="Áo gió" <%= product != null && "Áo gió".equals(product.getCategory()) ? "selected" : "" %>>Áo gió</option>
                                    <option value="Áo len" <%= product != null && "Áo len".equals(product.getCategory()) ? "selected" : "" %>>Áo len</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="brand">Thương hiệu</label>
                                <div class="custom-select-wrapper" id="brand-select-wrapper" style="position: relative; width: 100%;">
                                    <div class="custom-select-trigger form-select" onclick="toggleBrandSelect(event)" style="display: flex; align-items: center; justify-content: space-between; cursor: pointer; height: 41.6px;">
                                        <div style="display: flex; align-items: center; gap: 8px; flex: 1; overflow: hidden;">
                                            <span id="brand-display" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= product != null && product.getBrand() != null && !product.getBrand().isEmpty() ? product.getBrand() : "FamiCoats" %></span>
                                            <input type="hidden" name="brand" id="brand" value="<%= product != null && product.getBrand() != null && !product.getBrand().isEmpty() ? product.getBrand() : "FamiCoats" %>">
                                        </div>
                                        <svg class="chevron-icon" viewBox="0 0 24 24" width="16" height="16" stroke="#475569" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="transition: transform 0.2s ease; flex-shrink: 0;"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                    </div>
                                    <div class="custom-select-options" id="brand-options" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: #ffffff; border: 1px solid #767676; z-index: 100; max-height: 250px; overflow-y: auto;">
                                        <div style="position: sticky; top: 0; background: white; border-bottom: 1px solid #767676; z-index: 2;">
                                            <input type="text" id="brand-search" placeholder="Tìm kiếm hoặc thêm mới..." style="width: 100%; padding: 4px; border: none; outline: none; font-size: 13px; font-family: inherit;" oninput="filterBrandOptions(this.value)" onclick="event.stopPropagation()">
                                        </div>
                                        <div id="brand-list">
                                            <div class="basic-select-option" data-value="FamiCoats" onclick="selectBrandOption('FamiCoats')" style="padding: 4px; font-size: 13px; cursor: pointer;">FamiCoats</div>
                                            <div class="basic-select-option" data-value="Zara" onclick="selectBrandOption('Zara')" style="padding: 4px; font-size: 13px; cursor: pointer;">Zara</div>
                                            <div class="basic-select-option" data-value="H&M" onclick="selectBrandOption('H&M')" style="padding: 4px; font-size: 13px; cursor: pointer;">H&M</div>
                                            <div class="basic-select-option" data-value="Uniqlo" onclick="selectBrandOption('Uniqlo')" style="padding: 4px; font-size: 13px; cursor: pointer;">Uniqlo</div>
                                            <div class="basic-select-option" data-value="Gucci" onclick="selectBrandOption('Gucci')" style="padding: 4px; font-size: 13px; cursor: pointer;">Gucci</div>
                                            <div class="basic-select-option" data-value="Dior" onclick="selectBrandOption('Dior')" style="padding: 4px; font-size: 13px; cursor: pointer;">Dior</div>
                                        </div>
                                        <div id="brand-no-result" style="display: none; padding: 4px; font-size: 13px;">
                                            No results found / <a href="javascript:void(0)" onclick="addNewBrand()" style="color: blue; text-decoration: none;" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'">Add new</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="origin">Xuất xứ</label>
                                <div class="custom-select-wrapper" id="origin-select-wrapper" style="position: relative; width: 100%;">
                                    <div class="custom-select-trigger form-select" onclick="toggleOriginSelect(event)" style="display: flex; align-items: center; justify-content: space-between; cursor: pointer; height: 41.6px;">
                                        <div style="display: flex; align-items: center; gap: 8px; flex: 1; overflow: hidden;">
                                            <span id="origin-display" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= product != null && product.getOrigin() != null && !product.getOrigin().isEmpty() ? product.getOrigin() : "Việt Nam" %></span>
                                            <input type="hidden" name="origin" id="origin" value="<%= product != null && product.getOrigin() != null && !product.getOrigin().isEmpty() ? product.getOrigin() : "Việt Nam" %>">
                                        </div>
                                        <svg class="chevron-icon" viewBox="0 0 24 24" width="16" height="16" stroke="#475569" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="transition: transform 0.2s ease; flex-shrink: 0;"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                    </div>
                                    <div class="custom-select-options" id="origin-options" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: #ffffff; border: 1px solid #767676; z-index: 100; max-height: 250px; overflow-y: auto;">
                                        <div style="position: sticky; top: 0; background: white; border-bottom: 1px solid #767676; z-index: 2;">
                                            <input type="text" id="origin-search" placeholder="Tìm kiếm hoặc thêm mới..." style="width: 100%; padding: 4px; border: none; outline: none; font-size: 13px; font-family: inherit;" oninput="filterOriginOptions(this.value)" onclick="event.stopPropagation()">
                                        </div>
                                        <div id="origin-list">
                                            <div class="basic-select-option" data-value="Việt Nam" onclick="selectOriginOption('Việt Nam')" style="padding: 4px; font-size: 13px; cursor: pointer;">Việt Nam</div>
                                            <div class="basic-select-option" data-value="Trung Quốc" onclick="selectOriginOption('Trung Quốc')" style="padding: 4px; font-size: 13px; cursor: pointer;">Trung Quốc</div>
                                            <div class="basic-select-option" data-value="Hàn Quốc" onclick="selectOriginOption('Hàn Quốc')" style="padding: 4px; font-size: 13px; cursor: pointer;">Hàn Quốc</div>
                                            <div class="basic-select-option" data-value="Nhật Bản" onclick="selectOriginOption('Nhật Bản')" style="padding: 4px; font-size: 13px; cursor: pointer;">Nhật Bản</div>
                                            <div class="basic-select-option" data-value="Mỹ" onclick="selectOriginOption('Mỹ')" style="padding: 4px; font-size: 13px; cursor: pointer;">Mỹ</div>
                                            <div class="basic-select-option" data-value="Thái Lan" onclick="selectOriginOption('Thái Lan')" style="padding: 4px; font-size: 13px; cursor: pointer;">Thái Lan</div>
                                            <div class="basic-select-option" data-value="Ý" onclick="selectOriginOption('Ý')" style="padding: 4px; font-size: 13px; cursor: pointer;">Ý</div>
                                            <div class="basic-select-option" data-value="Pháp" onclick="selectOriginOption('Pháp')" style="padding: 4px; font-size: 13px; cursor: pointer;">Pháp</div>
                                        </div>
                                        <div id="origin-no-result" style="display: none; padding: 4px; font-size: 13px;">
                                            No results found / <a href="javascript:void(0)" onclick="addNewOrigin()" style="color: blue; text-decoration: none;" onmouseover="this.style.textDecoration='underline'" onmouseout="this.style.textDecoration='none'">Add new</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="careInstructions">Hướng dẫn bảo quản</label>
                                <textarea id="careInstructions" name="careInstructions" class="form-textarea" placeholder="Nhập hướng dẫn bảo quản sản phẩm..."><%= product != null && product.getCareInstructions() != null ? product.getCareInstructions() : "" %></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="description">Mô tả sản phẩm</label>
                                <textarea id="description" name="description" class="form-textarea" placeholder="Nhập mô tả sản phẩm chi tiết..."><%= product != null && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. Cấu hình biến thể tự động -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                        Cấu hình biến thể sản phẩm
                    </div>
                    <div class="form-card-body">
                        <div style="display: flex; gap: 16px; margin-bottom: 16px; flex-wrap: wrap;">
                            <div style="flex: 1; min-width: 250px; position: relative;">
                                <label class="form-label" style="margin-bottom: 8px; display: block;">Màu sắc <span style="color: red;">*</span></label>
                                <div class="tag-input-container" id="color-tags-container" style="border: 1px solid #cbd5e1; border-radius: 8px; padding: 6px; display: flex; flex-wrap: wrap; gap: 6px; min-height: 42px; align-items: center; background: #fff; cursor: text;" onclick="document.getElementById('color-input').focus()">
                                    <input type="text" id="color-input" autocomplete="off" placeholder="Tìm và chọn màu sắc" style="border: none; outline: none; flex: 1; min-width: 180px; font-size: 13px;" onfocus="openTagDropdown('color-options')" oninput="filterTagDropdown('color-options', this.value)" onclick="event.stopPropagation()">
                                </div>
                                <div class="custom-select-options tag-dropdown-menu" id="color-options" style="display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); z-index: 100; max-height: 200px; overflow-y: auto;">
                                    <div class="tag-option" data-val="Đen" onclick="selectTagOption('Đen', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #000000; display: inline-block;"></span>Đen
                                    </div>
                                    <div class="tag-option" data-val="Trắng" onclick="selectTagOption('Trắng', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #FFFFFF; border: 1px solid #cbd5e1; display: inline-block;"></span>Trắng
                                    </div>
                                    <div class="tag-option" data-val="Navy" onclick="selectTagOption('Navy', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #1B365D; display: inline-block;"></span>Navy
                                    </div>
                                    <div class="tag-option" data-val="Be" onclick="selectTagOption('Be', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #E6D7C3; display: inline-block;"></span>Be
                                    </div>
                                    <div class="tag-option" data-val="Xám" onclick="selectTagOption('Xám', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #808080; display: inline-block;"></span>Xám
                                    </div>
                                    <div class="tag-option" data-val="Đỏ đô" onclick="selectTagOption('Đỏ đô', 'color-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #8B0000; display: inline-block;"></span>Đỏ đô
                                    </div>
                                </div>
                            </div>
                            <div style="flex: 1; min-width: 250px; position: relative;">
                                <label class="form-label" style="margin-bottom: 8px; display: block;">Kích cỡ <span style="color: red;">*</span></label>
                                <div class="tag-input-container" id="size-tags-container" style="border: 1px solid #cbd5e1; border-radius: 8px; padding: 6px; display: flex; flex-wrap: wrap; gap: 6px; min-height: 42px; align-items: center; background: #fff; cursor: text;" onclick="document.getElementById('size-input').focus()">
                                    <input type="text" id="size-input" autocomplete="off" placeholder="Tìm và chọn kích cỡ" style="border: none; outline: none; flex: 1; min-width: 180px; font-size: 13px;" onfocus="openTagDropdown('size-options')" oninput="filterTagDropdown('size-options', this.value)" onclick="event.stopPropagation()">
                                </div>
                                <div class="custom-select-options tag-dropdown-menu" id="size-options" style="display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); z-index: 100; max-height: 200px; overflow-y: auto;">
                                    <div class="tag-option" data-val="S" onclick="selectTagOption('S', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">S</div>
                                    <div class="tag-option" data-val="M" onclick="selectTagOption('M', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">M</div>
                                    <div class="tag-option" data-val="L" onclick="selectTagOption('L', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">L</div>
                                    <div class="tag-option" data-val="XL" onclick="selectTagOption('XL', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">XL</div>
                                    <div class="tag-option" data-val="XXL" onclick="selectTagOption('XXL', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">XXL</div>
                                    <div class="tag-option" data-val="3XL" onclick="selectTagOption('3XL', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">3XL</div>
                                    <div class="tag-option" data-val="Free size" onclick="selectTagOption('Free size', 'size-input')" style="padding: 8px 12px; font-size: 13px; color: #334155; cursor: pointer;">Free size</div>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn-generate-variants" id="btnGenerateVariants" onclick="generateVariants()" style="width: 100%; padding: 12px; background-color: #1e3a8a; color: white; border: none; border-radius: 8px; font-weight: 700; font-size: 14px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: background 0.2s;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                            Tạo biến thể tự động
                        </button>

                        <!-- Danh sách biến thể đã tạo -->
                        <div id="generated-variants-container" style="margin-top: 24px;"></div>

                        <!-- Phần ảnh theo màu sắc -->
                        <div id="images-section" style="margin-top: 32px; display: none;">
                            <h3 style="font-size: 16px; font-weight: 700; color: #1e293b; display: flex; align-items: center; gap: 8px; margin-bottom: 16px;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                Ảnh theo màu sắc
                            </h3>
                            <div id="images-by-color-container" style="display: flex; flex-wrap: wrap; gap: 16px;"></div>
                        </div>
                    </div>
                </div>
        </div>

        <!-- Form Actions -->
        <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px; margin-bottom: 40px;">
            <button type="button" class="btn-cancel" onclick="handleCancelBtn(event)" style="padding: 10px 24px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; border-radius: 8px; font-weight: 600; font-size: 14px; cursor: pointer; transition: all 0.2s;">
                Hủy bỏ
            </button>
            <button type="submit" class="btn-save" style="padding: 10px 24px; background-color: #1e3a8a; color: white; border: none; border-radius: 8px; font-weight: 600; font-size: 14px; cursor: pointer; transition: background 0.2s; display: flex; align-items: center; gap: 8px;">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                Lưu sản phẩm
            </button>
        </div>
        </form>
</div>
</main>
</div>
<script>
    let selectedColors = [];
    let selectedSizes = [];
    let generatedVariants = {};
    let colorImages = {};
    let isFormDirty = false;

    function validateForm() {
        var id = document.getElementById("id").value;
        var name = document.getElementById("name").value;

        if (!id || id.trim() === "") {
            alert("Vui lòng nhập Mã sản phẩm.");
            return false;
        }
        if (!name || name.trim() === "") {
            alert("Vui lòng nhập Tên sản phẩm.");
            return false;
        }
        if (selectedColors.length === 0) {
            alert("Vui lòng chọn ít nhất một màu sắc!");
            return false;
        }
        if (selectedSizes.length === 0) {
            alert("Vui lòng chọn ít nhất một kích cỡ!");
            return false;
        }
        var generatedKeys = Object.keys(generatedVariants);
        if (generatedKeys.length === 0) {
            alert("Vui lòng bấm 'Tạo biến thể tự động' sau khi chọn màu sắc và kích cỡ để tạo danh sách biến thể!");
            return false;
        }

        let hasVariantError = false;
        let errorMsg = "";
        for (let i = 0; i < generatedKeys.length; i++) {
            let color = generatedKeys[i];
            let variants = generatedVariants[color];
            for (let j = 0; j < variants.length; j++) {
                let v = variants[j];
                let p = parseFloat(v.price);
                let st = parseInt(v.stock);
                if (isNaN(p) || p < 0) {
                    hasVariantError = true;
                    errorMsg = "Đơn giá của biến thể (Màu: " + color + ", Kích cỡ: " + v.size + ") không hợp lệ!";
                    break;
                }
                if (isNaN(st) || st < 0) {
                    hasVariantError = true;
                    errorMsg = "Số lượng của biến thể (Màu: " + color + ", Kích cỡ: " + v.size + ") không hợp lệ!";
                    break;
                }
            }
            if (hasVariantError) break;
        }
        if (hasVariantError) {
            alert(errorMsg);
            return false;
        }

        return true;
    }

    window.openTagDropdown = function(dropdownId) {
        document.querySelectorAll('.tag-dropdown-menu').forEach(el => el.style.display = 'none');
        const dropdown = document.getElementById(dropdownId);
        if (dropdown) dropdown.style.display = 'block';
    };

    window.filterTagDropdown = function(dropdownId, searchText) {
        const dropdown = document.getElementById(dropdownId);
        if (!dropdown) return;
        const options = dropdown.querySelectorAll('.tag-option');
        const lowerSearch = searchText.toLowerCase().trim();
        options.forEach(opt => {
            const text = opt.getAttribute('data-val').toLowerCase();
            if (text.includes(lowerSearch)) {
                opt.style.display = 'flex';
            } else {
                opt.style.display = 'none';
            }
        });
        dropdown.style.display = 'block';
    };

    window.selectTagOption = function(val, inputId) {
        const input = document.getElementById(inputId);
        if (input) {
            input.value = '';
            let dataArray, containerId, placeholderText;
            if (inputId === 'color-input') {
                dataArray = selectedColors;
                containerId = 'color-tags-container';
                placeholderText = 'Tìm và chọn màu sắc (ấn Enter để thêm)...';
            } else {
                dataArray = selectedSizes;
                containerId = 'size-tags-container';
                placeholderText = 'Tìm và chọn kích cỡ (ấn Enter để thêm)...';
            }
            if (val && !dataArray.includes(val)) {
                dataArray.push(val);
                renderTags(containerId, dataArray, inputId, placeholderText);
                isFormDirty = true;
            }
            input.focus();
        }
    };

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.tag-input-container') && !e.target.closest('.tag-dropdown-menu')) {
            document.querySelectorAll('.tag-dropdown-menu').forEach(el => el.style.display = 'none');
        }
    });

    function setupTagInput(inputId, containerId, dataArray, placeholderText) {
        const input = document.getElementById(inputId);
        const container = document.getElementById(containerId);

        input.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const val = this.value.trim();
                if (val && !dataArray.includes(val)) {
                    dataArray.push(val);
                    renderTags(containerId, dataArray, inputId, placeholderText);
                    this.value = '';
                    isFormDirty = true;
                }
            }
        });
        input.addEventListener('blur', function() {
            const val = this.value.trim();
            if (val && !dataArray.includes(val)) {
                dataArray.push(val);
                renderTags(containerId, dataArray, inputId, placeholderText);
                this.value = '';
                isFormDirty = true;
            }
        });
    }

    function getClientColorHex(colorName) {
        switch (colorName.toLowerCase()) {
            case "đen": return "#000000";
            case "trắng": return "#ffffff";
            case "be": case "beige": return "#E6D7C3";
            case "navy": case "xanh navy": return "#1B365D";
            case "đỏ đô": case "đỏ đậm": return "#8B0000";
            case "đỏ": return "#EF4444";
            case "xám": case "ghi": return "#808080";
            case "xanh dương": case "xanh lam": return "#3B82F6";
            case "xanh lá": case "xanh lục": return "#10B981";
            case "vàng": return "#FBBF24";
            case "cam": return "#F97316";
            case "hồng": return "#EC4899";
            case "nâu": return "#78350F";
            case "kem": return "#FFFDD0";
            case "tím": return "#8B5CF6";
            case "xanh rêu": return "#4B5320";
            default: return "#cbd5e1";
        }
    }

    function renderTags(containerId, dataArray, inputId, placeholderText) {
        const container = document.getElementById(containerId);
        const input = document.getElementById(inputId);

        const oldTags = container.querySelectorAll('.tag-pill');
        oldTags.forEach(t => t.remove());

        dataArray.forEach((val, index) => {
            let colorCircleHtml = '';
            if (containerId === 'color-tags-container') {
                const hex = getClientColorHex(val);
                colorCircleHtml = `<span style="width: 10px; height: 10px; border-radius: 50%; background-color: \${hex}; border: 1px solid #cbd5e1; display: inline-block;"></span>`;
            } else {
                colorCircleHtml = `<span style="width: 6px; height: 6px; border-radius: 50%; background-color: #475569; display: inline-block;"></span>`;
            }

            const tag = document.createElement('div');
            tag.className = 'tag-pill';
            tag.innerHTML = `
                    \${colorCircleHtml}
                    \${val}
                    <span class="remove-tag" onclick="removeTag('\${containerId}', \${index}, '\${inputId}', '\${placeholderText}'); event.stopPropagation();">
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                    </span>
                `;
            container.insertBefore(tag, input);
        });

        if (dataArray.length > 0) {
            input.placeholder = '';
        } else {
            input.placeholder = placeholderText;
        }
    }

    window.removeTag = function(containerId, index, inputId, placeholderText) {
        if (containerId === 'color-tags-container') {
            selectedColors.splice(index, 1);
            renderTags(containerId, selectedColors, inputId, placeholderText);
        } else if (containerId === 'size-tags-container') {
            selectedSizes.splice(index, 1);
            renderTags(containerId, selectedSizes, inputId, placeholderText);
        }
        isFormDirty = true;
    };

    window.generateVariants = function() {
        if (selectedColors.length === 0 || selectedSizes.length === 0) {
            alert("Vui lòng nhập ít nhất 1 Màu sắc và 1 Kích cỡ để tạo biến thể.");
            return;
        }

        const newGenerated = {};
        selectedColors.forEach(color => {
            newGenerated[color] = [];
            selectedSizes.forEach(size => {
                let existing = null;
                if (generatedVariants[color]) {
                    existing = generatedVariants[color].find(v => v.size === size);
                }
                if (existing) {
                    newGenerated[color].push(existing);
                } else {
                    newGenerated[color].push({
                        size: size,
                        stock: 10,
                        price: 0,
                        style: '',
                        weight: 0.5,
                        length: 20,
                        width: 20,
                        thickness: 5,
                        status: 'Còn hàng'
                    });
                }
            });
        });

        generatedVariants = newGenerated;
        isFormDirty = true;
        renderGeneratedTable();
        renderImagesSection();
    };

    function renderGeneratedTable() {
        const container = document.getElementById('generated-variants-container');
        container.innerHTML = '';

        Object.keys(generatedVariants).forEach((color, cIdx) => {
            const variants = generatedVariants[color];

            const groupDiv = document.createElement('div');
            groupDiv.style.marginBottom = '24px';

            let tbodyHtml = '';
            variants.forEach((v, vIdx) => {
                tbodyHtml += `<tr>`;
                if (vIdx === 0) {
                    tbodyHtml += `
                            <td style="width: 12%; vertical-align: middle; background: #fff;" rowspan="\${variants.length}">
                                <div style="width: 100px; height: 100px; border: 1px dashed #cbd5e1; border-radius: 4px; overflow: hidden; display: flex; flex-direction: column; align-items: center; justify-content: center; background: #f8fafc; cursor: pointer; position: relative; margin: 0 auto;" onclick="document.getElementById('img-input-\${cIdx}').click()">
                                    <img id="img-preview-\${cIdx}" src="${pageContext.request.contextPath}/assets/img/\${colorImages[color] || 'anh-default.png'}" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/assets/img/anh-default.png'">
                                    <div style="position: absolute; bottom: 0; left: 0; right: 0; background: rgba(0,0,0,0.6); color: white; font-size: 11px; font-weight: 500; text-align: center; padding: 6px 0;">Thêm ảnh</div>
                                </div>
                                <input type="file" id="img-input-\${cIdx}" accept="image/*" style="display: none;" onchange="handleColorImageUpload(this, '\${color}', 'img-preview-\${cIdx}')">
                            </td>
                        `;
                }
                tbodyHtml += `
                            <td style="width: 10%;">
                                <input type="text" class="form-input" value="\${v.size}" readonly style="background: #f8fafc; color: #475569; font-weight: 600; border-color: #e2e8f0; pointer-events: none; margin-bottom: 4px;">
                                <input type="hidden" name="variantSize" value="\${v.size}">
                                <input type="hidden" name="variantColor" value="\${color}">
                                <input type="hidden" name="variantImage" class="hidden-img-input-\${cIdx}" value="\${colorImages[color] || 'anh-default.png'}">
                                <input type="hidden" name="variantImportPrice" value="0">
                            </td>
                            <td style="width: 13%;">
                                <input type="text" name="variantStyle" class="form-input style-input-\${cIdx}" placeholder="Ví dụ: Slim-fit" value="\${v.style || ''}" onchange="updateVariantData('\${color}', '\${v.size}', 'style', this.value)">
                            </td>
                            <td style="width: 22%;">
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 4px;">
                                    <div style="display: flex; align-items: center; gap: 4px;">
                                        <span style="font-size: 11px; color: #64748b; width: 28px;">Dài</span>
                                        <input type="number" name="variantLength" class="form-input len-input-\${cIdx}" value="\${v.length || 20}" min="0" step="0.1" style="padding: 2px 6px; font-size: 12px; height: 24px; width: 100px;" oninput="if(this.value < 0) this.value = 0;" onchange="updateVariantData('\${color}', '\${v.size}', 'length', this.value)">
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 4px;">
                                        <span style="font-size: 11px; color: #64748b; width: 28px;">Rộng</span>
                                        <input type="number" name="variantWidth" class="form-input wid-input-\${cIdx}" value="\${v.width || 20}" min="0" step="0.1" style="padding: 2px 6px; font-size: 12px; height: 24px; width: 100px;" oninput="if(this.value < 0) this.value = 0;" onchange="updateVariantData('\${color}', '\${v.size}', 'width', this.value)">
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 4px;">
                                        <span style="font-size: 11px; color: #64748b; width: 28px;">Dày</span>
                                        <input type="number" name="variantThickness" class="form-input thi-input-\${cIdx}" value="\${v.thickness || 5}" min="0" step="0.1" style="padding: 2px 6px; font-size: 12px; height: 24px; width: 100px;" oninput="if(this.value < 0) this.value = 0;" onchange="updateVariantData('\${color}', '\${v.size}', 'thickness', this.value)">
                                    </div>
                                    <div style="display: flex; align-items: center; gap: 4px;">
                                        <span style="font-size: 11px; color: #64748b; width: 28px;">Nặng</span>
                                        <input type="number" name="variantWeight" class="form-input wei-input-\${cIdx}" value="\${v.weight || 0.5}" min="0" step="0.01" style="padding: 2px 6px; font-size: 12px; height: 24px; width: 100px;" oninput="if(this.value < 0) this.value = 0;" onchange="updateVariantData('\${color}', '\${v.size}', 'weight', this.value)">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 13%;">
                                <input type="text" name="variantPrice" class="form-input price-input-\${cIdx}" value="\${(v.price || 0).toLocaleString('en-US')}" style="padding: 6px; font-size: 12px; text-align: right;" oninput="formatNumberInput(this, '\${color}', '\${v.size}', 'price')">
                            </td>
                            <td style="width: 12%;">
                                <input type="text" name="variantStock" class="form-input stock-input-\${cIdx}" value="\${(v.stock || 0).toLocaleString('en-US')}" style="padding: 6px; font-size: 12px; text-align: right;" oninput="formatNumberInput(this, '\${color}', '\${v.size}', 'stock')">
                            </td>
                            <td style="width: 15%;">
                                <select name="variantStatus" class="form-select status-input-\${cIdx}" style="padding: 6px; font-size: 12px;" onchange="updateVariantData('\${color}', '\${v.size}', 'status', this.value)">
                                    <option value="Còn hàng" \${v.status === 'Còn hàng' || v.status === 'Hoạt động' ? 'selected' : ''}>Còn hàng</option>
                                    <option value="Hết hàng" \${v.status === 'Hết hàng' || v.status === 'Ngừng hoạt động' ? 'selected' : ''}>Hết hàng</option>
                                </select>
                            </td>
                            <td style="width: 5%; text-align: center;">
                                <button type="button" onclick="removeVariantRow('\${color}', '\${v.size}')" style="background: #fee2e2; border: none; color: #ef4444; width: 24px; height: 24px; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background 0.2s;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                </button>
                            </td>
                        </tr>
                    `;
            });

            groupDiv.innerHTML = `
                    <div class="color-group-header">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #1e293b; display: inline-block;"></span>
                            \${color} <span style="color: #64748b; font-size: 13px; font-weight: 500;">(\${variants.length} kích cỡ)</span>
                        </div>
                        <button type="button" class="btn-apply-group" onclick="applyToAllGroups('\${color}')">
                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                            Áp dụng cho tất cả
                        </button>
                    </div>
                    <div class="color-group-body">
                        <table class="variant-table">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Kích cỡ</th>
                                    <th>Kiểu dáng</th>
                                    <th>Thông số (cm, kg)</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Trạng thái</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                \${tbodyHtml}
                            </tbody>
                        </table>
                    </div>
                `;
            container.appendChild(groupDiv);
        });
    }

    window.handleColorImageUpload = function(input, color, previewId) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById(previewId).src = e.target.result;
                colorImages[color] = file.name;

                if (generatedVariants[color]) {
                    generatedVariants[color].forEach(v => {
                        v.image = file.name;
                    });
                }

                document.querySelectorAll('input[name="variantColor"]').forEach(inp => {
                    if (inp.value === color) {
                        const imgInp = inp.parentElement.querySelector('input[name="variantImage"]');
                        if (imgInp) imgInp.value = file.name;
                    }
                });

                renderImagesSection();
            };
            reader.readAsDataURL(file);
            isFormDirty = true;
        }
    };

    window.handleVariantImageUpload = function(input, color, size, previewId, cIdx) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById(previewId).src = e.target.result;
                updateVariantData(color, size, 'image', file.name);
                const hiddenInput = input.parentElement.querySelector('input[name="variantImage"]');
                if (hiddenInput) {
                    hiddenInput.value = file.name;
                }
            };
            reader.readAsDataURL(file);
            isFormDirty = true;
        }
    };

    window.formatNumberInput = function(input, color, size, field) {
        let rawValue = input.value.replace(/[^0-9]/g, '');
        if (!rawValue) rawValue = '0';
        let num = parseInt(rawValue, 10);
        input.value = num.toLocaleString('en-US');
        updateVariantData(color, size, field, num);
    };

    window.updateVariantData = function(color, size, field, value) {
        if (generatedVariants[color]) {
            const variant = generatedVariants[color].find(v => v.size === size);
            if (variant) {
                if (['length', 'width', 'thickness', 'weight', 'price', 'stock'].includes(field)) {
                    if (parseFloat(value) < 0) value = 0;
                }
                variant[field] = value;
                isFormDirty = true;
            }
        }
    };

    window.removeVariantRow = function(color, size) {
        if (generatedVariants[color]) {
            generatedVariants[color] = generatedVariants[color].filter(v => v.size !== size);
            if (generatedVariants[color].length === 0) {
                delete generatedVariants[color];
                selectedColors = selectedColors.filter(c => c !== color);
                renderTags('color-tags-container', selectedColors, 'color-input', 'Tìm và chọn màu sắc');
            }
            isFormDirty = true;
            renderGeneratedTable();
            renderImagesSection();
        }
    };

    window.applyToAllGroups = function(sourceColor) {
        const sourceVariants = generatedVariants[sourceColor];
        if (!sourceVariants) return;

        sourceVariants.forEach(sourceVar => {
            const size = sourceVar.size;
            Object.keys(generatedVariants).forEach(targetColor => {
                if (targetColor !== sourceColor) {
                    const targetVar = generatedVariants[targetColor].find(v => v.size === size);
                    if (targetVar) {
                        targetVar.stock = sourceVar.stock;
                        targetVar.price = sourceVar.price;
                        targetVar.style = sourceVar.style;
                        targetVar.length = sourceVar.length;
                        targetVar.width = sourceVar.width;
                        targetVar.thickness = sourceVar.thickness;
                        targetVar.weight = sourceVar.weight;
                        targetVar.status = sourceVar.status;
                    }
                }
            });
        });

        isFormDirty = true;
        renderGeneratedTable();
    };

    // Các hàm cho combobox Xuất xứ
    window.openOriginSelect = function() {
        const wrapper = document.getElementById('origin-select-wrapper');
        const options = document.getElementById('origin-options');

        document.querySelectorAll('.custom-select-options').forEach(opt => opt.style.display = 'none');
        document.querySelectorAll('.custom-select-wrapper').forEach(w => w.classList.remove('open'));

        options.style.display = 'block';
        wrapper.classList.add('open');
        setTimeout(() => {
            document.getElementById('origin-search').focus();
        }, 10);
    };

    window.toggleOriginSelect = function(event) {
        event.stopPropagation();
        const wrapper = document.getElementById('origin-select-wrapper');
        const options = document.getElementById('origin-options');

        if (options.style.display === 'none') {
            openOriginSelect();
        } else {
            options.style.display = 'none';
            wrapper.classList.remove('open');
        }
    };

    window.selectOriginOption = function(originName) {
        const wrapper = document.getElementById('origin-select-wrapper');
        const options = document.getElementById('origin-options');
        const inputEl = document.getElementById('origin');
        const displayEl = document.getElementById('origin-display');

        inputEl.value = originName;
        displayEl.textContent = originName;

        options.style.display = 'none';
        wrapper.classList.remove('open');
        isFormDirty = true;
    };

    window.filterOriginOptions = function(searchText) {
        const list = document.getElementById('origin-list');
        const items = list.querySelectorAll('.custom-select-option');
        const noResult = document.getElementById('origin-no-result');
        let hasResult = false;

        const lowerSearch = searchText.toLowerCase().trim();

        items.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(lowerSearch)) {
                item.style.display = 'block';
                hasResult = true;
            } else {
                item.style.display = 'none';
            }
        });

        if (hasResult) {
            noResult.style.display = 'none';
            list.style.display = 'block';
        } else {
            noResult.style.display = 'block';
            list.style.display = 'none';
        }
    };

    window.addNewOrigin = function() {
        const searchInput = document.getElementById('origin-search');
        const newVal = searchInput.value.trim();
        if (newVal) {
            const list = document.getElementById('origin-list');
            const newOption = document.createElement('div');
            newOption.className = 'basic-select-option';
            newOption.setAttribute('data-value', newVal);
            newOption.setAttribute('onclick', `selectOriginOption('\${newVal}')`);
            newOption.style = 'padding: 4px; font-size: 13px; cursor: pointer; border-bottom: 1px solid #e5e7eb;';
            newOption.textContent = newVal;

            list.appendChild(newOption);
            selectOriginOption(newVal);

            searchInput.value = '';
            filterOriginOptions('');
        }
    };

    // Các hàm cho combobox Thương hiệu
    window.openBrandSelect = function() {
        const wrapper = document.getElementById('brand-select-wrapper');
        const options = document.getElementById('brand-options');

        document.querySelectorAll('.custom-select-options').forEach(opt => opt.style.display = 'none');
        document.querySelectorAll('.custom-select-wrapper').forEach(w => w.classList.remove('open'));

        options.style.display = 'block';
        wrapper.classList.add('open');
        setTimeout(() => {
            document.getElementById('brand-search').focus();
        }, 10);
    };

    window.toggleBrandSelect = function(event) {
        event.stopPropagation();
        const wrapper = document.getElementById('brand-select-wrapper');
        const options = document.getElementById('brand-options');

        if (options.style.display === 'none') {
            openBrandSelect();
        } else {
            options.style.display = 'none';
            wrapper.classList.remove('open');
        }
    };

    window.selectBrandOption = function(brandName) {
        const wrapper = document.getElementById('brand-select-wrapper');
        const options = document.getElementById('brand-options');
        const inputEl = document.getElementById('brand');
        const displayEl = document.getElementById('brand-display');

        inputEl.value = brandName;
        displayEl.textContent = brandName;

        options.style.display = 'none';
        wrapper.classList.remove('open');
        isFormDirty = true;
    };

    window.filterBrandOptions = function(searchText) {
        const list = document.getElementById('brand-list');
        const items = list.querySelectorAll('.basic-select-option');
        const noResult = document.getElementById('brand-no-result');
        let hasResult = false;

        const lowerSearch = searchText.toLowerCase().trim();

        items.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(lowerSearch)) {
                item.style.display = 'block';
                hasResult = true;
            } else {
                item.style.display = 'none';
            }
        });

        if (hasResult) {
            noResult.style.display = 'none';
            list.style.display = 'block';
        } else {
            noResult.style.display = 'block';
            list.style.display = 'none';
        }
    };

    window.addNewBrand = function() {
        const searchInput = document.getElementById('brand-search');
        const newVal = searchInput.value.trim();
        if (newVal) {
            const list = document.getElementById('brand-list');
            const newOption = document.createElement('div');
            newOption.className = 'basic-select-option';
            newOption.setAttribute('data-value', newVal);
            newOption.setAttribute('onclick', `selectBrandOption('\${newVal}')`);
            newOption.style = 'padding: 4px; font-size: 13px; cursor: pointer; border-bottom: 1px solid #e5e7eb;';
            newOption.textContent = newVal;

            list.appendChild(newOption);
            selectBrandOption(newVal);

            searchInput.value = '';
            filterBrandOptions('');
        }
    };



    // Đăng ký bộ lắng nghe sự kiện
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('productForm');
        if (form) {
            form.addEventListener('input', () => { isFormDirty = true; });
            form.addEventListener('change', () => { isFormDirty = true; });
            form.addEventListener('submit', () => { isFormDirty = false; });
        }
    });

    document.addEventListener('click', function(event) {
        // Đóng các dropdown Thương hiệu, Xuất xứ nếu click ra ngoài
        if (!event.target.closest('#brand-select-wrapper')) {
            const brandOptions = document.getElementById('brand-options');
            if (brandOptions) brandOptions.style.display = 'none';
            const brandWrapper = document.getElementById('brand-select-wrapper');
            if (brandWrapper) brandWrapper.classList.remove('open');
        }
        if (!event.target.closest('#origin-select-wrapper')) {
            const originOptions = document.getElementById('origin-options');
            if (originOptions) originOptions.style.display = 'none';
            const originWrapper = document.getElementById('origin-select-wrapper');
            if (originWrapper) originWrapper.classList.remove('open');
        }
        // Đóng các dropdown tag Màu sắc, Kích cỡ
        if (!event.target.closest('.tag-input-container') && !event.target.closest('.tag-dropdown-menu')) {
            document.querySelectorAll('.tag-dropdown-menu').forEach(el => el.style.display = 'none');
        }
    });

    // Xử lý confirm quay lại danh sách khi thêm mới sản phẩm
    window.confirmBackToList = function(event) {
        if (event) event.preventDefault();
        const modal = document.getElementById('confirmBackModal');
        modal.style.display = 'flex';
        setTimeout(() => {
            modal.classList.add('active');
        }, 10);
    };

    window.closeConfirmModal = function() {
        const modal = document.getElementById('confirmBackModal');
        modal.classList.remove('active');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 250);
    };

    // Xử lý confirm quay lại danh sách khi chỉnh sửa sản phẩm có thay đổi dữ liệu
    window.handleEditBack = function(event) {
        if (event) event.preventDefault();
        if (isFormDirty) {
            const modal = document.getElementById('editConfirmBackModal');
            modal.style.display = 'flex';
            setTimeout(() => {
                modal.classList.add('active');
            }, 10);
        } else {
            proceedBackToList();
        }
    };

    window.closeEditConfirmModal = function() {
        const modal = document.getElementById('editConfirmBackModal');
        modal.classList.remove('active');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 250);
    };

    window.saveAndGoBack = function() {
        const form = document.getElementById('productForm');
        if (form) {
            if (typeof validateForm === 'function' && !validateForm()) {
                closeEditConfirmModal();
                return;
            }
            isFormDirty = false;
            form.submit();
        }
    };

    // Xử lý nút Hủy bỏ ở cuối form
    window.handleCancelBtn = function(event) {
        if (event) event.preventDefault();
        const isEditMode = <%= isEdit %>;
        if (isEditMode) {
            if (isFormDirty) {
                const modal = document.getElementById('editConfirmBackModal');
                modal.style.display = 'flex';
                setTimeout(() => {
                    modal.classList.add('active');
                }, 10);
            } else {
                proceedBackToList();
            }
        } else {
            // Thêm mới sản phẩm thì dùng modal của thêm mới
            confirmBackToList(event);
        }
    };

    window.proceedBackToList = function() {
        window.location.href = "${pageContext.request.contextPath}/admin/products";
    };
</script>

<!-- Modal Xác nhận quay lại khi Thêm mới -->
<div id="confirmBackModal" class="confirm-modal-overlay" style="display: none;">
    <div class="confirm-modal-card">
        <div class="confirm-modal-header">
            <svg viewBox="0 0 24 24" width="24" height="24" stroke="#e11d48" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
            <h3 class="confirm-title">Xác nhận quay lại</h3>
        </div>
        <div class="confirm-modal-body">
            Quay lại danh sách sẽ làm mất toàn bộ dữ liệu sản phẩm hiện có đang nhập. Bạn có chắc chắn muốn tiếp tục?
        </div>
        <div class="confirm-modal-footer">
            <button type="button" class="confirm-btn-no" onclick="closeConfirmModal()">Không quay lại</button>
            <button type="button" class="confirm-btn-yes" onclick="proceedBackToList()">Đồng ý</button>
        </div>
    </div>
</div>

<!-- Modal Xác nhận quay lại khi Chỉnh sửa (có thay đổi dữ liệu) -->
<div id="editConfirmBackModal" class="confirm-modal-overlay" style="display: none;">
    <div class="confirm-modal-card" style="max-width: 440px;">
        <div class="confirm-modal-header">
            <svg viewBox="0 0 24 24" width="28" height="28" stroke="#eab308" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
            <h3 class="confirm-title">Lưu thay đổi trước khi rời đi?</h3>
        </div>
        <div class="confirm-modal-body" style="text-align: left;">
            Bạn đã thực hiện một số chỉnh sửa trên sản phẩm này. Bạn có muốn lưu lại dữ liệu mới trước khi quay lại không?
        </div>
        <div class="confirm-modal-footer" style="flex-direction: column; gap: 8px;">
            <button type="button" class="confirm-btn-yes" onclick="saveAndGoBack()" style="width: 100%; padding: 10px; display: block;">Lưu dữ liệu mới</button>
            <button type="button" class="confirm-btn-danger" onclick="proceedBackToList()" style="width: 100%; padding: 10px; display: block;">Hủy bỏ (Quay lại không lưu)</button>
            <button type="button" class="confirm-btn-no" onclick="closeEditConfirmModal()" style="width: 100%; padding: 10px; display: block; border-color: transparent; background: transparent;">Tiếp tục chỉnh sửa</button>
        </div>
    </div>
</div>

<% if (product != null && product.getDetails() != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        <% for (project.duan1_sd21301.model.luong.ProductDetail d : product.getDetails()) { %>
        var c = "<%= d.getColor() != null ? d.getColor().replace("\"", "\\\"") : "" %>";
        var s = "<%= d.getSize() != null ? d.getSize().replace("\"", "\\\"") : "" %>";

        if (c && !selectedColors.includes(c)) {
            selectedColors.push(c);
        }
        if (s && !selectedSizes.includes(s)) {
            selectedSizes.push(s);
        }
        if (!generatedVariants[c]) {
            generatedVariants[c] = [];
        }
        generatedVariants[c].push({
            size: s,
            style: "<%= d.getStyle() != null ? d.getStyle().replace("\"", "\\\"") : "" %>",
            price: <%= d.getPrice() %>,
            stock: <%= d.getStock() %>,
            weight: <%= d.getWeight() %>,
            length: <%= d.getLength() %>,
            width: <%= d.getWidth() %>,
            thickness: <%= d.getThickness() %>,
            status: "<%= d.getStatus() %>"
        });

        <% if (d.getImages() != null && !d.getImages().isEmpty()) { %>
        colorImages[c] = "<%= String.join(",", d.getImages()).replace("\"", "\\\"") %>";
        <% } %>
        <% } %>

        if (selectedColors.length > 0) {
            renderTags("color-tags-container", selectedColors, "color-input", "Tìm và chọn màu sắc");
        }
        if (selectedSizes.length > 0) {
            renderTags("size-tags-container", selectedSizes, "size-input", "Tìm và chọn kích cỡ");
        }
        if (selectedColors.length > 0 || selectedSizes.length > 0) {
            renderGeneratedTable();
            renderImagesSection();
        }
    });
</script>
<% } %>
</body>
</html>