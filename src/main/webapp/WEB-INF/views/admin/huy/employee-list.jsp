<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ page import="project.duan1_sd21301.model.huy.Employee" %>
        <%@ page import="project.duan1_sd21301.model.huy.Role" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.Date" %>
                    <%@ page import="java.text.SimpleDateFormat" %>
<% 
    Employee loggedInUser = (Employee) session.getAttribute("loggedInUser");
    String currentUserRole = (loggedInUser != null && loggedInUser.getRole() != null && loggedInUser.getRole().getRoleName() != null) 
                              ? loggedInUser.getRole().getRoleName() : "Nhân viên";
    boolean isAdmin = "Admin".equalsIgnoreCase(currentUserRole) || "Quản lý".equalsIgnoreCase(currentUserRole); 
    List<Role> listRoles = (List<Role>) request.getAttribute("roles");
%>
                                <!DOCTYPE html>
                                <html lang="vi">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>
                                        <%= isAdmin ? "FamiCoats Admin - Quản lý nhân viên"
                                            : "FamiCoats - Danh bạ nội bộ" %>
                                    </title>
                                    <link rel="preconnect" href="https://fonts.googleapis.com">
                                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                    <link
                                        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                        rel="stylesheet">
                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/assets/css/admin.css">
                                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                                    <link rel="stylesheet"
                                        href="${pageContext.request.contextPath}/assets/css/employees/employee-list.css?v=2.6">
                                    <style>
                                        /* Pagination Styling */
                                        .pagination-container {
                                            display: flex;
                                            justify-content: center;
                                            align-items: center;
                                            gap: 8px;
                                            padding: 20px 0;
                                            margin-top: 10px;
                                        }
                                        .page-btn {
                                            min-width: 32px;
                                            height: 32px;
                                            padding: 0 10px;
                                            display: inline-flex;
                                            align-items: center;
                                            justify-content: center;
                                            border-radius: 6px;
                                            border: 1px solid #cbd5e1;
                                            background-color: #ffffff;
                                            color: #475569;
                                            font-size: 13px;
                                            font-weight: 600;
                                            cursor: pointer;
                                            transition: all 0.2s;
                                        }
                                        .page-btn:hover:not(:disabled) {
                                            background-color: #f1f5f9;
                                            color: #0f172a;
                                            border-color: #94a3b8;
                                        }
                                        .page-btn.active {
                                            background-color: #1e3a8a;
                                            color: #ffffff;
                                            border-color: #1e3a8a;
                                        }
                                        .page-btn:disabled {
                                            opacity: 0.5;
                                            cursor: not-allowed;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="app-container">
                                        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

                                        <main class="main-content">
                                            <header class="navbar">
                                                <div class="breadcrumb">
                                                    <span>FamiCoats</span> / <span class="active-crumb">
                                                        <%= isAdmin ? "Quản lý nhân viên" : "Danh bạ nội bộ" %>
                                                    </span>
                                                </div>
                                                <div class="navbar-right">
                                                    <button class="notif-btn">
                                                        <svg viewBox="0 0 24 24" width="20" height="20"
                                                            stroke="currentColor" stroke-width="2" fill="none">
                                                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9">
                                                            </path>
                                                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                                        </svg>
                                                    </button>
                                                    <div class="date-pill" id="live-date">Thứ Năm, 09/07/2026</div>
                                                    <div class="profile-pill">
                                                        <span class="profile-avatar-mini">A</span>
                                                        <span>Admin</span>
                                                    </div>
                                                </div>
                                            </header>

                                            <div class="content-wrapper">

                                                                        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                                                            <div>
                                                                                <h1>Quản lý nhân viên</h1>
                                                                                <div class="subtitle">Tổng ${totalAll != null ? totalAll : 0} nhân sự</div>
                                                                            </div>
                                                                            <div style="display: flex; gap: 8px;">
                                                                            </div>
                                                                        </div>

                                                                        <!-- Bộ lọc & tìm kiếm -->
                                                                        <div class="custom-card">
                                                                            <div class="card-header-bar">
                                                                                <span class="card-header-title">&#8226;
                                                                                    Bộ lọc tìm kiếm</span>
                                                                                <button class="toggle-filter-btn"
                                                                                    id="toggleFilterBtn"
                                                                                    onclick="toggleFilterCard()">Nhấn để
                                                                                    thu gọn</button>
                                                                            </div>
                                                                            <div class="card-body-content" id="filterCardBody">
                                                                                <div class="filter-grid">

                                                                                    <!-- Tìm kiếm -->
                                                                                    <div class="filter-field">
                                                                                        <label for="empSearch">Tìm kiếm</label>
                                                                                        <div style="position: relative;">
                                                                                            <input type="text"
                                                                                                id="empSearch"
                                                                                                class="filter-control"
                                                                                                style="padding-left: 36px; width: 100%; box-sizing: border-box;"
                                                                                                placeholder="Tìm tên, mã, số điện thoại..."
                                                                                                onkeyup="filterTable()">
                                                                                            <svg viewBox="0 0 24 24"
                                                                                                width="16" height="16"
                                                                                                stroke="#94a3b8"
                                                                                                stroke-width="2"
                                                                                                fill="none"
                                                                                                stroke-linecap="round"
                                                                                                stroke-linejoin="round"
                                                                                                style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%);">
                                                                                                <circle cx="11" cy="11"
                                                                                                    r="8"></circle>
                                                                                                <line x1="21" y1="21"
                                                                                                    x2="16.65"
                                                                                                    y2="16.65"></line>
                                                                                            </svg>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Vai trò -->
                                                                                    <div class="filter-field">
                                                                                        <label for="roleFilter">Vai
                                                                                            trò</label>
                                                                                        <select id="roleFilter"
                                                                                            class="filter-control"
                                                                                            onchange="filterTable()">
                                                                                            <option value="all">Tất cả
                                                                                                vai trò</option>
                                                                                            <% if (listRoles !=null) {
                                                                                                for (Role
                                                                                                r : listRoles) { 
                                                                                                if("Admin".equals(r.getRoleName())) continue;
                                                                                                %>
                                                                                                <option
                                                                                                    value="<%= r.getRoleName() %>">
                                                                                                    <%= r.getRoleName()
                                                                                                        %>
                                                                                                </option>
                                                                                                <% } } %>
                                                                                        </select>
                                                                                    </div>

                                                                                    <!-- Giới tính -->
                                                                                    <div class="filter-field">
                                                                                        <label>Giới tính</label>
                                                                                        <div
                                                                                            style="display: flex; gap: 12px; align-items: center; margin-top: 8px;">
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer;">
                                                                                                <input type="radio"
                                                                                                    name="genderFilter"
                                                                                                    value="all"
                                                                                                    onchange="filterTable()"
                                                                                                    checked> Tất cả
                                                                                            </label>
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer;">
                                                                                                <input type="radio"
                                                                                                    name="genderFilter"
                                                                                                    value="true"
                                                                                                    onchange="filterTable()">
                                                                                                Nam
                                                                                            </label>
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer;">
                                                                                                <input type="radio"
                                                                                                    name="genderFilter"
                                                                                                    value="false"
                                                                                                    onchange="filterTable()">
                                                                                                Nữ
                                                                                            </label>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Trạng thái -->
                                                                                    <div class="filter-field">
                                                                                        <label>Trạng thái</label>
                                                                                        <div
                                                                                            style="display: flex; gap: 12px; align-items: center; margin-top: 8px;">
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer; white-space: nowrap;">
                                                                                                <input type="radio"
                                                                                                    name="statusFilter"
                                                                                                    value="all"
                                                                                                    onchange="filterTable()"
                                                                                                    checked> Tất cả
                                                                                            </label>
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer; white-space: nowrap;">
                                                                                                <input type="radio"
                                                                                                    name="statusFilter"
                                                                                                    value="1"
                                                                                                    onchange="filterTable()">
                                                                                                Đang hoạt động
                                                                                            </label>
                                                                                            <label
                                                                                                style="display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: normal; color: #334155; cursor: pointer; white-space: nowrap;">
                                                                                                <input type="radio"
                                                                                                    name="statusFilter"
                                                                                                    value="0"
                                                                                                    onchange="filterTable()">
                                                                                                Đã nghỉ việc
                                                                                            </label>
                                                                                        </div>
                                                                                    </div>

                                                                                    <!-- Đặt lại -->
                                                                                    <div class="filter-field" style="grid-column: -1; justify-content: flex-end; align-items: flex-end; visibility: hidden;" id="resetFilterContainer">
                                                                                        <button type="button" class="btn-reset-filter"
                                                                                        onclick="document.getElementById('empSearch').value=''; document.getElementById('roleFilter').value='all'; document.querySelector('input[name=\'genderFilter\'][value=\'all\']').checked = true; document.querySelector('input[name=\'statusFilter\'][value=\'all\']').checked = true; filterTable();"
                                                                                        style="display: flex; align-items: center; gap: 6px; padding: 10px 16px; font-weight: 600; border-radius: 6px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; cursor: pointer; transition: all 0.2s; font-size: 13px; height: 38px; box-sizing: border-box; width: fit-content;">
                                                                                        <svg viewBox="0 0 24 24"
                                                                                            width="14" height="14"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2.5"
                                                                                            fill="none">
                                                                                            <polyline
                                                                                                points="1 4 1 10 7 10">
                                                                                            </polyline>
                                                                                            <path
                                                                                                d="M3.51 15a9 9 0 1 0 .49-3.5">
                                                                                            </path>
                                                                                        </svg>
                                                                                        Đặt lại
                                                                                        </button>
                                                                                    </div>

                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <div class="toolbar" style="display: flex; justify-content: flex-end; gap: 8px; margin-bottom: 16px;">
                                                                            <% if (isAdmin) { %>
                                                                                <button onclick="exportToCSV()" class="btn-export" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                                                                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="8" y1="13" x2="16" y2="13"></line><line x1="8" y1="17" x2="16" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                                                                    <span>Xuất Excel</span>
                                                                                </button>
                                                                                <a href="${pageContext.request.contextPath}/admin/employees?action=add" class="btn-export" style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; height: 38px;">
                                                                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                                                                        <line x1="12" y1="5" x2="12" y2="19"></line>
                                                                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                                                                    </svg>
                                                                                    <span>Thêm nhân viên</span>
                                                                                </a>
                                                                            <% } %>
                                                                        </div>

                                                                        <div class="custom-card">
                                                                            <div class="card-header-bar">
                                                                                <span class="card-header-title">&#8226;
                                                                                    Bảng dữ liệu nhân viên</span>
                                                                            </div>
                                                                            <table class="invoice-table"
                                                                                style="table-layout: fixed; width: 100%;">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th
                                                                                            style="text-align: center; width: 50px;">
                                                                                            STT</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 120px;">
                                                                                            Mã nhân viên</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 200px;">
                                                                                            Họ và tên</th>
                                                                                        <th
                                                                                            style="text-align: center; width: 90px;">
                                                                                            Giới tính</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 120px;">
                                                                                            Vai trò</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 110px;">
                                                                                            SĐT</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 220px;">
                                                                                            Email</th>
                                                                                        <th
                                                                                            style="text-align: left; width: 240px;">
                                                                                            Địa chỉ</th>
                                                                                        <th
                                                                                            style="text-align: center; width: 130px;">
                                                                                            Trạng thái</th>
                                                                                        <% if (isAdmin) { %>
                                                                                            <th
                                                                                                style="text-align: center; width: 120px;">
                                                                                                Hành động</th>
                                                                                            <% } %>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody id="empTbody">
                                                                                    <% List<Employee> listEmp = (List
                                                                                        <Employee>)
                                                                                            request.getAttribute("employees");
                                                                                            SimpleDateFormat df = new
                                                                                            SimpleDateFormat("yyyy-MM-dd");

                                                                                            if (listEmp != null &&
                                                                                            !listEmp.isEmpty()) {
                                                                                            int stt = 1;
                                                                                            for (Employee emp : listEmp)
                                                                                            {
                                                                                            String fullAddr = emp.getFullAddressString();
                                                                                            %>
                                                                                            <tr data-role="<%= emp.getRoleName() %>"
                                                                                                data-gender="<%= emp.getGender() != null ? emp.getGender() : "" %>"
                                                                                                data-status="<%= emp.getStatus() %>"
                                                                                                data-address="<%= fullAddr.toLowerCase() %>"
                                                                                                data-id="<%= emp.getId() %>"
                                                                                                onmouseover="this.style.backgroundColor='#F8FAFC'"
                                                                                                onmouseout="this.style.backgroundColor='transparent'">
                                                                                                <td
                                                                                                    style="text-align: center; color: #64748b; font-weight: 500;">
                                                                                                    <%= stt++ %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= emp.getCode()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        style="font-weight: 600; color: #0f172a;">
                                                                                                        <%= emp.getFullName()
                                                                                                            !=null ?
                                                                                                            emp.getFullName()
                                                                                                            : "—" %>
                                                                                                    </span></td>
                                                                                                <td style="padding: 14px 16px; text-align: center;">
                                                                                                    <%= (emp.getGender() != null && emp.getGender()) ? "Nam" : "Nữ" %>
                                                                                                </td>
                                                                                                <td
                                                                                                    style="padding: 14px 16px;">
                                                                                                    <span
                                                                                                        style="font-size:14px; font-weight:500; color:#334155;">
                                                                                                        <% 
                                                                                                            String rName = emp.getRoleName();
                                                                                                            if ("Admin".equals(rName) || rName == null || rName.isEmpty()) rName = "Quản lý";
                                                                                                        %>
                                                                                                        <%= rName %>
                                                                                                    </span>
                                                                                                </td>
                                                                                                <td
                                                                                                    style="padding: 14px 16px;">
                                                                                                    <%= emp.getPhoneNumber() != null ? emp.getPhoneNumber() : ""
                                                                                                        %>
                                                                                                </td>
                                                                                                <td
                                                                                                    style="padding: 14px 16px;">
                                                                                                    <%= emp.getEmail()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td style="padding: 14px 16px; max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"
                                                                                                    title="<%= fullAddr %>">
                                                                                                    <%= !fullAddr.isEmpty()
                                                                                                        ?
                                                                                                        fullAddr
                                                                                                        : "-" %>
                                                                                                </td>
                                                                                                <td
                                                                                                    style="padding: 14px 16px; text-align: center;">
                                                                                                    <span
                                                                                                        class="badge-status <%= emp.getStatus()==1 ? "active" : "inactive" %>">
                                                                                                        <%= emp.getStatus()==1 ? "Đang hoạt động" : "Đã nghỉ việc" %>
                                                                                                    </span>
                                                                                                </td>
                                                                                                <% if (isAdmin) { %>
                                                                                                    <td style="padding: 14px 16px; text-align: center;">
                                                                                                        <div style="display: flex; gap: 8px; justify-content: center; align-items: center;">
                                                                                                            <a href="${pageContext.request.contextPath}/admin/employees?action=detail&id=<%= emp.getId() %>"
                                                                                                                class="action-icon-btn details-btn" title="Chi tiết">
                                                                                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                                                                                            </a>
                                                                                                            <a href="${pageContext.request.contextPath}/admin/employees?action=edit&id=<%= emp.getId() %>"
                                                                                                                class="action-icon-btn edit-btn" title="Chỉnh sửa">
                                                                                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                                                                            </a>
                                                                                                            <label class="switch" title="Chuyển trạng thái" style="margin-left: 4px;">
                                                                                                                <input type="checkbox" <%=emp.getStatus()==1 ? "checked" : ""%> onchange="window.location.href='${pageContext.request.contextPath}/admin/employees?action=toggleStatus&id=<%= emp.getId() %>'">
                                                                                                                <span class="slider"></span>
                                                                                                            </label>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <% } %>
                                                                                            </tr>
                                                                                            <% } } else { %>
                                                                                                <tr>
                                                                                                    <td colspan="9"
                                                                                                        style="padding: 40px; text-align: center; color: #94A3B8; font-weight: 500;">
                                                                                                        Không tìm thấy
                                                                                                        nhân viên nào
                                                                                                        trong hệ thống.
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                </tbody>
                                                                            </table>
                                                                            <!-- Pagination Container -->
                                                                            <div id="paginationContainer" class="pagination-container"></div>
                                                                        </div>
                                            </div>
                                        </main>
                                    </div>


                                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                                    <script>
                                        function confirmAction(url, title, text) {
                                            Swal.fire({
                                                title: title,
                                                text: text,
                                                icon: 'warning',
                                                showCancelButton: true,
                                                confirmButtonColor: '#3B82F6',
                                                cancelButtonColor: '#94A3B8',
                                                confirmButtonText: 'Đồng ý',
                                                cancelButtonText: 'Hủy'
                                            }).then((result) => {
                                                if (result.isConfirmed) {
                                                    window.location.href = url;
                                                }
                                            });
                                        }

                                        // ====== Tìm kiếm & Lọc ======
                                        const searchInput = document.getElementById('empSearch');
                                        const roleFilter = document.getElementById('roleFilter');
                                        const tableRows = document.querySelectorAll('#empTbody tr');

                                        function toggleFilterCard() {
                                            const body = document.getElementById('filterCardBody');
                                            const btn = document.getElementById('toggleFilterBtn');
                                            if (body.classList.contains('collapsed')) {
                                                body.classList.remove('collapsed');
                                                btn.textContent = 'Nhấn để thu gọn';
                                            } else {
                                                body.classList.add('collapsed');
                                                btn.textContent = 'Nhấn để mở rộng';
                                            }
                                        }

                                        function filterTable() {
                                            const searchVal = searchInput ? searchInput.value.toLowerCase().trim() : '';
                                            const roleVal = roleFilter ? (roleFilter.value || '').trim() : 'all';
                                            const genderRadio = document.querySelector('input[name="genderFilter"]:checked');
                                            const genderVal = genderRadio ? genderRadio.value : 'all';
                                            const statusRadio = document.querySelector('input[name="statusFilter"]:checked');
                                            const statusVal = statusRadio ? statusRadio.value : 'all';

                                            let visibleRows = [];
                                            tableRows.forEach(row => {
                                                if (row.children.length === 1) return;

                                                const rowText = row.innerText.toLowerCase();
                                                const rowRole = (row.getAttribute('data-role') || '').trim();
                                                const rowStatus = row.getAttribute('data-status') || '';
                                                const rowGender = (row.getAttribute('data-gender') || '').trim();
                                                const rowAddress = row.getAttribute('data-address') || '';
                                                const rowId = row.getAttribute('data-id') || '';
                                                const fullText = rowText + " " + rowAddress + " " + rowId;

                                                const matchSearch = !searchVal || fullText.includes(searchVal);
                                                const matchRole = roleVal === 'all' || rowRole.toLowerCase() === roleVal.toLowerCase();
                                                const matchGender = genderVal === 'all' || rowGender.toLowerCase() === genderVal.toLowerCase();
                                                const matchStatus = statusVal === 'all' || rowStatus === statusVal;

                                                if (matchSearch && matchRole && matchGender && matchStatus) {
                                                    visibleRows.push(row);
                                                } else {
                                                    row.style.display = 'none';
                                                }
                                            });

                                            // Pagination Logic
                                            const totalItems = visibleRows.length;
                                            const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;
                                            
                                            if (currentPage > totalPages) currentPage = totalPages;
                                            if (currentPage < 1) currentPage = 1;

                                            const startIndex = (currentPage - 1) * itemsPerPage;
                                            const endIndex = startIndex + itemsPerPage;

                                            visibleRows.forEach((row, idx) => {
                                                if (idx >= startIndex && idx < endIndex) {
                                                    row.style.display = '';
                                                    const sttCell = row.querySelector('td:first-child');
                                                    if (sttCell) {
                                                        sttCell.textContent = (idx + 1) + '';
                                                    }
                                                } else {
                                                    row.style.display = 'none';
                                                }
                                            });

                                            const isFiltering = searchVal !== '' || roleVal !== 'all' || genderVal !== 'all' || statusVal !== 'all';
                                            const resetContainer = document.getElementById('resetFilterContainer');
                                            if (resetContainer) {
                                                resetContainer.style.visibility = isFiltering ? 'visible' : 'hidden';
                                            }

                                            renderPagination(totalItems, totalPages);
                                        }

                                        function renderPagination(totalItems, totalPages) {
                                            const container = document.getElementById('paginationContainer');
                                            if (!container) return;
                                            
                                            container.innerHTML = '';
                                            
                                            if (totalItems === 0 || totalPages <= 1) {
                                                return;
                                            }

                                            const prevBtn = document.createElement('button');
                                            prevBtn.className = 'page-btn';
                                            prevBtn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="15 18 9 12 15 6"></polyline></svg>';
                                            prevBtn.disabled = currentPage === 1;
                                            prevBtn.onclick = () => { currentPage--; filterTable(); };
                                            container.appendChild(prevBtn);

                                            for (let i = 1; i <= totalPages; i++) {
                                                if (totalPages > 7) {
                                                    if (i !== 1 && i !== totalPages && Math.abs(i - currentPage) > 1) {
                                                        if (i === 2 || i === totalPages - 1) {
                                                            const dots = document.createElement('span');
                                                            dots.innerHTML = '...';
                                                            dots.style.padding = '0 5px';
                                                            dots.style.color = '#94a3b8';
                                                            container.appendChild(dots);
                                                        }
                                                        continue;
                                                    }
                                                }

                                                const pageBtn = document.createElement('button');
                                                pageBtn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                                                pageBtn.textContent = i;
                                                pageBtn.onclick = () => { currentPage = i; filterTable(); };
                                                container.appendChild(pageBtn);
                                            }

                                            const nextBtn = document.createElement('button');
                                            nextBtn.className = 'page-btn';
                                            nextBtn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="9 18 15 12 9 6"></polyline></svg>';
                                            nextBtn.disabled = currentPage === totalPages;
                                            nextBtn.onclick = () => { currentPage++; filterTable(); };
                                            container.appendChild(nextBtn);
                                        }

                                        let currentPage = 1;
                                        const itemsPerPage = 10;

                                        if (searchInput) searchInput.addEventListener('keyup', () => { currentPage = 1; filterTable(); });
                                        document.addEventListener("DOMContentLoaded", function() {
                                            filterTable();
                                        });

                                        function exportToCSV() {
                                            let csv = [];
                                            let rows = document.querySelectorAll("table tr");
                                            for (let i = 0; i < rows.length; i++) {
                                                if (rows[i].style.display === 'none') continue;
                                                let row = [], cols = rows[i].querySelectorAll("td, th");
                                                for (let j = 0; j < cols.length; j++) {
                                                    const isActionCol = (i === 0 && cols[j].innerText.indexOf('Hành động') > -1) ||
                                                        (i > 0 && rows[0].querySelectorAll("th")[j] && rows[0].querySelectorAll("th")[j].innerText.indexOf('Hành động') > -1);
                                                    if (isActionCol) continue;
                                                    let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, " ").trim();
                                                    data = data.replace(/"/g, '""');
                                                    row.push('"' + data + '"');
                                                }
                                                csv.push(row.join(","));
                                            }
                                            let csvFile = new Blob(["\uFEFF" + csv.join("\n")], { type: "text/csv;charset=utf-8;" });
                                            let downloadLink = document.createElement("a");
                                            downloadLink.download = "danh_sach_nhan_vien.csv";
                                            downloadLink.href = window.URL.createObjectURL(csvFile);
                                            downloadLink.style.display = "none";
                                            document.body.appendChild(downloadLink);
                                            downloadLink.click();
                                            document.body.removeChild(downloadLink);
                                        }
                                    </script>
                                    <script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
                                    <script src="${pageContext.request.contextPath}/assets/js/qr-scanner.js"></script>
                                </body>
                                
                                <%-- Toast thông báo dùng chung --%>
                                <jsp:include page="/WEB-INF/views/layout/toast.jsp" />

                                </html>