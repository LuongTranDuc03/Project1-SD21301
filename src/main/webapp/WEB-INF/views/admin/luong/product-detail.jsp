<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%@ page import="java.util.List" %>
<%-- KHU VỰC LOGIC JSP: Xử lý màu sắc, chuẩn bị dữ liệu sản phẩm hiển thị --%>
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
        request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm " + (prodObj != null ? prodObj.getCode() : ""));
        request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-add.jsp").forward(request, response);
        return;
    }

    Product prod = (Product) request.getAttribute("product");
    String statusClass = "";
    String statusLabel = "";
    if (prod != null) {
        if ("AVAILABLE".equals(prod.getStatus())) {
            statusLabel = "Còn hàng";
            statusClass = "available";
        } else if ("LOW_STOCK".equals(prod.getStatus())) {
            statusLabel = "Sắp hết";
            statusClass = "low_stock";
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
        .detail-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .detail-card-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px 24px;
        }
        @media (max-width: 992px) {
            .info-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 576px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: #1e293b;
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
                            <div class="subtitle" style="margin-top: 4px;">Mã sản phẩm: <span style="font-weight: 600; color: #475569;"><%= prod.getCode() %></span></div>
                        </div>
                        <div style="display: flex; gap: 8px;">
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

                    <!-- KHU VỰC THÔNG TIN CHUNG SẢN PHẨM: Tên, giá, đánh giá, danh mục -->
                    <div class="detail-card">
                        <div class="detail-card-title">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                            Thông tin chung sản phẩm
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Danh mục</span>
                                <span class="info-value" style="background-color: #f1f5f9; color: #475569; font-size: 12px; padding: 4px 10px; border-radius: 6px; font-weight: 600; width: fit-content;"><%= prod.getCategory() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Thương hiệu</span>
                                <span class="info-value" style="font-weight: 600;"><%= prod.getBrand() != null ? prod.getBrand() : "N/A" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Xuất xứ</span>
                                <span class="info-value"><%= prod.getOrigin() != null ? prod.getOrigin() : "N/A" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Bảo hành</span>
                                <span class="info-value"><%= prod.getWarranty() != null ? prod.getWarranty() : "N/A" %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Đánh giá trung bình</span>
                                <span class="info-value" style="display: flex; align-items: center; gap: 4px;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="#F59E0B" color="#F59E0B" style="vertical-align: middle;"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <strong style="color: #0f172a;"><%= prod.getRating() %></strong> / 5.0
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Khoảng giá bán</span>
                                <span class="info-value" style="font-weight: 700; color: #0f172a;"><%= prod.getPriceRangeFormatted() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Tổng đã bán</span>
                                <span class="info-value" style="font-weight: 600;"><%= prod.getSold() %> sản phẩm</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Tổng tồn kho</span>
                                <span class="info-value" style="font-weight: 600;"><%= prod.getStock() %> sản phẩm</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Trạng thái</span>
                                <span class="badge-status <%= statusClass %>"><%= statusLabel %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Danh sách màu sắc</span>
                                <div class="color-circles-list" style="margin-top: 4px;">
                                    <% 
                                        java.util.Set<String> uniqueColors = new java.util.LinkedHashSet<>();
                                        if (prod.getDetails() != null) {
                                            for (ProductDetail detail : prod.getDetails()) {
                                                if (detail.getColor() != null && !detail.getColor().isEmpty()) {
                                                    uniqueColors.add(detail.getColor());
                                                }
                                            }
                                        }
                                        if (!uniqueColors.isEmpty()) {
                                            for (String colName : uniqueColors) {
                                                String hex = getColorHex(colName);
                                    %>
                                                <div class="color-circle" style="background-color: <%= hex %>;" title="<%= colName %>"></div>
                                    <%      }
                                        } else if (prod.getColorCircles() != null && !prod.getColorCircles().isEmpty()) {
                                            for (String colorHex : prod.getColorCircles()) { 
                                    %>
                                                <div class="color-circle" style="background-color: <%= colorHex %>;" title="<%= colorHex %>"></div>
                                    <%      }
                                        } else { %>
                                            <span style="color: #94a3b8; font-size: 12px; font-style: italic;">N/A</span>
                                    <%  } %>
                                </div>
                            </div>

                            <!-- Hướng dẫn bảo quản -->
                            <div class="info-item full-width-item">
                                <span class="info-label">Hướng dẫn bảo quản</span>
                                <div style="font-size: 13px; color: #334155; line-height: 1.6; margin-top: 4px;">
                                    <%= prod.getCareInstructions() != null ? prod.getCareInstructions() : "Chưa có hướng dẫn bảo quản cho sản phẩm này." %>
                                </div>
                            </div>

                            <!-- Mô tả chi tiết -->
                            <div class="info-item full-width-item" style="border-top: 1px solid #f1f5f9; padding-top: 16px;">
                                <span class="info-label">Mô tả sản phẩm</span>
                                <div style="font-size: 13px; color: #475569; line-height: 1.6; font-style: italic; margin-top: 4px;">
                                    <%= prod.getDescription() != null ? prod.getDescription() : "Chưa có mô tả chi tiết cho sản phẩm này." %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- KHU VỰC DANH SÁCH BIẾN THỂ CON: Hiển thị các tuỳ chọn màu, size, giá tương ứng -->
                    <div class="detail-card" style="padding: 0; overflow: hidden;">
                        <div style="padding: 24px 24px 16px 24px;">
                            <div class="detail-card-title" style="border-bottom: none; margin-bottom: 0; padding-bottom: 0;">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                                Danh sách các biến thể (<%= prod.getDetails() != null ? prod.getDetails().size() : 0 %>)
                            </div>
                        </div>
                        
                        <div style="overflow-x: auto;">
                            <% if (prod.getDetails() != null && !prod.getDetails().isEmpty()) { %>
                                <table class="variant-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 70px; text-align: center;">STT</th>
                                            <th>Ảnh</th>
                                            <th>Màu sắc</th>
                                            <th>Kích cỡ</th>
                                            <th>Kiểu dáng</th>
                                            <th>Giá bán</th>
                                            <th>Tồn kho</th>
                                            <th>Thông số kích thước</th>
                                            <th>Trạng thái</th>
                                            <th style="text-align: center; width: 100px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            int detailStt = 1;
                                            for (ProductDetail detail : prod.getDetails()) { 
                                        %>
                                            <tr>
                                                <td style="text-align: center; font-weight: 600; color: #64748b;"><%= detailStt++ %></td>
                                                <td style="width: 160px; min-width: 160px; text-align: center; vertical-align: middle;">
                                                    <% if (detail.getImages() != null && !detail.getImages().isEmpty()) { %>
                                                        <div class="variant-gallery">
                                                            <!-- Ảnh chính to ở giữa -->
                                                            <div class="main-thumb-wrapper">
                                                                <img class="gallery-main-img" data-main-filename="<%= detail.getImages().get(0) %>" src="" style="display: none;" />
                                                                <div class="main-placeholder" style="display: flex; align-items: center; justify-content: center;">
                                                                    <svg viewBox="0 0 24 24" width="24" height="24" stroke="#94a3b8" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                                                </div>
                                                            </div>
                                                            <!-- Danh sách ảnh con kéo ngang (chỉ hiển thị nếu > 1 ảnh) -->
                                                            <% if (detail.getImages().size() > 1) { %>
                                                                <div class="gallery-thumbs">
                                                                    <% for (int imgIdx = 0; imgIdx < detail.getImages().size(); imgIdx++) { 
                                                                        String img = detail.getImages().get(imgIdx);
                                                                    %>
                                                                        <div class="gallery-thumb-item <%= imgIdx == 0 ? "active" : "" %>" 
                                                                             data-thumb-filename="<%= img %>" 
                                                                             onclick="switchGalleryImage(this)">
                                                                            <img class="thumb-img" data-filename="<%= img %>" src="" style="display: none;" />
                                                                            <div class="thumb-placeholder-mini" style="display: flex; align-items: center; justify-content: center;">
                                                                                <svg viewBox="0 0 24 24" width="10" height="10" stroke="#94a3b8" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect></svg>
                                                                            </div>
                                                                        </div>
                                                                    <% } %>
                                                                </div>
                                                            <% } %>
                                                        </div>
                                                    <% } else { %>
                                                        <span style="color: #94a3b8; font-size: 12px; font-style: italic;">N/A</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <div class="color-circle" style="background-color: <%= getColorHex(detail.getColor()) %>; width: 16px; height: 16px; min-width: 16px; box-shadow: 0 1px 2px rgba(0,0,0,0.15);" title="<%= detail.getColor() %>"></div>
                                                        <strong style="color: #0f172a;"><%= detail.getColor() %></strong>
                                                    </div>
                                                </td>
                                                <td><span style="background-color: #f1f5f9; color: #475569; font-size: 11px; padding: 4px 8px; border-radius: 4px; font-weight: 600;"><%= detail.getSize() %></span></td>
                                                <td><%= detail.getStyle() %></td>
                                                <td><strong style="color: #0f172a;"><%= String.format("%,.0fđ", detail.getPrice()).replace(",", ".") %></strong></td>
                                                <td><%= detail.getStock() %></td>
                                                <td>
                                                    <div style="font-size: 11px; color: #64748b; line-height: 1.4;">
                                                        <span>Dài: <%= detail.getLength() %> cm</span><br/>
                                                        <span>Rộng: <%= detail.getWidth() %> cm</span><br/>
                                                        <span>Dày: <%= detail.getThickness() %> cm</span><br/>
                                                        <span>Nặng: <%= detail.getWeight() %> kg</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span style="display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 500; background-color: #ecfdf5; color: #065f46;">
                                                        <%= detail.getStatus() != null ? detail.getStatus() : "Hoạt động" %>
                                                    </span>
                                                </td>
                                                <td style="text-align: center;">
                                                    <div style="display: flex; gap: 4px; justify-content: center; align-items: center;">
                                                        <!-- Chỉnh sửa biến thể -->
                                                        <button class="action-icon-btn edit-btn" title="Chỉnh sửa biến thể" type="button"
                                                                data-id="<%= detail.getId() %>"
                                                                data-color="<%= detail.getColor() %>"
                                                                data-size="<%= detail.getSize() %>"
                                                                data-style="<%= detail.getStyle() %>"
                                                                data-import-price="<%= detail.getImportPrice() %>"
                                                                data-price="<%= detail.getPrice() %>"
                                                                data-promo-price="<%= detail.getPromoPrice() %>"
                                                                data-stock="<%= detail.getStock() %>"
                                                                data-length="<%= detail.getLength() %>"
                                                                data-width="<%= detail.getWidth() %>"
                                                                data-thickness="<%= detail.getThickness() %>"
                                                                data-weight="<%= detail.getWeight() %>"
                                                                data-status="<%= detail.getStatus() != null ? detail.getStatus() : "Hoạt động" %>"
                                                                data-images="<%= detail.getImages() != null ? String.join(",", detail.getImages()) : "" %>"
                                                                onclick="openEditModal(this)">
                                                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                        </button>
                                                        <!-- Xóa biến thể -->
                                                        <button class="action-icon-btn delete-btn" title="Xoá biến thể" type="button"
                                                                data-variant-id="<%= detail.getId() %>"
                                                                data-variant-label="<%= detail.getSize() %> - <%= detail.getColor() %>"
                                                                onclick="confirmDeleteVariant(this)">
                                                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            <% } else { %>
                                <div style="color: #94a3b8; font-size: 13px; font-style: italic; padding: 32px; text-align: center;">Không tìm thấy biến thể nào cho sản phẩm này.</div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <!-- Modal xác nhận xóa biến thể -->
    <div id="deleteVariantModal" class="delete-confirm-overlay">
        <div class="delete-confirm-card">
            <div class="delete-confirm-icon">
                <svg viewBox="0 0 24 24" width="24" height="24" stroke="#dc2626" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                </svg>
            </div>
            <div class="delete-confirm-title">Xác nhận xóa biến thể</div>
            <div class="delete-confirm-body">
                Bạn có chắc muốn xóa biến thể <strong id="deleteVariantLabel"></strong> không?<br>
                Hành động này <strong>không thể hoàn tác</strong>.
            </div>
            <div class="delete-confirm-actions">
                <button type="button" class="btn-del-cancel" onclick="closeDeleteVariantModal()">Hủy bỏ</button>
                <form id="deleteVariantForm" method="POST" action="${pageContext.request.contextPath}/admin/products?action=deleteVariant" style="flex:1;">
                    <input type="hidden" name="productId" value="<%= prod != null ? prod.getId() : "" %>" />
                    <input type="hidden" id="deleteVariantIdInput" name="variantId" value="" />
                    <button type="submit" class="btn-del-confirm" style="width:100%;">Xóa biến thể</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Script xử lý hiển thị ảnh Base64 / Placeholder và tương tác chuyển ảnh con -->
    <%-- KHU VỰC JAVASCRIPT: Xử lý modal và hình ảnh preview --%>
    <script>
        // Hàm chuyển ảnh chính khi click vào ảnh con
        // Hàm chuyển ảnh lớn tương ứng khi click vào ảnh thu nhỏ
        window.switchGalleryImage = function(thumbEl) {
            const gallery = thumbEl.closest('.variant-gallery');
            const mainImg = gallery.querySelector('.gallery-main-img');
            const mainPlaceholder = gallery.querySelector('.main-placeholder');
            const thumbImg = thumbEl.querySelector('.thumb-img');
            
            if (mainImg && thumbImg) {
                mainImg.src = thumbImg.src;
                mainImg.style.display = 'block';
                if (mainPlaceholder) {
                    mainPlaceholder.style.display = 'none';
                }
            }
            
            // Cập nhật trạng thái active
            const siblings = gallery.querySelectorAll('.gallery-thumb-item');
            siblings.forEach(s => s.classList.remove('active'));
            thumbEl.classList.add('active');
        };

        document.addEventListener('DOMContentLoaded', () => {
            // Tải dữ liệu ảnh Base64 từ localStorage hoặc tạo mock placeholder ảnh đẹp
            const allImgs = document.querySelectorAll('img[data-filename], img[data-main-filename]');
            allImgs.forEach(imgEl => {
                const filename = imgEl.getAttribute('data-filename') || imgEl.getAttribute('data-main-filename');
                if (!filename) return;

                let src = localStorage.getItem('img_' + filename);
                if (!src) {
                    // Nếu là ảnh giả lập sẵn (anh1.png, anh2.png...)
                    if (filename.includes('anh') || filename.includes('default') || filename.endsWith('.png') || filename.endsWith('.jpg')) {
                        const hash = filename.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
                        src = `https://picsum.photos/id/${(hash % 70) + 15}/200/200`;
                    }
                }
                
                if (src) {
                    imgEl.src = src;
                    imgEl.style.display = 'block';
                    
                    // Ẩn placeholder tương ứng
                    const parent = imgEl.parentElement;
                    if (parent) {
                        const placeholder = parent.querySelector('.thumb-placeholder, .main-placeholder, .thumb-placeholder-mini');
                        if (placeholder) {
                            placeholder.style.display = 'none';
                        }
                    }
                }
            });
        });
    </script>

    <!-- Modal Chỉnh sửa biến thể -->
    <div id="editVariantModal" class="modal-overlay" style="display: none;">
        <div class="modal-card">
            <div class="modal-header">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="#0f172a" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                    <h3 style="margin: 0; font-size: 16px; font-weight: 700; color: #0f172a;">Chỉnh sửa biến thể chi tiết</h3>
                </div>
                <button type="button" class="close-modal-btn" onclick="closeEditModal()">
                    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
            
            <form id="editVariantForm" action="${pageContext.request.contextPath}/admin/products?action=updateVariant" method="POST">
                <input type="hidden" id="editProductId" name="productId" value="<%= prod != null ? prod.getId() : "" %>" />
                <input type="hidden" id="editVariantId" name="variantId" value="" />
                
                <div class="modal-body">
                    <div class="modal-form-grid">
                        <!-- Hình ảnh biến thể (Ở trên đầu) -->
                        <div class="form-group col-span-12" style="margin-bottom: 12px;">
                            <label class="modal-label" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                                <span>HÌNH ẢNH BIẾN THỂ</span>
                                <span style="font-size: 11px; color: #64748b; font-weight: normal;">Nhấp vào nút Thêm ảnh hoặc chỉnh sửa danh sách bên dưới</span>
                            </label>
                            <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap; border: 1px solid #cbd5e1; padding: 12px; border-radius: 8px; background-color: #f8fafc;">
                                <div id="modal-img-previews" style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                                    <!-- Ảnh xem trước render động -->
                                </div>
                                <div onclick="triggerModalImageUpload()" style="width: 60px; height: 60px; border-radius: 6px; border: 2px dashed #cbd5e1; display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: #ffffff; cursor: pointer; transition: all 0.2s; gap: 2px;">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="#64748b" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                    <span style="font-size: 9px; color: #64748b; font-weight: 700;">Thêm ảnh</span>
                                </div>
                                <input type="file" id="modalImageInput" multiple accept="image/*" style="display: none;" onchange="handleModalImageSelect(this)" />
                                <input type="hidden" id="editImages" name="images" value="" />
                            </div>
                        </div>

                        <!-- Row 1: KÍCH CỠ * | MÀU SẮC * | KIỂU DÁNG -->
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editSize">KÍCH CỠ *</label>
                            <input type="text" id="editSize" name="size" class="modal-input" required />
                        </div>
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editColor">MÀU SẮC *</label>
                            <input type="text" id="editColor" name="color" class="modal-input" required />
                        </div>
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editStyle">KIỂU DÁNG</label>
                            <input type="text" id="editStyle" name="style" class="modal-input" placeholder="Ví dụ: Slim-fit, Oversize..." />
                        </div>
                        
                        <!-- Row 2: GIÁ NHẬP * (Đ) | GIÁ BÁN * (Đ) | SỐ LƯỢNG TỒN * -->
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editImportPrice">GIÁ NHẬP * (Đ)</label>
                            <input type="number" step="any" id="editImportPrice" name="importPrice" class="modal-input" placeholder="Giá nhập hàng..." required />
                        </div>
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editPrice">GIÁ BÁN * (Đ)</label>
                            <input type="number" step="any" id="editPrice" name="price" class="modal-input" placeholder="Giá bán lẻ..." required />
                        </div>
                        <div class="form-group col-span-4">
                            <label class="modal-label" for="editStock">SỐ LƯỢNG TỒN *</label>
                            <input type="number" id="editStock" name="stock" class="modal-input" placeholder="10" required />
                        </div>
                        
                        <!-- Row 3: CHIỀU DÀI (CM) | CHIỀU RỘNG (CM) | ĐỘ DÀY (CM) | TRỌNG LƯỢNG (KG) -->
                        <div class="form-group col-span-3">
                            <label class="modal-label" for="editLength">CHIỀU DÀI (CM)</label>
                            <input type="number" step="any" id="editLength" name="length" class="modal-input" placeholder="70" required />
                        </div>
                        <div class="form-group col-span-3">
                            <label class="modal-label" for="editWidth">CHIỀU RỘNG (CM)</label>
                            <input type="number" step="any" id="editWidth" name="width" class="modal-input" placeholder="50" required />
                        </div>
                        <div class="form-group col-span-3">
                            <label class="modal-label" for="editThickness">ĐỘ DÀY (CM)</label>
                            <input type="number" step="any" id="editThickness" name="thickness" class="modal-input" placeholder="1.5" required />
                        </div>
                        <div class="form-group col-span-3">
                            <label class="modal-label" for="editWeight">TRỌNG LƯỢNG (KG)</label>
                            <input type="number" step="any" id="editWeight" name="weight" class="modal-input" placeholder="0.5" required />
                        </div>

                        <!-- Row 4: TRẠNG THÁI HOẠT ĐỘNG -->
                        <div class="form-group col-span-12">
                            <label class="modal-label" for="editStatus">TRẠNG THÁI HOẠT ĐỘNG</label>
                            <select id="editStatus" name="status" class="modal-input">
                                <option value="Hoạt động">Hoạt động</option>
                                <option value="Ngừng hoạt động">Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="modal-btn-secondary" onclick="closeEditModal()">Hủy bỏ</button>
                    <button type="submit" class="modal-btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Script xử lý Modal -->
    <script>
        window.currentModalImages = [];

        // Hàm kích hoạt input file để chọn ảnh mới tải lên
        window.triggerModalImageUpload = function() {
            document.getElementById('modalImageInput').click();
        };

        // Hàm xử lý khi người dùng chọn file ảnh tải lên (đọc Base64 và hiển thị)
        window.handleModalImageSelect = function(input) {
            const files = input.files;
            if (!files || files.length === 0) return;
            
            Array.from(files).forEach(file => {
                const fileName = file.name;
                
                // Tránh trùng lặp
                if (window.currentModalImages.some(img => img.fileName === fileName)) return;
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    try {
                        localStorage.setItem('img_' + fileName, e.target.result);
                        window.currentModalImages.push({ fileName, src: e.target.result });
                        renderModalPreviews();
                    } catch (err) {
                        console.error('Storage quota exceeded', err);
                    }
                };
                reader.readAsDataURL(file);
            });
        };

        // Hàm xóa ảnh khỏi danh sách ảnh hiện tại trong modal
        window.deleteModalImage = function(index) {
            window.currentModalImages.splice(index, 1);
            renderModalPreviews();
        };

        // Hàm render (hiển thị) danh sách ảnh xem trước trong modal chỉnh sửa
        window.renderModalPreviews = function() {
            const previewContainer = document.getElementById('modal-img-previews');
            previewContainer.innerHTML = '';
            
            const hiddenInput = document.getElementById('editImages');
            hiddenInput.value = window.currentModalImages.map(img => img.fileName).join(',');
            
            if (window.currentModalImages.length === 0) {
                previewContainer.innerHTML = `
                    <div class="default-placeholder" style="width: 60px; height: 60px; border-radius: 6px; border: 1px solid #cbd5e1; display: flex; align-items: center; justify-content: center; background-color: #ffffff;">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="#94a3b8" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                    </div>
                `;
                return;
            }
            
            window.currentModalImages.forEach((imgObj, idx) => {
                const cardHtml = `
                    <div style="width: 60px; height: 60px; border-radius: 6px; border: 1px solid #cbd5e1; position: relative; overflow: hidden; background-color: #ffffff;">
                        <img src="${imgObj.src}" style="width: 100%; height: 100%; object-fit: cover;" />
                        <button type="button" onclick="deleteModalImage(${idx})" style="position: absolute; top: 2px; right: 2px; background-color: rgba(239, 68, 68, 0.9); border: none; border-radius: 50%; width: 16px; height: 16px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: white; padding: 0; box-shadow: 0 1px 3px rgba(0,0,0,0.2);">
                            <svg viewBox="0 0 24 24" width="8" height="8" stroke="currentColor" stroke-width="3.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </button>
                    </div>
                `;
                previewContainer.insertAdjacentHTML('beforeend', cardHtml);
            });
        };

        // Hàm mở modal chỉnh sửa biến thể và điền dữ liệu (populate) từ dòng được chọn
        window.openEditModal = function(btn) {
            document.getElementById('editVariantId').value = btn.getAttribute('data-id');
            document.getElementById('editColor').value = btn.getAttribute('data-color');
            document.getElementById('editSize').value = btn.getAttribute('data-size');
            document.getElementById('editStyle').value = btn.getAttribute('data-style');
            
            // Format numbers to clean string for edit input (without decimals if integer)
            const getCleanNum = (val) => {
                if (!val) return '0';
                const num = parseFloat(val);
                return isNaN(num) ? '0' : (num % 1 === 0 ? num.toString() : num.toFixed(2));
            };
            
            document.getElementById('editImportPrice').value = getCleanNum(btn.getAttribute('data-import-price'));
            document.getElementById('editPrice').value = getCleanNum(btn.getAttribute('data-price'));
            document.getElementById('editStock').value = getCleanNum(btn.getAttribute('data-stock'));
            document.getElementById('editLength').value = getCleanNum(btn.getAttribute('data-length'));
            document.getElementById('editWidth').value = getCleanNum(btn.getAttribute('data-width'));
            document.getElementById('editThickness').value = getCleanNum(btn.getAttribute('data-thickness'));
            document.getElementById('editWeight').value = getCleanNum(btn.getAttribute('data-weight'));
            document.getElementById('editStatus').value = btn.getAttribute('data-status') || 'Hoạt động';
            
            // Populate images from row image sources
            window.currentModalImages = [];
            const row = btn.closest('tr');
            const imagesStr = btn.getAttribute('data-images') || '';
            const filenames = imagesStr ? imagesStr.split(',').filter(v => v) : [];
            
            filenames.forEach(fileName => {
                let src = '';
                const imgInRow = row.querySelector(`img[data-filename="${fileName}"], img[data-main-filename="${fileName}"]`);
                if (imgInRow && imgInRow.src) {
                    src = imgInRow.src;
                } else {
                    src = localStorage.getItem('img_' + fileName);
                    if (!src) {
                        if (fileName.includes('anh') || fileName.includes('default') || fileName.endsWith('.png') || fileName.endsWith('.jpg')) {
                            const hash = fileName.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
                            src = `https://picsum.photos/id/${(hash % 70) + 15}/200/200`;
                        }
                    }
                }
                if (src) {
                    window.currentModalImages.push({ fileName, src });
                }
            });
            
            renderModalPreviews();
            
            const modal = document.getElementById('editVariantModal');
            modal.style.display = 'flex';
            setTimeout(() => {
                modal.classList.add('active');
            }, 10);
        };

        // Hàm đóng modal chỉnh sửa biến thể
        window.closeEditModal = function() {
            const modal = document.getElementById('editVariantModal');
            modal.classList.remove('active');
            setTimeout(() => {
                modal.style.display = 'none';
            }, 300);
        };

        // Close modal when clicking outside of the card
        document.addEventListener('DOMContentLoaded', () => {
            const modal = document.getElementById('editVariantModal');
            if (modal) {
                modal.addEventListener('click', (e) => {
                    if (e.target === modal) {
                        closeEditModal();
                    }
                });
            }

            // Đóng modal xóa khi click ngoài
            const delModal = document.getElementById('deleteVariantModal');
            if (delModal) {
                delModal.addEventListener('click', (e) => {
                    if (e.target === delModal) {
                        closeDeleteVariantModal();
                    }
                });
            }
        });

        // Mở modal xác nhận xóa biến thể
        // Hàm mở modal xác nhận xóa biến thể
        window.confirmDeleteVariant = function(btn) {
            const variantId = btn.getAttribute('data-variant-id');
            const variantLabel = btn.getAttribute('data-variant-label');
            document.getElementById('deleteVariantLabel').textContent = variantLabel;
            document.getElementById('deleteVariantIdInput').value = variantId;
            document.getElementById('deleteVariantModal').classList.add('active');
        };

        // Hàm đóng modal xác nhận xóa biến thể
        window.closeDeleteVariantModal = function() {
            document.getElementById('deleteVariantModal').classList.remove('active');
        };
    </script>
</body>
</html>
