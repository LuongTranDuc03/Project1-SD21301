<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ page import="project.duan1_sd21301.model.huy.Employee" %>
        <%@ page import="project.duan1_sd21301.model.huy.Role" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.text.SimpleDateFormat" %>
<% 
    String currentUserRole = (String) session.getAttribute("currentUserRole"); 
    boolean isManager = "Quản lý".equals(currentUserRole);
    boolean isStaff = "Nhân viên".equals(currentUserRole);
    boolean isSysAdmin = "Admin".equals(currentUserRole);

    if (currentUserRole == null || (!isManager && !isStaff && !isSysAdmin)) { 
        currentUserRole = "Quản lý"; 
        session.setAttribute("currentUserRole", currentUserRole); 
    } 
    
    boolean isAdmin = "Admin".equals(currentUserRole) || "Quản lý".equals(currentUserRole); 
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
                                        alert("Lỗi JS: " + msg + "\nDòng: " + line);
                                        return false;
                                    };
                                    window.addEventListener('unhandledrejection', function(event) {
                                        alert("Lỗi Promise: " + (event.reason ? event.reason.message : event.reason));
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
                                        border: 1px solid #cbd5e1;
                                        border-radius: 8px;
                                        padding: 10px 14px;
                                        font-size: 13px;
                                        color: #1e293b;
                                        font-family: inherit;
                                        outline: none;
                                        transition: all 0.2s ease;
                                        background-color: #ffffff;
                                        box-sizing: border-box;
                                    }

                                    .form-input:focus,
                                    .form-select:focus,
                                    .form-textarea:focus {
                                        border-color: #0f172a;
                                        box-shadow: 0 0 0 3px rgba(15, 23, 42, 0.15);
                                    }

                                    .form-textarea {
                                        resize: vertical;
                                        min-height: 80px;
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
                                                method="post" id="employeeForm">
                                                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                                                <% if (isEdit) { %>
                                                    <input type="hidden" name="id" value="<%= emp.getId() %>">
                                                    <% } %>

                                                        <!-- Hidden fields -->
                                                        <input type="hidden" name="avatar" id="avatar"
                                                            value="<%= isEdit && emp.getAvatar() != null ? emp.getAvatar() : "" %>">

                                                        <!-- ALL IN ONE FORM CARD -->
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
                                                                        <input type="text" name="fullName"
                                                                            class="form-input" required
                                                                            value="<%= isEdit && emp.getFullName() != null ? emp.getFullName() : "" %>">
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Vai trò <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <select name="roleId" class="form-select"
                                                                            required>
                                                                            <option value="">-- Chọn vai trò --</option>
                                                                            <% if (listRoles !=null) { for
                                                                                (project.duan1_sd21301.model.huy.Role
                                                                                role : listRoles) { %>
                                                                                <option value="<%= role.getId() %>"
                                                                                    <%=(isEdit &&
                                                                                    emp.getRoleId()==role.getId())
                                                                                    ? "selected" : "" %>>
                                                                                    <%= role.getRoleName() %>
                                                                                </option>
                                                                                <% } } %>
                                                                        </select>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Số CCCD <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <div style="display: flex; gap: 8px;">
                                                                            <input type="text" name="cccd" id="cccdInput"
                                                                                class="form-input" required style="flex: 1;"
                                                                                value="<%= isEdit && emp.getCccd() != null ? emp.getCccd() : "" %>"
                                                                                pattern="\d{12}" title="Vui lòng nhập đúng 12 chữ số CCCD"
                                                                                maxlength="12">
                                                                            <button type="button" id="btnScanCccd" onclick="handleScanBtnClick()" style="padding: 0 16px; background-color: #f8fafc; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; display: flex; align-items: center; gap: 6px; color: #334155; font-weight: 500; white-space: nowrap;">
                                                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                                                                    <path d="M4 7V4h3M20 7V4h-3M4 17v3h3M20 17v3h-3M9 9h6v6H9z"></path>
                                                                                </svg>
                                                                                Quét ảnh
                                                                            </button>
                                                                        </div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Giới tính</label>
                                                                        <div class="radio-group"
                                                                            style="display: flex; gap: 16px; margin-top: 8px; color: #0f172a;">
                                                                            <label
                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px;">
                                                                                <input type="radio" name="gender"
                                                                                    value="1" <%=(!isEdit ||
                                                                                    (emp.getGender() !=null &&
                                                                                    emp.getGender())) ? "checked" : ""
                                                                                    %>> Nam
                                                                            </label>
                                                                            <label
                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px;">
                                                                                <input type="radio" name="gender"
                                                                                    value="0" <%=(isEdit &&
                                                                                    emp.getGender() !=null &&
                                                                                    !emp.getGender()) ? "checked" : ""
                                                                                    %>> Nữ
                                                                            </label>
                                                                        </div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Ngày sinh</label>
                                                                        <input type="date" name="birthday"
                                                                            class="form-input"
                                                                            value="<%= isEdit && emp.getBirthday() != null ? df.format(emp.getBirthday()) : "" %>">
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Số điện thoại <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <input type="text" name="phoneNumber"
                                                                            class="form-input" required
                                                                            pattern="^(03|05|07|08|09)\d{8}$"
                                                                            title="Vui lòng nhập đúng số điện thoại (10 số, bắt đầu bằng 03/05/07/08/09)"
                                                                            placeholder="VD: 0912345678"
                                                                            value="<%= isEdit && emp.getPhoneNumber() != null ? emp.getPhoneNumber() : "" %>">
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label class="form-label">Email <span
                                                                                style="color:#ef4444;">*</span></label>
                                                                        <input type="email" name="email"
                                                                            class="form-input" required
                                                                            placeholder="VD: abc@gmail.com"
                                                                            value="<%= isEdit && emp.getEmail() != null ? emp.getEmail() : "" %>">
                                                                    </div>

                                                                    <!-- BỘ ĐỊA CHỈ TRONG CÙNG GRID -->
                                                                    <div class="form-group">
                                                                        <label class="form-label">Tỉnh / Thành
                                                                            phố</label>
                                                                        <select id="province" class="form-select">
                                                                            <option value="">-- Tỉnh/Thành phố --
                                                                            </option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label class="form-label">Quận / Huyện</label>
                                                                        <select id="district" class="form-select"
                                                                            disabled>
                                                                            <option value="">-- Quận/Huyện --</option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label class="form-label">Phường / Xã</label>
                                                                        <select id="ward" class="form-select" disabled>
                                                                            <option value="">-- Phường/Xã/Đặc khu --
                                                                            </option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="form-group"
                                                                        style="grid-column: span 2;">
                                                                        <label class="form-label">Địa chỉ tổng hợp (Số
                                                                            nhà,
                                                                            đường...)</label>
                                                                        <input type="text" name="detailAddress"
                                                                            id="detailAddress" class="form-input"
                                                                            required
                                                                            placeholder="VD: Số 123, Đường Lê Lợi">
                                                                    </div>
                                                                    <!-- Input ẩn lưu chuỗi address đầy đủ -->
                                                                    <input type="hidden" name="address" id="fullAddress"
                                                                        value="<%= isEdit && emp.getAddress() != null ? emp.getAddress() : "" %>">
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

                                    // === ĐỊA CHỈ: tự gọi thẳng API ngoài, không qua proxy ===
                                    let _pCache = null;
                                    let _dCache = {};
                                    let _wCache = {};

                                    async function geoFetch(path) {
                                        const direct = 'https://provinces.open-api.vn' + path;
                                        try {
                                            const r = await fetch(direct, {signal: AbortSignal.timeout(15000)});
                                            if (r.ok) return await r.json();
                                        } catch(e) { console.error('[Geo] error:', e.message); }
                                        return null;
                                    }

                                    async function loadProvinces() {
                                        if (_pCache) return _pCache;
                                        const d = await geoFetch('/api/v1/p');
                                        if (Array.isArray(d) && d.length > 0) { _pCache = d; return d; }
                                        return [];
                                    }

                                    async function loadDistricts(pCode) {
                                        if (_dCache[pCode]) return _dCache[pCode];
                                        const d = await geoFetch('/api/v1/p/' + pCode + '?depth=2');
                                        if (d && d.districts) { _dCache[pCode] = d.districts; return d.districts; }
                                        return [];
                                    }

                                    async function loadWards(dCode) {
                                        if (_wCache[dCode]) return _wCache[dCode];
                                        const d = await geoFetch('/api/v1/d/' + dCode + '?depth=2');
                                        if (d && d.wards) { _wCache[dCode] = d.wards; return d.wards; }
                                        return [];
                                    }

                                    function buildOptions(sel, items, placeholder) {
                                        sel.innerHTML = '<option value="">' + placeholder + '</option>';
                                        items.forEach(function(item) {
                                            var o = document.createElement('option');
                                            o.value = item.code;
                                            o.textContent = item.name;
                                            sel.appendChild(o);
                                        });
                                    }

                                    function syncFullAddress() {
                                        var pSel = document.getElementById('province');
                                        var dSel = document.getElementById('district');
                                        var wSel = document.getElementById('ward');
                                        var street = document.getElementById('detailAddress');
                                        var hidden = document.getElementById('fullAddress');
                                        if (!hidden) return;
                                        var pt = pSel && pSel.selectedIndex > 0 ? pSel.options[pSel.selectedIndex].text : '';
                                        var dt = dSel && dSel.selectedIndex > 0 ? dSel.options[dSel.selectedIndex].text : '';
                                        var wt = wSel && wSel.selectedIndex > 0 ? wSel.options[wSel.selectedIndex].text : '';
                                        var s  = street ? street.value.trim() : '';
                                        var parts = [s, wt, dt, pt].filter(function(x){ return x; });
                                        hidden.value = parts.join(', ');
                                    }

                                    document.addEventListener('DOMContentLoaded', async function() {
                                        var provSel = document.getElementById('province');
                                        var distSel = document.getElementById('district');
                                        var wardSel = document.getElementById('ward');
                                        var streetIn = document.getElementById('detailAddress');
                                        var hidden   = document.getElementById('fullAddress');

                                        if (!provSel) return;

                                        // Load tỉnh thành
                                        provSel.innerHTML = '<option value="">Đang tải...</option>';
                                        provSel.disabled = true;
                                        var provinces = await loadProvinces();
                                        buildOptions(provSel, provinces, '-- Chọn Tỉnh/Thành --');
                                        provSel.disabled = false;

                                        // Sự kiện chọn Tỉnh
                                        provSel.addEventListener('change', async function() {
                                            distSel.innerHTML = '<option value="">Đang tải...</option>';
                                            distSel.disabled = true;
                                            wardSel.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                            wardSel.disabled = true;
                                            var dists = await loadDistricts(this.value);
                                            buildOptions(distSel, dists, '-- Chọn Quận/Huyện --');
                                            distSel.disabled = false;
                                            syncFullAddress();
                                        });

                                        // Sự kiện chọn Quận
                                        distSel.addEventListener('change', async function() {
                                            wardSel.innerHTML = '<option value="">Đang tải...</option>';
                                            wardSel.disabled = true;
                                            var wards = await loadWards(this.value);
                                            buildOptions(wardSel, wards, '-- Chọn Phường/Xã --');
                                            wardSel.disabled = (wards.length === 0);
                                            syncFullAddress();
                                        });

                                        wardSel.addEventListener('change', syncFullAddress);
                                        if (streetIn) streetIn.addEventListener('input', syncFullAddress);

                                        // Edit mode: phục hồi giá trị cũ
                                        var existing = hidden ? hidden.value.trim() : '';
                                        if (existing) {
                                            var parts = existing.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
                                            if (parts.length >= 4) {
                                                var pName = parts[parts.length - 1];
                                                var dName = parts[parts.length - 2];
                                                var wName = parts[parts.length - 3];
                                                var street2 = parts.slice(0, parts.length - 3).join(', ');
                                                if (streetIn) streetIn.value = street2;
                                                var pm = provinces.find(function(x){ return x.name.trim() === pName; });
                                                if (pm) {
                                                    provSel.value = pm.code;
                                                    var dists2 = await loadDistricts(pm.code);
                                                    buildOptions(distSel, dists2, '-- Chọn Quận/Huyện --');
                                                    distSel.disabled = false;
                                                    var dm = dists2.find(function(x){ return x.name.trim() === dName; });
                                                    if (dm) {
                                                        distSel.value = dm.code;
                                                        var wards2 = await loadWards(dm.code);
                                                        buildOptions(wardSel, wards2, '-- Chọn Phường/Xã --');
                                                        wardSel.disabled = false;
                                                        for (var i = 0; i < wardSel.options.length; i++) {
                                                            if (wardSel.options[i].text.trim() === wName) { wardSel.selectedIndex = i; break; }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                                </script>
                                <script>
                                    // Xử lý ảnh base64
                                    const avatarFileInput = document.getElementById('avatarFile');
                                    if (avatarFileInput) {
                                        avatarFileInput.addEventListener('change', function (e) {
                                            const file = e.target.files[0];
                                            if (file) {
                                                document.getElementById('fileName').innerText = file.name;
                                                const reader = new FileReader();
                                                reader.onload = function (evt) {
                                                    const base64Str = evt.target.result;
                                                    document.getElementById('avatar').value = base64Str;
                                                    document.getElementById('avatarPreview').innerHTML = `<img src="${base64Str}" style="width: 100%; height: 100%; object-fit: cover;">`;
                                                };
                                                reader.readAsDataURL(file);
                                            }
                                        });
                                    }

                                    document.addEventListener('DOMContentLoaded', () => {
                                        // (Phần khởi tạo block địa chỉ đã được xử lý ở script phía trên)

                                        // Auto-fill CCCD từ URL hoặc sessionStorage
                                        let cccdData = null;
                                        const urlParams = new URLSearchParams(window.location.search);
                                        if (urlParams.get('cccd')) {
                                            cccdData = { cccd: urlParams.get('cccd') };
                                        } else if (sessionStorage.getItem('scannedCccdData')) {
                                            cccdData = JSON.parse(sessionStorage.getItem('scannedCccdData'));
                                            sessionStorage.removeItem('scannedCccdData'); // Xóa sau khi dùng
                                        }

                                        if (cccdData) {
                                            fillFormWithCccdData(cccdData);
                                        }
                                    });

                                    // Helper hàm để điền data vào form
                                    function fillFormWithCccdData(data) {
                                        let debugMsg = "Data nhận được:\nCCCD: " + data.cccd + "\nTên: " + data.fullName + "\nDOB: " + data.dob + "\nGiới tính: " + data.gender;
                                        // Hiển thị thông báo để người dùng thấy rõ nội dung đã quét
                                        Swal.fire({
                                            icon: 'info',
                                            title: 'Debug Data',
                                            text: debugMsg
                                        });

                                        const cccdInput = document.getElementById('cccdInput');
                                        if (cccdInput && data.cccd) {
                                            cccdInput.value = data.cccd;
                                            cccdInput.readOnly = true;
                                            cccdInput.setAttribute('readonly', 'readonly');
                                            cccdInput.style.backgroundColor = '#f1f5f9';
                                            cccdInput.style.color = '#94a3b8';
                                            cccdInput.style.cursor = 'not-allowed';
                                            cccdInput.style.pointerEvents = 'none';
                                        }
                                        
                                        if (data.fullName) {
                                            const fullNameEl = document.querySelector('input[name="fullName"]');
                                            if (fullNameEl) fullNameEl.value = data.fullName;
                                        }
                                        
                                        if (data.dob) {
                                            const dobEl = document.querySelector('input[name="birthday"]');
                                            if (dobEl) dobEl.value = data.dob;
                                        }
                                        
                                        if (data.gender) {
                                            const genderEl = document.querySelector(`input[name="gender"][value="${data.gender}"]`);
                                            if (genderEl) genderEl.checked = true;
                                        }
                                        
                                        if (data.address) {
                                            const streetEl = document.getElementById('detailAddress');
                                            if (streetEl) streetEl.value = data.address;
                                            const addressHidden = document.getElementById('fullAddress');
                                            if (addressHidden) addressHidden.value = data.address;
                                            
                                            // Trigger sync if the function exists
                                            if (typeof syncFullAddress === 'function') syncFullAddress();
                                        }
                                    }
                                     // Toast is now handled by layout/toast.jsp
                                    function handleScanBtnClick() {
                                        Swal.fire({
                                            title: 'Tải ảnh CCCD',
                                            html: '<input type="file" id="cccdScanFile" accept="image/*" style="margin-top:10px;width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;">',
                                            showCancelButton: true,
                                            confirmButtonText: 'Xử lý & Quét',
                                            cancelButtonText: 'Hủy',
                                            confirmButtonColor: '#3B82F6',
                                            cancelButtonColor: '#94A3B8',
                                            preConfirm: () => {
                                                const file = document.getElementById('cccdScanFile').files[0];
                                                if (!file) { Swal.showValidationMessage('Vui lòng chọn ảnh CCCD'); }
                                                return file;
                                            }
                                        }).then(async (result) => {
                                            if (result.isConfirmed) {
                                                const file = result.value;
                                                Swal.fire({ title: 'Đang giải mã QR...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });
                                                try {
                                                    const qrText = await decodeQR(file);
                                                    const cccdData = parseCccdString(qrText);
                                                    
                                                    fillFormWithCccdData(cccdData);
                                                    
                                                    // Swal.fire({ icon: 'success', title: 'Quét thành công!', text: 'Đã điền thông tin tự động.', showConfirmButton: false, timer: 1500 });
                                                } catch (err) {
                                                    Swal.fire({ icon: 'error', title: 'Lỗi quét QR', text: err.message || "Không thể giải mã mã QR" });
                                                }
                                            }
                                        });
                                    }

                                    function confirmSave(btn) {
                                        const form = btn.closest('form');
                                        if (!form.checkValidity()) {
                                            form.reportValidity(); // This will show the browser's default validation UI
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
                                                // Sync địa chỉ tổng hợp trước khi submit
                                                if (typeof syncFullAddress === 'function') syncFullAddress();
                                                form.submit();
                                            }
                                        });
                                    }

                                </script>
                                <script>
document.addEventListener('DOMContentLoaded', function() {

    const form = document.querySelector('form');
    if (form) {

        form.addEventListener('submit', function(e) {
            document.querySelectorAll('.error-msg').forEach(el => el.remove());
            let isValid = true;
                const nameInput = document.querySelector('input[name="fullName"]');

                const nameRegex = /^[\p{L}\s]{2,}$/u;
                if (nameInput && (!nameInput.value || !nameRegex.test(nameInput.value.trim()))) {
                    showError(nameInput, 'Họ và tên tối thiểu 2 ký tự và không chứa số hoặc ký tự đặc biệt.');
                    isValid = false;
                }

                const phoneInput = document.querySelector('input[name="phoneNumber"]');

                const phoneRegex = /^(03|05|07|08|09)\d{8}$/;
                if (phoneInput && (!phoneInput.value || !phoneRegex.test(phoneInput.value.trim()))) {
                    showError(phoneInput, 'Số điện thoại phải 10 chữ số và bắt đầu bằng 03, 05, 07, 08, hoặc 09.');
                    isValid = false;
                }

                const emailInput = document.querySelector('input[name="email"]');

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (emailInput && (!emailInput.value || !emailRegex.test(emailInput.value.trim()))) {
                    showError(emailInput, 'Email không hợp lệ.');
                    isValid = false;
                }

            if (!isValid) {
                e.preventDefault();
            } else {
                // Form hợp lệ, hiển thị hộp thoại xác nhận
                const isEdit = form.getAttribute('data-is-edit') === 'true';
                const msg = isEdit ? "Bạn có chắc chắn muốn cập nhật nhân viên này không?" : "Bạn có chắc chắn muốn thêm nhân viên này không?";
                if (!confirm(msg)) {
                    e.preventDefault(); // Hủy submit nếu người dùng chọn Cancel
                }
            }
        });
    }

    function showError(input, message) {
        // Tạo một thẻ <div> mới
        const error = document.createElement('div');
        error.className = 'error-msg';
        error.style.color = '#EF4444'; // Màu đỏ
        error.style.fontSize = '12px';
        error.style.marginTop = '4px';
        error.style.fontWeight = '500';
        error.innerText = message; // Đặt nội dung lỗi
        
        input.parentNode.appendChild(error);
        input.focus();
    }
});
                                </script>
                                <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
                                <script src="${pageContext.request.contextPath}/assets/js/qr-scanner.js"></script>
                            </body>

                            <%-- Toast thông báo dùng chung --%>
                            <jsp:include page="/WEB-INF/views/layout/toast.jsp" />

                            </html>