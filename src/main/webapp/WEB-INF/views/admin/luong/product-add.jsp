<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%
    Product product = (Product) request.getAttribute("product");
    boolean isEdit = (product != null);
    String pageTitleStr = isEdit ? "Chỉnh sửa sản phẩm " + product.getId() : "Thêm sản phẩm mới";
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
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .form-card-title {
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
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px 20px;
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
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
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

                <form action="${pageContext.request.contextPath}/admin/products" method="POST" id="productForm">
                    <% if (isEdit) { %>
                        <input type="hidden" name="isEdit" value="true">
                    <% } %>
                    <!-- 1. Thông tin chung sản phẩm -->
                    <div class="form-card">
                        <div class="form-card-title">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                            Thông tin chung sản phẩm
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="id">Mã sản phẩm (Không bắt buộc)</label>
                                <input type="text" id="id" name="id" class="form-input" placeholder="Ví dụ: SP009 (Tự sinh nếu để trống)" value="<%= isEdit ? product.getId() : "" %>" <%= isEdit ? "readonly style='background-color: #f1f5f9; cursor: not-allowed;'" : "" %>>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="name">Tên sản phẩm *</label>
                                <input type="text" id="name" name="name" class="form-input" placeholder="Nhập tên sản phẩm..." value="<%= isEdit ? product.getName() : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="category">Danh mục *</label>
                                <select id="category" name="category" class="form-select" required>
                                    <option value="Áo khoác da" <%= isEdit && "Áo khoác da".equals(product.getCategory()) ? "selected" : "" %>>Áo khoác da</option>
                                    <option value="Áo bomber" <%= isEdit && "Áo bomber".equals(product.getCategory()) ? "selected" : "" %>>Áo bomber</option>
                                    <option value="Áo denim" <%= isEdit && "Áo denim".equals(product.getCategory()) ? "selected" : "" %>>Áo denim</option>
                                    <option value="Áo phao" <%= isEdit && "Áo phao".equals(product.getCategory()) ? "selected" : "" %>>Áo phao</option>
                                    <option value="Áo gió" <%= isEdit && "Áo gió".equals(product.getCategory()) ? "selected" : "" %>>Áo gió</option>
                                    <option value="Áo len" <%= isEdit && "Áo len".equals(product.getCategory()) ? "selected" : "" %>>Áo len</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="brand">Thương hiệu</label>
                                <input type="text" id="brand" name="brand" class="form-input" placeholder="Ví dụ: FamiCoats..." value="<%= isEdit && product.getBrand() != null ? product.getBrand() : "" %>">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="origin">Xuất xứ</label>
                                <input type="text" id="origin" name="origin" class="form-input" placeholder="Ví dụ: Việt Nam..." value="<%= isEdit && product.getOrigin() != null ? product.getOrigin() : "" %>">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="warranty">Bảo hành</label>
                                <input type="text" id="warranty" name="warranty" class="form-input" placeholder="Ví dụ: 12 tháng..." value="<%= isEdit && product.getWarranty() != null ? product.getWarranty() : "" %>">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="status">Trạng thái *</label>
                                <select id="status" name="status" class="form-select" required>
                                    <option value="AVAILABLE" <%= isEdit && "AVAILABLE".equals(product.getStatus()) ? "selected" : "" %>>Còn hàng (AVAILABLE)</option>
                                    <option value="LOW_STOCK" <%= isEdit && "LOW_STOCK".equals(product.getStatus()) ? "selected" : "" %>>Sắp hết (LOW_STOCK)</option>
                                    <option value="OUT_OF_STOCK" <%= isEdit && "OUT_OF_STOCK".equals(product.getStatus()) ? "selected" : "" %>>Hết hàng (OUT_OF_STOCK)</option>
                                </select>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="careInstructions">Hướng dẫn bảo quản</label>
                                <textarea id="careInstructions" name="careInstructions" class="form-textarea" placeholder="Nhập hướng dẫn bảo quản sản phẩm..."><%= isEdit && product.getCareInstructions() != null ? product.getCareInstructions() : "" %></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="description">Mô tả sản phẩm</label>
                                <textarea id="description" name="description" class="form-textarea" placeholder="Nhập mô tả sản phẩm chi tiết..."><%= isEdit && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Danh sách biến thể động -->
                    <div class="form-card">
                        <div class="form-card-title" style="justify-content: space-between; border-bottom: none; margin-bottom: 0; padding-bottom: 0;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                                Cấu hình biến thể sản phẩm (<span id="variant-count">0</span>)
                            </div>
                        </div>
                        <p style="font-size: 12px; color: #64748b; margin-top: 8px; margin-bottom: 16px;">Sản phẩm có thể có nhiều biến thể con khác nhau về kích cỡ, màu sắc, kiểu dáng...</p>

                        <div id="variants-container">
                            <!-- Nơi các card biến thể động được chèn bằng JS -->
                        </div>

                        <button type="button" class="btn-add-variant" id="btnAddVariant">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                            Thêm biến thể mới
                        </button>
                    </div>

                    <!-- Nút thao tác -->
                    <div class="form-actions" style="margin-bottom: 40px;">
                        <a href="javascript:void(0)" onclick="handleCancelBtn(event)" class="btn-cancel">Hủy bỏ</a>
                        <button type="submit" class="btn-submit">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                            Lưu sản phẩm
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- Javascript xử lý thêm/xóa biến thể con động -->
    <script>
        let variantIndex = 0;
        const container = document.getElementById('variants-container');
        const countSpan = document.getElementById('variant-count');
        const btnAdd = document.getElementById('btnAddVariant');

        // Hàm cập nhật đếm số biến thể và đánh số thứ tự từ 1 đến N
        function updateCount() {
            const cards = container.getElementsByClassName('variant-card');
            countSpan.textContent = cards.length;
            
            Array.from(cards).forEach((card, index) => {
                const titleSpan = card.querySelector('.variant-title');
                if (titleSpan) {
                    titleSpan.innerHTML = `
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="#64748b" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"></polyline><rect x="1" y="3" width="22" height="5"></rect><line x1="10" y1="12" x2="14" y2="12"></line></svg>
                        Biến thể \${index + 1}
                    `;
                }
            });
        }

        // Hàm sinh và chèn thêm card biến thể mới
        function addVariantCard(initialValues = null) {
            variantIndex++;
            const cardId = `variant-card-\${variantIndex}`;
            if (initialValues === null) {
                isFormDirty = true;
            }

            const vals = initialValues || {
                size: '',
                color: 'Đen',
                style: '',
                stock: '10',
                importPrice: '',
                price: '',
                weight: '0.5',
                length: '70',
                width: '50',
                thickness: '1.5',
                status: 'Hoạt động',
                images: ['anh-default.png']
            };

            // Build initial image preview elements
            let previewItemsHtml = '';
            if (vals.images && vals.images.length > 0) {
                vals.images.forEach((img, imgIdx) => {
                    if (img === 'anh-default.png') {
                        previewItemsHtml += `
                            <div class="preview-item default-placeholder" style="width: 80px; height: 80px; border-radius: 8px; border: 1px solid #cbd5e1; display: flex; align-items: center; justify-content: center; background-color: #f8fafc;">
                                <svg viewBox="0 0 24 24" width="24" height="24" stroke="#94a3b8" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                            </div>
                        `;
                    } else {
                        const previewId = `img-preview-item-\${variantIndex}-\${imgIdx}`;
                        previewItemsHtml += `
                            <div class="preview-item-wrapper" id="\${previewId}" data-filename="\${img}" style="width: 80px; height: 80px; border-radius: 8px; border: 1px solid #cbd5e1; position: relative; overflow: hidden; background-color: #f8fafc; flex-shrink: 0; transition: transform 0.2s;">
                                <img src="" class="preview-img" style="width: 100%; height: 100%; object-fit: cover;">
                                <button type="button" class="btn-delete-img" onclick="deletePreviewImage('\${previewId}', \${variantIndex})" style="position: absolute; top: 4px; right: 4px; background-color: rgba(239, 68, 68, 0.9); border: none; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: white; padding: 0; box-shadow: 0 1px 3px rgba(0,0,0,0.2); transition: all 0.2s;">
                                    <svg viewBox="0 0 24 24" width="10" height="10" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                </button>
                            </div>
                        `;
                    }
                });
            }

            const cardHtml = `
                <div class="variant-card" id="\${cardId}">
                    <div class="variant-header">
                        <span class="variant-title">
                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="#64748b" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"></polyline><rect x="1" y="3" width="22" height="5"></rect><line x1="10" y1="12" x2="14" y2="12"></line></svg>
                            Biến thể \${variantIndex}
                        </span>
                        <button type="button" class="btn-remove-variant" onclick="removeVariantCard('\${cardId}')">
                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                            Xóa bỏ
                        </button>
                    </div>

                    <!-- Thuộc tính ảnh để đầu tiên, to lên rõ ràng, có nút thêm ảnh bên phải -->
                    <div class="form-group full-width" style="margin-bottom: 18px; border-bottom: 1px dashed #e2e8f0; padding-bottom: 18px;">
                        <label class="form-label" style="margin-bottom: 8px;">Hình ảnh biến thể * (Chọn nhiều tệp)</label>
                        <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                            <input type="hidden" name="variantImage" id="img-input-\${variantIndex}" value="\${vals.images.join(',')}">
                            <div id="img-previews-container-\${variantIndex}" style="display: flex; gap: 10px; flex-wrap: wrap;">
                                \${previewItemsHtml}
                            </div>
                            <label class="btn-add-img" style="width: 80px; height: 80px; border: 2px dashed #cbd5e1; border-radius: 8px; display: flex; flex-direction: column; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; background-color: #ffffff; gap: 4px;">
                                <svg viewBox="0 0 24 24" width="20" height="20" stroke="#475569" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                <span style="font-size: 10px; font-weight: 600; color: #475569;">Thêm ảnh</span>
                                <input type="file" accept="image/*" multiple style="display: none;" onchange="handleMultipleImagesUpload(this, \${variantIndex})">
                            </label>
                        </div>
                    </div>

                    <!-- Hàng 2: Kích cỡ, Màu sắc, Kiểu dáng -->
                    <div class="variant-row variant-row-3">
                        <div class="form-group">
                            <label class="form-label">Kích cỡ *</label>
                            <select name="variantSize" class="form-select" required>
                                <option value="S" \${vals.size === 'S' ? 'selected' : ''}>S</option>
                                <option value="M" \${vals.size === 'M' ? 'selected' : ''}>M</option>
                                <option value="L" \${vals.size === 'L' ? 'selected' : ''}>L</option>
                                <option value="XL" \${vals.size === 'XL' ? 'selected' : ''}>XL</option>
                                <option value="XXL" \${vals.size === 'XXL' ? 'selected' : ''}>XXL</option>
                                <option value="3XL" \${vals.size === '3XL' ? 'selected' : ''}>3XL</option>
                                <option value="Free size" \${vals.size === 'Free size' ? 'selected' : ''}>Free size</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Màu sắc *</label>
                            <div class="custom-select-wrapper" id="custom-select-wrapper-\${variantIndex}" style="position: relative; width: 100%;">
                                <div class="custom-select-trigger" style="display: flex; align-items: center; justify-content: space-between; border: 1px solid #cbd5e1; border-radius: 8px; padding: 4px 14px; font-size: 13px; color: #1e293b; background-color: #ffffff; cursor: pointer; transition: all 0.2s ease;">
                                    <div style="display: flex; align-items: center; gap: 8px; flex: 1;">
                                        <span class="custom-select-color-preview" id="color-preview-\${variantIndex}" style="width: 12px; height: 12px; border-radius: 50%; background-color: \${getClientColorHex(vals.color)}; border: 1px solid rgba(0,0,0,0.1); display: inline-block; flex-shrink: 0;"></span>
                                        <input type="text" name="variantColor" id="color-input-\${variantIndex}" class="combobox-input" value="\${vals.color}" placeholder="Nhập hoặc chọn màu..." onfocus="openCustomSelect(\${variantIndex})" oninput="handleComboboxInput(this, \${variantIndex})" style="border: none; outline: none; padding: 6px 0; font-size: 13px; font-weight: 600; color: #1e293b; width: 100%; background: transparent;" required>
                                    </div>
                                    <div onclick="toggleCombobox(\${variantIndex}, event)" style="padding-left: 8px; cursor: pointer; display: flex; align-items: center;">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="#475569" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="transition: transform 0.2s ease;"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                    </div>
                                </div>
                                <div class="custom-select-options" id="color-options-\${variantIndex}" style="display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); z-index: 100; max-height: 200px; overflow-y: auto;">
                                    <div class="custom-select-option" onclick="selectComboboxOption('Đen', '#000000', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #000000; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Đen</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Be', '#E6D7C3', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #E6D7C3; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Be</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Navy', '#1B365D', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #1B365D; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Navy</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Đỏ đô', '#8B0000', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #8B0000; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Đỏ đô</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Trắng', '#FFFFFF', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #FFFFFF; border: 1px solid #cbd5e1; display: inline-block;"></span>
                                        <span>Trắng</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Xám', '#808080', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #808080; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Xám</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Xanh dương', '#3B82F6', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #3B82F6; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Xanh dương</span>
                                    </div>
                                    <div class="custom-select-option" onclick="selectComboboxOption('Xanh lá', '#10B981', \${variantIndex})" style="display: flex; align-items: center; gap: 8px; padding: 10px 14px; font-size: 13px; color: #334155; cursor: pointer; transition: background 0.15s; font-weight: 500;">
                                        <span style="width: 12px; height: 12px; border-radius: 50%; background-color: #10B981; border: 1px solid rgba(0,0,0,0.1); display: inline-block;"></span>
                                        <span>Xanh lá</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Kiểu dáng</label>
                            <input type="text" name="variantStyle" class="form-input" value="\${vals.style}" placeholder="Ví dụ: Slim-fit, Oversize...">
                        </div>
                    </div>

                    <!-- Hàng 3: Giá nhập, Giá bán, Số lượng tồn -->
                    <div class="variant-row variant-row-3">
                        <div class="form-group">
                            <label class="form-label">Giá nhập * (đ)</label>
                            <input type="number" name="variantImportPrice" class="form-input" value="\${vals.importPrice}" placeholder="Giá nhập hàng..." min="0" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá bán * (đ)</label>
                            <input type="number" name="variantPrice" class="form-input" value="\${vals.price}" placeholder="Giá bán lẻ..." min="0" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số lượng tồn *</label>
                            <input type="number" name="variantStock" class="form-input" value="\${vals.stock}" min="0" required>
                        </div>
                    </div>

                    <!-- Hàng 4: Chiều dài, Chiều rộng, Độ dày, Trọng lượng -->
                    <div class="variant-row variant-row-4">
                        <div class="form-group">
                            <label class="form-label">Chiều dài (cm)</label>
                            <input type="number" name="variantLength" class="form-input" value="\${vals.length}" step="0.1" min="0">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Chiều rộng (cm)</label>
                            <input type="number" name="variantWidth" class="form-input" value="\${vals.width}" step="0.1" min="0">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Độ dày (cm)</label>
                            <input type="number" name="variantThickness" class="form-input" value="\${vals.thickness}" step="0.1" min="0">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Trọng lượng (kg)</label>
                            <input type="number" name="variantWeight" class="form-input" value="\${vals.weight}" step="0.01" min="0">
                        </div>
                    </div>

                    <!-- Hàng cuối: Trạng thái hoạt động -->
                    <div class="variant-row variant-row-4">
                        <div class="form-group">
                            <label class="form-label">Trạng thái hoạt động</label>
                            <select name="variantStatus" class="form-select">
                                <option value="Hoạt động" \${vals.status === 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                                <option value="Ngừng hoạt động" \${vals.status === 'Ngừng hoạt động' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                </div>
            `;

            container.insertAdjacentHTML('beforeend', cardHtml);

            // Set image src for preview images
            const newCard = document.getElementById(cardId);
            newCard.querySelectorAll('img.preview-img').forEach(imgEl => {
                const parentWrapper = imgEl.closest('.preview-item-wrapper');
                if (parentWrapper) {
                    const filename = parentWrapper.getAttribute('data-filename');
                    if (filename) {
                        let src = localStorage.getItem('img_' + filename);
                        if (!src) {
                            if (filename.includes('anh') || filename.includes('default') || filename.endsWith('.png') || filename.endsWith('.jpg')) {
                                const hash = filename.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
                                src = `https://picsum.photos/id/\${(hash % 70) + 15}/200/200`;
                            }
                        }
                        if (src) {
                            imgEl.src = src;
                        }
                    }
                }
            });

            updateCount();
        }

        // Hàm xóa card biến thể
        window.removeVariantCard = function(cardId) {
            const card = document.getElementById(cardId);
            if (card) {
                card.remove();
                updateCount();
                isFormDirty = true;
            }
        };

        // Mở dropdown khi click vào input màu sắc
        window.openCustomSelect = function(idx) {
            const wrapper = document.getElementById('custom-select-wrapper-' + idx);
            const options = document.getElementById('color-options-' + idx);
            
            // Đóng tất cả dropdown khác trước
            document.querySelectorAll('.custom-select-options').forEach(opt => opt.style.display = 'none');
            document.querySelectorAll('.custom-select-wrapper').forEach(w => w.classList.remove('open'));
            
            options.style.display = 'block';
            wrapper.classList.add('open');
        };

        // Bật/tắt dropdown khi click vào nút mũi tên
        window.toggleCombobox = function(idx, event) {
            event.stopPropagation();
            const wrapper = document.getElementById('custom-select-wrapper-' + idx);
            const options = document.getElementById('color-options-' + idx);
            const inputEl = document.getElementById('color-input-' + idx);
            
            if (options.style.display === 'none') {
                openCustomSelect(idx);
                inputEl.focus();
            } else {
                options.style.display = 'none';
                wrapper.classList.remove('open');
            }
        };

        // Lựa chọn màu sắc gợi ý trong dropdown
        window.selectComboboxOption = function(colorName, hexValue, idx) {
            const wrapper = document.getElementById('custom-select-wrapper-' + idx);
            const options = document.getElementById('color-options-' + idx);
            const previewEl = document.getElementById('color-preview-' + idx);
            const inputEl = document.getElementById('color-input-' + idx);
            
            inputEl.value = colorName;
            previewEl.style.backgroundColor = hexValue;
            previewEl.style.borderStyle = 'solid';
            
            options.style.display = 'none';
            wrapper.classList.remove('open');
            isFormDirty = true;
        };

        // Khi người bán tự gõ màu trực tiếp vào ô input
        window.handleComboboxInput = function(inputEl, idx) {
            const previewEl = document.getElementById('color-preview-' + idx);
            const val = inputEl.value.trim();
            
            if (val) {
                previewEl.style.backgroundColor = getClientColorHex(val);
                previewEl.style.borderStyle = 'solid';
            } else {
                previewEl.style.backgroundColor = '#cbd5e1';
                previewEl.style.borderStyle = 'dashed';
            }
        };

        // Hàm ánh xạ nhanh màu ở phía client để tạo preview tức thì
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
        
        // Đóng dropdown khi click ra ngoài vùng chọn
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.custom-select-wrapper')) {
                document.querySelectorAll('.custom-select-options').forEach(opt => opt.style.display = 'none');
                document.querySelectorAll('.custom-select-wrapper').forEach(w => w.classList.remove('open'));
            }
        });

        // Hàm xử lý chọn nhiều ảnh và hiển thị preview
        window.handleMultipleImagesUpload = function(fileInput, idx) {
            const container = document.getElementById(`img-previews-container-\${idx}`);
            const hiddenInput = document.getElementById(`img-input-\${idx}`);
            
            if (fileInput.files && fileInput.files.length > 0) {
                // Xóa placeholder mặc định nếu có
                const placeholder = container.querySelector('.default-placeholder');
                if (placeholder) {
                    placeholder.remove();
                }

                // Lấy danh sách ảnh hiện tại (nếu đang là default thì reset)
                let currentValues = hiddenInput.value === 'anh-default.png' ? [] : hiddenInput.value.split(',').filter(v => v);

                Array.from(fileInput.files).forEach((file) => {
                    const fileName = file.name;
                    // Tránh thêm trùng tên file trong cùng 1 biến thể
                    if (!currentValues.includes(fileName)) {
                        currentValues.push(fileName);
                    }

                    // Tạo id ngẫu nhiên cho thẻ preview này
                    const previewId = `img-preview-item-\${idx}-\${Math.random().toString(36).substr(2, 9)}`;
                    const previewHtml = `
                        <div class="preview-item-wrapper" id="\${previewId}" data-filename="\${fileName}" style="width: 80px; height: 80px; border-radius: 8px; border: 1px solid #cbd5e1; position: relative; overflow: hidden; background-color: #f8fafc; flex-shrink: 0; transition: transform 0.2s;">
                            <img src="" class="preview-img" style="width: 100%; height: 100%; object-fit: cover;">
                            <button type="button" class="btn-delete-img" onclick="deletePreviewImage('\${previewId}', \${idx})" style="position: absolute; top: 4px; right: 4px; background-color: rgba(239, 68, 68, 0.9); border: none; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; cursor: pointer; color: white; padding: 0; box-shadow: 0 1px 3px rgba(0,0,0,0.2); transition: all 0.2s;">
                                <svg viewBox="0 0 24 24" width="10" height="10" stroke="currentColor" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                            </button>
                        </div>
                    `;
                    container.insertAdjacentHTML('beforeend', previewHtml);

                    // Hiển thị ảnh thực tế thông qua FileReader
                    const wrapper = document.getElementById(previewId);
                    const img = wrapper.querySelector('.preview-img');
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        img.src = e.target.result;
                        // Lưu Base64 vào localStorage để đồng bộ hiển thị ở mọi trang (chi tiết, chỉnh sửa biến thể)
                        try {
                            localStorage.setItem('img_' + fileName, e.target.result);
                        } catch (err) {
                            console.error('Storage quota exceeded', err);
                        }
                    };
                    reader.readAsDataURL(file);
                });

                // Cập nhật giá trị vào hidden input
                hiddenInput.value = currentValues.join(',');
            }
        };

        // Hàm xóa ảnh trong danh sách preview
        window.deletePreviewImage = function(previewId, idx) {
            const item = document.getElementById(previewId);
            if (item) {
                isFormDirty = true;
                const fileName = item.getAttribute('data-filename');
                item.remove();

                const container = document.getElementById(`img-previews-container-\${idx}`);
                const hiddenInput = document.getElementById(`img-input-\${idx}`);
                
                let currentValues = hiddenInput.value.split(',').filter(v => v);
                currentValues = currentValues.filter(val => val !== fileName);
                
                hiddenInput.value = currentValues.join(',');

                // Nếu không còn ảnh nào, hiển thị lại placeholder và đặt về default
                if (container.children.length === 0) {
                    hiddenInput.value = 'anh-default.png';
                    const placeholderHtml = `
                        <div class="preview-item default-placeholder" style="width: 80px; height: 80px; border-radius: 8px; border: 1px solid #cbd5e1; display: flex; align-items: center; justify-content: center; background-color: #f8fafc;">
                            <svg viewBox="0 0 24 24" width="24" height="24" stroke="#94a3b8" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                        </div>
                    `;
                    container.insertAdjacentHTML('beforeend', placeholderHtml);
                }
            }
        };

        // Gán sự kiện cho nút thêm
        btnAdd.addEventListener('click', () => addVariantCard());

        // Khởi tạo các biến thể ban đầu
        <% if (isEdit && product.getDetails() != null && !product.getDetails().isEmpty()) { %>
            <% for (ProductDetail detail : product.getDetails()) { %>
                addVariantCard({
                    size: '<%= detail.getSize() %>',
                    color: '<%= detail.getColor() %>',
                    style: '<%= detail.getStyle() != null ? detail.getStyle() : "" %>',
                    stock: '<%= detail.getStock() %>',
                    importPrice: '<%= detail.getImportPrice() %>',
                    price: '<%= detail.getPrice() %>',
                    weight: '<%= detail.getWeight() %>',
                    length: '<%= detail.getLength() %>',
                    width: '<%= detail.getWidth() %>',
                    thickness: '<%= detail.getThickness() %>',
                    status: '<%= detail.getStatus() != null ? detail.getStatus() : "Hoạt động" %>',
                    images: [<%= detail.getImages() != null ? String.join(",", detail.getImages().stream().map(s -> "'" + s + "'").toList()) : "'anh-default.png'" %>]
                });
            <% } %>
        <% } else { %>
            // Mặc định tự động tạo 1 biến thể đầu tiên để người bán nhập liệu nhanh hơn
            addVariantCard();
        <% } %>
        
        // Reset dirty flag after initial cards rendering to avoid false warnings
        isFormDirty = false;

        // Đăng ký bộ lắng nghe sự kiện thay đổi dữ liệu form
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.getElementById('productForm');
            if (form) {
                form.addEventListener('input', () => { isFormDirty = true; });
                form.addEventListener('change', () => { isFormDirty = true; });
                form.addEventListener('submit', () => { isFormDirty = false; });
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
            isFormDirty = false;
            const form = document.getElementById('productForm');
            if (form) {
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
</body>
</html>
