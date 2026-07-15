<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Coupon" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FamiCoats Admin - Quản lý phiếu giảm giá">
    <title>FamiCoats Admin - Quản lý phiếu giảm giá</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<%
    List<Coupon> coupons      = (List<Coupon>) request.getAttribute("coupons");
    Map<Integer,String> typeLabels  = (Map<Integer,String>) request.getAttribute("discountTypeLabels");
    Map<Integer,String> statusLabels    = (Map<Integer,String>) request.getAttribute("statusLabels");
    long   total       = request.getAttribute("total")      != null ? (long) request.getAttribute("total")      : 0;
    int    pageNo      = request.getAttribute("page")       != null ? (int)  request.getAttribute("page")       : 0;
    int    size        = request.getAttribute("size")       != null ? (int)  request.getAttribute("size")       : 10;
    int    totalPages  = request.getAttribute("totalPages") != null ? (int)  request.getAttribute("totalPages") : 1;
    Integer curType    = (Integer) request.getAttribute("currentDiscountType");
    Integer curStatus      = (Integer) request.getAttribute("currentStatus");
    String keyword     = (String)  request.getAttribute("keyword");
    String msg         = request.getParameter("msg");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    StringBuilder baseUrlSb = new StringBuilder(request.getContextPath() + "/admin/coupons?");
    if (curType  != null) baseUrlSb.append("discountType=").append(curType).append("&");
    if (curStatus    != null) baseUrlSb.append("status=").append(curStatus).append("&");
    if (keyword  != null && !keyword.isEmpty())
        baseUrlSb.append("q=").append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
    String baseUrl = baseUrlSb.toString();
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <!-- Navbar -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <span class="active-crumb">Quản lý phiếu giảm giá</span>
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
            <!-- Header row -->
            <div class="cl-header">
                <div class="cl-title">
                    <h1>Quản lý phiếu giảm giá</h1>
                    <p>Tổng <strong><%= total %></strong> phiếu giảm giá</p>
                </div>
                <div class="cl-actions">
                    <a href="${pageContext.request.contextPath}/admin/coupons/add" class="btn-primary" id="btnAddCoupon">
                        <svg viewBox="0 0 24 24" width="15" height="15" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        Thêm mới
                    </a>
                </div>
            </div>

            <!-- Toast message -->
            <% if ("created".equals(msg)) { %>
            <div class="msg-banner success" id="msgBanner">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                Thêm phiếu giảm giá thành công!
            </div>
            <% } else if ("updated".equals(msg)) { %>
            <div class="msg-banner success" id="msgBanner">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                Cập nhật phiếu giảm giá thành công!
            </div>
            <% } %>

            <!-- Search + Filter -->
            <div class="search-filter-row">
                <form id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/coupons"
                      style="display:flex;gap:10px;flex:1;flex-wrap:wrap;align-items:center;">

                    <!-- Ô tìm kiếm -->
                    <div class="search-box" id="searchBox" style="flex:1;min-width:220px;">
                        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        <input type="text" id="searchInput" name="q"
                               placeholder="Nhập mã / tên phiếu giảm giá..."
                               value="<%= keyword != null ? keyword : "" %>"
                               autocomplete="off">
                        <button type="button" class="clear-btn" id="clearBtn" title="Xóa">
                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        </button>
                    </div>

                    <!-- Lọc loại giảm -->
                    <select name="discountType" id="filterType" class="filter-select" onchange="this.form.submit()">
                        <option value="">Tất cả loại giảm</option>
                        <% if (typeLabels != null) {
                            for (Map.Entry<Integer,String> e : typeLabels.entrySet()) { %>
                        <option value="<%= e.getKey() %>" <%= e.getKey().equals(curType) ? "selected" : "" %>><%= e.getValue() %></option>
                        <%  }
                        } %>
                    </select>

                    <!-- Lọc trạng thái -->
                    <select name="status" id="filterStatus" class="filter-select" onchange="this.form.submit()">
                        <option value="">Tất cả trạng thái</option>
                        <% if (statusLabels != null) {
                            for (Map.Entry<Integer,String> e : statusLabels.entrySet()) { %>
                        <option value="<%= e.getKey() %>" <%= e.getKey().equals(curStatus) ? "selected" : "" %>><%= e.getValue() %></option>
                        <%  }
                        } %>
                    </select>
                </form>
            </div>

            <!-- Table -->
            <div class="cl-table-wrap">
                <table class="cl-table">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã giảm giá</th>
                        <th>Tên chương trình</th>
                        <th>Loại giảm</th>
                        <th>Giá trị giảm</th>
                        <th>Đơn hàng tối thiểu</th>
                        <th>Số lượng</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Trạng thái</th>
                        <th style="text-align:center;">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (coupons != null && !coupons.isEmpty()) {
                            int stt = pageNo * size + 1;
                            for (Coupon c : coupons) {
                                String typeBadgeCls = (c.getDiscountType() != null && c.getDiscountType() == 0) ? "phan-tram" : "giam-tien";
                                String typeLabel    = typeLabels != null ? typeLabels.getOrDefault(c.getDiscountType(), "?") : "?";

                                String valueStr;
                                if (c.getDiscountValue() == null) {
                                    valueStr = "—";
                                } else if (c.getDiscountType() != null && c.getDiscountType() == 0) {
                                    valueStr = String.format("%.0f%%", c.getDiscountValue());
                                } else {
                                    valueStr = String.format("%,.0fđ", c.getDiscountValue()).replace(",", ".");
                                }

                                String minOrder = c.getMinOrderValue() != null
                                        ? String.format("%,.0fđ", c.getMinOrderValue()).replace(",", ".")
                                        : "—";

                                int sl  = c.getQuantity()   != null ? c.getQuantity()   : 0;
                                int dsd = c.getUsedQuantity()  != null ? c.getUsedQuantity()  : 0;
                                int pct = sl > 0 ? (int)((double)dsd / sl * 100) : 0;

                                String ngayBD = c.getStartDate()  != null ? c.getStartDate().format(dtf)  : "—";
                                String ngayKT = c.getEndDate() != null ? c.getEndDate().format(dtf) : "—";

                                int tt = c.getStatus() != null ? c.getStatus() : 0;
                                String ttCls, ttLbl;
                                switch (tt) {
                                    case 1:  ttCls = "dang-ap-dung";   ttLbl = "Đang áp dụng";   break;
                                    case 2:  ttCls = "ket-thuc";       ttLbl = "Kết thúc";        break;
                                    case 3:  ttCls = "da-huy";         ttLbl = "Đã huỷ";          break;
                                    default: ttCls = "chua-kich-hoat"; ttLbl = "Chưa kích hoạt";  break;
                                }

                                boolean isOn = (tt == 1);
                    %>
                    <tr>
                        <td><%= stt++ %></td>
                        <td><span class="coupon-code"><%= c.getCode() != null ? c.getCode() : "" %></span></td>
                        <td style="font-weight:600;color:#111827;max-width:180px;">
                            <%= c.getName() != null ? c.getName() : "" %>
                        </td>
                        <td><span class="loai-badge <%= typeBadgeCls %>"><%= typeLabel %></span></td>
                        <td style="font-weight:700;color:#E11D48;"><%= valueStr %></td>
                        <td style="color:#6b7280;"><%= minOrder %></td>
                        <td>
                            <div class="qty-wrap">
                                <div class="qty-text"><%= dsd %>/<%= sl %></div>
                                <div class="qty-bar">
                                    <div class="qty-bar-fill" style="width:<%= pct %>%;"></div>
                                </div>
                            </div>
                        </td>
                        <td style="color:#6b7280;"><%= ngayBD %></td>
                        <td style="color:#6b7280;"><%= ngayKT %></td>
                        <td><span class="tt-badge <%= ttCls %>"><%= ttLbl %></span></td>
                        <td style="text-align:center;">
                            <div style="display:flex;gap:6px;justify-content:center;align-items:center;">
                                <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=<%= c.getId() %>"
                                   class="act-btn edit" title="Chỉnh sửa">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                </a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/coupons/toggle-status"
                                      style="display:inline;" id="toggleForm-<%= c.getId() %>">
                                    <input type="hidden" name="id"        value="<%= c.getId() %>">
                                    <input type="hidden" name="status" value="<%= isOn ? 3 : 1 %>">
                                    <label class="toggle-switch" title="<%= isOn ? "Tắt" : "Bật" %> phiếu">
                                        <input type="checkbox" <%= isOn ? "checked" : "" %>
                                               onchange="document.getElementById('toggleForm-<%= c.getId() %>').submit()">
                                        <span class="toggle-slider"></span>
                                    </label>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr class="empty-row"><td colspan="11">Không có dữ liệu phiếu giảm giá.</td></tr>
                    <%  } %>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="cl-pagination">
                    <span class="info">
                        Hiển thị <strong><%= total > 0 ? (pageNo * size + 1) : 0 %>-<%= Math.min((pageNo + 1) * size, (int) total) %></strong>
                        trong tổng <strong><%= String.format("%,d", total) %></strong> phiếu
                    </span>
                    <div class="paging-btns">
                        <a href="<%= baseUrl %>page=<%= pageNo - 1 %>" class="pg-btn <%= pageNo == 0 ? "disabled" : "" %>">‹</a>
                        <%
                            int startP = Math.max(0, pageNo - 2);
                            int endP   = Math.min(totalPages - 1, pageNo + 2);
                            if (startP > 0) {
                        %><a href="<%= baseUrl %>page=0" class="pg-btn">1</a>
                        <% if (startP > 1) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                        <%  }
                            for (int i = startP; i <= endP; i++) { %>
                        <a href="<%= baseUrl %>page=<%= i %>" class="pg-btn <%= i == pageNo ? "active" : "" %>"><%= i + 1 %></a>
                        <%  }
                            if (endP < totalPages - 1) {
                                if (endP < totalPages - 2) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                        <a href="<%= baseUrl %>page=<%= totalPages - 1 %>" class="pg-btn"><%= totalPages %></a>
                        <%  } %>
                        <a href="<%= baseUrl %>page=<%= pageNo + 1 %>" class="pg-btn <%= pageNo >= totalPages - 1 ? "disabled" : "" %>">›</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    (function() {
        var d    = new Date();
        var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
        var dd   = String(d.getDate()).padStart(2,'0');
        var mm   = String(d.getMonth()+1).padStart(2,'0');
        var el   = document.getElementById('currentDate');
        if (el) el.textContent = days[d.getDay()] + ', ' + dd + '/' + mm + '/' + d.getFullYear();
    })();

    (function () {
        var input    = document.getElementById('searchInput');
        var form     = document.getElementById('searchForm');
        var box      = document.getElementById('searchBox');
        var clearBtn = document.getElementById('clearBtn');
        var timer    = null;

        function updateClearBtn() { box.classList.toggle('has-value', input.value.trim().length > 0); }
        updateClearBtn();

        input.addEventListener('input', function () {
            updateClearBtn();
            clearTimeout(timer);
            timer = setTimeout(function () { form.submit(); }, 450);
        });
        clearBtn.addEventListener('click', function () {
            input.value = ''; updateClearBtn(); clearTimeout(timer); form.submit();
        });
        input.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') { input.value = ''; updateClearBtn(); clearTimeout(timer); form.submit(); }
            if (e.key === 'Enter')  { clearTimeout(timer); form.submit(); }
        });
    })();

    (function () {
        var banner = document.getElementById('msgBanner');
        if (banner) setTimeout(function () {
            banner.style.transition = 'opacity .4s';
            banner.style.opacity = '0';
            setTimeout(function () { banner.remove(); }, 450);
        }, 3000);
    })();
</script>
</body>
</html>
