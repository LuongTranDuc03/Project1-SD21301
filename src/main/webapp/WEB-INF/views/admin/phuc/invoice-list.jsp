<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Invoice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FamiCoats Admin - Quản lý toàn bộ hóa đơn bán hàng">
    <title>FamiCoats Admin - Quản lý hoá đơn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-list.css">
</head>
<body>
<%
    List<Invoice> invoices           = (List<Invoice>) request.getAttribute("invoices");
    Map<Integer, String> statusLabels = (Map<Integer, String>) request.getAttribute("orderStatusLabels");
    long total          = request.getAttribute("total")              != null ? (long) request.getAttribute("total")              : 0;
    int  pageNo         = request.getAttribute("page")               != null ? (int)  request.getAttribute("page")               : 0;
    int  size           = request.getAttribute("size")               != null ? (int)  request.getAttribute("size")               : 10;
    int  totalPages     = request.getAttribute("totalPages")         != null ? (int)  request.getAttribute("totalPages")         : 1;
    Integer currentStatus = (Integer) request.getAttribute("currentOrderStatus");
    String keyword        = (String)  request.getAttribute("keyword");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    String baseUrl = request.getContextPath() + "/admin/invoices?"
            + (currentStatus != null ? "trangThai=" + currentStatus + "&" : "")
            + (keyword != null && !keyword.isEmpty() ? "q=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&" : "");

    java.util.function.Function<Integer, String> badgeClass = (s) -> {
        if (s == null)  return "cho-xu-ly";
        if (s == 4)     return "da-huy";
        if (s == 3)     return "hoan-thanh";
        if (s == 2)     return "dang-giao";
        if (s == 1)     return "da-xac-nhan";
        return "cho-xu-ly";
    };
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <span class="active-crumb">Quản lý hoá đơn</span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn" aria-label="Thông báo">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    <span class="notif-badge"></span>
                </button>
                <div class="date-pill" id="currentDate"></div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="il-header">
                <div class="il-title">
                    <h1>Quản lý hoá đơn</h1>
                    <p>Tổng <strong><%= total %></strong> hoá đơn</p>
                </div>
                <div class="cl-actions">
                    <%
                        StringBuilder exportUrl = new StringBuilder(request.getContextPath() + "/admin/invoices/export-excel?_=1");
                        if (currentStatus != null) exportUrl.append("&trangThai=").append(currentStatus);
                        if (keyword != null && !keyword.isEmpty()) {
                            exportUrl.append("&q=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
                        }
                    %>
                    <a href="<%= exportUrl %>" class="btn-excel" id="btnExportExcel" title="Xuất danh sách hóa đơn ra Excel">
                        <svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                            <polyline points="10 9 9 9 8 9"/>
                        </svg>
                        Xuất Excel
                    </a>
                </div>
            </div>


            <!-- Search + Filter -->
            <div class="search-filter-row">
                <form id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/invoices" style="display:flex;flex:1;min-width:260px;">
                    <% if (currentStatus != null) { %><input type="hidden" name="trangThai" value="<%= currentStatus %>"><% } %>
                    <div class="search-box" id="searchBox" style="flex:1;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="text" id="searchInput" name="q"
                               placeholder="Tên khách hàng, SĐT hoặc mã HD (VD: 123)..."
                               value="<%= keyword != null ? keyword : "" %>"
                               autocomplete="off">
                        <button type="button" class="clear-btn" id="clearBtn" title="Xóa">
                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </div>
                </form>
                <div class="filter-tabs">
                    <a href="${pageContext.request.contextPath}/admin/invoices"               class="filter-tab <%= currentStatus == null          ? "active" : "" %>">Tất cả</a>
                    <a href="${pageContext.request.contextPath}/admin/invoices?trangThai=0"   class="filter-tab <%= Integer.valueOf(0).equals(currentStatus) ? "active" : "" %>">Chờ xác nhận</a>
                    <a href="${pageContext.request.contextPath}/admin/invoices?trangThai=1"   class="filter-tab <%= Integer.valueOf(1).equals(currentStatus) ? "active" : "" %>">Đã xác nhận</a>
                    <a href="${pageContext.request.contextPath}/admin/invoices?trangThai=2"   class="filter-tab <%= Integer.valueOf(2).equals(currentStatus) ? "active" : "" %>">Đang giao</a>
                    <a href="${pageContext.request.contextPath}/admin/invoices?trangThai=3"   class="filter-tab <%= Integer.valueOf(3).equals(currentStatus) ? "active" : "" %>">Hoàn thành</a>
                    <a href="${pageContext.request.contextPath}/admin/invoices?trangThai=4"   class="filter-tab <%= Integer.valueOf(4).equals(currentStatus) ? "active" : "" %>">Đã huỷ</a>
                </div>
            </div>

            <!-- Table -->
            <div class="il-table-wrap">
                <table class="il-table">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã HD</th>
                        <th>Khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Tổng tiền</th>
                        <th>Ngày đặt</th>
                        <th>Thanh toán</th>
                        <th>Trạng thái</th>
                        <th style="text-align:center;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (invoices != null && !invoices.isEmpty()) {
                            int stt = 1;
                            for (Invoice inv : invoices) {
                                int s        = inv.getOrderStatus();
                                String bCls  = badgeClass.apply(s);
                                String bLbl  = statusLabels != null ? statusLabels.getOrDefault(s, "?") : "?";
                                String total2  = inv.getTotalAmount() != null
                                        ? String.format("%,.0fđ", inv.getTotalAmount()).replace(",", ".") : "—";
                                String orderDate = inv.getOrderDate() != null ? inv.getOrderDate().format(dtf) : "—";
                                String custName  = inv.getCustomerName()  != null ? inv.getCustomerName()  : "";
                                String custPhone = inv.getCustomerPhone() != null ? inv.getCustomerPhone() : "";
                                String payMethod = inv.getPaymentMethod() != null ? inv.getPaymentMethod().getName() : "—";
                    %>
                    <tr>
                        <td><%= pageNo * size + (stt++) %></td>
                        <td><span class="hd-id">HD<%= inv.getId() %></span></td>
                        <td><div class="customer-name"><%= custName %></div></td>
                        <td><div class="customer-phone" style="margin-top:0;color:#374151;"><%= custPhone %></div></td>
                        <td style="font-weight:700;color:#111827;"><%= total2 %></td>
                        <td style="color:#6b7280;"><%= orderDate %></td>
                        <td style="color:#374151;"><%= payMethod %></td>
                        <td><span class="badge <%= bCls %>"><%= bLbl %></span></td>
                        <td style="text-align:center;">
                            <div style="display:flex;gap:6px;justify-content:center;">
                                <a href="${pageContext.request.contextPath}/admin/invoices/detail?id=<%= inv.getId() %>"
                                   class="act-btn view" title="Xem chi tiết">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else { %>
                    <tr class="empty-row"><td colspan="9">Không có dữ liệu hoá đơn.</td></tr>
                    <% } %>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="il-pagination">
                    <span class="info">
                        Hiển thị <strong><%= total > 0 ? (pageNo * size + 1) : 0 %>-<%= Math.min((pageNo + 1) * size, (int) total) %></strong>
                        trong tổng <strong><%= String.format("%,d", total) %></strong> đơn hàng
                    </span>
                    <div class="paging-btns">
                        <a href="<%= baseUrl %>page=<%= pageNo - 1 %>" class="pg-btn <%= pageNo == 0 ? "disabled" : "" %>">‹</a>
                        <%
                            int startPage = Math.max(0, pageNo - 2);
                            int endPage   = Math.min(totalPages - 1, pageNo + 2);
                            if (startPage > 0) {
                        %><a href="<%= baseUrl %>page=0" class="pg-btn">1</a>
                        <% if (startPage > 1) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                        <% }
                            for (int i = startPage; i <= endPage; i++) { %>
                        <a href="<%= baseUrl %>page=<%= i %>" class="pg-btn <%= i == pageNo ? "active" : "" %>"><%= i + 1 %></a>
                        <%  }
                            if (endPage < totalPages - 1) {
                                if (endPage < totalPages - 2) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                        <a href="<%= baseUrl %>page=<%= totalPages - 1 %>" class="pg-btn"><%= totalPages %></a>
                        <% } %>
                        <a href="<%= baseUrl %>page=<%= pageNo + 1 %>" class="pg-btn <%= pageNo >= totalPages - 1 ? "disabled" : "" %>">›</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    (function() {
        var d = new Date();
        var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
        var dd = String(d.getDate()).padStart(2,'0');
        var mm = String(d.getMonth()+1).padStart(2,'0');
        var el = document.getElementById('currentDate');
        if (el) el.textContent = days[d.getDay()] + ', ' + dd + '/' + mm + '/' + d.getFullYear();
    })();

    (function () {
        var input    = document.getElementById('searchInput');
        var form     = document.getElementById('searchForm');
        var box      = document.getElementById('searchBox');
        var clearBtn = document.getElementById('clearBtn');
        var timer    = null;

        input.focus();
        var len = input.value.length;
        input.setSelectionRange(len, len);

        function updateClearBtn() {
            box.classList.toggle('has-value', input.value.trim().length > 0);
        }
        updateClearBtn();

        input.addEventListener('input', function () {
            updateClearBtn();
            clearTimeout(timer);
            timer = setTimeout(function () { form.submit(); }, 400);
        });
        clearBtn.addEventListener('click', function () {
            input.value = '';
            updateClearBtn();
            clearTimeout(timer);
            form.submit();
        });
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') { input.value = ''; updateClearBtn(); clearTimeout(timer); form.submit(); }
            if (e.key === 'Enter')  { clearTimeout(timer); form.submit(); }
        });
    })();
</script>
</body>
</html>
