<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.huy.Employee" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    Employee employee = (Employee) request.getAttribute("employee"); 
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy"); 
    String currentUserRole = (String) session.getAttribute("currentUserRole");
    boolean isAdmin = "Admin".equals(currentUserRole) || "Quản lý".equals(currentUserRole); 
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết nhân viên - FamiCoats</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .form-card {
            background-color: #ffffff;
            border: 2px solid #0f172a;
            border-radius: 8px;
            overflow: visible;
            margin-bottom: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .form-card-title {
            background-color: #0f172a;
            color: #ffffff;
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 700;
            border-bottom: 1px solid #0f172a;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 8px;
            border-radius: 5px 5px 0 0;
        }
        .form-card-title svg {
            color: #ffffff !important;
        }
        .form-card-body {
            padding: 24px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px 24px;
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
        .form-label {
            font-size: 12px;
            font-weight: 600;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            display: block;
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 13px;
            color: #1e293b;
            font-family: inherit;
            background-color: #f8fafc;
            box-sizing: border-box;
            font-weight: 500;
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
            justify-content: center;
        }
        .btn-cancel:hover {
            background-color: #f8fafc;
            border-color: #94a3b8;
            color: #0f172a;
        }
        .btn-submit {
            background-color: #E11D48;
            color: #ffffff;
            border: 1px solid #E11D48;
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-submit:hover {
            background-color: #be123c;
            border-color: #be123c;
            box-shadow: 0 4px 12px rgba(225, 29, 72, 0.25);
        }
    </style>
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

        <main class="main-content">
            <header class="navbar">
                <div class="breadcrumb">
                    <span>FamiCoats</span> / 
                    <a href="${pageContext.request.contextPath}/admin/employees" style="text-decoration: none; color: inherit;">Quản lý nhân viên</a> / 
                    <span class="active-crumb">Chi tiết</span>
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
                    <h1 style="font-size: 24px; font-weight: 700; color: #0f172a; margin: 0;">
                        Chi tiết thông tin nhân viên
                    </h1>
                </div>

                <div class="form-card">
                    <div class="form-card-title">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="16" x2="12" y2="12"></line>
                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                        </svg>
                        THÔNG TIN CHI TIẾT NHÂN VIÊN
                    </div>
                    <div class="form-card-body">
                        <div class="form-grid">
                            <!-- THÔNG TIN CÁ NHÂN -->
                            <div class="form-group">
                                <span class="form-label">Họ và tên</span>
                                <span class="info-value"><%= employee.getFullName() %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Vai trò</span>
                                <span class="info-value"><%= (employee.getRoleName() != null && !employee.getRoleName().isEmpty()) ? employee.getRoleName() : (employee.getRoleId() == 2 ? "Quản lý" : "Nhân viên") %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Số CCCD</span>
                                <span class="info-value"><%= employee.getCccd() != null && !employee.getCccd().isEmpty() ? employee.getCccd() : "Chưa cập nhật" %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Giới tính</span>
                                <span class="info-value"><%= employee.getGender() != null ? (employee.getGender() ? "Nam" : "Nữ") : "Chưa xác định" %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Ngày sinh</span>
                                <span class="info-value"><%= employee.getBirthday() != null ? df.format(employee.getBirthday()) : "Chưa cập nhật" %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Số điện thoại</span>
                                <span class="info-value"><%= employee.getPhoneNumber() != null ? employee.getPhoneNumber() : "Chưa cập nhật" %></span>
                            </div>

                            <div class="form-group">
                                <span class="form-label">Email</span>
                                <span class="info-value"><%= employee.getEmail() %></span>
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
                                <span class="info-value" id="display-street"><%= employee.getAddress() != null && !employee.getAddress().isEmpty() ? employee.getAddress() : "Chưa cập nhật" %></span>
                            </div>
                            <input type="hidden" id="fullAddress" value="<%= employee.getAddress() != null ? employee.getAddress() : "" %>">
                        </div>
                    </div>
                </div>

                <div class="form-actions" style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px;">
                    <a href="<%= request.getContextPath() %>/admin/employees" class="btn-cancel" style="padding: 6px 16px; font-size: 12px; height: 36px;">
                        Quay lại
                    </a>
                    <% if (isAdmin) { %>
                    <a href="<%= request.getContextPath() %>/admin/employees?action=edit&id=<%= employee.getId() %>" class="btn-submit" style="padding: 6px 16px; font-size: 12px; height: 36px; background-color: #F59E0B; color: white; border: none; border-radius: 6px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                        </svg>
                        Chỉnh sửa hồ sơ
                    </a>
                    <% } %>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const fullAddr = document.getElementById('fullAddress').value.trim();
            if (fullAddr) {
                // Address format: Street, Ward, District, Province
                const parts = fullAddr.split(',').map(s => s.trim());
                if (parts.length >= 4) {
                    document.getElementById('display-street').textContent = parts.slice(0, parts.length - 3).join(', ');
                    document.getElementById('display-ward').textContent = parts[parts.length - 3];
                    document.getElementById('display-district').textContent = parts[parts.length - 2];
                    document.getElementById('display-province').textContent = parts[parts.length - 1];
                } else {
                    document.getElementById('display-street').textContent = fullAddr;
                    document.getElementById('display-ward').textContent = 'Chưa cập nhật';
                    document.getElementById('display-district').textContent = 'Chưa cập nhật';
                    document.getElementById('display-province').textContent = 'Chưa cập nhật';
                }
            } else {
                document.getElementById('display-street').textContent = 'Chưa cập nhật';
                document.getElementById('display-ward').textContent = 'Chưa cập nhật';
                document.getElementById('display-district').textContent = 'Chưa cập nhật';
                document.getElementById('display-province').textContent = 'Chưa cập nhật';
            }
        });
    </script>
</body>
</html>
