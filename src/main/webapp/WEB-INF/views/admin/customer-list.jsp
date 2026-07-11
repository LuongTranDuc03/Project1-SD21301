<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Quản lý khách hàng</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css">
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
                    <span>FamiCoats Admin</span> / <span class="active-crumb">${requestScope.pageTitle}</span>
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

            <!-- 2. Thân trang hiển thị danh sách khách hàng -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang và nút thêm -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý khách hàng</h1>
                        <div class="subtitle">Tổng số: <%= ((List<Customer>) request.getAttribute("customers")).size() %> khách hàng</div>
                    </div>
                    <!-- Nút Thêm mới chuyển sang màu đen trung tính -->
                    <a class="btn-add-customer" href="<%= contextPath %>/admin/customers?action=add-form" style="text-decoration: none; background: #0f172a; color: #ffffff; box-shadow: none;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Thêm khách hàng</span>
                    </a>
                </div>

                <!-- THAY ĐỔI: Thanh lọc và tìm kiếm được làm ngắn lại, thiết kế gọn gàng hơn -->
                <div class="filter-search-container" style="padding: 12px 20px; margin-bottom: 20px; display: flex; align-items: center;">
                    <form action="<%= contextPath %>/admin/customers" method="get" style="display: flex; flex-wrap: wrap; gap: 12px; width: 100%; align-items: center;">
                        <!-- Ô tìm kiếm ngắn lại -->
                        <div class="search-input-group" style="max-width: 300px; flex: 1;">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <input type="text" name="search" class="search-input" placeholder="Tìm kiếm nhanh..." value="${requestScope.searchVal}" style="padding: 8px 12px 8px 38px; font-size: 13px; height: 36px;">
                        </div>
                        
                        <!-- Bộ lọc hạng ngắn lại -->
                        <select name="filterRank" onchange="this.form.submit()" style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; font-weight: 500; color: #475569; outline: none; height: 36px; min-width: 130px; cursor: pointer; transition: border-color 0.2s;">
                            <option value="Tất cả" ${requestScope.filterRankVal == 'Tất cả' ? 'selected' : ''}>Hạng: Tất cả</option>
                            <option value="Đồng" ${requestScope.filterRankVal == 'Đồng' ? 'selected' : ''}>Hạng: Đồng</option>
                            <option value="Bạc" ${requestScope.filterRankVal == 'Bạc' ? 'selected' : ''}>Hạng: Bạc</option>
                            <option value="Vàng" ${requestScope.filterRankVal == 'Vàng' ? 'selected' : ''}>Hạng: Vàng</option>
                            <option value="Kim cương" ${requestScope.filterRankVal == 'Kim cương' ? 'selected' : ''}>Hạng: Kim cương</option>
                        </select>
                        
                        <!-- Bộ lọc trạng thái ngắn lại -->
                        <select name="filterStatus" onchange="this.form.submit()" style="padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; font-weight: 500; color: #475569; outline: none; height: 36px; min-width: 140px; cursor: pointer; transition: border-color 0.2s;">
                            <option value="Tất cả" ${requestScope.filterStatusVal == 'Tất cả' ? 'selected' : ''}>Trạng thái: Tất cả</option>
                            <option value="Hoạt động" ${requestScope.filterStatusVal == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
                            <option value="Khóa" ${requestScope.filterStatusVal == 'Khóa' ? 'selected' : ''}>Khóa</option>
                        </select>
                        
                        <!-- Nút tìm kiếm ngắn lại -->
                        <button type="submit" class="btn-export" style="background-color: #334155; padding: 8px 16px; height: 36px; display: inline-flex; align-items: center; box-shadow: none; border-radius: 8px;">
                            <span>Tìm</span>
                        </button>
                        
                        <% if ((request.getAttribute("searchVal") != null && !((String)request.getAttribute("searchVal")).isEmpty()) 
                             || (request.getAttribute("filterRankVal") != null && !((String)request.getAttribute("filterRankVal")).equals("Tất cả")) 
                             || (request.getAttribute("filterStatusVal") != null && !((String)request.getAttribute("filterStatusVal")).equals("Tất cả"))) { %>
                           <a href="<%= contextPath %>/admin/customers" class="btn-outline" style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 8px 12px; font-weight: 600; font-size: 12px; height: 36px; border: 1px solid #cbd5e1; color: #475569;">Xóa lọc</a>
                        <% } %>
                    </form>
                </div>

                <!-- Bảng danh sách khách hàng -->
                <div class="card" style="padding: 0; overflow: hidden;">
                    <div class="table-responsive">
                        <table class="invoice-table">
                            <thead>
                                <tr>
                                    <th>Mã KH</th>
                                    <th>Khách hàng</th>
                                    <th>Liên hệ</th>
                                    <th>Ngày sinh</th>
                                    <th>Giới tính</th>
                                    <th style="text-align: left;">Điểm</th>
                                    <th>Hạng</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                                    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                                    if (customers != null && !customers.isEmpty()) {
                                        for (Customer c : customers) {
                                %>
                                <tr style="cursor: pointer;" onclick="window.location.href='<%= contextPath %>/admin/customers?action=details&id=<%= c.getId() %>'">
                                    <td style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 600; color: #1e293b;"><%= c.getId() %></td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <img src="<%= c.getAnhDaiDien() %>" class="customer-avatar-img" alt="avatar" style="border: 1px solid #d1d5db;">
                                            <span style="font-weight: 600; color: #1e293b;"><%= c.getHoTen() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="customer-cell">
                                            <span class="customer-name-text" style="font-weight: 500; color: #334155;"><%= c.getEmail() %></span>
                                            <span class="customer-phone-text" style="color: #64748b;"><%= c.getSoDienThoai() %></span>
                                        </div>
                                    </td>
                                    <td style="color: #64748B;"><%= c.getNgaySinh() != null ? df.format(c.getNgaySinh()) : "N/A" %></td>
                                    <td style="color: #475569; font-weight: 500;"><%= c.getGioiTinh() %></td>
                                    <td style="font-weight: 600; color: #0f172a; text-align: left;"><%= c.getDiemTichLuy() %></td>
                                    <td>
                                        <% if ("Đồng".equals(c.getHangThanhVien())) { %>
                                            <span style="background-color: #fdf2e9; color: #9a3412; border: 1px solid #f97316; font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 6px; display: inline-block;">Đồng</span>
                                        <% } else if ("Bạc".equals(c.getHangThanhVien())) { %>
                                            <span style="background-color: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 6px; display: inline-block;">Bạc</span>
                                        <% } else if ("Vàng".equals(c.getHangThanhVien())) { %>
                                            <span style="background: linear-gradient(135deg, #fef9c3, #fde68a); color: #78350f; border: 1px solid #f59e0b; font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 6px; display: inline-block;">Vàng</span>
                                        <% } else if ("Kim cương".equals(c.getHangThanhVien())) { %>
                                            <span style="background: linear-gradient(135deg, #ede9fe, #dbeafe); color: #4338ca; border: 1px solid #818cf8; font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 6px; display: inline-block;"> Kim cương</span>
                                        <% } else { %>
                                            <span style="background-color: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 6px; display: inline-block;"><%= c.getHangThanhVien() %></span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if ("Hoạt động".equalsIgnoreCase(c.getTrangThai())) { %>
                                            <span style="background-color: #f0fdf4; color: #16a34a; border: 1px solid #86efac; font-size: 11px; font-weight: 600; padding: 3px 8px; border-radius: 6px; display: inline-block;">Hoạt động</span>
                                        <% } else { %>
                                            <span style="background-color: #fef2f2; color: #dc2626; border: 1px solid #fca5a5; font-size: 11px; font-weight: 600; padding: 3px 8px; border-radius: 6px; display: inline-block;">Khóa</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div style="display: flex; justify-content: center; gap: 8px;">
                                            <a class="action-icon-btn" style="background-color: #f1f5f9; color: #475569;" title="Xem chi tiết" 
                                               href="<%= contextPath %>/admin/customers?action=details&id=<%= c.getId() %>" onclick="event.stopPropagation()">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                            </a>
                                            <a class="action-icon-btn" style="background-color: #f1f5f9; color: #475569;" title="Sửa" 
                                               href="<%= contextPath %>/admin/customers?action=edit-form&id=<%= c.getId() %>" onclick="event.stopPropagation()">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                            </a>
                                            <form action="<%= contextPath %>/admin/customers" method="post" onsubmit="event.stopPropagation(); return confirm('Bạn có chắc chắn muốn xóa khách hàng này?')" style="display: inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= c.getId() %>">
                                                <button type="submit" class="action-icon-btn" style="background-color: #f1f5f9; color: #64748B; cursor: pointer; border: none;" title="Xóa" onclick="event.stopPropagation()">
                                                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 40px; color: #9ca3af;">Không tìm thấy khách hàng nào.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
