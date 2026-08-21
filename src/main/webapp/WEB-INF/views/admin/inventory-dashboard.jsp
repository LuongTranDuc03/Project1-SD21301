<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>FamiCoats Admin - <%= request.getAttribute("pageTitle") %>
                </title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-list.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-dashboard.css">
            </head>

            <body style="margin: 0; background: var(--bg);">
                <div class="app-container">
                    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

                    <main class="main-content">
                        <header class="navbar">
                            <div class="breadcrumb">
                                <span>FamiCoats</span> / <span>Thống kê</span> / <span class="active-crumb">Tồn
                                    kho</span>
                            </div>
                            <div class="navbar-right">
                                <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                                <div class="date-pill">
                                    <%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %>
                                </div>
                                <div class="profile-pill">
                                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                                </div>
                            </div>
                        </header>

                        <div class="content-wrapper">
                            <% Map<String, Object> kpis = (Map<String, Object>) request.getAttribute("kpis");
                                    int totalVariants = kpis != null && kpis.get("totalVariants") != null ? (int)
                                    kpis.get("totalVariants") : 0;
                                    int totalStock = kpis != null && kpis.get("totalStock") != null ? (int)
                                    kpis.get("totalStock") : 0;
                                    int soldInMonth = kpis != null && kpis.get("soldInMonth") != null ? (int)
                                    kpis.get("soldInMonth") : 0;
                                    int lowStock = kpis != null && kpis.get("lowStock") != null ? (int)
                                    kpis.get("lowStock") : 0;
                                    Integer selMonthKpi = (Integer) request.getAttribute("invMonth");
                                    String monthText = selMonthKpi != null && selMonthKpi > 0 ? "tháng " + selMonthKpi +
                                    "/" + java.time.LocalDate.now().getYear() : "trong tháng này";
                                    %>
                                    <div
                                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px;">
                                        <!-- KPI 1 -->
                                        <div
                                            style="background: #fff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px;">
                                            <div
                                                style="font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; margin-bottom: 12px;">
                                                Tổng biến thể</div>
                                            <div
                                                style="font-size: 28px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">
                                                <%= String.format("%,d", totalVariants) %>
                                            </div>
                                            <div style="font-size: 13px; color: #94a3b8;">đang mở bán</div>
                                        </div>

                                        <!-- KPI 2 -->
                                        <div
                                            style="background: #fff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px;">
                                            <div
                                                style="font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; margin-bottom: 12px;">
                                                Tổng tồn kho</div>
                                            <div
                                                style="font-size: 28px; font-weight: 700; color: #0f172a; margin-bottom: 8px;">
                                                <%= String.format("%,d", totalStock) %>
                                            </div>
                                            <div style="font-size: 13px; color: #94a3b8;">sản phẩm trên kệ</div>
                                        </div>

                                        <!-- KPI 3 -->
                                        <div
                                            style="background: #fff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px;">
                                            <div
                                                style="font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; margin-bottom: 12px;">
                                                Bán trong tháng</div>
                                            <div
                                                style="font-size: 28px; font-weight: 700; color: #10b981; margin-bottom: 8px;">
                                                <%= String.format("%,d", soldInMonth) %>
                                            </div>
                                            <div style="font-size: 13px; color: #94a3b8;">
                                                <%= monthText %>
                                            </div>
                                        </div>

                                        <!-- KPI 4 -->
                                        <div
                                            style="background: #fff; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px;">
                                            <div
                                                style="font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; margin-bottom: 12px;">
                                                Cần nhập gấp</div>
                                            <div
                                                style="font-size: 28px; font-weight: 700; color: #ef4444; margin-bottom: 8px;">
                                                <%= String.format("%,d", lowStock) %>
                                            </div>
                                            <div style="font-size: 13px; color: #94a3b8;">biến thể sắp hết / hết hàng
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Bộ lọc tìm kiếm -->
                                    <div class="custom-card">
                                        <div class="card-header-bar">
                                            <span class="card-header-title">&#8226; Bộ lọc tìm kiếm</span>
                                            <button type="button" class="toggle-filter-btn" id="toggleFilterBtn"
                                                onclick="toggleFilterCard()">Nhấn để thu gọn</button>
                                        </div>
                                        <div class="card-body-content" id="filterCardBody">
                                            <form action="${pageContext.request.contextPath}/admin/inventory-dashboard"
                                                method="GET" id="invFilterForm" class="filter-flex-grid"
                                                style="display: flex; gap: 20px; flex-wrap: wrap; align-items: flex-end;">
                                                <!-- Search input -->
                                                <div class="filter-field" style="min-width: 350px; max-width: 450px;">
                                                    <label for="searchQuery">Tìm kiếm</label>
                                                    <input type="text" name="searchQuery" id="searchQuery" class="filter-control" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>" placeholder="Tên SP, mã CT SP hoặc thuộc tính..." autocomplete="off">
                                                </div>

                                                <div class="filter-field" style="min-width: 140px;">
                                                    <label for="invBrand">Thương hiệu</label>
                                                    <select name="invBrand" id="invBrand" class="filter-control"
                                                        onchange="document.getElementById('invFilterForm').submit()">
                                                        <option value="all">-- Tất cả --</option>
                                                        <% List<Map<String, Object>> brands = (List<Map<String, Object>
                                                                >) request.getAttribute("brands");
                                                                Integer invBrandId = (Integer)
                                                                request.getAttribute("invBrandId");
                                                                if (brands != null) {
                                                                for (Map<String, Object> b : brands) {
                                                                    %>
                                                                    <option value="<%= b.get("id") %>" <%= (invBrandId != null && invBrandId.equals(b.get("id"))) ? "selected" : "" %>><%= b.get("name") %>
                                                                    </option>
                                                                    <% } } %>
                                                    </select>
                                                </div>

                                                <div class="filter-field" style="min-width: 140px;">
                                                    <label for="invMonth">Tháng xem bán ra</label>
                                                    <select name="invMonth" id="invMonth" class="filter-control"
                                                        onchange="document.getElementById('invFilterForm').submit()">
                                                        <option value="all">-- Tất cả --</option>
                                                        <% Integer invMonth=(Integer) request.getAttribute("invMonth");
                                                            for(int i=1; i <=12; i++) { %>
                                                            <option value="<%= i %>" <%=(invMonth !=null && invMonth==i)
                                                                ? "selected" : "" %>>Tháng <%= i %>
                                                            </option>
                                                            <% } %>
                                                    </select>
                                                </div>

                                                <div class="filter-field" style="min-width: 140px;">
                                                    <label for="invStatus">Trạng thái</label>
                                                    <select name="invStatus" id="invStatus" class="filter-control"
                                                        onchange="document.getElementById('invFilterForm').submit()">
                                                        <option value="all">-- Tất cả --</option>
                                                        <option value="1" <%=(request.getAttribute("invStatus") !=null
                                                            && (Integer)request.getAttribute("invStatus")==1)
                                                            ? "selected" : "" %>>Còn hàng</option>
                                                        <option value="2" <%=(request.getAttribute("invStatus") !=null
                                                            && (Integer)request.getAttribute("invStatus")==2)
                                                            ? "selected" : "" %>>Sắp hết</option>
                                                        <option value="0" <%=(request.getAttribute("invStatus") !=null
                                                            && (Integer)request.getAttribute("invStatus")==0)
                                                            ? "selected" : "" %>>Hết hàng</option>
                                                    </select>
                                                </div>

                                                <% boolean hasFilter=(request.getParameter("searchQuery") !=null &&
                                                    !request.getParameter("searchQuery").trim().isEmpty()) ||
                                                    (request.getParameter("invBrand") !=null &&
                                                    !request.getParameter("invBrand").equals("all")) ||
                                                    (request.getParameter("invMonth") !=null &&
                                                    !request.getParameter("invMonth").equals("all")) ||
                                                    (request.getParameter("invStatus") !=null &&
                                                    !request.getParameter("invStatus").equals("all")); if (hasFilter) {
                                                    %>
                                                    <div class="filter-field">
                                                        <a href="${pageContext.request.contextPath}/admin/inventory-dashboard"
                                                            class="btn-reset"
                                                            style="display: inline-flex; align-items: center; gap: 6px; padding: 9px 14px; border-radius: 8px; border: 1px solid #e5e7eb; background: #fff; color: #6b7280; font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; white-space: nowrap; transition: all .15s ease;">
                                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <path
                                                                    d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
                                                                <path d="M3 3v5h5" />
                                                            </svg>
                                                            Đặt lại
                                                        </a>
                                                    </div>
                                                    <% } %>

                                                        <button type="submit" style="display: none;">Submit</button>
                                            </form>
                                        </div>
                                    </div>


                                    <div style="display: flex; justify-content: flex-end; margin-bottom: 16px;">
                                        <% String exportUrl=request.getContextPath()
                                            + "/admin/inventory-dashboard/export-excel" + (request.getQueryString()
                                            !=null ? "?" + request.getQueryString() : "" ); %>
                                            <a href="<%= exportUrl %>" title="Xuất thống kê tồn kho ra Excel"
                                                style="background-color: #10B981; border: 1px solid #10B981; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor"
                                                    stroke-width="2.5" fill="none" stroke-linecap="round"
                                                    stroke-linejoin="round">
                                                    <path
                                                        d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                                                    </path>
                                                    <polyline points="14 2 14 8 20 8"></polyline>
                                                    <line x1="8" y1="13" x2="16" y2="13"></line>
                                                    <line x1="8" y1="17" x2="16" y2="17"></line>
                                                    <polyline points="10 9 9 9 8 9"></polyline>
                                                </svg>
                                                Xuất Excel
                                            </a>
                                    </div>

                                    <div class="custom-card">
                                        <div class="card-header-bar">
                                            <span class="card-header-title">&#8226; Bảng dữ liệu tồn kho</span>
                                        </div>


                                        <div class="table-wrap">
                                            <table class="inventory-table">
                                                <thead>
                                                    <tr>
                                                        <th>STT</th>
                                                        <th>Mã SP</th>
                                                        <th>Mã CT SP</th>
                                                        <th>Sản phẩm</th>
                                                        <th>Thương hiệu</th>
                                                        <th>Thuộc tính</th>
                                                        <th class="center" title="Nhập / Bán / Tồn thật">Nhập · Bán ·
                                                            Tồn</th>
                                                        <th>Trạng thái</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <% List<Map<String, Object>> inventoryStats = (List<Map<String,
                                                            Object>>) request.getAttribute("inventoryStats");
                                                            if (inventoryStats != null && !inventoryStats.isEmpty()) {
                                                            int stt = 1;
                                                            int invPageSize2 = request.getAttribute("invPageSize") !=
                                                            null ? (int) request.getAttribute("invPageSize") : 10;
                                                            int invPage2 = request.getAttribute("invPage") != null ?
                                                            (int) request.getAttribute("invPage") : 1;
                                                            stt = (invPage2 - 1) * invPageSize2 + 1;
                                                            for (Map<String, Object> stat : inventoryStats) {
                                                                int nhap = (int) stat.get("initial");
                                                                int ban = (int) stat.get("sold");
                                                                int ton = (int) stat.get("stock");
                                                                String statusClass = ton >= 10 ? "dang-ap-dung" : (ton >
                                                                0 ? "dang-giao" : "ket-thuc");
                                                                String statusText = ton >= 10 ? "Còn hàng" : (ton > 0 ?
                                                                "Sắp hết" : "Hết hàng");
                                                                %>
                                                                <tr class="<%= ton == 0 ? " row-empty" : "" %>">
                                                                    <td>
                                                                        <%= stt++ %>
                                                                    </td>
                                                                    <td><span class="code">
                                                                            <%= stat.get("productCode") %>
                                                                        </span></td>
                                                                    <td><span class="code">
                                                                            <%= stat.get("variantCode") %>
                                                                        </span></td>
                                                                    <td>
                                                                        <div class="product-name">
                                                                            <%= stat.get("productName") %>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div class="brand-name" style="color: var(--ink-600); font-size: 13px; font-weight: 500;">
                                                                            <%= stat.get("brandName") != null ? stat.get("brandName") : "Không có" %>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div class="attr-tags">
                                                                            <% String attrStr=(String)
                                                                                stat.get("attributes"); if (attrStr
                                                                                !=null && !attrStr.isEmpty()) { String[]
                                                                                attrs=attrStr.split(" - ");
                                                for (String a : attrs) {
                                        %>
                                        <span class=" tag">
                                                                                <%= a %></span>
                                                                                    <% } } %>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div class="nhap-ban-ton">
                                                                            <div class="nbt-cell">
                                                                                <span class="nbt-val blue">
                                                                                    <%= nhap %>
                                                                                </span>
                                                                            </div>
                                                                            <span class="nbt-divider">/</span>
                                                                            <div class="nbt-cell">
                                                                                <span class="nbt-val amber">
                                                                                    <%= ban %>
                                                                                </span>
                                                                            </div>
                                                                            <span class="nbt-divider">/</span>
                                                                            <div class="nbt-cell">
                                                                                <span class="nbt-val teal">
                                                                                    <%= ton %>
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge-status <%= statusClass %>">
                                                                            <%= statusText %>
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                                <% } } else { %>
                                                                    <tr>
                                                                        <td colspan="8"
                                                                            style="padding: 40px; text-align: center; color: var(--ink-400);">
                                                                            Không có biến thể nào phù hợp với bộ lọc.
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <% int invTotalPages=(int) request.getAttribute("invTotalPages"); int
                                            invPage=(int) request.getAttribute("invPage"); int
                                            invPageSize=request.getAttribute("invPageSize") !=null ? (int)
                                            request.getAttribute("invPageSize") : 10; int
                                            invTotalItems=request.getAttribute("invTotalItems") !=null ? (int)
                                            request.getAttribute("invTotalItems") : 0; Integer selMonth=(Integer)
                                            request.getAttribute("invMonth"); if (invTotalPages> 1 || invTotalItems > 0)
                                            {
                                            %>
                                            <div class="pagination-wrapper"
                                                style="display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; border-top: 1px solid var(--border-soft); background: var(--surface);">
                                                <div style="color: var(--ink-600); font-size: 13px;">
                                                    Hiển thị <strong>
                                                        <%= invTotalItems> 0 ? ((invPage - 1) * invPageSize + 1) : 0 %>-
                                                            <%= Math.min(invPage * invPageSize, invTotalItems) %>
                                                    </strong>
                                                    trong tổng <strong>
                                                        <%= String.format("%,d", invTotalItems) %>
                                                    </strong> phiếu
                                                </div>
                                                <div style="display: flex; gap: 4px; align-items: center;">
                                                    <% String paramBase="?" ; String
                                                        searchQ=request.getParameter("searchQuery"); if (searchQ !=null
                                                        && !searchQ.trim().isEmpty()) { paramBase +="searchQuery=" +
                                                        java.net.URLEncoder.encode(searchQ, "UTF-8" ) + "&" ; } if
                                                        (selMonth !=null) paramBase +="invMonth=" + selMonth + "&" ; if
                                                        (request.getAttribute("invBrandId") !=null) paramBase
                                                        +="invBrand=" + request.getAttribute("invBrandId") + "&" ;
                                                        Integer currentStatus=(Integer)
                                                        request.getAttribute("invStatus"); if (currentStatus !=null)
                                                        paramBase +="invStatus=" + currentStatus + "&" ; String
                                                        pageUrlBase=request.getContextPath()
                                                        + "/admin/inventory-dashboard" + paramBase + "invPage=" ; %>
                                                        <a href="<%= pageUrlBase %><%= invPage - 1 %>"
                                                            class="page-btn <%= invPage <= 1 ? " disabled" : "" %>"
                                                            style="display: inline-flex; align-items: center;
                                                            justify-content: center; width: 32px; height: 32px;
                                                            border-radius: 6px; font-size: 14px; text-decoration: none;
                                                            border: 1px solid var(--border); color: <%= invPage <=1
                                                                ? "var(--ink-300)" : "var(--ink-600)" %>;
                                                                pointer-events: <%= invPage <=1 ? "none" : "auto" %>;
                                                                    background: var(--surface);"><svg
                                                                        viewBox="0 0 24 24" width="16" height="16"
                                                                        stroke="currentColor" stroke-width="2"
                                                                        fill="none">
                                                                        <polyline points="15 18 9 12 15 6"></polyline>
                                                                    </svg></a>

                                                        <% int displayTotalPages=Math.max(1, invTotalPages); int
                                                            startPage=Math.max(1, invPage - 2); int
                                                            endPage=Math.min(displayTotalPages, invPage + 2); if
                                                            (startPage> 1) {
                                                            %><a href="<%= pageUrlBase %>1"
                                                                style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; font-size: 14px; text-decoration: none; border: 1px solid var(--border); color: var(--ink-600); background: var(--surface);">1</a>
                                                            <% if (startPage> 2) { %><span
                                                                    style="padding:0 4px;color:var(--ink-400)">...</span>
                                                                <% } %>
                                                                    <% } for (int i=startPage; i <=endPage; i++) { %>
                                                                        <a href="<%= pageUrlBase %><%= i %>"
                                                                            style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; font-size: 14px; text-decoration: none; <%= i == invPage ? "background: var(--brand); color: white; border: 1px solid var(--brand);" : "background: var(--surface); color: var(--ink-600); border: 1px solid var(--border);" %>"><%= i %></a>
                                                                        <% } if (endPage < displayTotalPages) { if
                                                                            (endPage < displayTotalPages - 1) { %><span
                                                                                style="padding:0 4px;color:var(--ink-400)">...</span>
                                                                            <% } %>
                                                                                <a href="<%= pageUrlBase %><%= displayTotalPages %>"
                                                                                    style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 6px; font-size: 14px; text-decoration: none; border: 1px solid var(--border); color: var(--ink-600); background: var(--surface);">
                                                                                    <%= displayTotalPages %>
                                                                                </a>
                                                                                <% } %>

                                                                                    <a href="<%= pageUrlBase %><%= invPage + 1 %>"
                                                                                        class="page-btn <%= invPage >= displayTotalPages ? "disabled" : "" %>"
                                                                                        style="display: inline-flex;
                                                                                        align-items: center;
                                                                                        justify-content: center; width:
                                                                                        32px; height: 32px;
                                                                                        border-radius: 6px; font-size:
                                                                                        14px; text-decoration: none;
                                                                                        border: 1px solid var(--border);
                                                                                        color: <%= invPage>=
                                                                                            displayTotalPages ?
                                                                                            "var(--ink-300)" :
                                                                                            "var(--ink-600)" %>;
                                                                                            pointer-events: <%= invPage >= displayTotalPages ? "none" : "auto" %>;
                                                                                                background:
                                                                                                var(--surface);"><svg
                                                                                                    viewBox="0 0 24 24"
                                                                                                    width="16"
                                                                                                    height="16"
                                                                                                    stroke="currentColor"
                                                                                                    stroke-width="2"
                                                                                                    fill="none">
                                                                                                    <polyline
                                                                                                        points="9 18 15 12 9 6">
                                                                                                    </polyline>
                                                                                                </svg></a>
                                                </div>
                                            </div>
                                            <% } %>

                                                <div class="legend">
                                                    <div class="legend-item"><span class="legend-dot"
                                                            style="background:var(--green)"></span> Còn hàng (&ge; 10)
                                                    </div>
                                                    <div class="legend-item"><span class="legend-dot"
                                                            style="background:var(--yellow)"></span> Sắp hết (&lt; 10)
                                                    </div>
                                                    <div class="legend-item"><span class="legend-dot"
                                                            style="background:var(--red)"></span> Hết hàng (0)</div>
                                                    <div class="legend-item"
                                                        style="margin-left:auto; font-size:11px; color:var(--ink-400)">
                                                        Tồn · Bán: dựa trên đơn hoàn thành & đã thanh toán
                                                    </div>
                                                </div>
                                    </div>
                        </div>
                    </main>
                </div>
                <script>
                    function toggleFilterCard() {
                        var filterCardBody = document.getElementById('filterCardBody');
                        var btn = document.getElementById('toggleFilterBtn');
                        if (filterCardBody.classList.contains('collapsed')) {
                            filterCardBody.classList.remove('collapsed');
                            btn.innerHTML = 'Nhấn để thu gọn';
                        } else {
                            filterCardBody.classList.add('collapsed');
                            btn.innerHTML = 'Nhấn để mở rộng';
                        }
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                        const searchInput = document.getElementById('searchQuery');
                        if (searchInput) {
                            // Focus lại ô tìm kiếm nếu trước đó vừa thao tác tìm kiếm
                            if (sessionStorage.getItem('inventorySearchFocused') === 'true') {
                                searchInput.focus();
                                const val = searchInput.value;
                                if (val) {
                                    // Đưa con trỏ chuột về cuối văn bản
                                    searchInput.setSelectionRange(val.length, val.length);
                                }
                                // Xoá cờ để không bị focus mãi nếu người dùng chuyển tab/tải lại trang tự nhiên
                                sessionStorage.removeItem('inventorySearchFocused');
                            }

                            // Debounce live search
                            let debounceTimer = null;
                            searchInput.addEventListener('input', function() {
                                // Lưu trạng thái đang focus để khi trang load lại vẫn giữ được focus
                                sessionStorage.setItem('inventorySearchFocused', 'true');
                                
                                clearTimeout(debounceTimer);
                                debounceTimer = setTimeout(function() {
                                    document.getElementById('invFilterForm').submit();
                                }, 500); // Đợi 500ms sau khi ngừng gõ mới submit
                            });
                        }
                    });
                </script>
            </body>

            </html>