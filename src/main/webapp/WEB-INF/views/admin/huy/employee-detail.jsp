<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ page import="project.duan1_sd21301.model.huy.Employee" %>
        <%@ page import="java.text.SimpleDateFormat" %>
            <% Employee employee=(Employee) request.getAttribute("employee"); SimpleDateFormat df=new
                SimpleDateFormat("dd/MM/yyyy"); Employee loggedInUserDetail=(Employee)
                session.getAttribute("loggedInUser"); String currentUserRole=(loggedInUserDetail !=null &&
                loggedInUserDetail.getRole() !=null && loggedInUserDetail.getRole().getRoleName() !=null) ?
                loggedInUserDetail.getRole().getRoleName() : (String) session.getAttribute("currentUserRole"); boolean
                isAdmin="Admin" .equalsIgnoreCase(currentUserRole) || "Quản lý" .equalsIgnoreCase(currentUserRole); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết nhân viên - FamiCoats</title>
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/employees/employee-detail.css">
                </head>

                <body>
                    <div class="app-container">
                        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

                        <main class="main-content">
                            <header class="navbar">
                                <div class="breadcrumb">
                                    <span>FamiCoats</span> /
                                    <a href="${pageContext.request.contextPath}/admin/employees"
                                        style="text-decoration: none; color: inherit;">Quản lý nhân viên</a> /
                                    <span class="active-crumb">Chi tiết</span>
                                </div>
                                <div class="navbar-right">
                                    <div class="date-pill">
                                        <%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %>
                                    </div>
                                    <div class="profile-pill">
                                        <span class="profile-avatar-mini">${sessionScope.loggedInUser != null ?
                                            sessionScope.loggedInUser.fullName.substring(0, 1).toUpperCase() :
                                            'U'}</span>
                                        <span>${sessionScope.loggedInUser != null ? sessionScope.loggedInUser.fullName :
                                            'Hệ thống'}</span>
                                    </div>
                                </div>
                            </header>

                            <div class="content-wrapper" style="padding: 24px;">
                                <div class="page-header" style="margin-bottom   : 24px;">
                                    <h1 style="font-size: 24px; font-weight: 700; color: #0f172a; margin: 0;">
                                        Chi tiết thông tin nhân viên
                                    </h1>
                                </div>

                                <% if (employee !=null) { %>
                                    <div class="form-card">
                                        <div class="form-card-title">
                                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor"
                                                stroke-width="2.5" fill="none" stroke-linecap="round"
                                                stroke-linejoin="round">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                            </svg>
                                            THÔNG TIN CHI TIẾT NHÂN VIÊN
                                        </div>
                                        <div class="form-card-body">
                                            <!-- Hiển thị ảnh đại diện -->
                                            <div
                                                style="display: flex; align-items: center; gap: 20px; padding: 20px; border: 1px dashed #cbd5e1; border-radius: 12px; margin-bottom: 24px; background-color: #f8fafc;">
                                                <img src="<%= (employee.getAvatar() != null && !employee.getAvatar().isEmpty()) ? employee.getAvatar() : "https://ui-avatars.com/api/?name=" + (employee.getFullName() != null ? employee.getFullName().replace(" ", "+") : "NV" ) + "&background=random" %>" alt="Avatar"
                                                onerror="this.src='https://i.pravatar.cc/150?img=0'" style="width:
                                                100px; height: 100px; border-radius: 50%; object-fit: cover; border: 2px
                                                solid #e2e8f0; margin-bottom: 0;">
                                                <div>
                                                    <h3
                                                        style="margin: 0 0 4px 0; font-size: 18px; color: #0f172a; font-weight: 700;">
                                                        <%= employee.getFullName() !=null ? employee.getFullName()
                                                            : "Chưa có tên" %>
                                                    </h3>
                                                    <div style="display: flex; gap: 12px; align-items: center;">
                                                        <span
                                                            style="font-size: 13px; color: #64748b; background: #e2e8f0; padding: 2px 8px; border-radius: 12px; font-weight: 600;">
                                                            <%= (employee.getRoleName() !=null &&
                                                                !employee.getRoleName().isEmpty()) ?
                                                                employee.getRoleName() : (employee.getRoleId()==2
                                                                ? "Quản lý" : "Nhân viên" ) %>
                                                        </span>
                                                        <span
                                                            style="font-size: 13px; color: <%= employee.getStatus() == 1 ? "#10b981" : "#ef4444" %>; font-weight: 600;">
                                                            <%= employee.getStatus()==1 ? "● Đang làm việc"
                                                                : "● Đã nghỉ việc/Khóa" %>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-grid">
                                                <!-- THÔNG TIN CÁ NHÂN -->
                                                <div class="form-group">
                                                    <span class="form-label">Họ và tên</span>
                                                    <span class="info-value">
                                                        <%= employee.getFullName() !=null ? employee.getFullName() : ""
                                                            %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Vai trò</span>
                                                    <span class="info-value">
                                                        <%= (employee.getRoleName() !=null &&
                                                            !employee.getRoleName().isEmpty()) ? employee.getRoleName()
                                                            : (employee.getRoleId()==2 ? "Quản lý" : "Nhân viên" ) %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Số CCCD</span>
                                                    <span class="info-value">
                                                        <%= employee.getCccd() !=null && !employee.getCccd().isEmpty() ?
                                                            employee.getCccd() : "Chưa cập nhật" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Giới tính</span>
                                                    <span class="info-value">
                                                        <%= employee.getGender() !=null ? (employee.getGender() ? "Nam"
                                                            : "Nữ" ) : "Chưa xác định" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Ngày sinh</span>
                                                    <span class="info-value">
                                                        <%= employee.getBirthday() !=null ?
                                                            df.format(employee.getBirthday()) : "Chưa cập nhật" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Số điện thoại</span>
                                                    <span class="info-value">
                                                        <%= employee.getPhoneNumber() !=null ? employee.getPhoneNumber()
                                                            : "Chưa cập nhật" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Email</span>
                                                    <span class="info-value">
                                                        <%= employee.getEmail() !=null ? employee.getEmail() : "" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Ngày tham gia</span>
                                                    <span class="info-value">
                                                        <%= employee.getCreatedAt() !=null ?
                                                            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(employee.getCreatedAt()) : "Chưa cập nhật" %>
                                                    </span>
                                                </div>

                                                <div class="form-group">
                                                    <span class="form-label">Cập nhật lần cuối</span>
                                                    <span class="info-value">
                                                        <%= employee.getUpdatedAt() !=null ?
                                                            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(employee.getUpdatedAt()) : "Chưa cập nhật" %>
                                                    </span>
                                                </div>

                                                <!-- BỘ ĐỊA CHỈ TRONG CÙNG GRID -->
                                                <div class="form-group">
                                                    <span class="form-label">Tỉnh / Thành phố</span>
                                                    <span class="info-value" id="display-province">Đang tải...</span>
                                                </div>
                                                <div class="form-group">
                                                    <span class="form-label">Quận / Huyện</span>
                                                    <span class="info-value" id="display-district">Đang tải...</span>
                                                </div>
                                                <div class="form-group">
                                                    <span class="form-label">Phường / Xã</span>
                                                    <span class="info-value" id="display-ward">Đang tải...</span>
                                                </div>
                                                <div class="form-group" style="grid-column: span 2;">
                                                    <span class="form-label">Địa chỉ tổng hợp (Số nhà, đường...)</span>
                                                    <span class="info-value" id="display-street">
                                                        <%= !employee.getFullAddressString().isEmpty() ?
                                                            employee.getFullAddressString() : "Chưa cập nhật" %>
                                                    </span>
                                                </div>
                                                <input type="hidden" id="fullAddress"
                                                    value="<%= employee.getFullAddressString() %>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-actions"
                                        style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px;">
                                        <a href="<%= request.getContextPath() %>/admin/employees" class="btn-cancel"
                                            style="padding: 6px 16px; font-size: 12px; height: 36px;">
                                            Quay lại
                                        </a>
                                        <% if (isAdmin) { %>
                                            <a href="<%= request.getContextPath() %>/admin/employees?action=edit&id=<%= employee.getId() %>"
                                                class="btn-submit"
                                                style="padding: 6px 16px; font-size: 12px; height: 36px; background-color: #F59E0B; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor"
                                                    stroke-width="2" fill="none" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path
                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                                    </path>
                                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                                    </path>
                                                </svg>
                                                Chỉnh sửa hồ sơ
                                            </a>
                                            <% } %>
                                    </div>
                                    <% } %>
                            </div>
                        </main>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/js/employees/employee-detail.js"></script>
                </body>

                </html>