<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="project.duan1_sd21301.model.ha.Customer" %>
        <%@ page import="project.duan1_sd21301.model.ha.Address" %>
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

                                <style>
                                    .profile-container {
                                        display: grid;
                                        grid-template-columns: 300px 1fr;
                                        gap: 28px;
                                        margin-top: 24px;
                                    }

                                    @media(max-width: 900px) {
                                        .profile-container {
                                            grid-template-columns: 1fr;
                                        }
                                    }

                                    .profile-card-left {
                                        background-color: #ffffff;
                                        border-radius: 16px;
                                        border: 1px solid #e2e8f0;
                                        padding: 36px 24px;
                                        text-align: center;
                                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
                                        display: flex;
                                        flex-direction: column;
                                        align-items: center;
                                    }

                                    .profile-avatar-large {
                                        width: 124px;
                                        height: 124px;
                                        border-radius: 50%;
                                        object-fit: cover;
                                        border: 4px solid #ffffff;
                                        outline: 2px solid #cbd5e1;
                                        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08);
                                        margin-bottom: 18px;
                                    }

                                    .profile-name {
                                        font-size: 19px;
                                        font-weight: 700;
                                        color: #0f172a;
                                        margin-bottom: 6px;
                                        letter-spacing: -0.02em;
                                    }

                                    .profile-email-sub {
                                        font-size: 13px;
                                        color: #64748b;
                                        margin-bottom: 18px;
                                        word-break: break-all;
                                    }

                                    .profile-stat-box {
                                        background: linear-gradient(135deg, #f8fafc, #f1f5f9);
                                        border-radius: 14px;
                                        padding: 16px;
                                        width: 100%;
                                        margin-top: 24px;
                                        display: flex;
                                        justify-content: space-around;
                                        border: 1px solid #e2e8f0;
                                        box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.03);
                                    }

                                    .stat-item {
                                        display: flex;
                                        flex-direction: column;
                                        align-items: center;
                                        gap: 4px;
                                    }

                                    .stat-val {
                                        font-size: 15px;
                                        font-weight: 700;
                                        color: #0f172a;
                                    }

                                    .stat-lbl {
                                        font-size: 10px;
                                        text-transform: uppercase;
                                        letter-spacing: 0.05em;
                                        font-weight: 600;
                                        color: #64748b;
                                    }

                                    .profile-card-right {
                                        background-color: #ffffff;
                                        border-radius: 16px;
                                        border: 1px solid #e2e8f0;
                                        padding: 28px;
                                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
                                    }

                                    .info-section-title {
                                        font-size: 11px;
                                        font-weight: 700;
                                        color: #475569;
                                        letter-spacing: 0.1em;
                                        border-left: 3px solid #0f172a;
                                        padding-left: 10px;
                                        margin-bottom: 20px;
                                        margin-top: 32px;
                                        text-transform: uppercase;
                                    }

                                    .info-section-title:first-of-type {
                                        margin-top: 0;
                                    }

                                    .info-grid {
                                        display: grid;
                                        grid-template-columns: 1fr 1fr;
                                        gap: 20px;
                                    }

                                    @media(max-width: 600px) {
                                        .info-grid {
                                            grid-template-columns: 1fr;
                                        }
                                    }

                                    .info-item {
                                        display: flex;
                                        flex-direction: column;
                                        gap: 6px;
                                    }

                                    .info-label {
                                        font-size: 12px;
                                        font-weight: 600;
                                        color: #64748b;
                                    }

                                    .info-value {
                                        font-size: 13px;
                                        font-weight: 500;
                                        color: #1e293b;
                                        padding: 11px 15px;
                                        background-color: #f8fafc;
                                        border-radius: 8px;
                                        border: 1px solid #f1f5f9;
                                    }
                                </style>
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
                                                <span>FamiCoats Admin</span> / <span>Quản lý khách hàng</span> / <span
                                                    class="active-crumb">Chi tiết hồ sơ</span>
                                            </div>
                                            <div class="navbar-right">
                                                <button class="notif-btn">
                                                    <svg viewBox="0 0 24 24" width="20" height="20"
                                                        stroke="currentColor" stroke-width="2" fill="none"
                                                        stroke-linecap="round" stroke-linejoin="round">
                                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                                    </svg>
                                                    <span class="notif-badge"></span>
                                                </button>
                                                <div class="date-pill">Thứ Ba, 30/06/2026</div>
                                                <div class="profile-pill">
                                                    <span class="profile-avatar-mini">A</span>
                                                    <span>Admin</span>
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
                                                <% } else { String statusLabel=c.getStatus(); %>
                                                    <!-- Thanh tiêu đề & nút điều hướng -->
                                                    <div class="page-header"
                                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                                        <div>
                                                            <h1>Hồ sơ: <%= c.getFullName() %>
                                                            </h1>
                                                            <div class="subtitle">Mã số: <%= c.getId() %>
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
                                                            <img src="<%= c.getAvatar() %>" class="profile-avatar-large"
                                                                alt="avatar" style="border: 2px solid #cbd5e1;">
                                                            <div class="profile-name">
                                                                <%= c.getFullName() %>
                                                            </div>
                                                            <div class="profile-email-sub">
                                                                <%= c.getEmail() %>
                                                            </div>

                                                            <div class="profile-stat-box">

                                                                <div class="stat-item">
                                                                    <% if ("Hoạt động".equalsIgnoreCase(c.getStatus()))
                                                                        { %>
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
                                                                        <%= c.getId() %>
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
                                                                                c.getDefaultAddress().getDetailedAddress()
                                                                                !=null) ?
                                                                                c.getDefaultAddress().getDetailedAddress()
                                                                                : "Chưa đăng ký địa chỉ mặc định." %>
                                                                        </div>
                                                                        <% if (c.getDefaultAddress() !=null &&
                                                                            c.getDefaultAddress().getDetailedAddress()
                                                                            !=null &&
                                                                            !c.getDefaultAddress().getDetailedAddress().trim().isEmpty())
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
                                                                    < c.getOtherAddresses().size(); i++) { Address
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
                                                                                <%= otherAddr.getDetailedAddress() %>
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
                                                                                <!-- Form xóa địa chỉ phụ -->
                                                                                <form
                                                                                    action="<%= contextPath %>/admin/customers"
                                                                                    method="post"
                                                                                    onsubmit="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')"
                                                                                    style="display: inline;">
                                                                                    <input type="hidden" name="action"
                                                                                        value="delete-other-address">
                                                                                    <input type="hidden" name="id"
                                                                                        value="<%= c.getId() %>">
                                                                                    <input type="hidden" name="index"
                                                                                        value="<%= i %>">
                                                                                    <button type="submit"
                                                                                        style="background: none; border: none; padding: 0; color: #0284c7; font-family: inherit; font-size: 13px; font-weight: 600; cursor: pointer; display: inline;">Xóa</button>
                                                                                </form>
                                                                            </div>

                                                                            <!-- Nút Thiết lập mặc định -->
                                                                            <a href="<%= contextPath %>/admin/customers?action=set-default-address&id=<%= c.getId() %>&index=<%= i %>"
                                                                                style="background-color: #ffffff; border: 1px solid #d1d5db; color: #374151; font-size: 12px; font-weight: 500; padding: 6px 12px; border-radius: 4px; text-decoration: none; display: inline-block; text-align: center; transition: background-color 0.2s; font-family: inherit;">
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