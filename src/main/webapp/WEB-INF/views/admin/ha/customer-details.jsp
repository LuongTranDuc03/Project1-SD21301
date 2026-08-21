<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="project.duan1_sd21301.model.ha.Customer" %>
        <%@ page import="project.duan1_sd21301.model.Address" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.util.ArrayList" %>
                    <%@ page import="java.text.SimpleDateFormat" %>
                        <% Customer c=(Customer) request.getAttribute("customer"); SimpleDateFormat df=new
                            SimpleDateFormat("dd/MM/yyyy"); String contextPath=request.getContextPath(); %>
                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>FamiCoats Admin - Chi tiết khách hàng</title>
                                <!-- Nhúng Google Fonts (Inter) -->
                                <link rel="preconnect" href="https://fonts.googleapis.com">
                                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                                <link
                                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                    rel="stylesheet">
                                <!-- Nhúng CSS Custom -->
                                <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css">
                                <link rel="stylesheet"
                                    href="<%= contextPath %>/assets/css/customers/customer.css?v=<%= System.currentTimeMillis() %>">

                                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customers/customer-details.css">
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
                                                <span>FamiCoats</span> / <a href="${pageContext.request.contextPath}/admin/customers" style="color: #64748b; text-decoration: none;">Quản lý khách hàng</a> / <span
                                                    class="active-crumb">Chi tiết hồ sơ</span>
                                            </div>
                                            <div class="navbar-right">
                                                <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                                                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                                                <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
                                            </div>
                                        </header>

                                        <!-- 2. Thân trang hiển thị chi tiết hồ sơ -->
                                        <div class="content-wrapper">
                                            <% if (c==null) { %>
                                                <div class="card" style="text-align: center; padding: 50px;">
                                                    <h2 style="color: #ef4444;">Khách hàng không tồn tại hoặc đã bị xóa!
                                                    </h2>
                                                    <a href="<%= contextPath %>/admin/customers" class="btn-export"
                                                        style="margin-top: 20px; background-color: #1e293b; text-decoration: none; display: inline-flex;">
                                                        Quay lại danh sách
                                                    </a>
                                                </div>
                                                <% } else { String statusLabel=(c.getStatus() != null && c.getStatus() == 1) ? "Hoạt động" : "Khóa"; %>
                                                    <!-- Thanh tiêu đề & nút điều hướng -->
                                                    <div class="page-header"
                                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                                        <div>
                                                            <h1>Hồ sơ: <%= c.getFullName() %>
                                                            </h1>
                                                            <div class="subtitle">Mã số: <%= c.getCode() %>
                                                            </div>
                                                        </div>
                                                        <div style="display: flex; gap: 12px;">
                                                            <a href="<%= contextPath %>/admin/customers"
                                                                class="btn-outline"
                                                                style="display: inline-flex; align-items: center; justify-content: center; text-decoration: none; border-radius: 8px; padding: 10px 16px; font-weight: 600;">
                                                                <span>Quay lại</span>
                                                            </a>
                                                            <a href="<%= contextPath %>/admin/customers?action=edit-form&id=<%= c.getId() %>"
                                                                class="btn-export"
                                                                style="background-color: #E11D48; border: 1px solid #E11D48; text-decoration: none; box-shadow: none;">
                                                                <span>Chỉnh sửa hồ sơ</span>
                                                            </a>
                                                        </div>
                                                    </div>

                                                    <!-- Layout chính dạng Grid -->
                                                    <div class="profile-container">
                                                        <!-- Cột trái: Avatar và Tóm tắt dạng nền sáng tinh tế, không màu sắc -->
                                                        <div class="profile-card-left"
                                                            style="background-color: #ffffff; border: 1px solid #e2e8f0;">
                                                            <img src="<%= (c != null && c.getAvatar() != null && !c.getAvatar().isEmpty()) ? c.getAvatar() : "https://i.pravatar.cc/150?img=0" %>" onerror="this.src='https://i.pravatar.cc/150?img=0'" class="profile-avatar-large"
                                                                alt="avatar" style="border: 2px solid #cbd5e1;">
                                                            <div class="profile-name">
                                                                <%= c.getFullName() %>
                                                            </div>
                                                            <div class="profile-email-sub">
                                                                <%= c.getEmail() %>
                                                            </div>

                                                            <div class="profile-stat-box">

                                                                <div class="stat-item">
                                                                    <% if (c.getStatus() != null && c.getStatus() == 1) { %>
                                                                        <span class="stat-val"
                                                                            style="color: #16a34a;">Hoạt động</span>
                                                                        <% } else { %>
                                                                            <span class="stat-val"
                                                                                style="color: #dc2626;">Khóa</span>
                                                                            <% } %>
                                                                                <span class="stat-lbl">Tài khoản</span>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Cột phải: Chi tiết thông tin -->
                                                        <div class="profile-card-right">
                                                            <!-- Phần 1: Thông tin cá nhân -->
                                                            <div class="info-section-title">THÔNG TIN CÁ NHÂN</div>
                                                            <div class="info-grid">
                                                                <div class="info-item">
                                                                    <span class="info-label">Mã khách hàng</span>
                                                                    <span class="info-value"
                                                                        style="font-weight: 700; color: #1e293b;">
                                                                        <%= c.getCode() %>
                                                                    </span>
                                                                </div>
                                                                <div class="info-item">
                                                                    <span class="info-label">Họ và tên</span>
                                                                    <span class="info-value">
                                                                        <%= c.getFullName() %>
                                                                    </span>
                                                                </div>
                                                                <div class="info-item">
                                                                    <span class="info-label">Ngày sinh</span>
                                                                    <span class="info-value">
                                                                        <%= c.getDateOfBirth() !=null ?
                                                                            df.format(c.getDateOfBirth())
                                                                            : "Chưa cập nhật" %>
                                                                    </span>
                                                                </div>
                                                                <div class="info-item">
                                                                    <span class="info-label">Giới tính</span>
                                                                    <span class="info-value">
                                                                        <%= c.getGender() %>
                                                                    </span>
                                                                </div>
                                                            </div>

                                                            <!-- Phần 2: Thông tin liên hệ & Tài khoản -->
                                                            <div class="info-section-title">LIÊN HỆ & TÀI KHOẢN</div>
                                                            <div class="info-grid">
                                                                <div class="info-item">
                                                                    <span class="info-label">Số điện thoại</span>
                                                                    <span class="info-value">
                                                                        <%= c.getPhoneNumber() %>
                                                                    </span>
                                                                </div>
                                                                <div class="info-item">
                                                                    <span class="info-label">Email</span>
                                                                    <span class="info-value">
                                                                        <%= c.getEmail() %>
                                                                    </span>
                                                                </div>

                                                            </div>

                                                            <!-- Phần 3: Địa chỉ -->
                                                            <div class="info-section-title">DANH SÁCH ĐỊA CHỈ</div>
                                                            <div
                                                                style="display: flex; flex-direction: column; background-color: #ffffff; border-radius: 12px; border: 1px solid #e2e8f0; overflow: hidden; margin-top: 10px;">

                                                                <!-- 1. Địa chỉ mặc định -->
                                                                <div
                                                                    style="display: flex; justify-content: space-between; align-items: flex-start; padding: 20px; border-bottom: 1px solid #f1f5f9;">
                                                                    <div
                                                                        style="display: flex; flex-direction: column; gap: 4px;">
                                                                        <div
                                                                            style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                                                            <%= (c.getDefaultAddress() !=null &&
                                                                                c.getDefaultAddress().getRecipientName()
                                                                                !=null &&
                                                                                !c.getDefaultAddress().getRecipientName().isEmpty())
                                                                                ?
                                                                                c.getDefaultAddress().getRecipientName()
                                                                                : c.getFullName() %>
                                                                                <span
                                                                                    style="font-weight: 400; color: #64748b; margin-left: 8px;">
                                                                                    <%= (c.getDefaultAddress() !=null &&
                                                                                        c.getDefaultAddress().getPhoneNumber()
                                                                                        !=null &&
                                                                                        !c.getDefaultAddress().getPhoneNumber().isEmpty())
                                                                                        ?
                                                                                        c.getDefaultAddress().getPhoneNumber()
                                                                                        : c.getPhoneNumber() %>
                                                                                </span>
                                                                        </div>
                                                                        <div
                                                                            style="font-size: 13px; color: #475569; line-height: 1.5; margin-top: 2px;">
                                                                            <%= (c.getDefaultAddress() !=null &&
                                                                                c.getDefaultAddress().getFormattedAddress()
                                                                                !=null) ?
                                                                                c.getDefaultAddress().getFormattedAddress()
                                                                                : "Chưa đăng ký địa chỉ mặc định." %>
                                                                        </div>
                                                                        <% if (c.getDefaultAddress() !=null &&
                                                                            c.getDefaultAddress().getFormattedAddress()
                                                                            !=null &&
                                                                            !c.getDefaultAddress().getFormattedAddress().trim().isEmpty())
                                                                            { %>
                                                                            <div>
                                                                                <span
                                                                                    style="background-color: #FFF1F2; color: #E11D48; border: 1px solid #FDA4AF; font-size: 10px; font-weight: 600; padding: 2px 6px; border-radius: 4px; display: inline-block; margin-top: 4px;">Mặc
                                                                                    định</span>
                                                                            </div>
                                                                            <% } %>
                                                                    </div>
                                                                    <div
                                                                        style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                                                        <a href="<%= contextPath %>/admin/customers?action=edit-form&id=<%= c.getId() %>"
                                                                            style="color: #0284c7; text-decoration: none; font-size: 13px; font-weight: 600;">Cập
                                                                            nhật</a>
                                                                    </div>
                                                                </div>

                                                                <!-- 2. Các địa chỉ khác -->
                                                                <% if (c.getOtherAddresses() !=null &&
                                                                    !c.getOtherAddresses().isEmpty()) { for (int i=0; i
                                                                    < c.getOtherAddresses().size(); i++) { project.duan1_sd21301.model.ha.CustomerAddress
                                                                    otherAddr=c.getOtherAddresses().get(i); boolean
                                                                    isLast=(i==c.getOtherAddresses().size() - 1); %>
                                                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; padding: 20px;<%= isLast ? "" : "border-bottom: 1px solid #f1f5f9;" %>">
                                                                        <div
                                                                            style="display: flex; flex-direction: column; gap: 4px;">
                                                                            <div
                                                                                style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                                                                <%= (otherAddr.getRecipientName() !=null
                                                                                    &&
                                                                                    !otherAddr.getRecipientName().isEmpty())
                                                                                    ? otherAddr.getRecipientName() :
                                                                                    c.getFullName() %>
                                                                                    <span
                                                                                        style="font-weight: 400; color: #64748b; margin-left: 8px;">
                                                                                        <%= (otherAddr.getPhoneNumber()
                                                                                            !=null &&
                                                                                            !otherAddr.getPhoneNumber().isEmpty())
                                                                                            ?
                                                                                            otherAddr.getPhoneNumber()
                                                                                            : c.getPhoneNumber() %>
                                                                                    </span>
                                                                            </div>
                                                                            <div
                                                                                style="font-size: 13px; color: #475569; line-height: 1.5; margin-top: 2px;">
                                                                                <%= otherAddr.getFormattedAddress() %>
                                                                            </div>
                                                                        </div>
                                                                        <div
                                                                            style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px; min-width: 140px;">
                                                                            <div
                                                                                style="display: flex; gap: 12px; font-size: 13px; font-weight: 600;">
                                                                                <a href="<%= contextPath %>/admin/customers?action=edit-form&id=<%= c.getId() %>"
                                                                                    style="color: #0284c7; text-decoration: none;">Cập
                                                                                    nhật</a>
                                                                                 <span style="color: #cbd5e1;">|</span>
                                                                                 <form
                                                                                    action="<%= contextPath %>/admin/customers"
                                                                                    method="post"
                                                                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')"
                                                                                    style="display: inline;">
                                                                                    <input type="hidden" name="action"
                                                                                        value="delete-address">
                                                                                    <input type="hidden" name="id"
                                                                                        value="<%= c.getId() %>">
                                                                                    <input type="hidden" name="addressCode"
                                                                                        value="<%= otherAddr.getCode() %>">
                                                                                    <button type="submit"
                                                                                        style="background: none; border: none; padding: 0; color: #ef4444; font-family: inherit; font-size: 13px; font-weight: 600; cursor: pointer; display: inline;">Xóa</button>
                                                                                </form>
                                                                            </div>

                                                                            <!-- Nút Thiết lập mặc định -->
                                                                            <a href="<%= contextPath %>/admin/customers?action=set-default-address&id=<%= c.getId() %>&addressCode=<%= otherAddr.getCode() %>"
                                                                                style="background-color: #ffffff; border: 1px solid #d1d5db; color: #374151; font-size: 11px; padding: 4px 8px; border-radius: 4px; text-decoration: none; margin-top: 6px; display: inline-block; transition: background-color 0.2s; font-family: inherit;">
                                                                                Thiết lập mặc định
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                    <% } } else { %>
                                                                        <div
                                                                            style="padding: 20px; font-size: 13px; color: #94a3b8; font-style: italic; text-align: center;">
                                                                            Chưa thiết lập địa chỉ phụ nào khác.</div>
                                                                        <% } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <% } %>
                                        </div>
                                    </main>
                                </div>
                                <%-- Toast thông báo dùng chung --%>
                                    <jsp:include page="/WEB-INF/views/layout/toast.jsp" />
                            </body>

                            </html>
