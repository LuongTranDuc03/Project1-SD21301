<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="project.duan1_sd21301.model.Invoice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Quản lý hoá đơn</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
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

            <!-- 2. Thân trang hiển thị danh sách hóa đơn -->
            <div class="content-wrapper">
                <!-- Tiêu đề trang -->
                <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <div>
                        <h1>Quản lý hoá đơn</h1>
                        <div class="subtitle">Tổng số: 120 hoá đơn</div>
                    </div>
                    <button class="btn-export">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                        <span>Xuất Excel</span>
                    </button>
                </div>



                <!-- Thanh tìm kiếm & bộ lọc -->
                <div class="filter-search-container">
                    <div class="search-input-group">
                        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" class="search-input" placeholder="Tìm theo mã đơn, khách hàng, sản phẩm...">
                    </div>
                    <div class="filter-pills">
                        <button class="filter-pill active">Tất cả</button>
                        <button class="filter-pill">Hoàn thành</button>
                        <button class="filter-pill">Đang giao</button>
                        <button class="filter-pill">Chờ xử lý</button>
                        <button class="filter-pill">Đã huỷ</button>
                    </div>
                </div>

                <!-- Bảng danh sách hoá đơn -->
                <div class="card" style="padding: 0; overflow: hidden;">
                    <div class="table-responsive">
                        <table class="invoice-table">
                            <thead>
                                <tr>
                                    <th>Mã HD</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>SL</th>
                                    <th>Tổng tiền</th>
                                    <th>Ngày đặt</th>
                                    <th>Thanh toán</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                                    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    if (invoices != null) {
                                        for (Invoice inv : invoices) {
                                            // Format status pill and labels
                                            String statusClass = "";
                                            String statusLabel = "";
                                            if ("SUCCESS".equals(inv.getStatus())) {
                                                statusClass = "success";
                                                statusLabel = "Hoàn thành";
                                            } else if ("SHIPPING".equals(inv.getStatus())) {
                                                statusClass = "warning";
                                                statusLabel = "Đang giao";
                                            } else if ("PENDING".equals(inv.getStatus())) {
                                                statusClass = "info";
                                                statusLabel = "Chờ xử lý";
                                            } else if ("CANCELLED".equals(inv.getStatus())) {
                                                statusClass = "danger";
                                                statusLabel = "Đã huỷ";
                                            }
                                            
                                            // Format currency
                                            String priceFormatted = String.format("%,.0fđ", inv.getTotalAmount()).replace(",", ".");
                                %>
                                <tr>
                                    <td style="font-family: 'Inter', sans-serif; font-size: 14px; line-height: 20px; font-weight: 600; color: #E11D48;"><%= inv.getId() %></td>
                                    <td>
                                        <div class="customer-cell">
                                            <span class="customer-name-text"><%= inv.getCustomerName() %></span>
                                            <span class="customer-phone-text"><%= inv.getCustomerPhone() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="font-weight: 500; color: #1e293b;"><%= inv.getProductName() %></span>
                                    </td>
                                    <td style="font-weight: 600; color: #475569; text-align: center;"><%= inv.getQuantity() %></td>
                                    <td style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 600; color: #0f172a;"><%= priceFormatted %></td>
                                    <td style="color: #64748B;"><%= df.format(inv.getCreatedAt()) %></td>
                                    <td>
                                        <span style="font-size: 13px; font-weight: 500; color: #475569;"><%= inv.getPaymentMethod() %></span>
                                    </td>
                                    <td>
                                        <span class="status-pill <%= statusClass %>"><%= statusLabel %></span>
                                    </td>
                                    <td>
                                        <button class="action-icon-btn view" title="Xem chi tiết">
                                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                        </button>
                                        <button class="action-icon-btn print" title="In hoá đơn" style="margin-left: 8px;">
                                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu hoá đơn.</td>
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
