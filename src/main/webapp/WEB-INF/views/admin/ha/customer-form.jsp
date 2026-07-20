<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Import các Model và lớp tiện ích phục vụ xử lý trên Form --%>
<%@ page import="project.duan1_sd21301.model.ha.Customer" %>
<%@ page import="project.duan1_sd21301.model.ha.Address" %>
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
                <span>FamiCoats Admin</span> / <span>Quản lý khách hàng</span> / <span class="active-crumb"><%= isEdit ? "Chỉnh sửa hồ sơ" : "Thêm mới" %></span>
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

        <!-- 2. Thân trang hiển thị form nhập liệu -->
        <div class="content-wrapper">
            <!-- Tiêu đề trang và điều hướng -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div>
                    <h1><%= isEdit ? "Cập nhật hồ sơ khách hàng" : "Thêm khách hàng mới" %></h1>
                    <div class="subtitle"><%= (c != null) ? "Chỉnh sửa các trường thông tin của " + c.getId() : "Điền đầy đủ thông tin để lưu khách hàng" %></div>
                </div>
                <a href="<%= contextPath %>/admin/customers<%= (c != null) ? "?action=details&id=" + c.getId() : "" %>" class="btn-outline" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 10px 16px; font-weight: 600;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    <span>Quay lại</span>
                </a>
            </div>

            <!-- Form Layout Container - Đã thêm enctype="multipart/form-data" -->
            <%
                List<String> errors = (List<String>) request.getAttribute("errors");
                if (errors != null && !errors.isEmpty()) {
            %>
            <div style="background-color: #fee2e2; border: 1px solid #f87171; color: #b91c1c; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px;">
                <ul style="margin: 0; padding-left: 20px;">
                    <% for (String error : errors) { %>
                    <li style="font-size: 13px; font-weight: 500;"><%= error %></li>
                    <% } %>
                </ul>
            </div>
            <% } %>

            <form action="<%= contextPath %>/admin/customers" method="post" id="customerForm" enctype="multipart/form-data" onsubmit="return syncAllAddressBeforeSubmit()">
                <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                <!-- Trường ẩn giữ URL ảnh cũ khi chỉnh sửa và không upload tệp mới -->
                <input type="hidden" name="anhDaiDien" value="<%= (c != null) ? c.getAvatar() : "" %>">

                <!-- 1. Thông tin chung & Ảnh đại diện -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        Thông tin cá nhân & Ảnh đại diện
                    </div>

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
                            <label class="form-label" for="customerId">Mã khách hàng</label>
                            <input type="text" name="id" id="customerId" class="form-input" placeholder="Bỏ trống để tự sinh (Gợi ý: <%= request.getAttribute("nextId") != null ? request.getAttribute("nextId") : "KH005" %>)" value="<%= (c != null && c.getId() != null) ? c.getId() : "" %>" <%= isEdit ? "readonly style='background-color: #f1f5f9; cursor: not-allowed;'" : "" %>>
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
                        <div class="form-group">
                            <label class="form-label" for="customerStatus">Trạng thái</label>
                            <select name="trangThai" id="customerStatus" class="form-select">
                                <option value="Hoạt động" <%= (c != null && "Hoạt động".equals(c.getStatus())) ? "selected" : "" %>>Hoạt động</option>
                                <option value="Khóa" <%= (c != null && "Khóa".equals(c.getStatus())) ? "selected" : "" %>>Khóa</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 2. Địa chỉ mặc định -->
                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        Địa chỉ giao hàng mặc định
                    </div>
                    <div class="form-grid-2">
                        <div class="form-group">
                            <label class="form-label">Tên người nhận<span class="required">*</span></label>
                            <input type="text" name="diaChiMacDinhTen" id="defaultAddressTen" class="form-input" placeholder="Tên người nhận" required value="<%= (c != null && c.getDefaultAddress() != null) ? c.getDefaultAddress().getRecipientName() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số điện thoại<span class="required">*</span></label>
                            <input type="text" name="diaChiMacDinhSdt" id="defaultAddressSdt" class="form-input" placeholder="Số điện thoại" required value="<%= (c != null && c.getDefaultAddress() != null) ? c.getDefaultAddress().getRecipientPhone() : "" %>">
                        </div>
                    </div>

                    <input type="hidden" id="customerDefaultAddressSync" value="<%= (c != null && c.getDefaultAddress() != null) ? c.getDefaultAddress().getAddressDetail() : "" %>">  

                    <div class="form-grid" style="margin-top: 16px;">
                        <div class="form-group">
                            <label class="form-label">Tỉnh / Thành phố<span class="required">*</span></label>
                            <select id="defaultProvince" class="form-select" required>
                                <option value="">-- Chọn Tỉnh/Thành --</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Quận / Huyện<span class="required">*</span></label>
                            <select id="defaultDistrict" class="form-select" required disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phường / Xã<span class="required">*</span></label>
                            <select id="defaultWard" class="form-select" required disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                        </div>
                        <div class="form-group full-width">
                            <label class="form-label">Số nhà, tên đường<span class="required">*</span></label>
                            <input type="text" id="defaultAddressDetailInput" class="form-input" placeholder="Số nhà, tên đường, ngõ ngách..." required>
                        </div>
                    </div>
                    <input type="hidden" name="diaChiMacDinh" id="customerDefaultAddress" value="<%= (c != null && c.getDefaultAddress() != null) ? c.getDefaultAddress().getAddressDetail() : "" %>">
                </div>

                <!-- 3. Các địa chỉ khác -->
                <div class="form-card">
                    <div class="form-card-title" style="justify-content: space-between; border-bottom: none; padding-bottom: 0;">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="color: #64748b;"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="12" y1="18" x2="12" y2="12"></line><line x1="9" y1="15" x2="15" y2="15"></line></svg>
                            Các địa chỉ nhận hàng phụ
                        </div>
                    </div>

                    <button type="button" class="btn-add-address" onclick="addNewAddressCard()">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        Thêm địa chỉ mới
                    </button>

                    <div id="otherAddressesContainer">
                        <%
                            if (c != null && c.getOtherAddresses() != null) {
                                for (int i = 0; i < c.getOtherAddresses().size(); i++) {
                                    Address addr = c.getOtherAddresses().get(i);
                        %>
                        <div class="address-card-row">
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
                                    <input type="text" name="diaChiKhacTen" class="form-input" placeholder="Tên người nhận" value="<%= addr.getRecipientName() != null ? addr.getRecipientName() : "" %>">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">SĐT người nhận</label>
                                    <input type="text" name="diaChiKhacSdt" class="form-input" placeholder="Số điện thoại" value="<%= addr.getRecipientPhone() != null ? addr.getRecipientPhone() : "" %>">
                                </div>
                            </div>
                            <input type="hidden" name="diaChiKhac" class="other-address-hidden" value="<%= addr.getAddressDetail() != null ? addr.getAddressDetail() : "" %>">
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
                                    <input type="text" class="other-detail-input form-input" placeholder="Số nhà, tên đường, ngõ ngách...">
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="<%= contextPath %>/admin/customers" class="btn-cancel">
                        Hủy bỏ
                    </a>
                    <button type="submit" class="btn-submit">
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
            console.log('[Geo] Đang tải quận/huyện + phường/xã...');
            // Dùng depth=2 để mỗi district có sẵn .wards → không cần gọi API thêm
            const d = await geoGet('/api/v1/d?depth=2');
            _dCache = Array.isArray(d) ? d : [];
            const sample = _dCache[0];
            console.log('[Geo] Districts:', _dCache.length,
                '| province_code:', sample?.province_code,
                '| wards in 1st:', sample?.wards?.length ?? 'UNDEFINED');
        }
        return _dCache;
    }

    async function getWards(districtCode) {
        // 1. Thử lấy từ cache (district đã có .wards nếu load depth=2)
        if (_dCache) {
            const district = _dCache.find(d => String(d.code) === String(districtCode));
            if (district && Array.isArray(district.wards) && district.wards.length > 0) {
                console.log('[Geo] Wards từ cache:', district.wards.length);
                return district.wards;
            }
        }
        // 2. Fallback: gọi API trực tiếp
        console.log('[Geo] Fallback: gọi API wards cho', districtCode);
        const d = await geoGet(`/api/v1/d/${districtCode}?depth=2`);
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
            const pVal  = provinceSel.value;
            const dVal  = districtSel.value;
            const wVal  = wardSel.value;
            const pText = pVal ? (provinceSel.options[provinceSel.selectedIndex]?.text || '') : '';
            const dText = dVal ? (districtSel.options[districtSel.selectedIndex]?.text || '') : '';
            const wText = wVal ? (wardSel.options[wardSel.selectedIndex]?.text || '') : '';
            const s     = streetInput.value.trim();
            
            let parts = [];
            if (s) parts.push(s);
            if (wText) parts.push(wText);
            if (dText) parts.push(dText);
            if (pText) parts.push(pText);
            hiddenInput.value = parts.join(', ');
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

        // Chọn quận/huyện → load phường/xã qua proxy với log đầy đủ
        districtSel.addEventListener('change', async () => {
            wardSel.innerHTML = '<option value="">Đang tải phường/xã...</option>';
            wardSel.disabled = true;
            const dCode = String(districtSel.value);
            console.log('[Ward] District selected, code =', dCode);

            if (dCode) {
                // Bước 1: Thử lấy từ cache
                const cached = _dCache?.find(d => String(d.code) === dCode);
                if (cached?.wards?.length) {
                    console.log('[Ward] Từ cache:', cached.wards.length, 'phường/xã');
                    wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                    cached.wards.forEach(w => {
                        const o = document.createElement('option');
                        o.value = w.code; o.textContent = w.name;
                        wardSel.appendChild(o);
                    });
                } else {
                    // Bước 2: Gọi trực tiếp qua proxy nội bộ
                    const proxyUrl = CONTEXT_PATH + '/api/v1/d/' + dCode + '?depth=2';
                    console.log('[Ward] Proxy call:', proxyUrl);
                    try {
                        const r = await fetch(proxyUrl, {signal: AbortSignal.timeout(20000)});
                        console.log('[Ward] HTTP Status:', r.status);
                        if (r.ok) {
                            const data = await r.json();
                            console.log('[Ward] data.code:', data?.code,
                                '| data.wards:', data?.wards?.length ?? 'UNDEFINED');
                            wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            if (Array.isArray(data?.wards) && data.wards.length > 0) {
                                data.wards.forEach(w => {
                                    const o = document.createElement('option');
                                    o.value = w.code; o.textContent = w.name;
                                    wardSel.appendChild(o);
                                });
                                console.log('[Ward] Loaded', data.wards.length, 'phường/xã ✅');
                            } else {
                                console.warn('[Ward] wards array rỗng hoặc không có!');
                            }
                        } else {
                            console.error('[Ward] Proxy lỗi HTTP', r.status);
                            wardSel.innerHTML = '<option value="">-- Lỗi tải (HTTP ' + r.status + ') --</option>';
                        }
                    } catch(e) {
                        console.error('[Ward] Exception:', e.message);
                        wardSel.innerHTML = '<option value="">-- Lỗi kết nối --</option>';
                    }
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

            const pMatch = provinces.find(p =>
                p.name.toLowerCase() === parsed.province.toLowerCase());
            if (pMatch) {
                provinceSel.value = pMatch.code;
                fillDistricts(pMatch.code);

                const dMatch = allDistricts.filter(
                    d => String(d.province_code) === String(pMatch.code)
                ).find(d => d.name.toLowerCase() === parsed.district.toLowerCase());

                if (dMatch) {
                    districtSel.value = dMatch.code;
                    const wards = await getWards(dMatch.code);
                    if (wards.length) {
                        wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                        wards.forEach(w => {
                            const o = document.createElement('option');
                            o.value = w.code;
                            o.textContent = w.name;
                            wardSel.appendChild(o);
                        });
                        const wMatch = wards.find(w =>
                            w.name.toLowerCase() === parsed.ward.toLowerCase());
                        if (wMatch) {
                            wardSel.value = wMatch.code;
                            wardSel.disabled = false;
                        } else {
                            wardSel.disabled = false;
                        }
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
                    <input type="text" name="diaChiKhacTen" class="form-input" placeholder="Tên người nhận" value="${ten}">
                </div>
                <div class="form-group">
                    <label class="form-label">SĐT người nhận</label>
                    <input type="text" name="diaChiKhacSdt" class="form-input" placeholder="Số điện thoại" value="${sdt}">
                </div>
            </div>
            <input type="hidden" name="diaChiKhac" class="other-address-hidden" value="${detail}">
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
                    <input type="text" class="other-detail-input form-input" placeholder="Số nhà, tên đường, ngõ ngách...">
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

        const otherTen = card.querySelector('input[name="diaChiKhacTen"]');
        const otherSdt = card.querySelector('input[name="diaChiKhacSdt"]');
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

    // Sync tất cả hidden inputs của địa chỉ ngay trước khi submit form
    // Trả về false nếu địa chỉ mặc định chưa hợp lệ → ngăn submit
    function syncAllAddressBeforeSubmit() {
        const defaultHidden = document.getElementById('customerDefaultAddress');
        const defaultProv   = document.getElementById('defaultProvince');
        const defaultDist   = document.getElementById('defaultDistrict');
        const defaultWard   = document.getElementById('defaultWard');
        const defaultStreet = document.getElementById('defaultAddressDetailInput');
        _syncOneBlock(defaultHidden, defaultProv, defaultDist, defaultWard, defaultStreet);

        document.querySelectorAll('.address-card-row').forEach(card => {
            const h = card.querySelector('.other-address-hidden');
            const p = card.querySelector('.other-province');
            const d = card.querySelector('.other-district');
            const w = card.querySelector('.other-ward');
            const s = card.querySelector('.other-detail-input');
            _syncOneBlock(h, p, d, w, s);
        });

        // Kiểm tra địa chỉ mặc định có hợp lệ không
        // Kiểm tra địa chỉ mặc định có hợp lệ không
        const finalAddr = defaultHidden ? defaultHidden.value.trim() : '';
        const isValid = finalAddr && finalAddr.replace(/[,\s]/g, '').length > 0;
        if (!isValid) {
            const streetVal = defaultStreet ? defaultStreet.value.trim() : '';
            if (!streetVal) {
                alert('Vui lòng nhập số nhà/tên đường và chọn Tỉnh/Thành, Quận/Huyện, Phường/Xã!');
                return false;
            }
            if (defaultHidden) defaultHidden.value = streetVal;
        }
        return true;
    }

    // Hàm nội bộ: cập nhật hidden với các trường đã chọn
    function _syncOneBlock(hidden, prov, dist, ward, street) {
        if (!hidden || !prov || !dist || !ward || !street) return;
        const pVal = prov.value, dVal = dist.value, wVal = ward.value;
        const s = street.value.trim();
        const pText = pVal ? (prov.options[prov.selectedIndex]?.text || '') : '';
        const dText = dVal ? (dist.options[dist.selectedIndex]?.text || '') : '';
        const wText = wVal ? (ward.options[ward.selectedIndex]?.text || '') : '';
        
        let parts = [];
        if (s) parts.push(s);
        if (wText) parts.push(wText);
        if (dText) parts.push(dText);
        if (pText) parts.push(pText);
        hidden.value = parts.join(', ');
    }
</script>

<%-- Toast thông báo dùng chung --%>
<jsp:include page="/WEB-INF/views/layout/toast.jsp" />
</body>
</html>