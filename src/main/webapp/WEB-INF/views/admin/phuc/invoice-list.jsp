<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ page import="project.duan1_sd21301.model.Invoice" %>--%>
<%--<%@ page import="java.util.List" %>--%>
<%--<%@ page import="java.util.Map" %>--%>
<%--<%@ page import="java.time.format.DateTimeFormatter" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="vi">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <meta name="description" content="FamiCoats Admin - Quản lý toàn bộ hóa đơn bán hàng">--%>
<%--    <title>FamiCoats Admin - Quản lý hoá đơn</title>--%>
<%--    <link rel="preconnect" href="https://fonts.googleapis.com">--%>
<%--    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>--%>
<%--    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoice-list.css">--%>
<%--</head>--%>
<%--<body>--%>
<%--<%--%>
<%--    List<Invoice> hoaDons = (List<Invoice>) request.getAttribute("hoaDons");--%>
<%--    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");--%>
<%--    long total = request.getAttribute("total") != null ? (long) request.getAttribute("total") : 0;--%>
<%--    int pageNo  = request.getAttribute("page") != null ? (int) request.getAttribute("page") : 0;--%>
<%--    int size  = request.getAttribute("size") != null ? (int) request.getAttribute("size") : 10;--%>
<%--    int totalPages = request.getAttribute("totalPages") != null ? (int) request.getAttribute("totalPages") : 1;--%>
<%--    Integer currentTrangThai = (Integer) request.getAttribute("currentTrangThai");--%>
<%--    String keyword = (String) request.getAttribute("keyword");--%>

<%--    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");--%>

<%--    String baseUrl = request.getContextPath() + "/admin/orders?"--%>
<%--            + (currentTrangThai != null ? "trangThai=" + currentTrangThai + "&" : "")--%>
<%--            + (keyword != null && !keyword.isEmpty() ? "q=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&" : "");--%>

<%--    // Helper: badge class (compatible Java 11)--%>
<%--    java.util.function.Function<Integer, String> badgeClass = (tt) -> {--%>
<%--        if (tt == null) return "cho-xu-ly";--%>
<%--        if (tt == 3) return "hoan-thanh";--%>
<%--        if (tt == 2) return "dang-giao";--%>
<%--        if (tt == 1) return "da-xac-nhan";--%>
<%--        if (tt == 4) return "da-huy";--%>
<%--        return "cho-xu-ly";--%>
<%--    };--%>
<%--%>--%>
<%--<div class="app-container">--%>
<%--    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />--%>

<%--    <main class="main-content">--%>
<%--        <!-- Navbar -->--%>
<%--        <header class="navbar">--%>
<%--            <div class="breadcrumb">--%>
<%--                <span>FamiCoats Admin</span>--%>
<%--                <span style="margin: 0 6px; color:#d1d5db">/</span>--%>
<%--                <span class="active-crumb">Quản lý hoá đơn</span>--%>
<%--            </div>--%>
<%--            <div class="navbar-right">--%>
<%--                <button class="notif-btn" aria-label="Thông báo">--%>
<%--                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>--%>
<%--                    <span class="notif-badge"></span>--%>
<%--                </button>--%>
<%--                <div class="date-pill">Thứ Ba, 30/06/2026</div>--%>
<%--                <div class="profile-pill">--%>
<%--                    <span class="profile-avatar-mini">A</span>--%>
<%--                    <span>Admin</span>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </header>--%>

<%--        <div class="content-wrapper">--%>
<%--            <!-- Page header -->--%>
<%--            <div class="il-header">--%>
<%--                <div class="il-title">--%>
<%--                    <h1>Quản lý hoá đơn</h1>--%>
<%--                    <p>Tổng <%= total %> hoá đơn</p>--%>
<%--                </div>--%>
<%--                <%--%>
<%--                    // Tạo URL xuất Excel với bộ lọc hiện tại--%>
<%--                    StringBuilder exportUrl = new StringBuilder(request.getContextPath() + "/admin/orders/export-excel?_=1");--%>
<%--                    if (currentTrangThai != null) exportUrl.append("&trangThai=").append(currentTrangThai);--%>
<%--                    if (keyword != null && !keyword.isEmpty()) exportUrl.append("&q=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));--%>
<%--                %>--%>
<%--                <a href="<%= exportUrl %>" class="btn-excel" id="btnExportExcel">--%>
<%--                    <svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2.5" fill="none"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>--%>
<%--                    Xuất Excel--%>
<%--                </a>--%>
<%--            </div>--%>

<%--            <!-- Search + Filter -->--%>
<%--            <div class="search-filter-row">--%>
<%--                <form id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/orders" style="display:flex;flex:1;min-width:260px;">--%>
<%--                    <% if (currentTrangThai != null) { %><input type="hidden" name="trangThai" value="<%= currentTrangThai %>"><% } %>--%>
<%--                    <div class="search-box" id="searchBox" style="flex:1;">--%>
<%--                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>--%>
<%--                        <input type="text" id="searchInput" name="q"--%>
<%--                               placeholder="Tên khách hàng hoặc mã HD (VD: 123)..."--%>
<%--                               value="<%= keyword != null ? keyword : "" %>"--%>
<%--                               autocomplete="off">--%>
<%--                        <button type="button" class="clear-btn" id="clearBtn" title="Xóa">--%>
<%--                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>--%>
<%--                        </button>--%>
<%--                    </div>--%>
<%--                </form>--%>
<%--                <div class="filter-tabs">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders" class="filter-tab <%= currentTrangThai == null ? "active" : "" %>">Tất cả</a>--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=3" class="filter-tab <%= Integer.valueOf(3).equals(currentTrangThai) ? "active" : "" %>">Hoàn thành</a>--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=2" class="filter-tab <%= Integer.valueOf(2).equals(currentTrangThai) ? "active" : "" %>">Đang giao</a>--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=0" class="filter-tab <%= Integer.valueOf(0).equals(currentTrangThai) ? "active" : "" %>">Chờ xử lý</a>--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=4" class="filter-tab <%= Integer.valueOf(4).equals(currentTrangThai) ? "active" : "" %>">Đã huỷ</a>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Table -->--%>
<%--            <div class="il-table-wrap">--%>
<%--                <table class="il-table">--%>
<%--                    <thead>--%>
<%--                    <tr>--%>
<%--                        <th>STT</th>--%>
<%--                        <th>Mã HD</th>--%>
<%--                        <th>Khách hàng</th>--%>
<%--                        <th>Số điện thoại</th>--%>
<%--                        <th>Tổng tiền</th>--%>
<%--                        <th>Ngày đặt</th>--%>
<%--                        <th>Thanh toán</th>--%>
<%--                        <th>Trạng thái</th>--%>
<%--                        <th style="text-align:center;">Thao tác</th>--%>
<%--                    </tr>--%>
<%--                    </thead>--%>
<%--                    <tbody>--%>
<%--                    <%--%>
<%--                        if (hoaDons != null && !hoaDons.isEmpty()) {--%>
<%--                            int sttIndex = 1;--%>
<%--                            for (Invoice hd : hoaDons) {--%>
<%--                                int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;--%>
<%--                                String bClass = badgeClass.apply(tt);--%>
<%--                                String bLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";--%>
<%--                                String tongTien = hd.getTongThanhToan() != null--%>
<%--                                        ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—";--%>
<%--                                String ngayDat = hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "—";--%>
<%--                                String tenKH = hd.getTenKhachHang() != null ? hd.getTenKhachHang() : "";--%>
<%--                                String sdtKH = hd.getSdtKhachHang() != null ? hd.getSdtKhachHang() : "";--%>
<%--                                String pttt = (hd.getPhuongThucThanhToan() != null) ? hd.getPhuongThucThanhToan().getTenPhuongThuc() : "—";--%>
<%--                                int soLuong = hd.getTongSoLuong() != null ? hd.getTongSoLuong() : 0;--%>
<%--                    %>--%>
<%--                    <tr>--%>
<%--                        <td><%= pageNo * size + (sttIndex++) %></td>--%>
<%--                        <td><span class="hd-id">HD<%= hd.getId() %></span></td>--%>
<%--                        <td>--%>
<%--                            <div class="customer-name"><%= tenKH %></div>--%>
<%--                        </td>--%>
<%--                        <td>--%>
<%--                            <div class="customer-phone" style="margin-top: 0; color: #374151;"><%= sdtKH %></div>--%>
<%--                        </td>--%>
<%--                        <td style="font-weight:700; color:#111827;"><%= tongTien %></td>--%>
<%--                        <td style="color:#6b7280;"><%= ngayDat %></td>--%>
<%--                        <td style="color:#374151;"><%= pttt %></td>--%>
<%--                        <td><span class="badge <%= bClass %>"><%= bLabel %></span></td>--%>
<%--                        <td style="text-align:center;">--%>
<%--                            <div style="display:flex;gap:6px;justify-content:center;">--%>
<%--                                <a href="${pageContext.request.contextPath}/admin/orders/detail?id=<%= hd.getId() %>"--%>
<%--                                   class="act-btn view" title="Xem chi tiết">--%>
<%--                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </td>--%>
<%--                    </tr>--%>
<%--                    <%  }--%>
<%--                    } else { %>--%>
<%--                    <tr class="empty-row"><td colspan="9">Không có dữ liệu hoá đơn.</td></tr>--%>
<%--                    <% } %>--%>
<%--                    </tbody>--%>
<%--                </table>--%>

<%--                <!-- Pagination footer -->--%>
<%--                <div class="il-pagination">--%>
<%--                    <span class="info">--%>
<%--                        Hiển thị <strong><%= total > 0 ? (pageNo * size + 1) : 0 %>-<%= Math.min((pageNo + 1) * size, (int) total) %></strong> trong tổng <strong><%= String.format("%,d", total) %></strong> đơn hàng--%>
<%--                    </span>--%>
<%--                    <div class="paging-btns">--%>
<%--                        <a href="<%= baseUrl %>page=<%= pageNo - 1 %>" class="pg-btn <%= pageNo == 0 ? "disabled" : "" %>">‹</a>--%>
<%--                        <%--%>
<%--                            int startPage = Math.max(0, pageNo - 2);--%>
<%--                            int endPage   = Math.min(totalPages - 1, pageNo + 2);--%>
<%--                            if (startPage > 0) {--%>
<%--                        %><a href="<%= baseUrl %>page=0" class="pg-btn">1</a>--%>
<%--                        <% if (startPage > 1) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>--%>
<%--                        <% }--%>
<%--                            for (int i = startPage; i <= endPage; i++) { %>--%>
<%--                        <a href="<%= baseUrl %>page=<%= i %>" class="pg-btn <%= i == pageNo ? "active" : "" %>"><%= i + 1 %></a>--%>
<%--                        <%  }--%>
<%--                            if (endPage < totalPages - 1) {--%>
<%--                                if (endPage < totalPages - 2) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>--%>
<%--                        <a href="<%= baseUrl %>page=<%= totalPages - 1 %>" class="pg-btn"><%= totalPages %></a>--%>
<%--                        <% } %>--%>
<%--                        <a href="<%= baseUrl %>page=<%= pageNo + 1 %>" class="pg-btn <%= pageNo >= totalPages - 1 ? "disabled" : "" %>">›</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--</body>--%>
<%--<script>--%>
<%--    (function () {--%>
<%--        var input    = document.getElementById('searchInput');--%>
<%--        var form     = document.getElementById('searchForm');--%>
<%--        var box      = document.getElementById('searchBox');--%>
<%--        var clearBtn = document.getElementById('clearBtn');--%>
<%--        var timer    = null;--%>


<%--        input.focus();--%>
<%--        var len = input.value.length;--%>
<%--        input.setSelectionRange(len, len);--%>

<%--        // Hiển thị nút X khi ô có giá trị--%>
<%--        function updateClearBtn() {--%>
<%--            if (input.value.trim().length > 0) {--%>
<%--                box.classList.add('has-value');--%>
<%--            } else {--%>
<%--                box.classList.remove('has-value');--%>
<%--            }--%>
<%--        }--%>

<%--        updateClearBtn();--%>

<%--        // Live search: mỗi lần thay đổi (gõ hoặc xóa), chờ 400ms rồi submit--%>
<%--        input.addEventListener('input', function () {--%>
<%--            updateClearBtn();--%>
<%--            clearTimeout(timer);--%>
<%--            timer = setTimeout(function () {--%>
<%--                form.submit();--%>
<%--            }, 400);--%>
<%--        });--%>

<%--        // Nút X: xóa và submit ngay--%>
<%--        clearBtn.addEventListener('click', function () {--%>
<%--            input.value = '';--%>
<%--            updateClearBtn();--%>
<%--            clearTimeout(timer);--%>
<%--            form.submit();--%>
<%--        });--%>

<%--        // Phím Escape: xóa nhanh và submit (tiện lợi hơn bấm X)--%>
<%--        input.addEventListener('keydown', function (e) {--%>
<%--            if (e.key === 'Escape') {--%>
<%--                input.value = '';--%>
<%--                updateClearBtn();--%>
<%--                clearTimeout(timer);--%>
<%--                form.submit();--%>
<%--            }--%>
<%--            if (e.key === 'Enter') {--%>
<%--                clearTimeout(timer);--%>
<%--                form.submit();--%>
<%--            }--%>
<%--        });--%>
<%--    })();--%>
<%--</script>--%>
<%--</html>--%>


