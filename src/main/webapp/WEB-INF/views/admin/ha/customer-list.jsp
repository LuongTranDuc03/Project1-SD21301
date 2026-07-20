<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Import các lớp Model và thư viện Java cần thiết --%>
<%@ page import="project.duan1_sd21301.model.ha.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    // Đường dẫn gốc ứng dụng (Context Path) dùng cho việc định tuyến và tải file tĩnh (CSS/JS)
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
                        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                            rel="stylesheet">
                        <!-- Nhúng CSS Custom -->
                        <link rel="stylesheet" href="<%= contextPath %>/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">
                        <link rel="stylesheet" href="<%= contextPath %>/assets/css/customers/customer.css?v=<%= System.currentTimeMillis() %>">
                        <style>
                            /* Tối giản màu sắc và cải thiện giao diện table */
                            .invoice-table th, .invoice-table td {
                                border-bottom: 1px solid #f1f5f9;
                            }
                            .customer-id-text {
                                font-family: 'Inter', sans-serif;
                                font-size: 13px;
                                font-weight: 600;
                                color: #475569;
                            }
                            .customer-name-text {
                                font-weight: 600;
                                color: #0f172a;
                            }
                            .action-icon-btn {
                                width: 32px;
                                height: 32px;
                                border-radius: 6px;
                                border: 1px solid #e2e8f0;
                                background-color: #ffffff;
                                color: #64748b;
                                display: inline-flex;
                                align-items: center;
                                justify-content: center;
                                cursor: pointer;
                                transition: all 0.2s ease;
                                margin-right: 4px;
                                text-decoration: none;
                            }
                            .action-icon-btn:hover {
                                background-color: #f8fafc;
                                color: #0f172a;
                            }
                            .badge-status {
                                display: inline-block;
                                padding: 2px 8px;
                                border-radius: 6px;
                                font-size: 11px;
                                font-weight: 600;
                            }
                            .badge-status.available {
                                background-color: #ecfdf5;
                                color: #065f46;
                            }
                            .badge-status.out_of_stock {
                                background-color: #fef2f2;
                                color: #991b1b;
                            }
                            /* Custom card style with border radius and header */
                            .custom-card {
                                background: #ffffff;
                                border: 1px solid #e2e8f0;
                                border-radius: 8px !important;
                                overflow: hidden !important;
                                margin-bottom: 10px;
                                box-shadow: 0 1px 3px rgba(0,0,0,0.04);
                            }
                            .card-header-bar {
                                background-color: #12192D;
                                color: #ffffff;
                                padding: 12px 20px;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }
                            .card-header-title {
                                font-size: 13px;
                                font-weight: 700;
                                letter-spacing: 0.5px;
                                text-transform: uppercase;
                            }
                            .toggle-filter-btn {
                                background: none;
                                border: none;
                                color: #94a3b8;
                                font-size: 12px;
                                cursor: pointer;
                                font-weight: 500;
                                transition: color 0.2s;
                            }
                            .toggle-filter-btn:hover {
                                color: #ffffff;
                            }
                            .card-body-content {
                                padding: 20px;
                                transition: all 0.3s ease;
                                overflow: hidden;
                                max-height: 1000px;
                            }
                            .card-body-content.collapsed {
                                max-height: 0;
                                padding-top: 0;
                                padding-bottom: 0;
                                border: none;
                            }
                            /* Filter Grid Layout */
                            .filter-grid {
                                display: grid;
                                grid-template-columns: 2.5fr 1.5fr max-content max-content 110px;
                                gap: 16px 40px;
                                align-items: flex-end;
                                width: 100%;
                            }
                            @media (max-width: 992px) {
                                .filter-grid {
                                    grid-template-columns: 1fr 1fr;
                                }
                            }
                            @media (max-width: 576px) {
                                .filter-grid {
                                    grid-template-columns: 1fr;
                                }
                            }
                            .filter-field {
                                display: flex;
                                flex-direction: column;
                                gap: 6px;
                            }
                            .filter-field label {
                                font-size: 12px;
                                font-weight: 600;
                                color: #475569;
                            }
                            .filter-control {
                                width: 100%;
                                padding: 10px 12px;
                                border: 1px solid #cbd5e1;
                                border-radius: 6px;
                                font-size: 13px;
                                font-family: inherit;
                                color: #1e293b;
                                background: #ffffff;
                                outline: none;
                                transition: all 0.2s;
                                box-sizing: border-box;
                                height: 38px;
                            }
                            .filter-control:focus {
                                border-color: #12192D;
                                box-shadow: 0 0 0 3px rgba(18, 25, 45, 0.08);
                            }
                            .btn-reset-filter {
                                display: inline-flex;
                                align-items: center;
                                gap: 6px;
                                padding: 10px 16px;
                                font-weight: 600;
                                border-radius: 6px;
                                border: 1px solid #cbd5e1;
                                background: #ffffff;
                                color: #475569;
                                cursor: pointer;
                                transition: all 0.2s;
                                font-size: 13px;
                                height: 38px;
                                box-sizing: border-box;
                            }
                            .btn-reset-filter:hover {
                                background-color: #f1f5f9;
                            }
                            /* Modern Switch Styling */
                            .switch {
                                position: relative;
                                display: inline-block;
                                width: 34px;
                                height: 18px;
                                flex-shrink: 0;
                            }
                            .switch input {
                                opacity: 0;
                                width: 0;
                                height: 0;
                            }
                            .slider {
                                position: absolute;
                                cursor: pointer;
                                top: 0;
                                left: 0;
                                right: 0;
                                bottom: 0;
                                background-color: #cbd5e1;
                                transition: .2s;
                                border-radius: 18px;
                            }
                            .slider:before {
                                position: absolute;
                                content: "";
                                height: 12px;
                                width: 12px;
                                left: 3px;
                                bottom: 3px;
                                background-color: white;
                                transition: .2s;
                                border-radius: 50%;
                                box-shadow: 0 1px 3px rgba(15,23,42,0.25);
                            }
                            input:checked + .slider {
                                background-color: #10b981;
                            }
                            input:checked + .slider:before {
                                transform: translateX(16px);
                            }
                            /* Align table headers in one line and shrink font size if too big */
                            .invoice-table th {
                                white-space: nowrap !important;
                                font-size: 11px !important;
                                padding: 12px 20px !important;
                            }
                            /* Action Buttons Styling */
                            .action-icon-btn.edit-btn,
                            .action-icon-btn.details-btn {
                                width: 32px !important;
                                height: 32px !important;
                                border-radius: 8px !important;
                                border: 1px solid #e2e8f0 !important;
                                background-color: #ffffff !important;
                                color: #475569 !important;
                                display: inline-flex !important;
                                align-items: center !important;
                                justify-content: center !important;
                                transition: all 0.2s ease !important;
                                flex-shrink: 0 !important;
                            }
                            .action-icon-btn.edit-btn:hover,
                            .action-icon-btn.details-btn:hover {
                                background-color: #f1f5f9 !important;
                                color: #0f172a !important;
                                border-color: #cbd5e1 !important;
                                transform: translateY(-1px) !important;
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
                                        <span>FamiCoats Admin</span> / <span
                                            class="active-crumb">${requestScope.pageTitle}</span>
                                    </div>
                                    <div class="navbar-right">
                                        <button class="notif-btn">
                                            <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor"
                                                stroke-width="2" fill="none" stroke-linecap="round"
                                                stroke-linejoin="round">
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

                                <!-- 2. Thân trang hiển thị danh sách khách hàng -->
                                <div class="content-wrapper">
                                    <!-- Tiêu đề trang và nút thêm -->
                                    <div class="page-header"
                                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                        <div>
                                            <h1>Quản lý khách hàng</h1>
                                            <div class="subtitle">Tổng số: <%= ((List<Customer>)
                                                    request.getAttribute("customers")).size() %> khách hàng</div>
                                        </div>
                                        <div style="display: flex; gap: 8px;">
                                            <a href="#" onclick="exportExcelFiltered(); return false;" class="btn-export" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="8" y1="13" x2="16" y2="13"></line><line x1="8" y1="17" x2="16" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                                <span>Xuất Excel</span>
                                            </a>
                                            <!-- Nút Thêm mới chuyển sang màu hồng đỏ giống sản phẩm -->
                                            <a class="btn-export"
                                                href="<%= contextPath %>/admin/customers?action=add-form"
                                                style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; height: 38px; box-shadow: none;">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                                    stroke-width="2.5" fill="none" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                                </svg>
                                                <span>Thêm khách hàng</span>
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Bộ lọc & tìm kiếm -->
                                    <div class="custom-card">
                                        <div class="card-header-bar">
                                            <span class="card-header-title">&#8226; BỘ LỌC TÌM KIẾM</span>
                                            <button class="toggle-filter-btn" id="toggleFilterBtn" onclick="toggleFilterCard()">Nhấn để thu gọn</button>
                                        </div>
                                        <div class="card-body-content" id="filterCardBody">
                                            <form action="<%= contextPath %>/admin/customers" method="get" id="searchForm" class="filter-grid">
                                                
                                                <!-- Tìm kiếm -->
                                                <div class="filter-field">
                                                    <label for="searchInput">Tìm kiếm chung</label>
                                                    <div style="position: relative; width: 100%;">
                                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                                            stroke-width="2.5" fill="none" stroke-linecap="round"
                                                            stroke-linejoin="round" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94A3B8;">
                                                            <circle cx="11" cy="11" r="8"></circle>
                                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                                        </svg>
                                                        <input type="text" name="search" id="searchInput" class="filter-control"
                                                            placeholder="Tìm mã, tên, SĐT, email..." value="${requestScope.searchVal}"
                                                            style="padding-left: 36px;" oninput="debouncedSubmit()">
                                                    </div>
                                                </div>

                                                <!-- Bộ lọc địa chỉ -->
                                                <div class="filter-field">
                                                    <label for="addressInput">Địa chỉ</label>
                                                    <input type="text" name="filterAddress" id="addressInput" class="filter-control"
                                                        placeholder="Nhập tỉnh/thành, địa chỉ..." value="${requestScope.filterAddressVal}"
                                                        oninput="debouncedSubmit()">
                                                </div>

                                                <!-- Bộ lọc giới tính -->
                                                <div class="filter-field">
                                                    <label>Giới tính</label>
                                                    <div style="display: flex; align-items: center; gap: 16px; margin-top: 8px;">
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterGender" value="Tất cả" onchange="this.form.submit()" ${requestScope.filterGenderVal == null || requestScope.filterGenderVal == 'Tất cả' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Tất cả
                                                        </label>
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterGender" value="Nam" onchange="this.form.submit()" ${requestScope.filterGenderVal == 'Nam' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Nam
                                                        </label>
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterGender" value="Nữ" onchange="this.form.submit()" ${requestScope.filterGenderVal == 'Nữ' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Nữ
                                                        </label>
                                                    </div>
                                                </div>

                                                <!-- Bộ lọc trạng thái -->
                                                <div class="filter-field">
                                                    <label>Trạng thái</label>
                                                    <div style="display: flex; align-items: center; gap: 16px; margin-top: 8px;">
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterStatus" value="Tất cả" onchange="this.form.submit()" ${requestScope.filterStatusVal == null || requestScope.filterStatusVal == 'Tất cả' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Tất cả
                                                        </label>
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterStatus" value="Hoạt động" onchange="this.form.submit()" ${requestScope.filterStatusVal == 'Hoạt động' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Hoạt động
                                                        </label>
                                                        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; font-weight: 500; font-size: 13px; color: #1e293b;">
                                                            <input type="radio" name="filterStatus" value="Khóa" onchange="this.form.submit()" ${requestScope.filterStatusVal == 'Khóa' ? 'checked' : ''} style="cursor: pointer; margin: 0;">
                                                            Khóa
                                                        </label>
                                                    </div>
                                                </div>

                                                <!-- Nút Đặt lại (Luôn giữ chỗ để không vỡ Grid) -->
                                                <div class="filter-field" style="justify-content: flex-end; align-items: flex-end;">
                                                    <% if ((request.getAttribute("searchVal") !=null && !((String)request.getAttribute("searchVal")).isEmpty()) ||
                                                           (request.getAttribute("filterGenderVal") !=null && !((String)request.getAttribute("filterGenderVal")).equals("Tất cả")) ||
                                                           (request.getAttribute("filterAddressVal") !=null && !((String)request.getAttribute("filterAddressVal")).isEmpty()) ||
                                                           (request.getAttribute("filterStatusVal") !=null && !((String)request.getAttribute("filterStatusVal")).equals("Tất cả"))) {
                                                    %>
                                                        <a href="<%= contextPath %>/admin/customers" class="btn-reset-filter" style="text-decoration: none;">
                                                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 .49-3.5"></path></svg>
                                                            Đặt lại
                                                        </a>
                                                    <% } %>
                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Bảng danh sách khách hàng -->
                                    <div class="custom-card">
                                        <div class="card-header-bar">
                                            <span class="card-header-title">&#8226; BẢNG DỮ LIỆU KHÁCH HÀNG</span>
                                        </div>
                                        <div class="table-responsive">
                                            <table class="invoice-table">
                                                <thead>
                                                    <tr>
                                                        <th style="text-align: center; width: 60px;">STT</th>
                                                        <th>MÃ KHÁCH HÀNG</th>
                                                        <th>TÊN KHÁCH HÀNG</th>
                                                        <th>SỐ ĐIỆN THOẠI</th>
                                                        <th>EMAIL</th>
                                                        <th>NGÀY SINH</th>
                                                        <th>GIỚI TÍNH</th>
                                                        <th>ĐỊA CHỈ MẶC ĐỊNH</th>
                                                        <th style="text-align: center; width: 120px;">TRẠNG THÁI</th>
                                                        <th style="text-align: center; width: 140px;">HÀNH ĐỘNG</th>
                                                    </tr>
                                                </thead>
                                                <%-- Duyệt qua danh sách khách hàng được truyền từ Servlet Controller --%>
                                                <% List<Customer> customers = (List<Customer>)
                                                        request.getAttribute("customers");
                                                        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                                                        if (customers != null && !customers.isEmpty()) {
                                                        int stt = 1;
                                                        for (Customer c : customers) {
                                                        %>
                                                        <%-- Khi click vào dòng thì chuyển hướng sang trang xem chi tiết khách hàng --%>
                                                        <tr>
                                                                <td
                                                                    style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 600; color: #475569; text-align: center;">
                                                                    <%= stt++ %>
                                                                </td>
                                                                <td
                                                                    style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 600; color: #1e293b;">
                                                                    <%= c.getId() %>
                                                                </td>
                                                                <td>
                                                                    <div
                                                                        style="display: flex; align-items: center; gap: 12px;">
                                                                        <img src="<%= c.getAvatar() %>"
                                                                            class="customer-avatar-img" alt="avatar"
                                                                            style="border: 1px solid #d1d5db;">
                                                                        <span style="font-weight: 600; color: #1e293b;">
                                                                            <%= c.getFullName() %>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                                <td
                                                                    style="font-family: 'Inter', sans-serif; font-size: 14px; font-weight: 500; color: #334155;">
                                                                    <%= c.getPhoneNumber() %>
                                                                </td>
                                                                <td style="color: #475569; font-size: 13px;">
                                                                    <%= c.getEmail() %>
                                                                </td>
                                                                <td style="color: #64748B;">
                                                                    <%= c.getDateOfBirth() != null ?
                                                                        df.format(c.getDateOfBirth()) : "N/A" %>
                                                                </td>
                                                                <td style="color: #475569; font-weight: 500;">
                                                                    <%= c.getGender() %>
                                                                </td>
                                                                <td style="color: #475569; font-size: 13px; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                                    title="<%= (c.getDefaultAddress() != null) ? c.getDefaultAddress().getAddressDetail() : "" %>">
                                                                    <%= (c.getDefaultAddress() != null) ?
                                                                        c.getDefaultAddress().getAddressDetail() : "N/A"
                                                                        %>
                                                                </td>
                                                                <td style="text-align: center;">
                                                                    <% if ("Hoạt động".equalsIgnoreCase(c.getStatus())) { %>
                                                                        <span class="badge-status available">Hoạt động</span>
                                                                    <% } else { %>
                                                                        <span class="badge-status out_of_stock">Khóa</span>
                                                                    <% } %>
                                                                </td>
                                                                <td style="text-align: center;">
                                                                    <div style="display: flex; justify-content: center; gap: 4px; align-items: center;">
                                                                        <a class="action-icon-btn details-btn"
                                                                            title="Xem chi tiết"
                                                                            href="<%= contextPath %>/admin/customers?action=details&id=<%= c.getId() %>"
                                                                            onclick="event.stopPropagation()">
                                                                            <svg viewBox="0 0 24 24" width="16"
                                                                                height="16" stroke="currentColor"
                                                                                stroke-width="2.2" fill="none"
                                                                                stroke-linecap="round"
                                                                                stroke-linejoin="round">
                                                                                <path
                                                                                    d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z">
                                                                                </path>
                                                                                <circle cx="12" cy="12" r="3"></circle>
                                                                            </svg>
                                                                        </a>
                                                                        <a class="action-icon-btn edit-btn"
                                                                            title="Sửa"
                                                                            href="<%= contextPath %>/admin/customers?action=edit-form&id=<%= c.getId() %>"
                                                                            onclick="event.stopPropagation()">
                                                                            <svg viewBox="0 0 24 24" width="16"
                                                                                height="16" stroke="currentColor"
                                                                                stroke-width="2.2" fill="none"
                                                                                stroke-linecap="round"
                                                                                stroke-linejoin="round">
                                                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                                <path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                                            </svg>
                                                                        </a>
                                                                        <label class="switch" title="<%= "Hoạt động".equalsIgnoreCase(c.getStatus()) ? "Khóa tài khoản" : "Kích hoạt tài khoản" %>" onclick="event.stopPropagation();" style="margin-left: 4px;">
                                                                            <input type="checkbox"
                                                                                <%= "Hoạt động".equalsIgnoreCase(c.getStatus()) ? "checked" : "" %>
                                                                                onchange="toggleCustomerStatus('<%= c.getId() %>')">
                                                                            <span class="slider"></span>
                                                                        </label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <% } } else { %>
                                                                <tr>
                                                                    <td colspan="12"
                                                                        style="text-align: center; padding: 40px; color: #9ca3af;">
                                                                        Không tìm thấy khách hàng nào.</td>
                                                                </tr>
                                                                <% } %>
                                                            </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>
                                 <script>
                            // HÀM TOGGLE BỘ LỌC
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

                            // HÀM DEBOUNCE SUBMIT: Tránh việc gửi request liên tục lên server khi người dùng đang gõ tìm kiếm.
                            // Form sẽ tự động submit sau 400ms kể từ khi người dùng ngừng gõ phím.
                            let debounceTimer = null;
                            function debouncedSubmit() {
                                clearTimeout(debounceTimer);
                                if (document.activeElement && document.activeElement.id) {
                                    sessionStorage.setItem('lastFocus', document.activeElement.id);
                                }
                                debounceTimer = setTimeout(() => {
                                    document.getElementById('searchForm').submit();
                                }, 400);
                            }

                            // Hàm gửi request thay đổi trạng thái hoạt động của khách hàng
                            function toggleCustomerStatus(customerId) {
                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '<%= contextPath %>/admin/customers';
                                
                                const actionInput = document.createElement('input');
                                actionInput.type = 'hidden';
                                actionInput.name = 'action';
                                actionInput.value = 'toggle-status';
                                form.appendChild(actionInput);
                                
                                const idInput = document.createElement('input');
                                idInput.type = 'hidden';
                                idInput.name = 'id';
                                idInput.value = customerId;
                                form.appendChild(idInput);
                                
                                document.body.appendChild(form);
                                form.submit();
                            }

                            // HÀM RETAIN FOCUS: Đưa con trỏ chuột về lại cuối ô tìm kiếm sau khi trang bị tải lại.
                            document.addEventListener("DOMContentLoaded", function () {
                                const lastFocusId = sessionStorage.getItem('lastFocus');
                                if (lastFocusId) {
                                    const inputToFocus = document.getElementById(lastFocusId);
                                    if (inputToFocus) {
                                        inputToFocus.focus();
                                        const val = inputToFocus.value;
                                        inputToFocus.value = '';
                                        inputToFocus.value = val;
                                    }
                                    sessionStorage.removeItem('lastFocus');
                                }
                            });
                            
                            // Hàm xuất Excel kèm theo các tham số bộ lọc hiện tại
                            function exportExcelFiltered() {
                                const form = document.getElementById('searchForm');
                                const formData = new FormData(form);
                                const params = new URLSearchParams(formData);
                                params.set('action', 'exportExcel');
                                window.location.href = "<%= contextPath %>/admin/customers?" + params.toString();
                            }
                        </script>
                        
                        <%-- Toast thông báo dùng chung --%>
                        <jsp:include page="/WEB-INF/views/layout/toast.jsp" />
                    </body>

                    </html>
