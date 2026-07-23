<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ page import="project.duan1_sd21301.model.huy.Employee" %>
        <%@ page import="project.duan1_sd21301.model.huy.Role" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.text.SimpleDateFormat" %>
<% 
    Employee loggedInEmpForm = (Employee) session.getAttribute("loggedInUser");
    String currentUserRole = (loggedInEmpForm != null && loggedInEmpForm.getRole() != null && loggedInEmpForm.getRole().getRoleName() != null)
                              ? loggedInEmpForm.getRole().getRoleName() 
                              : (String) session.getAttribute("currentUserRole");
    if (currentUserRole == null) currentUserRole = "Nhân viên";
    
    boolean isAdmin = "Admin".equalsIgnoreCase(currentUserRole) || "Quản lý".equalsIgnoreCase(currentUserRole); 
    List<Role> listRoles = (List<Role>) request.getAttribute("roles");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    if (isEdit == null) {
        isEdit = false;
    }
    
    Employee emp = (Employee) request.getAttribute("employee");
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
%>
                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>
                                    <%= isEdit ? "Cập nhật nhân viên" : "Thêm nhân viên mới" %>
                                </title>
                                <link rel="preconnect" href="https://fonts.googleapis.com">
                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                <link
                                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                    rel="stylesheet">
                                <!-- jQuery & Select2 for searchable dropdowns -->
                                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                                <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"
                                    rel="stylesheet" />
                                <script
                                    src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
                                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                                <script>
                                    window.onerror = function(msg, url, line, col, error) {
                                        console.error("Lỗi JS: ", msg, url, line);
                                        return false;
                                    };
                                    window.addEventListener('unhandledrejection', function(event) {
                                        console.error("Lỗi Promise: ", event.reason);
                                    });
                                </script>
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

                                    .form-label {
                                        font-size: 12px;
                                        font-weight: 600;
                                        color: #475569;
                                        text-transform: uppercase;
                                        letter-spacing: 0.5px;
                                    }

                                    .form-input,
                                    .form-select,
                                    .form-textarea {
                                        width: 100%;
                                        padding: 8px 12px;
                                        border-radius: 8px;
                                        background-color: #ffffff;
                                        border: 1px solid #cbd5e1;
                                        color: #0f172a;
                                        font-size: 13px;
                                        transition: all 0.2s;
                                    }

                                    .form-input:focus,
                                    .form-select:focus,
                                    .form-textarea:focus {
                                        outline: none;
                                        border-color: #3b82f6;
                                        box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
                                    }

                                    .invalid-feedback {
                                        color: #ef4444;
                                        font-size: 11px;
                                        margin-top: 4px;
                                        font-weight: 500;
                                        display: none;
                                    }

                                    .form-card-body {
                                        padding: 24px;
                                    }

                                    .form-grid {
                                        display: grid;
                                        grid-template-columns: repeat(3, 1fr);
                                        gap: 16px 24px;
                                    }

                                    .form-grid-2 {
                                        display: grid;
                                        grid-template-columns: repeat(2, 1fr);
                                        gap: 16px 24px;
                                    }

                                    @media (max-width: 992px) {

                                        .form-grid,
                                        .form-grid-2 {
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
                                        text-decoration: none;
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

                                    .btn-cancel:hover {
                                        background-color: #f8fafc;
                                        border-color: #94a3b8;
                                        color: #0f172a;
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="app-container">
                                    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

                                    <main class="main-content">
                                        <header class="navbar">
                                            <div class="breadcrumb">
                                                <span>FamiCoats</span> / <a
                                                    href="${pageContext.request.contextPath}/admin/employees"
                                                    style="text-decoration: none; color: inherit;">Quản lý nhân viên</a>
                                                / <span class="active-crumb">
                                                    <%= isEdit ? "Cập nhật" : "Thêm mới" %>
                                                </span>
                                            </div>
                                            <div class="navbar-right">
                                                <div class="date-pill" id="live-date">Thứ Năm, 09/07/2026</div>
                                                <div class="profile-pill">
                                                    <span class="profile-avatar-mini">A</span>
                                                    <span>Admin</span>
                                                </div>
                                            </div>
                                        </header>

                                        <div class="content-wrapper" style="padding: 24px;">
                                            <div class="page-header" style="margin-bottom: 24px;">
                                                <h1
                                                    style="font-size: 24px; font-weight: 700; color: #0f172a; margin: 0;">
                                                    <%= isEdit ? "Cập nhật thông tin nhân viên"
                                                        : "Thêm mới thông tin nhân viên" %>
                                                </h1>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/admin/employees"
                                                method="post" id="employeeForm" novalidate>
                                                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                                                <% if (isEdit && emp != null) { %>
                                                    <input type="hidden" name="id" value="<%= emp.getId() %>">
                                                    <% } %>

                                                        <!-- Hidden fields -->
                                                        <input type="hidden" name="avatar" id="avatar"
                                                            value="<%= isEdit && emp != null && emp.getAvatar() != null ? emp.getAvatar() : "" %>">

                                                        <% if (session.getAttribute("errorMsg") != null) { %>
                                                            <div style="background-color: #fee2e2; color: #dc2626; padding: 12px 20px; border-radius: 8px; margin-bottom: 24px; font-weight: 500; border: 1px solid #fca5a5; display: flex; align-items: center; box-shadow: 0 2px 4px rgba(220,38,38,0.1);">
                                                                <svg style="margin-right: 12px;" viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                                                    <circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                                </svg>
                                                                <span><%= session.getAttribute("errorMsg") %></span>
                                                            </div>
                                                        <% } %>

                                                        <div class="form-card">
                                                            <div class="form-card-title">
                                                                <svg viewBox="0 0 24 24" width="18" height="18"
                                                                    stroke="currentColor" stroke-width="2.5" fill="none"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <line x1="12" y1="16" x2="12" y2="12"></line>
                                                                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                                                </svg>
                                                                THÔNG TIN NHÂN VIÊN
                                                            </div>
                                                            <div class="form-card-body">
                                                                <div class="form-grid">
                                                                    <!-- THÔNG TIN CÁ NHÂN -->
                                                                    <div class="form-group">
                                                                        <label class="form-label">Họ và tên <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <input type="text" name="fullName" id="fullNameInput"
                                                                            class="form-input" required
                                                                            placeholder="Nhập họ và tên đầy đủ"
                                                                            value="<%= isEdit && emp != null && emp.getFullName() != null ? emp.getFullName() : "" %>">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Vai trò <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <select name="roleId" id="roleSelect" class="form-select"
                                                                            required>
                                                                            <option value="">-- Chọn vai trò --</option>
                                                                            <% if (listRoles !=null) { for
                                                                                (Role role : listRoles) { %>
                                                                                <option value="<%= role.getId() %>"
                                                                                    <%=(isEdit && emp != null && emp.getRoleId()==role.getId())
                                                                                    ? "selected" : "" %>>
                                                                                    <%= role.getRoleName() %>
                                                                                </option>
                                                                                <% } } %>
                                                                        </select>
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Số CCCD <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <div style="display: flex; gap: 8px;">
                                                                            <input type="text" name="cccd" id="cccdInput"
                                                                                class="form-input" required style="flex: 1;"
                                                                                placeholder="12 chữ số"
                                                                                value="<%= isEdit && emp != null && emp.getCccd() != null ? emp.getCccd() : "" %>"
                                                                                maxlength="12">
                                                                            <button type="button" id="btnScanCccdCamera" onclick="startCameraScan()" style="padding: 0 16px; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 6px; color: #334155; font-weight: 500; white-space: nowrap;">
                                                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                                                                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path><circle cx="12" cy="13" r="4"></circle>
                                                                                </svg>
                                                                                Quét Camera
                                                                            </button>
                                                                        </div>
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Giới tính</label>
                                                                        <div class="radio-group"
                                                                            style="display: flex; gap: 16px; margin-top: 8px; color: #0f172a;">
                                                                            <label
                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px;">
                                                                                <input type="radio" name="gender"
                                                                                    value="1" <%=(!isEdit ||
                                                                                    (emp != null && emp.getGender() !=null &&
                                                                                    emp.getGender())) ? "checked" : ""
                                                                                    %>> Nam
                                                                            </label>
                                                                            <label
                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px;">
                                                                                <input type="radio" name="gender"
                                                                                    value="0" <%=(isEdit && emp != null &&
                                                                                    emp.getGender() !=null &&
                                                                                    !emp.getGender()) ? "checked" : ""
                                                                                    %>> Nữ
                                                                            </label>
                                                                        </div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Ngày sinh</label>
                                                                        <input type="date" name="birthday" id="birthdayInput"
                                                                            class="form-input"
                                                                            value="<%= isEdit && emp != null && emp.getBirthday() != null ? df.format(emp.getBirthday()) : "" %>">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Số điện thoại <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <input type="text" name="phoneNumber" id="phoneInput"
                                                                            class="form-input" required
                                                                            placeholder="VD: 0912345678"
                                                                            value="<%= isEdit && emp != null && emp.getPhoneNumber() != null ? emp.getPhoneNumber() : "" %>">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Email <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <input type="email" name="email" id="emailInput"
                                                                            class="form-input" required
                                                                            placeholder="VD: abc@gmail.com"
                                                                            value="<%= isEdit && emp != null && emp.getEmail() != null ? emp.getEmail() : "" %>">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Mật khẩu <%= isEdit ? "" : "<span style=\"color:#ef4444;\">*</span>" %></label>
                                                                        <input type="password" name="password" id="passwordInput"
                                                                            class="form-input"
                                                                            placeholder="<%= isEdit ? "Để trống nếu giữ nguyên mật khẩu" : "Nhập mật khẩu (Mặc định: 123456)" %>"
                                                                            value="">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <!-- BỘ ĐỊA CHỈ TRONG CÙNG GRID -->
                                                                    <div class="form-group">
                                                                        <label class="form-label">Tỉnh / Thành phố <span style="color:#ef4444;">*</span></label>
                                                                        <select id="province" class="form-select">
                                                                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                                                        </select>
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label class="form-label">Quận / Huyện <span style="color:#ef4444;">*</span></label>
                                                                        <select id="district" class="form-select" disabled>
                                                                            <option value="">-- Chọn Quận/Huyện --</option>
                                                                        </select>
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label class="form-label">Phường / Xã <span style="color:#ef4444;">*</span></label>
                                                                        <select id="ward" class="form-select" disabled>
                                                                            <option value="">-- Chọn Phường/Xã --</option>
                                                                        </select>
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <!-- Trường Địa chỉ chi tiết (Tổ, Thôn, Xóm, Số nhà...) -->
                                                                    <div class="form-group" style="grid-column: span 2;">
                                                                        <label class="form-label">Địa chỉ <span style="color:#ef4444;">*</span></label>
                                                                        <input type="text" name="detailAddress"
                                                                            id="detailAddress" class="form-input"
                                                                            placeholder="Nhập Tổ, Thôn, Xóm, Số nhà, Tên đường...">
                                                                        <div class="invalid-feedback"></div>
                                                                    </div>

                                                                    <!-- Các input ẩn hỗ trợ truyền thông tin về Backend -->
                                                                    <input type="hidden" name="province" id="hiddenProvinceName">
                                                                    <input type="hidden" name="district" id="hiddenDistrictName">
                                                                    <input type="hidden" name="ward" id="hiddenWardName">
                                                                    <input type="hidden" name="detailedAddress" id="hiddenDetailedAddress">
                                                                    <input type="hidden" name="address" id="fullAddress"
                                                                        value="<%= isEdit && emp != null ? emp.getFullAddressString() : "" %>">
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="form-actions"
                                                            style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px;">
                                                            <a href="${pageContext.request.contextPath}/admin/employees"
                                                                class="btn-cancel"
                                                                style="padding: 6px 16px; font-size: 12px; height: 36px;">Quay
                                                                lại</a>
                                                            <button type="button" class="btn-submit"
                                                                onclick="confirmSave(this)"
                                                                style="padding: 6px 16px; font-size: 12px; height: 36px; background-color: #3B82F6; color: white; border: none; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 6px; font-weight: 600;">
                                                                <svg viewBox="0 0 24 24" width="14" height="14"
                                                                    stroke="currentColor" stroke-width="2" fill="none"
                                                                    stroke-linecap="round" stroke-linejoin="round">
                                                                    <path
                                                                        d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z">
                                                                    </path>
                                                                    <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                                                    <polyline points="7 3 7 8 15 8"></polyline>
                                                                </svg>
                                                                <%= isEdit ? "Lưu thay đổi" : "Lưu nhân viên" %>
                                                            </button>
                                                        </div>
                                            </form>
                                        </div>
                                    </main>
                                </div>
                                

                                <script>
                                    window.CONTEXT_PATH = '${pageContext.request.contextPath}';

                                    let _pCache = null;
                                    let _dCache = {};
                                    let _wCache = {};

                                    async function geoFetch(path) {
                                        const urls = [
                                            'https://provinces.open-api.vn/api' + path,
                                            'https://provinces.open-api.vn/api/v1' + path
                                        ];
                                        for (const url of urls) {
                                            try {
                                                const r = await fetch(url, {signal: AbortSignal.timeout(8000)});
                                                if (r.ok) {
                                                    const d = await r.json();
                                                    if (d) return d;
                                                }
                                            } catch(e) {}
                                        }
                                        return null;
                                    }

                                    async function loadProvinces() {
                                        if (_pCache) return _pCache;
                                        const d = await geoFetch('/p/');
                                        if (Array.isArray(d) && d.length > 0) { _pCache = d; return d; }
                                        return [];
                                    }

                                    async function loadDistricts(pCode) {
                                        if (!pCode) return [];
                                        if (_dCache[pCode]) return _dCache[pCode];
                                        const d = await geoFetch('/p/' + pCode + '?depth=2');
                                        if (d && (d.districts || Array.isArray(d))) {
                                            const list = d.districts || d;
                                            _dCache[pCode] = list;
                                            return list;
                                        }
                                        return [];
                                    }

                                    async function loadWards(dCode) {
                                        if (!dCode) return [];
                                        if (_wCache[dCode]) return _wCache[dCode];
                                        const d = await geoFetch('/d/' + dCode + '?depth=2');
                                        if (d && (d.wards || Array.isArray(d))) {
                                            const list = d.wards || d;
                                            _wCache[dCode] = list;
                                            return list;
                                        }
                                        return [];
                                    }

                                    function buildOptions(sel, items, placeholder) {
                                        sel.innerHTML = '<option value="">' + placeholder + '</option>';
                                        if (!items || !Array.isArray(items)) return;
                                        items.forEach(function(item) {
                                            var o = document.createElement('option');
                                            o.value = item.code;
                                            o.textContent = item.name;
                                            sel.appendChild(o);
                                        });
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

                                    function syncFullAddress() {
                                        var pSel = document.getElementById('province');
                                        var dSel = document.getElementById('district');
                                        var wSel = document.getElementById('ward');
                                        var street = document.getElementById('detailAddress');
                                        
                                        var hiddenProv = document.getElementById('hiddenProvinceName');
                                        var hiddenDist = document.getElementById('hiddenDistrictName');
                                        var hiddenWard = document.getElementById('hiddenWardName');
                                        var hiddenDetail = document.getElementById('hiddenDetailedAddress');
                                        var hiddenFull = document.getElementById('fullAddress');

                                        var pt = pSel && pSel.selectedIndex > 0 ? pSel.options[pSel.selectedIndex].text : '';
                                        var dt = dSel && dSel.selectedIndex > 0 ? dSel.options[dSel.selectedIndex].text : '';
                                        var wt = wSel && wSel.selectedIndex > 0 ? wSel.options[wSel.selectedIndex].text : '';
                                        var s  = street ? street.value.trim() : '';

                                        if (hiddenProv) hiddenProv.value = pt;
                                        if (hiddenDist) hiddenDist.value = dt;
                                        if (hiddenWard) hiddenWard.value = wt;
                                        if (hiddenDetail) hiddenDetail.value = s;

                                        var parts = [s, wt, dt, pt].filter(function(x){ return x; });
                                        if (hiddenFull) hiddenFull.value = parts.join(', ');
                                    }

                                    async function setAddressCascading(addressString) {
                                        if (!addressString) return;
                                        var provSel = document.getElementById('province');
                                        var distSel = document.getElementById('district');
                                        var wardSel = document.getElementById('ward');
                                        var streetIn = document.getElementById('detailAddress');

                                        var parts = addressString.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
                                        if (parts.length === 0) return;

                                        if (streetIn) streetIn.value = addressString;

                                        if (parts.length < 2) {
                                            syncFullAddress();
                                            return;
                                        }

                                        var pName = parts[parts.length - 1];
                                        var provinces = await loadProvinces();
                                        if (!provSel) return;
                                        buildOptions(provSel, provinces, '-- Chọn Tỉnh/Thành phố --');
                                        provSel.disabled = false;

                                        var selectedPCode = null;
                                        for (var i = 0; i < provSel.options.length; i++) {
                                            if (geoMatch(pName, provSel.options[i].text)) {
                                                provSel.selectedIndex = i;
                                                selectedPCode = provSel.options[i].value;
                                                break;
                                            }
                                        }

                                        if (!selectedPCode) {
                                            syncFullAddress();
                                            return;
                                        }

                                        distSel.innerHTML = '<option value="">Đang tải Quận/Huyện...</option>';
                                        distSel.disabled = true;
                                        var dists = await loadDistricts(selectedPCode);
                                        buildOptions(distSel, dists, '-- Chọn Quận/Huyện --');
                                        distSel.disabled = false;

                                        var dName = parts.length >= 2 ? parts[parts.length - 2] : '';
                                        var selectedDCode = null;
                                        var matchedDIndex = -1;

                                        for (var j = 0; j < distSel.options.length; j++) {
                                            if (geoMatch(dName, distSel.options[j].text)) {
                                                matchedDIndex = j;
                                                selectedDCode = distSel.options[j].value;
                                                break;
                                            }
                                        }

                                        var wName = '';
                                        var streetParts = [];

                                        if (matchedDIndex > 0) {
                                            distSel.selectedIndex = matchedDIndex;
                                            wName = parts.length >= 3 ? parts[parts.length - 3] : '';
                                            streetParts = parts.slice(0, parts.length - 3);
                                        } else {
                                            for (var idx = parts.length - 2; idx >= 0; idx--) {
                                                for (var j = 0; j < distSel.options.length; j++) {
                                                    if (geoMatch(parts[idx], distSel.options[j].text)) {
                                                        distSel.selectedIndex = j;
                                                        selectedDCode = distSel.options[j].value;
                                                        wName = idx > 0 ? parts[idx - 1] : '';
                                                        streetParts = parts.slice(0, idx - 1);
                                                        break;
                                                    }
                                                }
                                                if (selectedDCode) break;
                                            }
                                        }

                                        var detailText = streetParts.join(', ').trim();
                                        if (streetIn) {
                                            if (detailText) {
                                                streetIn.value = detailText;
                                            } else if (matchedDIndex > 0 && parts.length > 3) {
                                                streetIn.value = parts.slice(0, parts.length - 3).join(', ');
                                            } else if (parts.length > 2) {
                                                streetIn.value = parts.slice(0, parts.length - 2).join(', ');
                                            }
                                        }

                                        if (selectedDCode) {
                                            wardSel.innerHTML = '<option value="">Đang tải Phường/Xã...</option>';
                                            wardSel.disabled = true;
                                            var wards = await loadWards(selectedDCode);
                                            buildOptions(wardSel, wards, '-- Chọn Phường/Xã --');
                                            wardSel.disabled = (wards.length === 0);

                                            if (wName) {
                                                for (var k = 0; k < wardSel.options.length; k++) {
                                                    if (geoMatch(wName, wardSel.options[k].text)) {
                                                        wardSel.selectedIndex = k;
                                                        break;
                                                    }
                                                }
                                            }
                                        }

                                        syncFullAddress();
                                        validateAllFieldsLive();
                                    }

                                    document.addEventListener('DOMContentLoaded', async function() {
                                        var provSel = document.getElementById('province');
                                        var distSel = document.getElementById('district');
                                        var wardSel = document.getElementById('ward');
                                        var streetIn = document.getElementById('detailAddress');
                                        var hidden   = document.getElementById('fullAddress');

                                        if (!provSel) return;

                                        provSel.innerHTML = '<option value="">Đang tải Tỉnh/Thành...</option>';
                                        provSel.disabled = true;
                                        var provinces = await loadProvinces();
                                        buildOptions(provSel, provinces, '-- Chọn Tỉnh/Thành phố --');
                                        provSel.disabled = false;

                                        provSel.addEventListener('change', async function() {
                                            var pCode = this.value;
                                            if (!pCode) {
                                                distSel.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                                                distSel.disabled = true;
                                                wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                                wardSel.disabled = true;
                                                syncFullAddress();
                                                validateField('province');
                                                return;
                                            }
                                            distSel.innerHTML = '<option value="">Đang tải Quận/Huyện...</option>';
                                            distSel.disabled = true;
                                            wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                            wardSel.disabled = true;
                                            var dists = await loadDistricts(pCode);
                                            buildOptions(distSel, dists, '-- Chọn Quận/Huyện --');
                                            distSel.disabled = false;
                                            syncFullAddress();
                                            validateField('province');
                                        });

                                        distSel.addEventListener('change', async function() {
                                            var dCode = this.value;
                                            if (!dCode) {
                                                wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                                wardSel.disabled = true;
                                                syncFullAddress();
                                                validateField('district');
                                                return;
                                            }
                                            wardSel.innerHTML = '<option value="">Đang tải Phường/Xã...</option>';
                                            wardSel.disabled = true;
                                            var wards = await loadWards(dCode);
                                            buildOptions(wardSel, wards, '-- Chọn Phường/Xã --');
                                            wardSel.disabled = (wards.length === 0);
                                            syncFullAddress();
                                            validateField('district');
                                        });

                                        wardSel.addEventListener('change', function() {
                                            syncFullAddress();
                                            validateField('ward');
                                        });
                                        if (streetIn) streetIn.addEventListener('input', function() {
                                            syncFullAddress();
                                            validateField('detailAddress');
                                        });

                                        var existing = hidden ? hidden.value.trim() : '';
                                        if (existing) {
                                            await setAddressCascading(existing);
                                        }

                                        setupLiveValidation();
                                    });
                                </script>

                                <div id="qrCameraModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 9999; justify-content: center; align-items: center;">
                                    <div style="background: white; padding: 24px; border-radius: 12px; width: 440px; max-width: 95%; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.4);">
                                        <h3 style="margin-top: 0; font-size: 18px; color: #0f172a;">📷 Quét mã QR CCCD</h3>
                                        <div style="background: #fefce8; border: 1px solid #fde047; border-radius: 8px; padding: 10px 14px; margin-bottom: 14px; font-size: 12px; color: #713f12; text-align: left;">
                                            💡 <strong>Mẹo quét thẻ vật lý:</strong><br>
                                            • Đặt thẻ cách webcam <strong>15–25cm</strong><br>
                                            • Hướng thẻ về phía có nguồn đèn (cửa sổ, đèn trần)<br>
                                            • Tránh góc đặt khiến mã QR bị phản sáng<br>
                                            • Giữ thẻ thật yên, không rung
                                        </div>
                                        <div id="qrReader" style="width: 100%; border-radius: 8px; overflow: hidden; margin-bottom: 16px;"></div>
                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                            <button type="button" id="btnToggleTorch" onclick="toggleTorch()" style="display:none; padding: 10px 20px; background: #fef9c3; border: 1px solid #fde047; border-radius: 8px; color: #713f12; font-weight: 600; cursor: pointer; font-size: 13px;">
                                                🔦 Bật Đèn
                                            </button>
                                            <button type="button" onclick="stopCameraScan()" style="padding: 10px 28px; background: #f1f5f9; border: 1px solid #cbd5e1; border-radius: 8px; color: #475569; font-weight: 600; cursor: pointer; font-size: 14px;">
                                                ✕ Đóng Camera
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                                <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>

                                <script>
                                    // Hàm hiển thị / ẩn thông báo lỗi trực tiếp bên dưới ô input (Real-time Validation)
                                    function setFieldError(el, message) {
                                        if (!el) return;
                                        let parent = el.closest('.form-group') || el.parentElement;
                                        let errBox = parent ? parent.querySelector('.invalid-feedback') : null;

                                        if (message) {
                                            el.style.borderColor = '#ef4444';
                                            el.style.boxShadow = '0 0 0 2px rgba(239, 68, 68, 0.15)';
                                            if (errBox) {
                                                errBox.textContent = message;
                                                errBox.style.display = 'block';
                                            }
                                        } else {
                                            el.style.borderColor = '';
                                            el.style.boxShadow = '';
                                            if (errBox) {
                                                errBox.textContent = '';
                                                errBox.style.display = 'none';
                                            }
                                        }
                                    }

                                    function validateField(fieldIdOrName) {
                                        const form = document.getElementById('employeeForm');
                                        if (!form) return true;

                                        let el = document.getElementById(fieldIdOrName) || form.querySelector('[name="' + fieldIdOrName + '"]');
                                        if (!el) return true;

                                        let val = el.value ? el.value.trim() : '';

                                        if (fieldIdOrName === 'fullName' || fieldIdOrName === 'fullNameInput') {
                                            if (!val) { setFieldError(el, 'Họ và tên không được để trống.'); return false; }
                                            if (val.length < 2) { setFieldError(el, 'Họ và tên phải gồm ít nhất 2 ký tự.'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'roleId' || fieldIdOrName === 'roleSelect') {
                                            if (!val || val === '0') { setFieldError(el, 'Vui lòng chọn vai trò làm việc.'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'cccd' || fieldIdOrName === 'cccdInput') {
                                            if (!val) { setFieldError(el, 'Số CCCD không được để trống.'); return false; }
                                            if (!/^\d{12}$/.test(val)) { setFieldError(el, 'Số CCCD phải gồm đúng 12 chữ số.'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'phoneNumber' || fieldIdOrName === 'phoneInput') {
                                            if (!val) { setFieldError(el, 'Số điện thoại không được để trống.'); return false; }
                                            if (!/^(03|05|07|08|09)\d{8}$/.test(val)) { setFieldError(el, 'Số điện thoại không hợp lệ (10 số, bắt đầu bằng 03, 05, 07, 08, 09).'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'email' || fieldIdOrName === 'emailInput') {
                                            if (!val) { setFieldError(el, 'Email không được để trống.'); return false; }
                                            if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(val)) { setFieldError(el, 'Email không đúng định dạng chuẩn.'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'password' || fieldIdOrName === 'passwordInput') {
                                            if (val && val.length < 6) { setFieldError(el, 'Mật khẩu phải từ 6 ký tự trở lên.'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'birthday' || fieldIdOrName === 'birthdayInput') {
                                            if (val) {
                                                const dob = new Date(val);
                                                const today = new Date();
                                                let age = today.getFullYear() - dob.getFullYear();
                                                const m = today.getMonth() - dob.getMonth();
                                                if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) age--;
                                                if (age < 18) { setFieldError(el, 'Nhân viên phải từ 18 tuổi trở lên.'); return false; }
                                            }
                                            setFieldError(el, null); return true;
                                        }

                                        if (fieldIdOrName === 'province') {
                                            if (!val) { setFieldError(el, 'Vui lòng chọn Tỉnh / Thành phố.'); return false; }
                                            setFieldError(el, null); return true;
                                        }
                                        if (fieldIdOrName === 'district') {
                                            if (!val) { setFieldError(el, 'Vui lòng chọn Quận / Huyện.'); return false; }
                                            setFieldError(el, null); return true;
                                        }
                                        if (fieldIdOrName === 'ward') {
                                            if (!val) { setFieldError(el, 'Vui lòng chọn Phường / Xã.'); return false; }
                                            setFieldError(el, null); return true;
                                        }
                                        if (fieldIdOrName === 'detailAddress') {
                                            if (!val) { setFieldError(el, 'Vui lòng nhập chi tiết Địa chỉ (Tổ, Thôn, Xóm, Số nhà...).'); return false; }
                                            setFieldError(el, null); return true;
                                        }

                                        return true;
                                    }

                                    function validateAllFieldsLive() {
                                        const fields = ['fullNameInput', 'roleSelect', 'cccdInput', 'phoneInput', 'emailInput', 'birthdayInput', 'province', 'district', 'ward', 'detailAddress'];
                                        let isValid = true;
                                        let firstErrorEl = null;

                                        fields.forEach(function(fId) {
                                            let pass = validateField(fId);
                                            if (!pass && !firstErrorEl) {
                                                firstErrorEl = document.getElementById(fId) || document.querySelector('[name="' + fId + '"]');
                                            }
                                            if (!pass) isValid = false;
                                        });

                                        if (!isValid && firstErrorEl) {
                                            firstErrorEl.focus();
                                        }
                                        return isValid;
                                    }

                                    function setupLiveValidation() {
                                        const fields = [
                                            { id: 'fullNameInput', ev: ['input', 'blur'] },
                                            { id: 'roleSelect', ev: ['change', 'blur'] },
                                            { id: 'cccdInput', ev: ['input', 'blur'] },
                                            { id: 'phoneInput', ev: ['input', 'blur'] },
                                            { id: 'emailInput', ev: ['input', 'blur'] },
                                            { id: 'birthdayInput', ev: ['change', 'blur'] },
                                            { id: 'province', ev: ['change'] },
                                            { id: 'district', ev: ['change'] },
                                            { id: 'ward', ev: ['change'] },
                                            { id: 'detailAddress', ev: ['input', 'blur'] }
                                        ];

                                        fields.forEach(function(item) {
                                            let el = document.getElementById(item.id) || document.querySelector('[name="' + item.id + '"]');
                                            if (el) {
                                                item.ev.forEach(function(eventName) {
                                                    el.addEventListener(eventName, function() {
                                                        validateField(item.id);
                                                    });
                                                });
                                            }
                                        });
                                    }

                                    function confirmSave(btn) {
                                        const form = document.getElementById('employeeForm');
                                        if (!validateAllFieldsLive()) {
                                            return;
                                        }
                                        Swal.fire({
                                            title: 'Xác nhận lưu?',
                                            text: "Bạn có chắc chắn muốn lưu thông tin này?",
                                            icon: 'question',
                                            showCancelButton: true,
                                            confirmButtonColor: '#3B82F6',
                                            cancelButtonColor: '#94A3B8',
                                            confirmButtonText: 'Đồng ý',
                                            cancelButtonText: 'Hủy'
                                        }).then((result) => {
                                            if (result.isConfirmed) {
                                                if (typeof syncFullAddress === 'function') syncFullAddress();
                                                form.submit();
                                            }
                                        });
                                    }
                                </script>
                                <script src="https://unpkg.com/html5-qrcode"></script>
                                <script src="${pageContext.request.contextPath}/assets/js/qr-scanner.js"></script>
                                
                                <script>
                                    let html5QrCode = null;
                                    let isScannerRunning = false;

                                    function startCameraScan() {
                                        if (isScannerRunning) return;

                                        const modal = document.getElementById('qrCameraModal');
                                        modal.style.display = 'flex';

                                        html5QrCode = new Html5Qrcode("qrReader");
                                        
                                        const config = {
                                            fps: 30,
                                            qrbox: { width: 300, height: 300 },
                                            aspectRatio: 1.0,
                                            experimentalFeatures: {
                                                useBarCodeDetectorIfSupported: true
                                            },
                                            rememberLastUsedCamera: false
                                        };

                                        const onScanSuccess = (decodedText) => {
                                            stopCameraScan();
                                            handleScannedData(decodedText);
                                        };

                                        html5QrCode.start({ facingMode: "environment" }, config, onScanSuccess, () => {})
                                        .then(() => {
                                            isScannerRunning = true;
                                        })
                                        .catch(() => {
                                            html5QrCode.start({ facingMode: "user" }, config, onScanSuccess, () => {})
                                            .then(() => {
                                                isScannerRunning = true;
                                            })
                                            .catch((err2) => {
                                                console.error("Không mở được camera:", err2);
                                                modal.style.display = 'none';
                                                Swal.fire({
                                                    icon: 'error',
                                                    title: 'Không thể mở Camera',
                                                    html: 'Vui lòng:<br>• Cho phép trình duyệt truy cập camera<br>• Kiểm tra camera có đang dùng bởi app khác không<br>• Thử tải lại trang (F5)',
                                                    confirmButtonColor: '#3b82f6'
                                                });
                                            });
                                        });
                                    }

                                    let torchOn = false;
                                    async function toggleTorch() {
                                        if (!html5QrCode) return;
                                        try {
                                            torchOn = !torchOn;
                                            await html5QrCode.applyVideoConstraints({ advanced: [{ torch: torchOn }] });
                                            const btn = document.getElementById('btnToggleTorch');
                                            btn.textContent = torchOn ? '🔦 Tắt Đèn' : '🔦 Bật Đèn';
                                            btn.style.background = torchOn ? '#fde047' : '#fef9c3';
                                        } catch(e) { console.log('Torch not supported'); }
                                    }

                                    function stopCameraScan() {
                                        const modal = document.getElementById('qrCameraModal');
                                        modal.style.display = 'none';
                                        isScannerRunning = false;

                                        if (html5QrCode) {
                                            const instance = html5QrCode;
                                            html5QrCode = null;
                                            instance.stop()
                                            .then(() => instance.clear())
                                            .catch(() => {
                                                try { instance.clear(); } catch(e) {}
                                            });
                                        }
                                    }

                                    async function handleScannedData(qrText) {
                                        try {
                                            const cccdData = typeof parseCccdString === 'function' ? parseCccdString(qrText) : { cccd: qrText };
                                            await fillCccdData(cccdData);
                                            Swal.fire({
                                                icon: 'success',
                                                title: '✅ Thành công!',
                                                text: 'Đã quét và điền thông tin CCCD.',
                                                timer: 2000,
                                                showConfirmButton: false
                                            });
                                        } catch (e) {
                                            console.error(e);
                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'QR không hợp lệ',
                                                text: 'Mã QR không đúng định dạng CCCD Việt Nam. Vui lòng thử lại.',
                                                confirmButtonColor: '#3b82f6'
                                            });
                                        }
                                    }

                                    async function fillCccdData(data) {
                                        if (!data) return;
                                        const safeSet = (selector, value, byId) => {
                                            const el = byId ? document.getElementById(selector) : document.querySelector(selector);
                                            if (el && value !== undefined && value !== null) el.value = value;
                                        };
                                        if (data.cccd) safeSet('cccdInput', data.cccd, true);
                                        if (data.fullName) safeSet('input[name="fullName"]', data.fullName);
                                        if (data.dob) safeSet('input[name="birthday"]', data.dob);
                                        if (data.gender !== undefined && data.gender !== null) {
                                            const radio = document.querySelector('input[name="gender"][value="' + data.gender + '"]');
                                            if (radio) radio.checked = true;
                                        }
                                        if (data.address) {
                                            await setAddressCascading(data.address);
                                        }
                                        validateAllFieldsLive();
                                    }
                                </script>
                            </body>

                            <%-- Toast thông báo dùng chung --%>
                            <jsp:include page="/WEB-INF/views/layout/toast.jsp" />

                            </html>