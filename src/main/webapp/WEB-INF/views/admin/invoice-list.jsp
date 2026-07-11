<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.HoaDon" %>
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
    <style>
        /* ===== Invoice List Specific Styles ===== */
        .il-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        .il-title h1 { font-size: 22px; font-weight: 700; color: #111827; margin: 0; }
        .il-title p  { font-size: 13px; color: #9ca3af; margin: 4px 0 0; }

        .btn-excel {
            display: inline-flex; align-items: center; gap: 8px;
            background: #E11D48; color: #fff; border: none;
            padding: 10px 18px; border-radius: 8px; font-size: 13px;
            font-weight: 600; cursor: pointer; text-decoration: none;
            transition: background .15s;
        }
        .btn-excel:hover { background: #be123c; }

        /* Search + Filter row */
        .search-filter-row {
            display: flex; gap: 12px; align-items: center;
            flex-wrap: wrap; margin-bottom: 16px;
        }
        .search-box {
            display: flex; align-items: center; gap: 10px;
            background: #fff; border: 1px solid #e5e7eb;
            border-radius: 8px; padding: 9px 14px; flex: 1; min-width: 260px;
        }
        .search-box svg { color: #9ca3af; flex-shrink: 0; }
        .search-box input {
            border: none; outline: none; font-size: 13px;
            color: #374151; width: 100%; font-family: 'Inter', sans-serif;
            background: transparent;
        }
        .search-box input::placeholder { color: #9ca3af; }

        .filter-tabs {
            display: flex; gap: 6px; flex-wrap: wrap;
        }
        .filter-tab {
            padding: 8px 16px; border-radius: 20px; font-size: 13px;
            font-weight: 500; border: 1px solid #e5e7eb; background: #fff;
            color: #374151; cursor: pointer; text-decoration: none;
            transition: all .15s ease; white-space: nowrap;
        }
        .filter-tab:hover { border-color: #E11D48; color: #E11D48; }
        .filter-tab.active { background: #E11D48; border-color: #E11D48; color: #fff; }

        /* Table */
        .il-table-wrap {
            background: #fff; border-radius: 12px;
            border: 1px solid #e5e7eb; overflow: hidden;
        }
        .il-table { width: 100%; border-collapse: collapse; }
        .il-table thead tr { background: #f9fafb; border-bottom: 1px solid #e5e7eb; }
        .il-table th {
            padding: 12px 16px; text-align: left; font-size: 11px;
            font-weight: 700; color: #6b7280; text-transform: uppercase;
            letter-spacing: .04em; white-space: nowrap;
        }
        .il-table tbody tr {
            border-bottom: 1px solid #f3f4f6;
            transition: background .12s;
        }
        .il-table tbody tr:last-child { border-bottom: none; }
        .il-table tbody tr:hover { background: #fafafa; }
        .il-table td {
            padding: 14px 16px; font-size: 13px; color: #374151; vertical-align: middle;
        }

        .hd-id { font-weight: 700; color: #111827; font-size: 13px; }
        .customer-name { font-weight: 600; color: #111827; font-size: 13px; line-height: 1.4; }
        .customer-phone { color: #9ca3af; font-size: 12px; margin-top: 2px; }

        .badge {
            display: inline-flex; align-items: center;
            padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600; white-space: nowrap;
        }
        .badge.hoan-thanh  { background: #dcfce7; color: #166534; }
        .badge.dang-giao   { background: #fef9c3; color: #854d0e; }
        .badge.cho-xu-ly   { background: #e0f2fe; color: #0c4a6e; }
        .badge.da-huy      { background: #fee2e2; color: #991b1b; }
        .badge.da-xac-nhan { background: #ede9fe; color: #5b21b6; }

        /* Action buttons */
        .act-btn {
            display: inline-flex; align-items: center; justify-content: center;
            width: 32px; height: 32px; border-radius: 8px;
            border: 1px solid #e5e7eb; background: #fff;
            cursor: pointer; color: #6b7280; text-decoration: none;
            transition: all .15s;
        }
        .act-btn:hover { border-color: #E11D48; color: #E11D48; }
        .act-btn.view:hover  { border-color: #3b82f6; color: #3b82f6; background: #eff6ff; }
        .act-btn.edit:hover  { border-color: #f59e0b; color: #d97706; background: #fffbeb; }

        /* Pagination */
        .il-pagination {
            display: flex; align-items: center; justify-content: space-between;
            padding: 14px 20px; border-top: 1px solid #f3f4f6; font-size: 13px;
        }
        .il-pagination .info { color: #6b7280; }
        .paging-btns { display: flex; gap: 4px; align-items: center; }
        .pg-btn {
            min-width: 32px; height: 32px; padding: 0 8px;
            border-radius: 6px; border: 1px solid #e5e7eb; background: #fff;
            color: #374151; font-size: 13px; font-weight: 500;
            cursor: pointer; text-decoration: none; display: inline-flex;
            align-items: center; justify-content: center; transition: all .12s;
        }
        .pg-btn:hover { border-color: #E11D48; color: #E11D48; }
        .pg-btn.active { background: #E11D48; border-color: #E11D48; color: #fff; }
        .pg-btn.disabled { opacity: .4; pointer-events: none; }

        .empty-row td { text-align: center; padding: 60px !important; color: #9ca3af; }
    </style>
</head>
<body>
<%
    List<HoaDon> hoaDons = (List<HoaDon>) request.getAttribute("hoaDons");
    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");
    long total = request.getAttribute("total") != null ? (long) request.getAttribute("total") : 0;
    int pageNo  = request.getAttribute("page") != null ? (int) request.getAttribute("page") : 0;
    int size  = request.getAttribute("size") != null ? (int) request.getAttribute("size") : 10;
    int totalPages = request.getAttribute("totalPages") != null ? (int) request.getAttribute("totalPages") : 1;
    Integer currentTrangThai = (Integer) request.getAttribute("currentTrangThai");
    String keyword = (String) request.getAttribute("keyword");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    String baseUrl = request.getContextPath() + "/admin/orders?"
        + (currentTrangThai != null ? "trangThai=" + currentTrangThai + "&" : "")
        + (keyword != null && !keyword.isEmpty() ? "q=" + java.net.URLEncoder.encode(keyword, "UTF-8") + "&" : "");

    // Helper: badge class (compatible Java 11)
    java.util.function.Function<Integer, String> badgeClass = (tt) -> {
        if (tt == null) return "cho-xu-ly";
        if (tt == 3) return "hoan-thanh";
        if (tt == 2) return "dang-giao";
        if (tt == 1) return "da-xac-nhan";
        if (tt == 4) return "da-huy";
        return "cho-xu-ly";
    };
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <!-- Navbar -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span>
                <span style="margin: 0 6px; color:#d1d5db">/</span>
                <span class="active-crumb">Quản lý hoá đơn</span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn" aria-label="Thông báo">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    <span class="notif-badge"></span>
                </button>
                <div class="date-pill">Thứ Ba, 30/06/2026</div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
            <!-- Page header -->
            <div class="il-header">
                <div class="il-title">
                    <h1>Quản lý hoá đơn</h1>
                    <p>Tổng <%= total %> hoá đơn</p>
                </div>
                <button class="btn-excel" onclick="alert('Chức năng xuất Excel đang phát triển')">
                    <svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2.5" fill="none"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    Xuất Excel
                </button>
            </div>

            <!-- Search + Filter -->
            <div class="search-filter-row">
                <form method="get" action="${pageContext.request.contextPath}/admin/orders" style="display:flex;flex:1;min-width:260px;">
                    <% if (currentTrangThai != null) { %><input type="hidden" name="trangThai" value="<%= currentTrangThai %>"><% } %>
                    <div class="search-box" style="flex:1;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="text" name="q" placeholder="Tìm theo mã đơn, khách hàng, sản phẩm..."
                               value="<%= keyword != null ? keyword : "" %>">
                    </div>
                </form>
                <div class="filter-tabs">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="filter-tab <%= currentTrangThai == null ? "active" : "" %>">Tất cả</a>
                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=3" class="filter-tab <%= Integer.valueOf(3).equals(currentTrangThai) ? "active" : "" %>">Hoàn thành</a>
                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=2" class="filter-tab <%= Integer.valueOf(2).equals(currentTrangThai) ? "active" : "" %>">Đang giao</a>
                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=0" class="filter-tab <%= Integer.valueOf(0).equals(currentTrangThai) ? "active" : "" %>">Chờ xử lý</a>
                    <a href="${pageContext.request.contextPath}/admin/orders?trangThai=4" class="filter-tab <%= Integer.valueOf(4).equals(currentTrangThai) ? "active" : "" %>">Đã huỷ</a>
                </div>
            </div>

            <!-- Table -->
            <div class="il-table-wrap">
                <table class="il-table">
                    <thead>
                        <tr>
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
                        if (hoaDons != null && !hoaDons.isEmpty()) {
                            for (HoaDon hd : hoaDons) {
                                int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;
                                String bClass = badgeClass.apply(tt);
                                String bLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";
                                String tongTien = hd.getTongThanhToan() != null
                                    ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—";
                                String ngayDat = hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "—";
                                String tenKH = hd.getTenKhachHang() != null ? hd.getTenKhachHang() : "Khách vãng lai";
                                String sdtKH = hd.getSdtKhachHang() != null ? hd.getSdtKhachHang() : "";
                                String pttt = (hd.getPhuongThucThanhToan() != null) ? hd.getPhuongThucThanhToan().getTenPhuongThuc() : "—";
                                int soLuong = hd.getTongSoLuong() != null ? hd.getTongSoLuong() : 0;
                    %>
                        <tr>
                            <td><span class="hd-id">HD<%= hd.getId() %></span></td>
                            <td>
                                <div class="customer-name"><%= tenKH %></div>
                            </td>
                            <td>
                                <div class="customer-phone" style="margin-top: 0; color: #374151;"><%= sdtKH %></div>
                            </td>
                            <td style="font-weight:700; color:#111827;"><%= tongTien %></td>
                            <td style="color:#6b7280;"><%= ngayDat %></td>
                            <td style="color:#374151;"><%= pttt %></td>
                            <td><span class="badge <%= bClass %>"><%= bLabel %></span></td>
                            <td style="text-align:center;">
                                <div style="display:flex;gap:6px;justify-content:center;">
                                    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=<%= hd.getId() %>"
                                       class="act-btn view" title="Xem chi tiết">
                                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=<%= hd.getId() %>"
                                       class="act-btn edit" title="Cập nhật trạng thái">
                                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <%  }
                        } else { %>
                        <tr class="empty-row"><td colspan="9">Không có dữ liệu hoá đơn.</td></tr>
                    <% } %>
                    </tbody>
                </table>

                <!-- Pagination footer -->
                <div class="il-pagination">
                    <span class="info">
                        Hiển thị <strong><%= total > 0 ? (pageNo * size + 1) : 0 %>-<%= Math.min((pageNo + 1) * size, (int) total) %></strong> trong tổng <strong><%= String.format("%,d", total) %></strong> đơn hàng
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
        </div><!-- /content-wrapper -->
    </main>
</div>
</body>
</html>
