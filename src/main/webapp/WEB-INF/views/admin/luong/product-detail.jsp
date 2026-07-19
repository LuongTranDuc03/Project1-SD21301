<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%@ page import="java.util.List" %>
<%!
    public String getColorHex(String colorName) {
        if (colorName == null) return "#cbd5e1";
        String trimmed = colorName.trim();
        if (trimmed.startsWith("#")) {
            return trimmed;
        }
        switch (trimmed.toLowerCase()) {
            case "đăng": // Keep robust in case of typos
            case "đen":
                return "#000000";
            case "trắng":
                return "#ffffff";
            case "be":
            case "beige":
                return "#E6D7C3";
            case "navy":
            case "xanh navy":
                return "#1B365D";
            case "đỏ đô":
            case "đỏ đậm":
                return "#8B0000";
            case "đỏ":
                return "#EF4444";
            case "xám":
            case "ghi":
                return "#808080";
            case "xanh dương":
            case "xanh lam":
                return "#3B82F6";
            case "xanh lá":
            case "xanh lục":
                return "#10B981";
            case "vàng":
                return "#FBBF24";
            case "cam":
                return "#F97316";
            case "hồng":
                return "#EC4899";
            case "nâu":
                return "#78350F";
            case "kem":
                return "#FFFDD0";
            case "tím":
                return "#8B5CF6";
            case "xanh rêu":
                return "#4B5320";
            default:
                return "#cbd5e1"; // Slate grey default
        }
    }
%>
<%
    String requestAction = request.getParameter("action");
    if ("edit".equals(requestAction)) {
        Product prodObj = (Product) request.getAttribute("product");
        request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm " + (prodObj != null ? prodObj.getId() : ""));
        request.getRequestDispatcher("/WEB-INF/views/admin/product-add.jsp").forward(request, response);
        return;
    }

    Product prod = (Product) request.getAttribute("product");
    String statusClass = "";
    String statusLabel = "";
    if (prod != null) {
        if ("AVAILABLE".equals(prod.getStatus())) {
            statusLabel = "Còn hàng";
            statusClass = "available";
        } else {
            statusLabel = "Hết hàng";
            statusClass = "out_of_stock";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - <%= prod != null ? prod.getName() : "Không tìm thấy" %></title>
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
        .form-input, .form-textarea {
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
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }
        .badge-status {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            width: fit-content;
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
        .full-width-item {
            grid-column: 1 / -1;
            border-top: 1px dashed #e2e8f0;
            padding-top: 16px;
            margin-top: 8px;
        }
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
        .edit-product-btn {
            background-color: #0f172a;
            border: 1px solid #0f172a;
            color: #ffffff;
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
        .edit-product-btn:hover {
            background-color: #1e293b;
            border-color: #1e293b;
        }
        .variant-table {
            width: 100%;
            border-collapse: collapse;
        }
        .variant-table th {
            background-color: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 12px;
            text-align: left;
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
            white-space: nowrap;
        }
        .variant-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            font-size: 13px;
            white-space: nowrap;
        }
        .variant-table tr:hover td {
            background-color: #f8fafc;
        }
        .color-circles-list {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .color-circle {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: 1px solid #cbd5e1;
            box-shadow: 0 1px 3px rgba(0,0,0,0.12);
            transition: transform 0.2s ease;
        }
        .color-circle:hover {
            transform: scale(1.15);
        }
        .action-icon-btn {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            background-color: #ffffff;
            color: #64748b;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .action-icon-btn:hover {
            background-color: #f8fafc;
            color: #0f172a;
        }

        /* Gallery styles for variant image cell */
        .variant-gallery {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            width: 140px;
            margin: 0 auto;
        }
        .main-thumb-wrapper {
            width: 100px;
            height: 100px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            overflow: hidden;
            background-color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            transition: all 0.2s;
        }
        .main-thumb-wrapper:hover {
            border-color: #94a3b8;
        }
        .gallery-main-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .gallery-thumbs {
            display: flex;
            gap: 4px;
            width: 100%;
            overflow-x: auto;
            padding-bottom: 2px;
            scrollbar-width: none; /* Firefox */
            -ms-overflow-style: none; /* IE 10+ */
            justify-content: center;
        }
        .gallery-thumbs::-webkit-scrollbar {
            display: none; /* Safari and Chrome */
        }
        .gallery-thumb-item {
            width: 28px;
            height: 28px;
            border-radius: 4px;
            border: 1px solid #cbd5e1;
            flex-shrink: 0;
            overflow: hidden;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s ease-in-out;
        }
        .gallery-thumb-item:hover {
            transform: scale(1.08);
            border-color: #94a3b8;
        }
        .gallery-thumb-item.active {
            border-color: #FB7185 !important;
            box-shadow: 0 0 0 1.5px #FB7185;
        }
        .thumb-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Modal Style */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(8px);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
        }
        .modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }
        .modal-card {
            background-color: #ffffff;
            border-radius: 16px;
            width: 100%;
            max-width: 760px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            border: 1px solid #e2e8f0;
            overflow: hidden;
            transform: translateY(20px);
            transition: transform 0.3s ease;
        }
        .modal-overlay.active .modal-card {
            transform: translateY(0);
        }
        .modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .close-modal-btn {
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 4px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .close-modal-btn:hover {
            background-color: #f1f5f9;
            color: #0f172a;
        }
        .modal-body {
            padding: 24px;
            max-height: 70vh;
            overflow-y: auto;
        }
        .modal-form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 16px 20px;
        }
        .col-span-12 {
            grid-column: span 12;
        }
        .col-span-6 {
            grid-column: span 6;
        }
        .col-span-4 {
            grid-column: span 4;
        }
        .col-span-3 {
            grid-column: span 3;
        }
        @media (max-width: 768px) {
            .col-span-6, .col-span-4, .col-span-3 {
                grid-column: span 12;
            }
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .modal-label {
            font-size: 12px;
            font-weight: 600;
            color: #475569;
        }
        .modal-input {
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            font-size: 13px;
            color: #0f172a;
            font-family: inherit;
            outline: none;
            transition: all 0.2s ease;
            background-color: #ffffff;
        }
        .modal-input:focus {
            border-color: #0f172a;
            box-shadow: 0 0 0 3px rgba(15, 23, 76, 0.08);
        }
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #f1f5f9;
            background-color: #f8fafc;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .modal-btn-secondary {
            background-color: #ffffff;
            border: 1px solid #cbd5e1;
            color: #334155;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .modal-btn-secondary:hover {
            background-color: #f1f5f9;
            border-color: #94a3b8;
        }
        .modal-btn-primary {
            background-color: #0f172a;
            border: 1px solid #0f172a;
            color: #ffffff;
            padding: 10px 18px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .modal-btn-primary:hover {
            background-color: #1e293b;
            border-color: #1e293b;
        }
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
        .delete-confirm-overlay.active {
            display: flex;
        }
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
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background-color: #fef2f2;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
        }
        .delete-confirm-title {
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }
        .delete-confirm-body {
            font-size: 13px;
            color: #64748b;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        .delete-confirm-body strong {
            color: #1e293b;
        }
        .delete-confirm-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn-del-cancel {
            flex: 1;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            background: #f8fafc;
            color: #475569;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-del-cancel:hover { background: #e2e8f0; }
        .btn-del-confirm {
            flex: 1;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #dc2626;
            background: #dc2626;
            color: #ffffff;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-del-confirm:hover { background: #b91c1c; border-color: #b91c1c; }
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
                    <span>FamiCoats Admin</span> / <a href="${pageContext.request.contextPath}/admin/products" style="color: inherit; text-decoration: none;">Quản lý sản phẩm</a> / <span class="active-crumb">Chi tiết</span>
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
                <% if (prod == null) { %>
                    <div class="detail-card" style="text-align: center; padding: 48px;">
                        <h2 style="color: #64748b; margin-bottom: 16px;">Không tìm thấy thông tin sản phẩm</h2>
                        <a href="${pageContext.request.contextPath}/admin/products" class="back-btn">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            Quay lại danh sách
                        </a>
                    </div>
                <% } else { %>
                    <!-- Header Tiêu đề & Nút quay lại -->
                    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                        <div>
                            <h1><%= prod.getName() %></h1>
                            <div class="subtitle" style="margin-top: 4px;">Mã sản phẩm: <span style="font-weight: 600; color: #475569;"><%= prod.getId() %></span></div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <a href="${pageContext.request.contextPath}/admin/variants?productId=<%= prod.getId() %>" class="edit-product-btn" style="background-color: #64748b; border-color: #64748b;">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <span>Xem danh sách biến thể</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=<%= prod.getId() %>" class="edit-product-btn">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                <span>Chỉnh sửa sản phẩm</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products" class="back-btn">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>

                    <!-- 1. Thông tin chung sản phẩm -->
                    <!-- 1. Thông tin chung sản phẩm -->
                    <div class="form-card">
                        <div class="form-card-title">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                            Thông tin chung sản phẩm
                        </div>
                        <div class="form-card-body">
                            <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="id">Mã sản phẩm</label>
                                <input type="text" id="id" class="form-input" value="<%= prod.getId() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="name">Tên sản phẩm</label>
                                <input type="text" id="name" class="form-input" value="<%= prod.getName() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="category">Danh mục</label>
                                <input type="text" id="category" class="form-input" value="<%= prod.getCategory() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="brand">Thương hiệu</label>
                                <input type="text" id="brand" class="form-input" value="<%= prod.getBrand() != null ? prod.getBrand() : "N/A" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="origin">Xuất xứ</label>
                                <input type="text" id="origin" class="form-input" value="<%= prod.getOrigin() != null ? prod.getOrigin() : "N/A" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="status">Trạng thái</label>
                                <div style="display: flex; align-items: center; height: 41.6px; border: 1px solid #cbd5e1; border-radius: 8px; padding: 0 14px; background-color: #f1f5f9; cursor: not-allowed;">
                                    <span class="badge-status <%= statusClass %>" style="margin: 0;"><%= statusLabel %></span>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="priceRange">Khoảng giá bán</label>
                                <input type="text" id="priceRange" class="form-input" value="<%= prod.getPriceRangeFormatted() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed; font-weight: 700; color: #0f172a;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="sold">Tổng đã bán</label>
                                <input type="text" id="sold" class="form-input" value="<%= prod.getSold() %> sản phẩm" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="stock">Tổng tồn kho</label>
                                <input type="text" id="stock" class="form-input" value="<%= prod.getStock() %> sản phẩm" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="careInstructions">Hướng dẫn bảo quản</label>
                                <textarea id="careInstructions" class="form-textarea" readonly style="background-color: #f1f5f9; cursor: not-allowed;"><%= prod.getCareInstructions() != null ? prod.getCareInstructions() : "Chưa có hướng dẫn bảo quản cho sản phẩm này." %></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="description">Mô tả sản phẩm</label>
                                <textarea id="description" class="form-textarea" readonly style="background-color: #f1f5f9; cursor: not-allowed;"><%= prod.getDescription() != null ? prod.getDescription() : "Chưa có mô tả chi tiết cho sản phẩm này." %></textarea>
                            </div>
                        </div>
                        </div>
                    </div>
                
                    <!-- Danh sách biến thể (Read-only) -->
                    <div class="custom-card" style="margin-top: 24px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                        <div class="card-header-bar" style="background-color: #12192D; color: #ffffff; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center;">
                            <span class="card-header-title" style="font-size: 13px; font-weight: 700; text-transform: uppercase;">&#8226; Danh sách biến thể của sản phẩm</span>
                        </div>
                        <div style="overflow-x: auto;">
                            <table class="invoice-table" style="width: 100%; min-width: 800px; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">STT</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Hình ảnh</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Màu sắc</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Kích cỡ</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Đơn giá</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Số lượng</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Trạng thái</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (prod.getDetails() != null && !prod.getDetails().isEmpty()) {
                                        int stt = 1;
                                        for (project.duan1_sd21301.model.luong.ProductDetail v : prod.getDetails()) {
                                            String pStatus = v.getStatus();
                                            if (pStatus == null || pStatus.trim().isEmpty() || pStatus.equals("Hoạt động")) {
                                                pStatus = v.getStock() > 0 ? "Còn hàng" : "Hết hàng";
                                            }
                                            String vStatusClass = pStatus.equals("Còn hàng") || pStatus.equals("AVAILABLE") ? "available" : "out_of_stock";
                                            String vStatusLabel = pStatus.equals("Còn hàng") || pStatus.equals("AVAILABLE") ? "Còn hàng" : "Hết hàng";
                                %>
                                <tr>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; color: #64748b; font-weight: 500;"><%= stt++ %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <% if (v.getImages() != null && !v.getImages().isEmpty()) { %>
                                            <img src="${pageContext.request.contextPath}/assets/img/<%= v.getImages().get(0) %>" alt="Image" style="width: 36px; height: 36px; object-fit: cover; border-radius: 6px; border: 1px solid #e2e8f0; display: inline-block;">
                                        <% } else { %>
                                            <div style="width: 36px; height: 36px; border-radius: 6px; background-color: #f1f5f9; display: inline-flex; align-items: center; justify-content: center; color: #94a3b8; margin: 0 auto;">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #0f172a;"><%= v.getColor() != null ? v.getColor() : "" %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <span style="background-color: #f1f5f9; color: #475569; font-size: 12px; padding: 4px 8px; border-radius: 4px; font-weight: 600;"><%= v.getSize() != null ? v.getSize() : "" %></span>
                                    </td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #1e293b;"><%= String.format("%,.0f", v.getPrice()) %> đ</td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #475569;"><%= v.getStock() %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <span style="display: inline-block; padding: 2px 8px; border-radius: 6px; font-size: 11px; font-weight: 600; <%= vStatusClass.equals("available") ? "background-color: #ecfdf5; color: #065f46;" : "background-color: #fef2f2; color: #991b1b;" %>"><%= vStatusLabel %></span>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu biến thể.</td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
