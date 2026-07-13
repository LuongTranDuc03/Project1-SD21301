<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.Employee" %>
<%@ page import="project.duan1_sd21301.model.Role" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Lấy role từ session, nếu null hoặc bị lỗi font từ trước thì reset về "Quản lý"
    String currentUserRole = (String) session.getAttribute("currentUserRole");
    if (currentUserRole == null || (!"Quản lý".equals(currentUserRole) && !"Nhân viên".equals(currentUserRole) && !"Admin".equals(currentUserRole))) {
        currentUserRole = "Quản lý";
        session.setAttribute("currentUserRole", currentUserRole);
    }
    boolean isAdmin = "Admin".equals(currentUserRole) || "Quản lý".equals(currentUserRole);
    List<Role> listRoles = (List<Role>) request.getAttribute("roles");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isAdmin ? "FamiCoats Admin - Quản lý nhân viên" : "FamiCoats - Danh bạ nội bộ" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

    <style>
        .badge-mode-warning {
            background-color: #FEF3C7; color: #D97706; padding: 10px 16px; border-radius: 8px;
            margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 500; border: 1px solid #FCD34D;
        }
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 999; transition: all 0.3s ease;
        }
        .modal-overlay.active { display: flex; }
        .modal-container {
            background-color: #ffffff; border-radius: 16px; width: 100%; max-width: 700px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); overflow: hidden; animation: modalFadeIn 0.3s ease;
        }
        @keyframes modalFadeIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 20px 24px; border-bottom: 1px solid #E2E8F0; display: flex; justify-content: space-between; align-items: center; background: linear-gradient(135deg, #f43f5e, #FB7185); color: #ffffff; }
        .modal-header h2 { font-size: 18px; font-weight: 700; margin: 0; }
        .modal-close-btn { background: transparent; border: none; color: #ffffff; font-size: 24px; cursor: pointer; line-height: 1; padding: 4px; }
        .modal-body { padding: 24px; max-height: 75vh; overflow-y: auto; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group-full { grid-column: span 2; }
        .modal-form-group { display: flex; flex-direction: column; gap: 6px; }
        .modal-form-group label { font-size: 13px; font-weight: 600; color: #334155; }
        .modal-form-group input, .modal-form-group select, .modal-form-group textarea {
            width: 100%; box-sizing: border-box;
            padding: 10px 14px; border-radius: 8px; border: 1px solid #CBD5E1; font-family: inherit; font-size: 13px; outline: none;
        }
        .modal-form-group input:focus, .modal-form-group select:focus { border-color: #FB7185; box-shadow: 0 0 0 3px rgba(251, 113, 133, 0.15); }
        .modal-footer { padding: 16px 24px; border-top: 1px solid #E2E8F0; display: flex; justify-content: flex-end; gap: 12px; background-color: #F8FAFC; }
        .modal-btn-cancel { background-color: #ffffff; border: 1px solid #CBD5E1; color: #475569; padding: 10px 20px; border-radius: 8px; font-weight: 500; cursor: pointer; }
        .modal-btn-save { background: #1E293B; border: none; color: #ffffff; padding: 10px 20px; border-radius: 8px; font-weight: 500; cursor: pointer; }
        .btn-clear-filter { background: #F1F5F9; color: #475569; border: 1px solid #CBD5E1; padding: 0 16px; border-radius: 8px; font-size: 13px; font-weight: 500; height: 40px; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
        .emp-avatar-cell { width: 36px; height: 36px; border-radius: 50%; background-color: #E2E8F0; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #475569; font-size: 14px; overflow: hidden; }
        .emp-avatar-cell img { width: 100%; height: 100%; object-fit: cover; }
        .status-pill { padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; }
        .status-pill.active { background-color: #D1FAE5; color: #065F46; }
        .status-pill.inactive { background-color: #FEE2E2; color: #991B1B; }

        .summary-cards { display: grid; grid-template-columns: 1fr; gap: 16px; margin-bottom: 20px; }
        .sum-card { background: #fff; padding: 16px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); display: flex; flex-direction: column; gap: 4px; }
        .sum-card .title { font-size: 13px; color: #64748B; font-weight: 500; }
        .sum-card .value { font-size: 24px; font-weight: 700; color: #1E293B; }

        #toast-container { position: fixed; top: 20px; right: 20px; z-index: 9999; display: flex; flex-direction: column; gap: 10px; }
        .toast { min-width: 280px; background: #fff; padding: 16px 20px; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 12px; transform: translateX(120%); transition: transform 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55); border-left: 4px solid #3B82F6; }
        .toast.show { transform: translateX(0); }
        .toast.success { border-left-color: #10B981; }
        .toast.error { border-left-color: #EF4444; }
        .toast-icon { font-size: 20px; }
        .toast-msg { font-size: 14px; font-weight: 600; color: #1E293B; }

        .pagination { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-top: 1px solid #E2E8F0; background: #fff; }
        .page-info { font-size: 13px; color: #64748B; font-weight: 500; }
        .page-buttons { display: flex; gap: 6px; }
        .page-btn { padding: 6px 12px; border: 1px solid #E2E8F0; background: #fff; border-radius: 6px; color: #475569; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .page-btn:hover { background: #F1F5F9; color: #0F172A; }
        .page-btn.active { background: #3B82F6; color: #fff; border-color: #3B82F6; }
        .page-btn:disabled { opacity: 0.5; cursor: not-allowed; background: #F1F5F9; color: #94A3B8; }
    </style>
</head>
<body>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <span class="active-crumb"><%= isAdmin ? "Quản lý nhân viên" : "Danh bạ nội bộ" %></span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                </button>
                <div class="date-pill" id="live-date">Thứ Năm, 09/07/2026</div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper" style="padding: 24px;">

            <div id="toast-container"></div>
            <% if (session.getAttribute("successMsg") != null) { %>
                <script>
                    window.addEventListener('DOMContentLoaded', () => {
                        showToast('success', '\u2713', '<%= session.getAttribute("successMsg") %>');
                    });
                </script>
                <% session.removeAttribute("successMsg"); %>
            <% } %>
            <% if (session.getAttribute("errorMsg") != null) { %>
                <script>
                    window.addEventListener('DOMContentLoaded', () => {
                        showToast('error', '!', '<%= session.getAttribute("errorMsg") %>');
                    });
                </script>
                <% session.removeAttribute("errorMsg"); %>
            <% } %>

            <div style="margin-bottom: 16px; font-size: 14px; font-weight: 500; color: #475569;">
                Tổng số nhân sự: <span style="color: #0F172A; font-weight: 700;">${totalAll != null ? totalAll : 0}</span>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <div style="display: flex; gap: 12px; align-items: center;">
                    <div style="position: relative; display: flex; align-items: center;">
                        <input type="text" id="empSearch" placeholder="Tìm tên, mã, số điện thoại..." style="height: 40px; padding: 0 16px 0 36px; border-radius: 8px; border: 1px solid #CBD5E1; outline: none; width: 280px; font-size: 13px; box-sizing: border-box;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="#64748B" stroke-width="2" fill="none" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%);"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    </div>
                    <select id="roleFilter" style="height: 40px; padding: 0 16px; border-radius: 8px; border: 1px solid #CBD5E1; outline: none; font-size: 13px; color: #334155; font-weight: 500; cursor: pointer; background: #fff; box-sizing: border-box;">
                        <option value="all">Tất cả vai trò</option>
                        <% if (listRoles != null) {
                            for (Role r : listRoles) { %>
                                <option value="<%= r.getRoleName() %>"><%= r.getRoleName() %></option>
                        <% } } %>
                    </select>
                    <select id="statusFilter" style="height: 40px; padding: 0 16px; border-radius: 8px; border: 1px solid #CBD5E1; outline: none; font-size: 13px; color: #334155; font-weight: 500; cursor: pointer; background: #fff; box-sizing: border-box;">
                        <option value="all">Tất cả trạng thái</option>
                        <option value="1">Đang hoạt động</option>
                        <option value="0">Đã nghỉ việc</option>
                    </select>
                    <button class="btn-clear-filter" onclick="document.getElementById('empSearch').value=''; document.getElementById('roleFilter').value='all'; document.getElementById('statusFilter').value='all'; filterTable();">Xóa lọc</button>
                </div>
                <div style="display: flex; gap: 12px; align-items: center;">
                    <% if (isAdmin) { %>
                    <button onclick="location.href='${pageContext.request.contextPath}/admin/employees?action=add'" class="modal-btn-save" style="height: 40px; display: inline-flex; align-items: center; justify-content: center; padding: 0 20px; box-sizing: border-box; border-radius: 8px; font-size: 13px; font-weight: 600;">+ Thêm nhân viên</button>
                    <button onclick="exportToCSV()" style="height: 40px; display: inline-flex; align-items: center; justify-content: center; padding: 0 20px; box-sizing: border-box; background-color: #10B981; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 13px;">Xuất Excel</button>
                    <button type="button" onclick="openSendMailModal()" style="height: 40px; display: inline-flex; align-items: center; justify-content: center; padding: 0 20px; box-sizing: border-box; background: linear-gradient(135deg,#6366f1,#8b5cf6); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 13px;">&#9993; Gửi mail</button>
                    <% } %>
                </div>
            </div>

            <div style="background: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); overflow: hidden;">
                <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 14px;">
                    <thead style="background-color: #F8FAFC; border-bottom: 1px solid #E2E8F0; color: #475569; font-weight: 600;">
                    <tr>
                        <th style="padding: 14px 16px;">STT</th>
                        <th style="padding: 14px 16px;">Mã NV</th>
                        <th style="padding: 14px 16px;">Họ tên</th>
                        <th style="padding: 14px 16px;">Email</th>
                        <th style="padding: 14px 16px;">Số điện thoại</th>
                        <% if (isAdmin) { %>
                        <th style="padding: 14px 16px;">Lương (VNĐ)</th>
                        <% } %>
                        <th style="padding: 14px 16px;">Vai trò</th>
                        <th style="padding: 14px 16px;">Trạng thái</th>
                        <% if (isAdmin) { %>
                        <th style="padding: 14px 16px; text-align: center;">Hành động</th>
                        <% } %>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Employee> listEmp = (List<Employee>) request.getAttribute("employees");
                        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

                        if (listEmp != null && !listEmp.isEmpty()) {
                            int stt = 1;
                            for (Employee emp : listEmp) {
                    %>
                    <tr style="border-bottom: 1px solid #F1F5F9;"
                        data-role="<%= emp.getRoleName() %>"
                        data-status="<%= emp.getStatus() %>"
                        data-address="<%= emp.getAddress() != null ? emp.getAddress().toLowerCase() : "" %>"
                        data-id="<%= emp.getId().toLowerCase() %>"
                        onmouseover="this.style.backgroundColor='#F8FAFC'" onmouseout="this.style.backgroundColor='transparent'">
                        <td style="padding: 14px 16px; color: #475569;"><%= stt++ %></td>
                        <td style="padding: 14px 16px; font-weight: normal; color: #334155;"><%= emp.getId() %></td>
                        <td style="padding: 14px 16px; font-weight: 500;"><%= emp.getFullName() %></td>
                        <td style="padding: 14px 16px;"><%= emp.getEmail() %></td>
                        <td style="padding: 14px 16px;"><%= emp.getPhoneNumber() %></td>
                        <% if (isAdmin) { %>
                        <td style="padding: 14px 16px; color: #334155;">
                            <%= String.format("%,.0f", emp.getSalary()) %>
                        </td>
                        <% } %>
                        <td style="padding: 14px 16px;">
                            <span style="background-color: #F1F5F9; color: #1E293B; padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 500;">
                                <%= emp.getRoleName() != null ? emp.getRoleName() : "Chưa phân" %>
                            </span>
                        </td>
                        <td style="padding: 14px 16px;">
                            <% if (emp.getStatus() == 1) { %>
                                <span class="status-pill active">Đang hoạt động</span>
                            <% } else { %>
                                <span class="status-pill inactive">Đã nghỉ việc</span>
                            <% } %>
                        </td>
                        <% if (isAdmin) { %>
                        <td style="padding: 14px 16px; text-align: center;">
                            <div style="display: flex; gap: 12px; justify-content: center; align-items: center;">
                                <a href="${pageContext.request.contextPath}/admin/employees?action=view&id=<%= emp.getId() %>"
                                   style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; background-color: #F1F5F9; color: #475569; transition: all 0.2s;"
                                   title="Chi tiết">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/employees?action=edit&id=<%= emp.getId() %>"
                                        style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; background-color: #F1F5F9; color: #475569; border: none; cursor: pointer; transition: all 0.2s;"
                                        title="Sửa">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="pointer-events: none;">
                                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                        <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                    </svg>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/employees?action=delete&id=<%= emp.getId() %>"
                                   onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản nhân viên này?')"
                                   style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; background-color: #F1F5F9; color: #475569; transition: all 0.2s;"
                                   title="Khóa tài khoản">
                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                </a>
                            </div>
                        </td>
                        <% } %>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" style="padding: 40px; text-align: center; color: #94A3B8; font-weight: 500;">Không tìm thấy nhân viên nào trong hệ thống.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <!-- Phân trang UI -->
                <div class="pagination">
                    <div class="page-info">
                        <%
                            long totalCount = (request.getAttribute("totalActive") != null) ? (Long) request.getAttribute("totalActive") : 0;
                            int pageSize = 10;
                            if (totalCount <= pageSize) {
                        %>
                            Hiển thị <strong>1</strong> đến <strong><%= totalCount %></strong> của <strong><%= totalCount %></strong> nhân viên
                        <% } else { %>
                            Hiển thị <strong>1</strong> đến <strong><%= pageSize %></strong> của <strong><%= totalCount %></strong> nhân viên
                        <% } %>
                    </div>
                    <div class="page-buttons">
                        <button class="page-btn" disabled>Trước</button>
                        <button class="page-btn active">1</button>
                        <% if (totalCount > pageSize) { %>
                            <button class="page-btn">2</button>
                            <button class="page-btn">Sau</button>
                        <% } else { %>
                            <button class="page-btn" disabled>Sau</button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- ====== MODAL GỬI MẬT KHẨU ====== -->
<div id="sendMailOverlay" style="display:none; position:fixed; top:0; left:0; right:0; bottom:0;
     background:rgba(15,23,42,0.6); backdrop-filter:blur(6px); z-index:1000;
     align-items:center; justify-content:center;">
    <div style="background:#fff; border-radius:20px; width:100%; max-width:520px;
                box-shadow:0 25px 50px rgba(0,0,0,0.2); overflow:hidden; animation:modalFadeIn 0.3s ease;">
        <!-- Header -->
        <div style="padding:22px 28px; background:#1E293B; color:#fff;
                    display:flex; justify-content:space-between; align-items:center;">
            <div style="display:flex; align-items:center; gap:12px;">
                <div style="width:40px; height:40px; background:rgba(255,255,255,0.1); border-radius:10px;
                            display:flex; align-items:center; justify-content:center; font-size:18px;">&#128273;</div>
                <div>
                    <div style="font-size:17px; font-weight:700;">Gửi thông tin đăng nhập</div>
                    <div style="font-size:12px; opacity:0.85; margin-top:2px;">Gửi mật khẩu tới email nhân viên</div>
                </div>
            </div>
            <button onclick="closeSendMailModal()"
                    style="background:rgba(255,255,255,0.15); border:none; color:#fff;
                           width:32px; height:32px; border-radius:8px; font-size:18px;
                           cursor:pointer; display:flex; align-items:center; justify-content:center;">&times;</button>
        </div>
        <!-- Body -->
        <form method="post" action="${pageContext.request.contextPath}/admin/employees?action=sendMail"
              style="padding:24px; display:flex; flex-direction:column; gap:20px;">
            <!-- Chọn nhân viên -->
            <div style="display:flex; flex-direction:column; gap:8px;">
                <label style="font-size:13px; font-weight:600; color:#374151;">Chọn nhân viên nhận mail</label>
                <select id="smEmployeeId" name="employeeId" required onchange="updateMailPreview(this)"
                        style="padding:11px 14px; border-radius:10px; border:1.5px solid #E5E7EB;
                               font-size:13px; font-family:inherit; color:#1F2937; outline:none;
                               background:#F9FAFB; cursor:pointer;">
                    <option value="" disabled selected>-- Chọn nhân viên --</option>
                    <%
                        List<Employee> smList = (List<Employee>) request.getAttribute("employees");
                        if (smList != null) {
                            for (Employee smEmp : smList) {
                    %>
                    <option value="<%= smEmp.getId() %>"
                            data-name="<%= smEmp.getFullName() %>"
                            data-email="<%= smEmp.getEmail() %>"
                            data-pwd="<%= smEmp.getPassword() %>">
                        <%= smEmp.getFullName() %> &#8212; <%= smEmp.getEmail() %>
                    </option>
                    <%      }
                        }
                    %>
                </select>
            </div>
            <!-- Preview nội dung mail -->
            <div id="mailPreview" style="display:none; border-radius:12px; border:1px solid #334155;
                                         background:#F8FAFC; padding:16px;">
                <div style="font-size:12px; font-weight:700; color:#475569; letter-spacing:0.05em; margin-bottom:12px;">
                    XEM TRƯỚC NỘI DUNG MAIL
                </div>
                <div style="background:#fff; border-radius:8px; padding:14px; font-size:13px; color:#374151; line-height:1.8; box-shadow:0 1px 3px rgba(0,0,0,0.06); border:1px solid #E2E8F0;">
                    <p style="margin:0 0 6px;">Xin chào <strong id="pvName" style="color:#0F172A;">---</strong>,</p>
                    <p style="margin:0 0 10px;">Dưới đây là thông tin đăng nhập hệ thống <strong>FamiCoats</strong>:</p>
                    <div style="background:#F3F4F6; border-radius:8px; padding:10px 14px; font-family:monospace; font-size:13px;">
                        Email: <strong id="pvEmail" style="color:#1F2937;">---</strong><br>
                        Mật khẩu: <strong id="pvPwd" style="color:#DC2626;">---</strong>
                    </div>
                    <p style="margin:10px 0 0; font-size:12px; color:#6B7280;">Vui lòng đăng nhập và đổi mật khẩu ngay sau khi nhận mail này.</p>
                </div>
            </div>
            <!-- Footer -->
            <div style="display:flex; justify-content:flex-end; gap:10px; padding-top:4px;">
                <button type="button" onclick="closeSendMailModal()"
                        style="padding:10px 22px; border-radius:10px; border:1.5px solid #E5E7EB;
                               background:#fff; color:#6B7280; font-size:13px; font-weight:600;
                               cursor:pointer; font-family:inherit;">Hủy</button>
                <button type="submit" id="smSubmitBtn" disabled
                        style="padding:10px 24px; border-radius:10px; border:none;
                               background:#0F172A; color:#fff; font-size:13px; font-weight:600;
                               cursor:not-allowed; font-family:inherit; opacity:0.5;">
                    Gửi mật khẩu
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // ====== Toast ======
    function showToast(type, icon, msg) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast ' + type;
        toast.innerHTML = '<span class="toast-icon">' + icon + '</span><span class="toast-msg">' + msg + '</span>';
        container.appendChild(toast);
        setTimeout(() => toast.classList.add('show'), 50);
        setTimeout(() => { toast.classList.remove('show'); setTimeout(() => toast.remove(), 400); }, 4000);
    }

    // ====== Tìm kiếm & Lọc ======
    const searchInput = document.getElementById('empSearch');
    const roleFilter = document.getElementById('roleFilter');
    const statusFilter = document.getElementById('statusFilter');
    const tableRows = document.querySelectorAll('tbody tr');

    function filterTable() {
        const searchVal = searchInput.value.toLowerCase().trim();
        const roleVal = roleFilter ? roleFilter.value : 'all';
        const statusVal = statusFilter ? statusFilter.value : 'all';

        tableRows.forEach(row => {
            if (row.children.length === 1) return;
            const rowText = row.innerText.toLowerCase();
            const rowRole = row.getAttribute('data-role') || '';
            const rowStatus = row.getAttribute('data-status') || '';
            const rowAddress = row.getAttribute('data-address') || '';
            const rowId = row.getAttribute('data-id') || '';
            const fullText = rowText + " " + rowAddress + " " + rowId;
            const matchSearch = searchVal === '' || fullText.indexOf(searchVal) > -1;
            const matchRole = (roleVal === 'all') || (rowRole === roleVal);
            const matchStatus = (statusVal === 'all') || (rowStatus === statusVal);
            row.style.display = (matchSearch && matchRole && matchStatus) ? "" : "none";
        });
    }

    searchInput.addEventListener('keyup', filterTable);
    if (roleFilter) roleFilter.addEventListener('change', filterTable);
    if (statusFilter) statusFilter.addEventListener('change', filterTable);

    // ====== Xuất Excel (CSV) ======
    function exportToCSV() {
        let csv = [];
        let rows = document.querySelectorAll("table tr");
        for (let i = 0; i < rows.length; i++) {
            if(rows[i].style.display === 'none') continue;
            let row = [], cols = rows[i].querySelectorAll("td, th");
            for (let j = 0; j < cols.length; j++) {
                const isActionCol = (i === 0 && cols[j].innerText.indexOf('Hành động') > -1) ||
                                    (i > 0 && rows[0].querySelectorAll("th")[j] && rows[0].querySelectorAll("th")[j].innerText.indexOf('Hành động') > -1);
                if(isActionCol) continue;
                let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, " ").trim();
                data = data.replace(/"/g, '""');
                row.push('"' + data + '"');
            }
            csv.push(row.join(","));
        }
        let csvFile = new Blob(["\uFEFF"+csv.join("\n")], {type: "text/csv;charset=utf-8;"});
        let downloadLink = document.createElement("a");
        downloadLink.download = "danh_sach_nhan_vien.csv";
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);
    }

    // ====== Modal Gửi Mail ======
    function openSendMailModal() {
        var overlay = document.getElementById('sendMailOverlay');
        overlay.style.display = 'flex';
        document.getElementById('smEmployeeId').value = '';
        document.getElementById('mailPreview').style.display = 'none';
        var btn = document.getElementById('smSubmitBtn');
        btn.disabled = true; btn.style.opacity = '0.5'; btn.style.cursor = 'not-allowed';
    }
    function closeSendMailModal() {
        document.getElementById('sendMailOverlay').style.display = 'none';
    }
    function updateMailPreview(select) {
        var opt = select.options[select.selectedIndex];
        if (!opt || !opt.value) return;
        document.getElementById('pvName').textContent  = opt.getAttribute('data-name');
        document.getElementById('pvEmail').textContent = opt.getAttribute('data-email');
        document.getElementById('pvPwd').textContent   = opt.getAttribute('data-pwd');
        document.getElementById('mailPreview').style.display = 'block';
        var btn = document.getElementById('smSubmitBtn');
        btn.disabled = false; btn.style.opacity = '1'; btn.style.cursor = 'pointer';
    }
    document.getElementById('sendMailOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeSendMailModal();
    });
</script>
</body>
</html>
