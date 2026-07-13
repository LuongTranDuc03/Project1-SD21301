<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.Employee" %>
<%@ page import="project.duan1_sd21301.model.Role" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String currentUserRole = (String) session.getAttribute("currentUserRole");
    if (currentUserRole == null || (!"Quản lý".equals(currentUserRole) && !"Nhân viên".equals(currentUserRole) && !"Admin".equals(currentUserRole))) {
        currentUserRole = "Quản lý";
        session.setAttribute("currentUserRole", currentUserRole);
    }
    boolean isAdmin = "Admin".equals(currentUserRole) || "Quản lý".equals(currentUserRole);
    List<Role> listRoles = (List<Role>) request.getAttribute("roles");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    if (isEdit == null) isEdit = false;
    Employee emp = (Employee) request.getAttribute("employee");
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Cập nhật nhân viên" : "Thêm nhân viên mới" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    
    <style>
        .form-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            padding: 16px 24px;
            margin: 0 auto;
        }
        .form-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px 24px; }
        .form-group-full { grid-column: span 3; }
        .form-group { display: flex; flex-direction: column; gap: 4px; }
        .form-group label { font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 0; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 12px; border-radius: 6px; border: 1px solid #CBD5E1; font-family: inherit; font-size: 13px; outline: none;
        }
        .form-group input:focus, .form-group select:focus { border-color: #3B82F6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15); }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px; padding-top: 12px; border-top: 1px solid #E2E8F0; }
        .btn-cancel { background-color: #ffffff; border: 1px solid #CBD5E1; color: #475569; padding: 6px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-save { background: #1E293B; border: none; color: #ffffff; padding: 6px 16px; border-radius: 6px; font-weight: 600; cursor: pointer; }
    </style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <a href="${pageContext.request.contextPath}/admin/employees" style="text-decoration: none; color: inherit;">Quản lý nhân viên</a> / <span class="active-crumb"><%= isEdit ? "Cập nhật" : "Thêm mới" %></span>
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
            <div class="form-container">
                <h2 style="font-size: 20px; font-weight: 700; color: #0F172A; margin-top: 0; margin-bottom: 24px;"><%= isEdit ? "Cập nhật thông tin nhân viên" : "Thêm nhân viên mới" %></h2>
                
                <form action="${pageContext.request.contextPath}/admin/employees" method="POST">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                    
                    <div class="form-grid">
                        <div class="form-group form-group-full">
                            <label>Ảnh đại diện</label>
                            <div style="display: flex; align-items: center; gap: 16px; margin-top: 4px;">
                                <div id="avatarPreview" style="width: 64px; height: 64px; border-radius: 50%; background-color: #E2E8F0; display: flex; align-items: center; justify-content: center; overflow: hidden; border: 1px solid #CBD5E1; flex-shrink: 0;">
                                    <% if(isEdit && emp.getAvatar() != null && !emp.getAvatar().trim().isEmpty()) { %>
                                    <img src="<%= emp.getAvatar() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                    <% } else { %>
                                    <span style="font-size: 24px; color: #94A3B8;">&#128100;</span>
                                    <% } %>
                                </div>
                                <div style="flex: 1;">
                                    <button type="button" onclick="document.getElementById('avatarFile').click()" style="background-color: #F1F5F9; border: 1px solid #CBD5E1; color: #475569; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 13px; transition: all 0.2s;">
                                        Chọn ảnh từ máy
                                    </button>
                                    <input type="file" id="avatarFile" accept="image/*" style="display: none;">
                                    <input type="hidden" name="avatar" id="avatar" value="<%= isEdit && emp.getAvatar() != null ? emp.getAvatar() : "" %>">
                                    <div id="fileName" style="font-size: 12px; color: #64748B; margin-top: 8px;"><%= isEdit && emp.getAvatar() != null ? "Đã có ảnh đại diện" : "Chưa chọn ảnh" %></div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mã Nhân Viên <span style="color: red;">*</span></label>
                            <input type="text" name="id" required placeholder="Ví dụ: NV007" value="<%= isEdit ? emp.getId() : "" %>" <%= isEdit ? "readonly style='background: #F8FAFC;'" : "" %>>
                        </div>

                        <div class="form-group">
                            <label>Họ và tên <span style="color: red;">*</span></label>
                            <input type="text" name="fullName" required placeholder="Nhập họ và tên" value="<%= isEdit && emp.getFullName() != null ? emp.getFullName() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Số điện thoại <span style="color: red;">*</span></label>
                            <input type="text" name="phoneNumber" required placeholder="Nhập số điện thoại" value="<%= isEdit && emp.getPhoneNumber() != null ? emp.getPhoneNumber() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Số CCCD</label>
                            <input type="text" name="cccd" placeholder="Căn cước công dân" value="<%= isEdit && emp.getCccd() != null ? emp.getCccd() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Địa chỉ</label>
                            <input type="text" name="address" placeholder="Nhập địa chỉ (VD: Hà Nội)" value="<%= isEdit && emp.getAddress() != null ? emp.getAddress() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Mức lương (VNĐ) <span style="color: red;">*</span></label>
                            <input type="text" name="salary" id="salary" required placeholder="Ví dụ: 10,000,000" value="<%= isEdit ? String.format("%.0f", emp.getSalary()) : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gender">
                                <option value="1" <%= isEdit && Boolean.TRUE.equals(emp.getGender()) ? "selected" : "" %>>Nam</option>
                                <option value="0" <%= isEdit && Boolean.FALSE.equals(emp.getGender()) ? "selected" : "" %>>Nữ</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Vai trò chức vụ <span style="color: red;">*</span></label>
                            <select name="roleId" required>
                                <% if (listRoles != null) {
                                    for(Role r : listRoles) { %>
                                <option value="<%= r.getId() %>" <%= isEdit && emp.getRoleId() == r.getId() ? "selected" : "" %>><%= r.getRoleName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <input type="date" name="birthday" value="<%= isEdit && emp.getBirthday() != null ? df.format(emp.getBirthday()) : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Ngày vào làm</label>
                            <input type="date" name="hireDate" value="<%= isEdit && emp.getHireDate() != null ? df.format(emp.getHireDate()) : "" %>">
                        </div>

                        <div class="form-group form-group-full" style="margin-top: 12px; padding-top: 12px; border-top: 1px dashed #E2E8F0;">
                            <label style="font-size: 14px; color: #0F172A;">Tài khoản đăng nhập</label>
                        </div>
                        
                        <div class="form-group">
                            <label>Địa chỉ Email <span style="color: red;">*</span></label>
                            <input type="email" name="email" required placeholder="name@famicoats.vn" value="<%= isEdit && emp.getEmail() != null ? emp.getEmail() : "" %>">
                        </div>

                        <div class="form-group">
                            <label>Mật khẩu đăng nhập <small style="color:#64748B;">(Để trống mặc định là 123456)</small></label>
                            <input type="password" name="password" placeholder="Nhập mật khẩu bảo mật">
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/employees" class="btn-cancel">Quay lại</a>
                        <button type="submit" class="btn-save">Lưu nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // Định dạng số tiền
    const salaryInput = document.getElementById('salary');
    if (salaryInput.value) {
        salaryInput.value = Number(salaryInput.value).toLocaleString('en-US');
    }
    
    salaryInput.addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, ''); 
        if (value) {
            this.value = Number(value).toLocaleString('en-US');
        } else {
            this.value = '';
        }
    });

    // Xử lý ảnh base64
    const avatarFileInput = document.getElementById('avatarFile');
    avatarFileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            document.getElementById('fileName').innerText = file.name;
            const reader = new FileReader();
            reader.onload = function(evt) {
                const base64Str = evt.target.result;
                document.getElementById('avatar').value = base64Str;
                document.getElementById('avatarPreview').innerHTML = `<img src="${base64Str}" style="width: 100%; height: 100%; object-fit: cover;">`;
            };
            reader.readAsDataURL(file);
        }
    });
</script>
</body>
</html>
