<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Import các Model và lớp tiện ích phục vụ xử lý trên Form --%>
<%@ page import="project.duan1_sd21301.model.ha.Customer" %>
<%@ page import="project.duan1_sd21301.model.Address" %>
<%@ page import="project.duan1_sd21301.model.ha.CustomerAddress" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Lấy thông tin đối tượng khách hàng (nếu đang trong luồng cập nhật hoặc khi validation thất bại)
    Customer c = (Customer) request.getAttribute("customer");
    // Nhận cờ kiểm tra chế độ (Thêm mới hay Sửa đổi) truyền từ Controller
    Boolean isEditAttr = (Boolean) request.getAttribute("isEdit");
    boolean isEdit = (isEditAttr != null) ? isEditAttr : (c != null);
    // Trình định dạng ngày tháng để hiển thị dữ liệu kiểu Date lên ô input type="date"
    SimpleDateFormat isoDf = new SimpleDateFormat("yyyy-MM-dd");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - <%= isEdit ? "Cập nhật khách hàng" : "Thêm khách hàng" %></title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/customers/customer.css?v=<%= System.currentTimeMillis() %>">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="<%= contextPath %>/assets/js/address-dropdown.js?v=1.4" charset="UTF-8"></script>

    <style>
        .form-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: visible !important;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .form-card-body {
            padding: 24px;
        }
        .form-card-title {
            background-color: #12192D;
            color: #ffffff;
            padding: 12px 24px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 8px;
            border-radius: 12px 12px 0 0;
        }
        .form-card-title svg {
            color: #ffffff !important;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px 20px;
        }
        .form-grid-2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px 20px;
        }
        @media (max-width: 992px) {
            .form-grid, .form-grid-2 {
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
        .required {
            color: #ef4444;
            margin-left: 2px;
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
        /* Dynamic address card style */
        .address-card-row {
            background-color: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 10px;
            padding: 16px;
            margin-bottom: 12px;
            position: relative;
            animation: slideDown 0.25s ease-out;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .btn-add-address {
            background-color: #f1f5f9;
            border: 1px dashed #94a3b8;
            color: #475569;
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 16px;
        }
        .btn-add-address:hover {
            background-color: #e2e8f0;
            color: #0f172a;
            border-color: #64748b;
        }
        .avatar-upload-area {
            display: flex;
            align-items: center;
            gap: 20px;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px dashed #e2e8f0;
        }

        /* Dynamic Validation Styling (Bao khung đỏ mảnh, nền trắng, chữ đỏ mảnh) */
        .form-input.is-invalid, .form-select.is-invalid, .form-textarea.is-invalid {
            border: 1px solid #ef4444 !important;
            background-color: #ffffff !important;
            box-shadow: none !important;
            outline: none !important;
        }
        .invalid-feedback {
            color: #ef4444;
            font-size: 11px;
            font-weight: 400;
            margin-top: 4px;
            display: block;
            line-height: 1.4;
        }
        /* Error Banner Styling */
        .error-banner {
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
            border-left: 4px solid #ef4444;
            color: #991b1b;
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(239, 68, 68, 0.05);
            animation: slideDown 0.3s ease-out;
        }
        .error-banner-title {
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            color: #7f1d1d;
        }
        .error-banner-list {
            margin: 0;
            padding-left: 20px;
            font-size: 12px;
            line-height: 1.6;
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
                <span>FamiCoats</span> / <a href="<%= contextPath %>/admin/customers" style="color: #64748b; text-decoration: none;">Quản lý khách hàng</a> / <span class="active-crumb"><%= isEdit ? "Chỉnh sửa hồ sơ" : "Thêm mới" %></span>
            </div>
            <div class="navbar-right">
                <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
            </div>
        </header>

        <!-- 2. Thân trang hiển thị form nhập liệu -->
        <div class="content-wrapper">
            <!-- Tiêu đề trang và điều hướng -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div>
                    <h1><%= isEdit ? "Cập nhật hồ sơ khách hàng" : "Thêm khách hàng mới" %></h1>
                    <div class="subtitle"><%= (c != null) ? "Chỉnh sửa các trường thông tin của " + c.getCode() : "Điền đầy đủ thông tin để lưu khách hàng" %></div>
                </div>
                <a href="<%= contextPath %>/admin/customers<%= (isEdit && c != null) ? "?action=details&code=" + c.getCode() : "" %>" class="btn-outline" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 10px 16px; font-weight: 600;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    <span>Quay lại</span>
                </a>
            </div>

            <!-- Form Layout Container - Đã thêm enctype="multipart/form-data" -->
            <%
                List<String> errors = (List<String>) request.getAttribute("errors");
                if (errors != null && !errors.isEmpty()) {
            %>
            <div class="error-banner">
                <div class="error-banner-title">
                    <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color:#dc2626;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>Vui lòng kiểm tra và sửa lại các trường lỗi dưới đây:</span>
                </div>
                <ul class="error-banner-list">
                    <% for (String error : errors) { %>
                    <li><%= error %></li>
                    <% } %>
                </ul>
            </div>
            <% } %>

            <form action="<%= contextPath %>/admin/customers" method="post" id="customerForm" enctype="multipart/form-data" novalidate onsubmit="return syncAllAddressBeforeSubmit();">
                <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                <!-- Trường ẩn giữ URL ảnh cũ khi chỉnh sửa và không upload tệp mới -->
                <input type="hidden" name="anhDaiDien" value="<%= (c != null) ? c.getAvatar() : "" %>">

                <!-- 1. Thông tin chung & Ảnh đại diện -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        Thông tin cá nhân & Ảnh đại diện
                    </div>
                    <div class="form-card-body">
                    <!-- Khu vực upload ảnh đại diện -->
                    <div class="avatar-upload-area">
                        <img src="<%= (c != null && c.getAvatar() != null && !c.getAvatar().isEmpty()) ? c.getAvatar() : "https://i.pravatar.cc/150?img=0" %>" id="avatarPreview" class="preview-avatar" alt="avatar preview" onerror="this.src='https://i.pravatar.cc/150?img=0'" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; margin-bottom: 0;">
                        <div>
                            <input type="file" name="anhDaiDienFile" id="customerAvatarFile" accept="image/*" onchange="previewImage(this)" style="display: none;">
                            <button type="button" onclick="document.getElementById('customerAvatarFile').click()" class="btn-cancel" style="padding: 8px 16px; margin-bottom: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                                Chọn Ảnh Mới
                            </button>
                            <div style="font-size: 11px; color: #94a3b8; line-height: 1.5;">Dung lượng tối đa 1 MB (Định dạng: JPEG, PNG)</div>
                        </div>
                    </div>

                    <!-- Khung điền biểu mẫu chung -->
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="customerCode">Mã khách hàng</label>
                            <input type="text" name="code" id="customerCode" class="form-input" 
                                   value="<%= isEdit && c != null && c.getCode() != null ? c.getCode() : (request.getAttribute("nextCode") != null ? request.getAttribute("nextCode") : "") %>" 
                                   readonly style="background-color: #f1f5f9; cursor: not-allowed; font-weight: bold; color: #475569;">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="customerName">Họ và tên<span class="required">*</span></label>
                            <input type="text" name="hoTen" id="customerName" class="form-input" placeholder="Nhập đầy đủ họ tên" required value="<%= (c != null) ? c.getFullName() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="customerEmail">Email liên hệ<span class="required">*</span></label>
                            <input type="email" name="email" id="customerEmail" class="form-input" placeholder="example@gmail.com" required value="<%= (c != null) ? c.getEmail() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="customerGender">Giới tính</label>
                            <select name="gioiTinh" id="customerGender" class="form-select">
                                <option value="Nam" <%= (c != null && "Nam".equals(c.getGender())) ? "selected" : "" %>>Nam</option>
                                <option value="Nữ" <%= (c != null && "Nữ".equals(c.getGender())) ? "selected" : "" %>>Nữ</option>
                                <option value="Khác" <%= (c != null && "Khác".equals(c.getGender())) ? "selected" : "" %>>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="customerPhone">Số điện thoại<span class="required">*</span></label>
                            <input type="tel" name="soDienThoai" id="customerPhone" class="form-input" placeholder="Ví dụ: 0987654321" required value="<%= (c != null) ? c.getPhoneNumber() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="customerDob">Ngày sinh</label>
                            <input type="date" name="ngaySinh" id="customerDob" class="form-input" value="<%= (c != null && c.getDateOfBirth() != null) ? isoDf.format(c.getDateOfBirth()) : "" %>">
                        </div>
                        <% if (isEdit) { %>
                        <div class="form-group">
                            <label class="form-label" for="customerStatus">Trạng thái</label>
                            <select name="trangThai" id="customerStatus" class="form-select" style="background-color: #f1f5f9; pointer-events: none; -webkit-appearance: none; -moz-appearance: none; appearance: none;" readonly tabindex="-1">
                                <option value="1" <%= (c != null && c.getStatus() != null && c.getStatus() == 1) ? "selected" : "" %>>Hoạt động</option>
                                <option value="0" <%= (c != null && (c.getStatus() == null || c.getStatus() == 0)) ? "selected" : "" %>>Khóa</option>
                            </select>
                        </div>
                        <% } else { %>
                            <input type="hidden" name="trangThai" value="1">
                        <% } %>
                    </div>
                    </div>
                </div>

                <%
                    CustomerAddress defAddr = (c != null) ? c.getDefaultAddress() : null;
                %>
                <!-- 2. Địa chỉ mặc định -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color:#64748b;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        Địa chỉ giao hàng mặc định
                    </div>
                    <div class="form-card-body">
                    <input type="hidden" name="defaultAddressCode" value="<%= defAddr != null ? defAddr.getCode() : "" %>">
                    <input type="hidden" name="customerDefaultAddress" id="customerDefaultAddress" value="<%= defAddr != null && defAddr.getFormattedAddress() != null ? defAddr.getFormattedAddress() : "" %>">
                    <input type="hidden" id="customerDefaultAddressSync" value="<%= defAddr != null && defAddr.getFormattedAddress() != null ? defAddr.getFormattedAddress() : "" %>">
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Tên người nhận<span class="required">*</span></label>
                            <input type="text" name="defaultRecipientName" id="defaultAddressTen" class="form-input" placeholder="Tên người nhận" required value="<%= defAddr != null ? defAddr.getRecipientName() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại<span class="required">*</span></label>
                            <input type="text" name="defaultPhoneNumber" id="defaultAddressSdt" class="form-input" placeholder="Số điện thoại" required value="<%= defAddr != null ? defAddr.getPhoneNumber() : "" %>">
                        </div>
                    </div>
                    <input type="hidden" id="defaultProvinceVal" value="<%= defAddr != null && defAddr.getProvince() != null ? defAddr.getProvince() : "" %>">
                    <input type="hidden" id="defaultDistrictVal" value="<%= defAddr != null && defAddr.getDistrict() != null ? defAddr.getDistrict() : "" %>">
                    <input type="hidden" id="defaultWardVal" value="<%= defAddr != null && defAddr.getWard() != null ? defAddr.getWard() : "" %>">
                    <div class="form-grid" style="margin-top:16px;">
                        <div class="form-group">
                            <label class="form-label">Tỉnh / Thành phố<span class="required">*</span></label>
                            <select id="defaultProvince" data-name="defaultProvince" class="form-select" required>
                                <option value="">-- Chọn Tỉnh/Thành --</option>
                            </select>
                            <input type="hidden" name="defaultProvince" class="submit-province" value="<%= defAddr != null && defAddr.getProvince() != null ? defAddr.getProvince() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Quận / Huyện<span class="required">*</span></label>
                            <select id="defaultDistrict" data-name="defaultDistrict" class="form-select" required disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <input type="hidden" name="defaultDistrict" class="submit-district" value="<%= defAddr != null && defAddr.getDistrict() != null ? defAddr.getDistrict() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phường / Xã<span class="required">*</span></label>
                            <select id="defaultWard" data-name="defaultWard" class="form-select" required disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                            <input type="hidden" name="defaultWard" class="submit-ward" value="<%= defAddr != null && defAddr.getWard() != null ? defAddr.getWard() : "" %>">
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label class="form-label">Số nhà, tên đường<span class="required">*</span></label>
                            <input type="text" id="defaultAddressDetailInput" name="defaultDetailedAddress" class="form-input" placeholder="Số nhà, tên đường, ngõ ngách..." required value="<%= defAddr != null && defAddr.getDetailedAddress() != null ? defAddr.getDetailedAddress() : "" %>">
                        </div>

                    </div>
                    </div>
                </div>



                <!-- 3. Các địa chỉ khác -->
                <div class="form-card">
                    <div class="form-card-title">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                            Các địa chỉ nhận hàng phụ
                        </div>
                    </div>
                    <div class="form-card-body">

                    <button type="button" class="btn-add-address" onclick="addNewAddressCard()">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        Thêm địa chỉ mới
                    </button>

                    <div id="otherAddressesContainer">
                        <%
                            if (c != null && c.getOtherAddresses() != null) {
                                for (CustomerAddress addr : c.getOtherAddresses()) {
                        %>
                        <div class="address-card-row">
                            <input type="hidden" name="otherAddressCode" value="<%= addr.getCode() %>">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                <span style="font-size: 11px; color: #94a3b8; font-weight: 600;">Mã: <%= addr.getCode() %></span>
                                <div style="display: flex; gap: 8px;">
                                    <button type="button" class="back-btn" style="padding: 4px 8px; font-size: 11px; height: 28px;" onclick="setDefaultAddress(this)">Đặt làm mặc định</button>
                                    <button type="button" class="back-btn" style="padding: 4px 8px; font-size: 11px; height: 28px; color: #ef4444; border-color: #fee2e2; background-color: #fef2f2;" onclick="removeAddressField(this)">
                                        <svg viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px;"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                        Xóa
                                    </button>
                                </div>
                            </div>
                            <div class="form-grid-2">
                                <div class="form-group">
                                    <label class="form-label">Tên người nhận</label>
                                    <input type="text" name="otherRecipientName" class="form-input" placeholder="Tên người nhận" value="<%= addr.getRecipientName() != null ? addr.getRecipientName() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">SĐT người nhận</label>
                                    <input type="text" name="otherPhoneNumber" class="form-input" placeholder="Số điện thoại" value="<%= addr.getPhoneNumber() != null ? addr.getPhoneNumber() : "" %>">
                                </div>
                            </div>
                            <input type="hidden" name="otherProvince" class="submit-province" value="<%= addr.getProvince() != null ? addr.getProvince() : "" %>">
                            <input type="hidden" name="otherDistrict" class="submit-district" value="<%= addr.getDistrict() != null ? addr.getDistrict() : "" %>">
                            <input type="hidden" name="otherWard" class="submit-ward" value="<%= addr.getWard() != null ? addr.getWard() : "" %>">
                            <input type="hidden" name="otherAddressHidden" class="other-address-hidden" value="<%= addr.getFormattedAddress() != null ? addr.getFormattedAddress() : "" %>">
                            <div class="form-grid" style="margin-top: 16px;">
                                <div class="form-group">
                                    <label class="form-label">Tỉnh / Thành phố</label>
                                    <select data-name="otherProvince" class="other-province form-select">
                                        <option value="">-- Chọn Tỉnh/Thành --</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Quận / Huyện</label>
                                    <select data-name="otherDistrict" class="other-district form-select" disabled>
                                        <option value="">-- Chọn Quận/Huyện --</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Phường / Xã</label>
                                    <select data-name="otherWard" class="other-ward form-select" disabled>
                                        <option value="">-- Chọn Phường/Xã --</option>
                                    </select>
                                </div>
                                <div class="form-group full-width">
                                    <label class="form-label">Số nhà, tên đường</label>
                                    <input type="text" name="otherDetailedAddress" class="other-detail-input form-input" placeholder="Số nhà, tên đường, ngõ ngách..." value="<%= addr.getDetailedAddress() != null ? addr.getDetailedAddress() : "" %>">
                                </div>

                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="<%= contextPath %>/admin/customers" class="btn-cancel">
                        Hủy bỏ
                    </a>
                    <button type="button" class="btn-submit" onclick="confirmSave()">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                        Lưu thông tin
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // Đảm bảo lấy chính xác Context Path của Tomcat
    const CONTEXT_PATH = '<%= request.getContextPath() %>';

    // Preview ảnh khi người dùng tải tệp ảnh lên từ máy tính
    function previewImage(input) {
        const previewImg = document.getElementById('avatarPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        } else {
            previewImg.src = "https://i.pravatar.cc/150?img=0";
        }
    }

    // Phân tích chuỗi địa chỉ đầy đủ thành các phần: tỉnh, huyện, xã, số nhà
    // Trả về null nếu địa chỉ rỗng hoặc chỉ có dấu phẩy/khoảng trắng (địa chỉ bị hỏng)
    function parseAddressString(detailStr) {
        if (!detailStr) return null;
        // Kiểm tra địa chỉ có nội dung thực sự không (không chỉ là dấu phẩy/khoảng trắng)
        const meaningful = detailStr.replace(/[,\s]/g, '');
        if (!meaningful) return null; // Dữ liệu rác: ", ," hay tương tự
        const parts = detailStr.split(',').map(s => s.trim());
        if (parts.length >= 4) {
            const province = parts[parts.length - 1];
            const district = parts[parts.length - 2];
            const ward     = parts[parts.length - 3];
            const street   = parts.slice(0, parts.length - 3).join(', ');
            return { province, district, ward, street };
        }
        return { province: '', district: '', ward: '', street: detailStr.trim() };
    }

    function removeVietnameseTones(str) {
        if (!str) return '';
        str = str.normalize("NFC");
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
        str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
        str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
        str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
        str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
        str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
        str = str.replace(/Đ/g, "D");
        return str;
    }

    function cleanGeoSlug(str) {
        if (!str) return '';
        let s = removeVietnameseTones(str).toLowerCase();
        s = s.replace(/^(tinh|thanh pho|tp|quan|huyen|thi xa|thi tran|phuong|xa)\s+/g, '');
        s = s.replace(/[^a-z0-9\s]/g, ' ');
        return s.replace(/\s+/g, ' ').trim();
    }

    function geoMatch(target, candidate) {
        if (!target || !candidate) return false;
        let t = cleanGeoSlug(target);
        let c = cleanGeoSlug(candidate);
        if (!t || !c) return false;
        return t === c || t.includes(c) || c.includes(t);
    }


    // ================================================================
    // Hai cache riêng biệt:
    //   _pCache = Array(63) tỉnh  → load từ GET /api/v1/p
    //   _dCache = Array(~700) quận/huyện → load từ GET /api/v1/d
    // Mỗi quận/huyện có province_code → dùng để filter khi chọn tỉnh.
    // ================================================================
    let _pCache = null;   // provinces
    let _dCache = null;   // ALL districts (every province)

    // Proxy-first: proxy nội bộ đáng tin cậy hơn direct call (không CORS)
    async function geoGet(path) {
        const proxyUrl = CONTEXT_PATH + path;
        const directUrl = 'https://provinces.open-api.vn' + path;
        // Thử proxy trước (local server, không CORS, có cache)
        try {
            const r = await fetch(proxyUrl, {signal: AbortSignal.timeout(20000)});
            if (r.ok) {
                const data = await r.json();
                console.log('[Geo] Proxy OK:', path, '→',
                    Array.isArray(data) ? 'Array(' + data.length + ')' : (data?.code || typeof data));
                return data;
            }
            console.error('[Geo] Proxy status', r.status, 'for', proxyUrl);
        } catch(e) {
            console.error('[Geo] Proxy error:', e.message);
        }
        // Fallback: gọi trực tiếp
        try {
            const r = await fetch(directUrl, {signal: AbortSignal.timeout(15000)});
            if (r.ok) {
                const data = await r.json();
                console.log('[Geo] Direct OK:', path);
                return data;
            }
            console.error('[Geo] Direct status', r.status);
        } catch(e) {
            console.error('[Geo] Direct error:', e.message);
        }
        return null;
    }

    async function getProvinces() {
        if (!_pCache) {
            const d = await geoGet('/api/v1/p');
            _pCache = Array.isArray(d) ? d : [];
            console.log('[Geo] Provinces:', _pCache.length);
        }
        return _pCache;
    }

    async function getAllDistricts() {
        if (!_dCache) {
            console.log('[Geo] Đang tải danh sách quận/huyện...');
            // depth=1 (không cần wards, wards luôn rỗng trong bulk API)
            const d = await geoGet('/api/v1/d?depth=1');
            _dCache = Array.isArray(d) ? d : [];
            console.log('[Geo] Districts loaded:', _dCache.length);
        }
        return _dCache;
    }

    async function getWards(districtCode) {
        // Bulk /api/v1/d?depth=2 luôn trả wards=[] → không dùng cache, luôn gọi API riêng lẻ
        console.log('[Geo] Tải wards cho quận', districtCode);
        const d = await geoGet('/api/v1/d/' + districtCode + '?depth=2');
        if (d && Array.isArray(d.wards) && d.wards.length > 0) {
            console.log('[Geo] Wards từ API:', d.wards.length);
            return d.wards;
        }
        console.warn('[Geo] Không tìm được phường/xã cho quận code:', districtCode);
        return [];
    }

    // Khởi tạo các dropdown địa chỉ cho một khối
    // overrideValue: nếu có, dùng giá trị này để khôi phục dropdown (thay vì đọc từ hiddenInput.value)
    async function initAddressDropdowns(hiddenInput, provinceSel, districtSel, wardSel, streetInput, overrideValue) {

        // Tải song song tỉnh và quận/huyện
        const [provinces, allDistricts] = await Promise.all([getProvinces(), getAllDistricts()]);

        // Render tỉnh
        provinceSel.innerHTML = '<option value="">-- Chọn Tỉnh/Thành --</option>';
        provinces.forEach(p => {
            const o = document.createElement('option');
            o.value = p.code;
            o.textContent = p.name;
            provinceSel.appendChild(o);
        });

        function updateHiddenValue() {
            let pText = '';
            if (provinceSel.selectedIndex > 0) pText = provinceSel.options[provinceSel.selectedIndex].text;
            let dText = '';
            if (districtSel.selectedIndex > 0) dText = districtSel.options[districtSel.selectedIndex].text;
            let wText = '';
            if (wardSel.selectedIndex > 0) wText = wardSel.options[wardSel.selectedIndex].text;
            const s = streetInput.value.trim();

            let parts = [];
            if (s) parts.push(s);
            if (wText) parts.push(wText);
            if (dText) parts.push(dText);
            if (pText) parts.push(pText);
            hiddenInput.value = parts.join(', ');

            // Sync submit-province/district/ward hidden inputs trong cùng khối
            const container = hiddenInput.closest('.form-card-body') || hiddenInput.closest('.address-card-row');
            if (container) {
                const hP = container.querySelector('.submit-province');
                const hD = container.querySelector('.submit-district');
                const hW = container.querySelector('.submit-ward');
                if (hP) hP.value = pText;
                if (hD) hD.value = dText;
                if (hW) hW.value = wText;
            }
        }

        function fillDistricts(pCode) {
            districtSel.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
            wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSel.disabled = true;
            if (!pCode) { districtSel.disabled = true; return; }
            const list = allDistricts.filter(d => String(d.province_code) === String(pCode));
            console.log('[Geo] Districts for', pCode, ':', list.length);
            list.forEach(d => {
                const o = document.createElement('option');
                o.value = d.code;
                o.textContent = d.name;
                districtSel.appendChild(o);
            });
            districtSel.disabled = false;
        }

        // Chọn tỉnh → fill districts từ cache (KHÔNG gọi API)
        provinceSel.addEventListener('change', () => {
            fillDistricts(provinceSel.value);
            updateHiddenValue();
        });

        // Chọn quận/huyện → load phường/xã từ API riêng lẻ (bulk API không trả về wards)
        districtSel.addEventListener('change', async () => {
            wardSel.innerHTML = '<option value="">Đang tải phường/xã...</option>';
            wardSel.disabled = true;
            const dCode = String(districtSel.value);
            console.log('[Ward] District selected, code =', dCode);

            if (dCode) {
                // Luôn gọi API từng quận để lấy danh sách phường/xã (bulk /api/v1/d?depth=2 trả wards=[])
                const data = await geoGet('/api/v1/d/' + dCode + '?depth=2');
                wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                if (data && Array.isArray(data.wards) && data.wards.length > 0) {
                    data.wards.forEach(w => {
                        const o = document.createElement('option');
                        o.value = w.code; o.textContent = w.name;
                        wardSel.appendChild(o);
                    });
                    console.log('[Ward] Loaded', data.wards.length, 'phường/xã ✅');
                } else {
                    console.warn('[Ward] Không tải được phường/xã cho quận code:', dCode);
                }
                wardSel.disabled = false;
            }
            updateHiddenValue();
        });

        wardSel.addEventListener('change', updateHiddenValue);
        streetInput.addEventListener('input', updateHiddenValue);

        // Khôi phục giá trị cũ (chế độ Edit)
        // Nếu có overrideValue (từ hidden sync), dùng nó để khôi phục dropdown
        // Giá trị của hiddenInput (visible field) không bị xóa - người dùng có thể tự nhập vào đó
        const restoreSource = (overrideValue !== undefined) ? overrideValue : hiddenInput.value;
        if (restoreSource) {
            const parsed = parseAddressString(restoreSource);
            if (!parsed) {
                // Dữ liệu hỏng: chỉ log, KHÔNG xóa hiddenInput (nười dùng có thể sửa trực tiếp)
                console.warn('[Address] Phát hiện địa chỉ hỏng, bỏ qua khôi phục dropdown:', restoreSource);
                return;
            }
            // Chỉ điền số nhà nếu streetInput chưa có giá trị
            if (!streetInput.value) streetInput.value = parsed.street;

            const pMatch = provinces.find(p => geoMatch(parsed.province, p.name));
            if (pMatch) {
                provinceSel.value = pMatch.code;
                provinceSel.setAttribute('data-sync', Date.now());
                fillDistricts(pMatch.code);

                const dMatch = allDistricts.filter(
                    d => String(d.province_code) === String(pMatch.code)
                ).find(d => geoMatch(parsed.district, d.name));

                if (dMatch) {
                    districtSel.value = dMatch.code;
                    districtSel.setAttribute('data-sync', Date.now());
                    const wards = await getWards(dMatch.code);
                    if (wards.length) {
                        wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                        wards.forEach(w => {
                            const o = document.createElement('option');
                            o.value = w.code;
                            o.textContent = w.name;
                            wardSel.appendChild(o);
                        });
                        const wMatch = wards.find(w => geoMatch(parsed.ward, w.name));
                        if (wMatch) {
                            wardSel.value = wMatch.code;
                            wardSel.setAttribute('data-sync', Date.now());
                            wardSel.disabled = false;
                        } else {
                            wardSel.disabled = false;
                        }
                        // Sau khi khôi phục đầy đủ, sync hidden inputs từ trạng thái dropdown
                        updateHiddenValue();
                    }
                }
            }
        }
    }


    // Khởi chạy khi DOM load
    document.addEventListener('DOMContentLoaded', () => {
        // Init địa chỉ mặc định
        // customerDefaultAddressSync = hidden chứa giá trị gốc (chỉ để khôi phục dropdown)
        // customerDefaultAddress    = visible text field, là field submit chính
        const syncHidden   = document.getElementById('customerDefaultAddressSync');
        const visibleField = document.getElementById('customerDefaultAddress');
        const defaultProv  = document.getElementById('defaultProvince');
        const defaultDist  = document.getElementById('defaultDistrict');
        const defaultWard  = document.getElementById('defaultWard');
        const defaultStreet= document.getElementById('defaultAddressDetailInput');

        if (syncHidden && visibleField && defaultProv && defaultDist && defaultWard && defaultStreet) {
            // Dùng syncHidden để restore dropdown, nhưng khi updateHiddenValue chạy sẽ cập nhật visibleField
            initAddressDropdowns(visibleField, defaultProv, defaultDist, defaultWard, defaultStreet, syncHidden.value);
        }

        // Init các địa chỉ phụ cũ (nếu có trong chế độ Edit)
        const otherCards = document.querySelectorAll('.address-card-row');
        otherCards.forEach(card => {
            const hidden = card.querySelector('.other-address-hidden');
            const prov = card.querySelector('.other-province');
            const dist = card.querySelector('.other-district');
            const ward = card.querySelector('.other-ward');
            const street = card.querySelector('.other-detail-input');
            if (hidden && prov && dist && ward && street) {
                initAddressDropdowns(hidden, prov, dist, ward, street);
            }
        });

        // Tự động khoanh đỏ và hiển thị lỗi dưới ô input khi Backend trả về lỗi
        <% if (errors != null && !errors.isEmpty()) { %>
            <% for (String err : errors) { %>
                <% if (err.contains("Họ tên")) { %>
                    showFieldError(document.getElementById('customerName'), '<%= err %>');
                <% } else if (err.contains("Email")) { %>
                    showFieldError(document.getElementById('customerEmail'), '<%= err %>');
                <% } else if (err.contains("Số điện thoại") && !err.contains("người nhận")) { %>
                    showFieldError(document.getElementById('customerPhone'), '<%= err %>');
                <% } else if (err.contains("18 tuổi") || err.contains("Ngày sinh")) { %>
                    showFieldError(document.getElementById('customerDob'), '<%= err %>');
                <% } else if (err.contains("Địa chỉ mặc định") && err.contains("Tên người nhận")) { %>
                    showFieldError(document.getElementById('defaultAddressTen'), '<%= err %>');
                <% } else if (err.contains("Địa chỉ mặc định") && err.contains("Số điện thoại")) { %>
                    showFieldError(document.getElementById('defaultAddressSdt'), '<%= err %>');
                <% } %>
            <% } %>
        <% } %>
    });

    // Thêm địa chỉ phụ mới
    function addNewAddressCard(ten = '', sdt = '', detail = '') {
        const container = document.getElementById('otherAddressesContainer');

        const div = document.createElement('div');
        div.className = 'address-card-row';
        div.innerHTML = `
            <div style="display: flex; justify-content: flex-end; gap: 8px; margin-bottom: 12px;">
                <button type="button" class="back-btn" style="padding: 4px 8px; font-size: 11px; height: 28px;" onclick="setDefaultAddress(this)">Đặt làm mặc định</button>
                <button type="button" class="back-btn" style="padding: 4px 8px; font-size: 11px; height: 28px; color: #ef4444; border-color: #fee2e2; background-color: #fef2f2;" onclick="removeAddressField(this)">
                    <svg viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px;"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                    Xóa
                </button>
            </div>
            <div class="form-grid-2">
                <div class="form-group">
                    <label class="form-label">Tên người nhận</label>
                    <input type="text" name="otherRecipientName" class="form-input" placeholder="Tên người nhận" value="${ten}">
                </div>
                <div class="form-group">
                    <label class="form-label">SĐT người nhận</label>
                    <input type="text" name="otherPhoneNumber" class="form-input" placeholder="Số điện thoại" value="${sdt}">
                </div>
            </div>
            <input type="hidden" name="otherProvince" class="submit-province" value="">
            <input type="hidden" name="otherDistrict" class="submit-district" value="">
            <input type="hidden" name="otherWard" class="submit-ward" value="">
            <input type="hidden" class="other-address-hidden" value="${detail}">
            <div class="form-grid" style="margin-top: 16px;">
                <div class="form-group">
                    <label class="form-label">Tỉnh / Thành phố</label>
                    <select class="other-province form-select">
                        <option value="">-- Chọn Tỉnh/Thành --</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Quận / Huyện</label>
                    <select class="other-district form-select" disabled>
                        <option value="">-- Chọn Quận/Huyện --</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Phường / Xã</label>
                    <select class="other-ward form-select" disabled>
                        <option value="">-- Chọn Phường/Xã --</option>
                    </select>
                </div>
                <div class="form-group full-width">
                    <label class="form-label">Số nhà, tên đường</label>
                    <input type="text" name="otherDetailedAddress" class="other-detail-input form-input" placeholder="Số nhà, tên đường, ngõ ngách...">
                </div>

            </div>
        `;
        container.appendChild(div);

        // Khởi tạo dropdown cho card mới
        const hidden = div.querySelector('.other-address-hidden');
        const prov = div.querySelector('.other-province');
        const dist = div.querySelector('.other-district');
        const ward = div.querySelector('.other-ward');
        const street = div.querySelector('.other-detail-input');
        initAddressDropdowns(hidden, prov, dist, ward, street);
    }

    // Hoán đổi địa chỉ phụ được chọn lên làm địa chỉ mặc định chính thức
    function setDefaultAddress(button) {
        const card = button.closest('.address-card-row');

        const otherTen = card.querySelector('input[name="otherRecipientName"]');
        const otherSdt = card.querySelector('input[name="otherPhoneNumber"]');
        const otherHidden = card.querySelector('.other-address-hidden');

        const mainTen = document.getElementById('defaultAddressTen');
        const mainSdt = document.getElementById('defaultAddressSdt');
        const mainHidden = document.getElementById('customerDefaultAddress');

        if (otherTen && otherSdt && otherHidden && mainTen && mainSdt && mainHidden) {
            // Swap values in hidden inputs and recipient fields
            const tempTen = mainTen.value;
            const tempSdt = mainSdt.value;
            const tempVal = mainHidden.value;

            mainTen.value = otherTen.value;
            mainSdt.value = otherSdt.value;
            mainHidden.value = otherHidden.value;

            otherTen.value = tempTen;
            otherSdt.value = tempSdt;
            otherHidden.value = tempVal;

            // Kích hoạt re-init dropdown cho cả 2 khối để hiển thị lại thông tin tương ứng
            // Default address
            const defaultProv = document.getElementById('defaultProvince');
            const defaultDist = document.getElementById('defaultDistrict');
            const defaultWard = document.getElementById('defaultWard');
            const defaultStreet = document.getElementById('defaultAddressDetailInput');
            initAddressDropdowns(mainHidden, defaultProv, defaultDist, defaultWard, defaultStreet);

            // Other address
            const otherProv = card.querySelector('.other-province');
            const otherDist = card.querySelector('.other-district');
            const otherWard = card.querySelector('.other-ward');
            const otherStreet = card.querySelector('.other-detail-input');
            initAddressDropdowns(otherHidden, otherProv, otherDist, otherWard, otherStreet);

            // Hiệu ứng màu nền chuyển động mượt mà
            const elements = [mainTen, mainSdt, otherTen, otherSdt];
            elements.forEach(el => {
                el.style.transition = 'background-color 0.3s';
                el.style.backgroundColor = '#f1f5f9';
            });
            setTimeout(() => {
                elements.forEach(el => {
                    el.style.backgroundColor = '#ffffff';
                });
            }, 300);
        }
    }

    function removeAddressField(button) {
        button.closest('.address-card-row').remove();
    }

    // Helper hiển thị thông báo lỗi inline dưới ô input
    function showFieldError(element, message) {
        if (!element) return;
        element.classList.add('is-invalid');
        element.focus();
        element.scrollIntoView({ behavior: 'smooth', block: 'center' });

        const formGroup = element.closest('.form-group') || element.parentElement;
        if (!formGroup) return;

        // Xóa thông báo lỗi cũ nếu có
        const oldFeedback = formGroup.querySelector('.invalid-feedback');
        if (oldFeedback) oldFeedback.remove();

        // Tạo phần tử hiển thị lỗi mới (khớp với ảnh mẫu)
        const feedback = document.createElement('div');
        feedback.className = 'invalid-feedback';
        feedback.textContent = message;
        formGroup.appendChild(feedback);

        // Lắng nghe sự kiện để xóa lỗi khi người dùng gõ/chọn lại
        const clearErr = () => {
            element.classList.remove('is-invalid');
            if (feedback && feedback.parentElement) feedback.remove();
            element.removeEventListener('input', clearErr);
            element.removeEventListener('change', clearErr);
        };
        element.addEventListener('input', clearErr);
        element.addEventListener('change', clearErr);
    }

    function clearAllFieldErrors() {
        document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
        document.querySelectorAll('.invalid-feedback').forEach(el => el.remove());
    }

    // Sync tất cả hidden inputs của địa chỉ ngay trước khi submit form
    // Trả về false nếu địa chỉ hoặc thông tin cá nhân chưa hợp lệ → ngăn submit
    function syncAllAddressBeforeSubmit() {
        clearAllFieldErrors();

        const nameRegex = /^[a-zA-ZàáảãạâầấẩẫậăằắẳẵặèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđÀÁẢÃẠÂẦẤẨẪẬĂẰẮẲẴẶÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ\s]+$/;
        const phoneRegex = /^0\d{9}$/;
        const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        // 1. Kiểm tra Họ và Tên Khách hàng
        const nameInput = document.getElementById('customerName');
        if (nameInput) {
            const nameVal = nameInput.value.trim();
            if (!nameVal) {
                showFieldError(nameInput, 'Vui lòng nhập họ và tên khách hàng');
                return false;
            }
            if (!nameRegex.test(nameVal)) {
                showFieldError(nameInput, 'Họ tên khách hàng chỉ được chứa chữ cái và khoảng trắng, không chứa số/ký tự đặc biệt');
                return false;
            }
        }

        // 2. Kiểm tra Email liên hệ
        const emailInput = document.getElementById('customerEmail');
        if (emailInput) {
            const emailVal = emailInput.value.trim();
            if (!emailVal) {
                showFieldError(emailInput, 'Vui lòng nhập email liên hệ');
                return false;
            }
            if (!emailRegex.test(emailVal)) {
                showFieldError(emailInput, 'Email không đúng định dạng (Ví dụ: example@gmail.com)');
                return false;
            }
        }

        // 3. Kiểm tra Số điện thoại chính
        const phoneInput = document.getElementById('customerPhone');
        if (phoneInput) {
            const phoneVal = phoneInput.value.trim();
            if (!phoneVal) {
                showFieldError(phoneInput, 'Vui lòng nhập số điện thoại');
                return false;
            }
            if (!phoneRegex.test(phoneVal)) {
                showFieldError(phoneInput, 'Số điện thoại khách hàng phải gồm đúng 10 số và bắt đầu bằng 0');
                return false;
            }
        }

        // 4. Kiểm tra Ngày sinh (Phải đủ 18 tuổi)
        const dobInput = document.getElementById('customerDob');
        if (dobInput && dobInput.value) {
            const dob = new Date(dobInput.value);
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const m = today.getMonth() - dob.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
                age--;
            }
            if (age < 18) {
                showFieldError(dobInput, 'Khách hàng phải từ 18 tuổi trở lên');
                return false;
            }
        } else if (dobInput) {
            showFieldError(dobInput, 'Vui lòng chọn ngày sinh');
            return false;
        }

        // 5. Kiểm tra Địa chỉ mặc định (Tên người nhận, SĐT, Tỉnh, Huyện, Xã, Số nhà)
        const defTenInput   = document.getElementById('defaultAddressTen');
        const defSdtInput   = document.getElementById('defaultAddressSdt');
        const defaultProv   = document.getElementById('defaultProvince');   // select (code)
        const defaultDist   = document.getElementById('defaultDistrict');   // select (code)
        const defaultWard   = document.getElementById('defaultWard');       // select (code)
        const defaultStreet = document.getElementById('defaultAddressDetailInput');

        // Hidden inputs chứa text name – kiểm tra fallback nếu select chưa được cập nhật (async chưa xong)
        const defProvCardBody = defaultProv ? (defaultProv.closest('.form-card-body') || defaultProv.closest('.address-card-row')) : null;
        const defProvHidden  = defProvCardBody ? defProvCardBody.querySelector('.submit-province') : null;
        const defDistHidden  = defProvCardBody ? defProvCardBody.querySelector('.submit-district') : null;
        const defWardHidden  = defProvCardBody ? defProvCardBody.querySelector('.submit-ward')     : null;

        if (defTenInput) {
            const ten = defTenInput.value.trim();
            if (!ten) {
                showFieldError(defTenInput, 'Vui lòng nhập Tên người nhận ở Địa chỉ mặc định');
                return false;
            }
            if (!nameRegex.test(ten)) {
                showFieldError(defTenInput, 'Tên người nhận ở Địa chỉ mặc định chỉ được chứa chữ cái và khoảng trắng');
                return false;
            }
        }

        if (defSdtInput) {
            const sdt = defSdtInput.value.trim();
            if (!sdt) {
                showFieldError(defSdtInput, 'Vui lòng nhập SĐT người nhận ở Địa chỉ mặc định');
                return false;
            }
            if (!phoneRegex.test(sdt)) {
                showFieldError(defSdtInput, 'Số điện thoại người nhận phải gồm đúng 10 số và bắt đầu bằng số 0');
                return false;
            }
        }

        if (defaultProv && !defaultProv.value && !(defProvHidden && defProvHidden.value)) {
            showFieldError(defaultProv, 'Vui lòng chọn Tỉnh/Thành phố');
            return false;
        }
        if (defaultDist && !defaultDist.value && !(defDistHidden && defDistHidden.value)) {
            showFieldError(defaultDist, 'Vui lòng chọn Quận/Huyện');
            return false;
        }
        if (defaultWard && !defaultWard.value && !(defWardHidden && defWardHidden.value)) {
            showFieldError(defaultWard, 'Vui lòng chọn Phường/Xã');
            return false;
        }
        if (defaultStreet && !defaultStreet.value.trim()) {
            showFieldError(defaultStreet, 'Vui lòng nhập số nhà, tên đường');
            return false;
        }

        // 6. Kiểm tra các Địa chỉ Phụ (Tên người nhận, SĐT, Tỉnh, Huyện, Xã, Số nhà)
        const otherCards = document.querySelectorAll('.address-card-row');
        for (let i = 0; i < otherCards.length; i++) {
            const card = otherCards[i];
            const cardTitle = `Địa chỉ phụ thứ ${i + 1}`;
            const tenInput = card.querySelector('input[name="otherRecipientName"]');
            const sdtInput = card.querySelector('input[name="otherPhoneNumber"]');
            const provSel  = card.querySelector('.other-province');
            const distSel  = card.querySelector('.other-district');
            const wardSel  = card.querySelector('.other-ward');
            const streetIn = card.querySelector('.other-detail-input');

            if (tenInput) {
                const ten = tenInput.value.trim();
                if (!ten) {
                    showFieldError(tenInput, `Vui lòng nhập Tên người nhận ở ${cardTitle}`);
                    return false;
                }
                if (!nameRegex.test(ten)) {
                    showFieldError(tenInput, `Tên người nhận ở ${cardTitle} chỉ được chứa chữ cái và khoảng trắng`);
                    return false;
                }
            }

            if (sdtInput) {
                const sdt = sdtInput.value.trim();
                if (!sdt) {
                    showFieldError(sdtInput, `Vui lòng nhập SĐT người nhận ở ${cardTitle}`);
                    return false;
                }
                if (!phoneRegex.test(sdt)) {
                    showFieldError(sdtInput, `SĐT người nhận ở ${cardTitle} phải gồm đúng 10 số và bắt đầu bằng số 0`);
                    return false;
                }
            }

            if (provSel && !provSel.value) {
                showFieldError(provSel, `Vui lòng chọn Tỉnh/Thành phố ở ${cardTitle}`);
                return false;
            }
            if (distSel && !distSel.value) {
                showFieldError(distSel, `Vui lòng chọn Quận/Huyện ở ${cardTitle}`);
                return false;
            }
            if (wardSel && !wardSel.value) {
                showFieldError(wardSel, `Vui lòng chọn Phường/Xã ở ${cardTitle}`);
                return false;
            }
            if (streetIn && !streetIn.value.trim()) {
                showFieldError(streetIn, `Vui lòng nhập số nhà, tên đường ở ${cardTitle}`);
                return false;
            }
        }

        // 7. Đồng bộ tất cả dữ liệu sang hidden input trước khi submit
        const defaultHidden = document.getElementById('customerDefaultAddress');
        _syncOneBlock(defaultHidden, defaultProv, defaultDist, defaultWard, defaultStreet);

        otherCards.forEach(card => {
            const h = card.querySelector('.other-address-hidden');
            const p = card.querySelector('.other-province');
            const d = card.querySelector('.other-district');
            const w = card.querySelector('.other-ward');
            const s = card.querySelector('.other-detail-input');
            _syncOneBlock(h, p, d, w, s);
        });

        return true;
    }

    function confirmSave() {
        if (!syncAllAddressBeforeSubmit()) {
            return;
        }
        var isEdit = <%= isEdit %>;
        if (isEdit) {
            Swal.fire({
                title: 'Xác nhận lưu?',
                text: 'Bạn có chắc chắn muốn lưu thông tin này?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3B82F6',
                cancelButtonColor: '#94A3B8',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    document.getElementById('customerForm').submit();
                }
            });
        } else {
            document.getElementById('customerForm').submit();
        }
    }

    // Hàm nội bộ: cập nhật hidden với các trường đã chọn
    // Nếu select không có lựa chọn (selectedIndex <= 0), giữ nguyên giá trị hidden cũ (không ghi đè rỗng)
    function _syncOneBlock(hidden, prov, dist, ward, street) {
        if (!hidden || !prov || !dist || !ward || !street) return;

        const container = hidden.closest('.form-card-body') || hidden.closest('.address-card-row');
        const hP = container ? container.querySelector('.submit-province') : null;
        const hD = container ? container.querySelector('.submit-district') : null;
        const hW = container ? container.querySelector('.submit-ward') : null;

        // Đọc text từ dropdown nếu có lựa chọn, nếu không giữ giá trị hidden cũ
        let pText = (prov.selectedIndex > 0) ? prov.options[prov.selectedIndex].text : (hP ? hP.value : '');
        let dText = (dist.selectedIndex > 0) ? dist.options[dist.selectedIndex].text : (hD ? hD.value : '');
        let wText = (ward.selectedIndex > 0) ? ward.options[ward.selectedIndex].text : (hW ? hW.value : '');

        const s = street.value.trim();

        let parts = [];
        if (s) parts.push(s);
        if (wText) parts.push(wText);
        if (dText) parts.push(dText);
        if (pText) parts.push(pText);
        hidden.value = parts.join(', ');

        if (hP) hP.value = pText;
        if (hD) hD.value = dText;
        if (hW) hW.value = wText;
    }
</script>

<%-- Toast thông báo dùng chung --%>
<jsp:include page="/WEB-INF/views/layout/toast.jsp" />
</body>
</html>
