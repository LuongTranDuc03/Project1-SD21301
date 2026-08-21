<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Invoice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="project.duan1_sd21301.model.huy.Employee" %>
<%
    Employee loggedInUser = (Employee) session.getAttribute("loggedInUser");
    boolean isManager = (loggedInUser != null && loggedInUser.getRoleId() == 1);
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FamiCoats Admin - Quản lý toàn bộ hóa đơn bán hàng">
    <title>FamiCoats Admin - Quản lý hoá đơn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/invoices/invoice-list.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>
<%-- KHU VỰC LOGIC JSP: Khởi tạo và lấy dữ liệu phân trang, lọc hoá đơn từ Request --%>
<%
    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
    long total = request.getAttribute("total") != null ? (long) request.getAttribute("total") : 0;
    int pageNo = request.getAttribute("page") != null ? (int) request.getAttribute("page") : 0;
    int size = request.getAttribute("size") != null ? (int) request.getAttribute("size") : 10;
    int totalPages = request.getAttribute("totalPages") != null ? (int) request.getAttribute("totalPages") : 1;
    Integer currentStatus = (Integer) request.getAttribute("currentOrderStatus");
    Integer currentOrderType = (Integer) request.getAttribute("currentOrderType");
    Map<Integer, String> statusLabels = (Map<Integer, String>) request.getAttribute("orderStatusLabels");

    String keyword = (String) request.getAttribute("keyword");
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    StringBuilder baseUrlSb = new StringBuilder(request.getContextPath() + "/admin/invoices?");
    if (currentStatus != null) baseUrlSb.append("trangThai=").append(currentStatus).append("&");
    if (fromDate != null && !fromDate.isEmpty()) baseUrlSb.append("fromDate=").append(fromDate).append("&");
    if (toDate != null && !toDate.isEmpty()) baseUrlSb.append("toDate=").append(toDate).append("&");
    if (keyword != null && !keyword.isEmpty())
        baseUrlSb.append("q=").append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
    Integer currentPaymentMethodId = (Integer) request.getAttribute("currentPaymentMethodId");
    if (currentPaymentMethodId != null) baseUrlSb.append("paymentMethodId=").append(currentPaymentMethodId).append("&");
    if (currentOrderType != null) baseUrlSb.append("orderType=").append(currentOrderType).append("&");
    String baseUrl = baseUrlSb.toString();

    java.util.function.BiFunction<Integer, Integer, String> badgeClass = (s, type) -> {
        if (s == null) return "cho-xu-ly";
        if (s == 3) return "da-huy";
        if (s == 2) return "hoan-thanh";
        if (s == 1) return "da-xac-nhan";
        return "cho-xu-ly";
    };
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp"/>

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span>
                <span>/</span>
                <span class="active-crumb">Quản lý hoá đơn</span>
            </div>
            <div class="navbar-right">
                <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="page-header"
                 style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <div>
                    <h1>Quản lý hoá đơn</h1>
                    <div class="subtitle">Tổng <%= total %> hoá đơn</div>
                </div>

            </div>

            <!-- KHU VỰC TÌM KIẾM VÀ BỘ LỌC: Tìm kiếm theo mã, khách hàng, ngày tháng và trạng thái -->
            <div class="custom-card">
                <div class="card-header-bar">
                                            <span class="card-header-title">&#8226; Bộ lọc tìm
                                                kiếm</span>
                    <button class="toggle-filter-btn" id="toggleFilterBtn"
                            onclick="toggleFilterCard()">Nhấn để thu gọn
                    </button>
                </div>
                <div class="card-body-content" id="filterCardBody">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-list.css">
                    <form id="searchForm" method="get"
                          action="${pageContext.request.contextPath}/admin/invoices"
                          class="filter-flex-grid" style="display: flex; flex-wrap: wrap; align-items: flex-end; gap: 16px 20px;">
                        
                        <!-- Tìm kiếm -->
                        <div class="filter-field" style="min-width: 315px;">
                            <label for="searchInput">Tìm kiếm</label>
                            <input type="text" id="searchInput" name="q" class="filter-control" placeholder="Tên KH, SĐT hoặc mã HD..." value="<%= keyword != null ? keyword : "" %>" autocomplete="off">
                        </div>



                        <!-- Từ ngày -->
                        <div class="filter-field" style="min-width: 175px;">
                            <label for="fromDateFilter">Từ ngày</label>
                            <div style="display: flex; gap: 8px;">
                                <input type="date" id="fromDateFilter" name="fromDate" class="filter-control" value="<%= fromDate != null ? fromDate : "" %>" onchange="document.getElementById('searchForm').submit()" style="flex: 1;">
                                <% if (fromDate != null && !fromDate.isEmpty()) { %>
                                <button type="button" onclick="document.getElementById('fromDateFilter').value=''; document.getElementById('searchForm').submit();" style="padding: 0 12px; background: #fff; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; color: #64748b;" title="Xoá ngày">✕</button>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- Đến ngày -->
                        <div class="filter-field" style="min-width: 175px;">
                            <label for="toDateFilter">Đến ngày</label>
                            <div style="display: flex; gap: 8px;">
                                <input type="date" id="toDateFilter" name="toDate" class="filter-control" value="<%= toDate != null ? toDate : "" %>" onchange="document.getElementById('searchForm').submit()" style="flex: 1;">
                                <% if (toDate != null && !toDate.isEmpty()) { %>
                                <button type="button" onclick="document.getElementById('toDateFilter').value=''; document.getElementById('searchForm').submit();" style="padding: 0 12px; background: #fff; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; color: #64748b;" title="Xoá ngày">✕</button>
                                <% } %>
                            </div>
                        </div>


                        
                        <!-- Loại hoá đơn -->
                        <div class="filter-field" style="min-width: 155px;">
                            <label for="orderTypeFilter">Loại đơn hàng</label>
                            <select id="orderTypeFilter" name="orderType" class="filter-control" onchange="document.getElementById('searchForm').submit()">
                                <option value="">-- Tất cả --</option>
                                <option value="0" <%= currentOrderType != null && currentOrderType == 0 ? "selected" : "" %>>Tại quầy</option>
                                <option value="1" <%= currentOrderType != null && currentOrderType == 1 ? "selected" : "" %>>Giao hàng</option>
                            </select>
                        </div>
                        
                        <!-- Phương thức thanh toán -->
                        <div class="filter-field" style="min-width: 175px;">
                            <label for="paymentMethodFilter">Thanh toán</label>
                            <select id="paymentMethodFilter" name="paymentMethodId" class="filter-control" onchange="document.getElementById('searchForm').submit()">
                                <option value="">-- Tất cả --</option>
                                <%
                                    List<project.duan1_sd21301.model.phuc.PaymentMethod> paymentMethods = (List<project.duan1_sd21301.model.phuc.PaymentMethod>) request.getAttribute("paymentMethods");
                                    if (paymentMethods != null) {
                                        for (project.duan1_sd21301.model.phuc.PaymentMethod pm : paymentMethods) {
                                %>
                                <option value="<%= pm.getId() %>" <%= currentPaymentMethodId != null && currentPaymentMethodId.equals(pm.getId()) ? "selected" : "" %>><%= pm.getName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <!-- Trạng thái -->
                        <div class="filter-field" style="min-width: 155px;">
                            <label for="statusFilter">Trạng thái</label>
                            <select id="statusFilter" name="trangThai" class="filter-control" onchange="document.getElementById('searchForm').submit()">
                                <option value="">-- Tất cả --</option>
                                <% if (statusLabels != null) {
                                    for (Map.Entry<Integer, String> e : statusLabels.entrySet()) { %>
                                <option value="<%= e.getKey() %>" <%= e.getKey().equals(currentStatus) ? "selected" : "" %>><%= e.getValue() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <!-- Đặt lại -->
                        <% if ((keyword != null && !keyword.isEmpty()) || currentStatus != null || currentOrderType != null || currentPaymentMethodId != null || (fromDate != null && !fromDate.isEmpty()) || (toDate != null && !toDate.isEmpty())) { %>
                        <div class="filter-field" style="flex-shrink: 0;">
                            <a href="${pageContext.request.contextPath}/admin/invoices" class="btn-reset-filter" title="Đặt lại toàn bộ bộ lọc" style="display: flex; align-items: center; justify-content: center; gap: 6px; padding: 10px 16px; font-weight: 600; border-radius: 6px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; text-decoration: none; height: 38px; box-sizing: border-box;">
                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 .49-4.5"/></svg>
                                Đặt lại
                            </a>
                        </div>
                        <% } %>
                    </form>


                </div>
            </div>

            <!-- Thanh nút thao tác -->
            <div style="display: flex; justify-content: flex-end; align-items: center; gap: 10px; margin: 16px 0;">
                <%
                    StringBuilder exportUrl = new StringBuilder(request.getContextPath() + "/admin/invoices/export-excel?_=1");
                    if (currentStatus != null) exportUrl.append("&trangThai=").append(currentStatus);
                    if (fromDate != null && !fromDate.isEmpty())
                        exportUrl.append("&fromDate=").append(fromDate);
                    if (toDate != null && !toDate.isEmpty()) exportUrl.append("&toDate=").append(toDate);
                    if (keyword != null && !keyword.isEmpty())
                        exportUrl.append("&q=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
                    if (currentPaymentMethodId != null)
                        exportUrl.append("&paymentMethodId=").append(currentPaymentMethodId);
                    if (currentOrderType != null)
                        exportUrl.append("&orderType=").append(currentOrderType);
                %>
                <a href="<%= exportUrl %>" class="btn-export" id="btnExportExcel" title="Xuất danh sách hóa đơn ra Excel" style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="8" y1="13" x2="16" y2="13"></line>
                        <line x1="8" y1="17" x2="16" y2="17"></line>
                        <polyline points="10 9 9 9 8 9"></polyline>
                    </svg>
                    <span>Xuất Excel</span>
                </a>

                <a href="${pageContext.request.contextPath}/admin/pos" class="btn-add" style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Thêm hóa đơn</span>
                </a>
            </div>

            <!-- KHU VỰC BẢNG DỮ LIỆU HOÁ ĐƠN: Hiển thị danh sách hoá đơn dựa trên bộ lọc -->
            <div class="custom-card">
                <div class="card-header-bar" style="display: flex; justify-content: space-between; align-items: center;">
                                            <span class="card-header-title">&#8226; Bảng dữ liệu hoá đơn</span>
                </div>

                <div class="card-body-content" style="padding: 0;">
                    <div style="overflow-x: auto; width: 100%;">
                    <table class="invoice-table"
                           style="width:100%; min-width:1000px;">
                        <colgroup>
                            <col style="width: 5%;">
                            <col style="width: 8%;">
                            <col style="width: 10%;">
                            <col style="width: 15%;">
                            <col style="width: 10%;">
                            <col style="width: 7%;">
                            <col style="width: 10%;">
                            <col style="width: 10%;">
                            <col style="width: 8%;">
                            <col style="width: 10%;">
                            <col style="width: 7%;">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã HD</th>
                            <th>Mã nhân viên</th>
                            <th>Khách hàng</th>
                            <th>Số điện thoại</th>
                            <th>Loại đơn</th>
                            <th>Tổng tiền</th>
                            <th>Ngày đặt</th>
                            <th>Thanh toán</th>
                            <th style="text-align:center;">Trạng thái</th>
                            <th
                                    style="width: 100px; text-align:center;">
                                Thao tác
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (invoices != null && !invoices.isEmpty()) {
                            int stt = 1;
                            for (Invoice inv : invoices) {
                                int s = inv.getOrderStatus();
                                Integer type = inv.getOrderType();
                                String bCls = badgeClass.apply(s, type);
                                String bLbl = statusLabels.getOrDefault(s, "?");
                                String total2 = inv.getTotalAmount() != null ?
                                        String.format("%,.0fđ",
                                                inv.getTotalAmount()).replace(",", ".")
                                        : "—";
                                String orderDate = inv.getOrderDate()
                                        != null ? inv.getOrderDate().format(dtf)
                                        : "—";
                                String
                                        custName = inv.getCustomerName() != null ?
                                        inv.getCustomerName() : "";
                                String
                                        custPhone = inv.getCustomerPhone() != null ?
                                        inv.getCustomerPhone() : "";
                                String
                                        payMethod = inv.getPaymentMethod() != null ?
                                        inv.getPaymentMethod().getName() : "—"; %>
                        <tr>
                            <td
                                    style="color:#64748b; font-size:13px; text-align:center;">
                                <%= pageNo * size + (stt++) %>
                            </td>
                            <td><span class="product-id-text"><%= inv.getCode() %></span></td>
                            <% String fakeStaffCode = "NV00" + ((inv.getId() % 3) + 1); %>
                            <td><span
                                    style="color:#6b7280;"><%= fakeStaffCode %></span>
                            </td>
                            <td>
                                <div class="customer-name">
                                    <%= custName %>
                                </div>
                            </td>
                            <td>
                                <div class="customer-phone"
                                     style="margin-top:0;color:#374151;">
                                    <%= custPhone %>
                                </div>
                            </td>
                            <td>
                                <span style="padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500; <%= (type != null && type == 0) ? "background: #fef3c7; color: #d97706;" : "background: #dbeafe; color: #2563eb;" %>">
                                    <%= (type != null && type == 0) ? "Tại quầy" : "Giao hàng" %>
                                </span>
                            </td>
                            <td
                                    style="font-weight:700;color:#111827;">
                                <%= total2 %>
                            </td>
                            <td style="color:#6b7280;">
                                <%= orderDate %>
                            </td>
                            <td style="color:#374151;">
                                <%= payMethod %>
                            </td>
                            <td style="text-align:center;"><span
                                    class="badge-status <%= bCls %>">
                                                                    <%= bLbl %>
                                                                </span></td>
                            <td style="text-align:center;">
                                <div
                                        style="display:flex;gap:4px;justify-content:center;">
                                    <a href="${pageContext.request.contextPath}/admin/invoices/detail?id=<%= inv.getId() %>"
                                       class="action-icon-btn edit-btn"
                                       title="Chỉnh sửa hoá đơn"
                                       style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
                                        <svg viewBox="0 0 24 24"
                                             width="16" height="16"
                                             stroke="currentColor"
                                             stroke-width="2.2"
                                             fill="none"
                                             stroke-linecap="round"
                                             stroke-linejoin="round">
                                            <path
                                                    d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7">
                                            </path>
                                            <path
                                                    d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z">
                                            </path>
                                        </svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/invoices/print?id=<%= inv.getId() %>"
                                       target="_blank"
                                       class="action-icon-btn"
                                       title="In hoá đơn"
                                       style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; color: #10B981;">
                                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                             stroke-width="2.2" fill="none" stroke-linecap="round"
                                             stroke-linejoin="round">
                                            <polyline points="6 9 6 2 18 2 18 9"/>
                                            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                                            <rect x="6" y="14" width="12" height="8"/>
                                        </svg>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <% }
                        } else { %>
                        <tr class="empty-row">
                            <td colspan="10">Không có dữ liệu
                                hoá đơn.
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    </div>
            </div>

            <!-- KHU VỰC PHÂN TRANG: Hiển thị thông tin phân trang và các nút chuyển trang -->
            <div class="pagination-wrapper" style="display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; margin-top: 10px;">
                <div id="paginationInfo" style="color: #64748b; font-size: 13px;">
                    Hiển thị <strong><%= total > 0 ? (pageNo * size + 1) : 0 %>-<%= Math.min((pageNo + 1) * size, (int) total) %></strong>
                    trong tổng <strong><%= String.format("%,d", total) %></strong> đơn hàng
                </div>
                <div id="paginationContainer" class="pagination-container" style="padding: 0; margin-top: 0;">
                    <a href="<%= baseUrl %>page=<%= pageNo - 1 %>" class="page-btn <%= pageNo == 0 ? "disabled" : "" %>"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="15 18 9 12 15 6"></polyline></svg></a>
                    <%
                        int displayTotalPages = Math.max(1, totalPages);
                        int startPage = Math.max(0, pageNo - 2);
                        int endPage = Math.min(displayTotalPages - 1, pageNo + 2);
                        if (startPage > 0) {
                    %><a href="<%= baseUrl %>page=0" class="page-btn">1</a>
                    <% if (startPage > 1) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                    <% }
                        for (int i = startPage; i <= endPage; i++) { %>
                    <a href="<%= baseUrl %>page=<%= i %>" class="page-btn <%= i == pageNo ? "active" : "" %>"><%= i + 1 %></a>
                    <% }
                        if (endPage < displayTotalPages - 1) {
                            if (endPage < displayTotalPages - 2) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                    <a href="<%= baseUrl %>page=<%= displayTotalPages - 1 %>" class="page-btn"><%= displayTotalPages %></a>
                    <% } %>
                    <a href="<%= baseUrl %>page=<%= pageNo + 1 %>" class="page-btn <%= pageNo >= displayTotalPages - 1 ? "disabled" : "" %>"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="9 18 15 12 9 6"></polyline></svg></a>
                </div>
            </div>
            </div>
        </div>
</main>

<%-- KHU VỰC JAVASCRIPT: Xử lý đồng hồ, submit form tìm kiếm và các sự kiện UI khác --%>
<script src="${pageContext.request.contextPath}/assets/js/invoices/invoice-list.js"></script>
</body>

</html>

