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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-list.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
<%-- KHU VỰC LOGIC JSP: Xử lý dữ liệu danh sách phiếu giảm giá, bộ lọc và phân trang --%>
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
    String fromDate    = (String)  request.getAttribute("fromDate");
    String toDate      = (String)  request.getAttribute("toDate");
    String msg         = request.getParameter("msg");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    StringBuilder baseUrlSb = new StringBuilder(request.getContextPath() + "/admin/coupons?");
    if (curType  != null) baseUrlSb.append("discountType=").append(curType).append("&");
    if (curStatus    != null) baseUrlSb.append("status=").append(curStatus).append("&");
    if (keyword  != null && !keyword.isEmpty())
        baseUrlSb.append("q=").append(java.net.URLEncoder.encode(keyword, "UTF-8")).append("&");
    if (fromDate != null && !fromDate.isEmpty()) baseUrlSb.append("fromDate=").append(fromDate).append("&");
    if (toDate != null && !toDate.isEmpty()) baseUrlSb.append("toDate=").append(toDate).append("&");
    String baseUrl = baseUrlSb.toString();
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
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
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">A</span>
                    <span>Admin</span>
                </div>
            </div>
        </header>

        <div class="content-wrapper">
                        <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <h1 class="page-title-text">Quản lý phiếu giảm giá</h1>
                    <div class="page-subtitle-text">Tổng <strong><%= total %></strong> phiếu giảm giá</div>
                </div>
            </div>

                        <% if ("created".equals(msg) || "updated".equals(msg)) { %>
            <script>
                document.addEventListener("DOMContentLoaded", function() {
                    if (window.showToast) {
                        window.showToast('<%= "created".equals(msg) ? "Thêm phiếu giảm giá thành công." : "Cập nhật trạng thái phiếu giảm giá thành công." %>', 'success');
                    }
                });
            </script>
            <% } %>

            <!-- KHU VỰC TÌM KIẾM VÀ BỘ LỌC: Lọc theo mã, loại, trạng thái và ngày -->
            <div class="custom-card">
                <div class="card-header-bar">
                    <span class="card-header-title">&#8226; Bộ lọc tìm kiếm</span>
                    <button class="toggle-filter-btn" id="toggleFilterBtn" onclick="toggleFilterCard()">Nhấn để thu gọn</button>
                </div>
                <div class="card-body-content" id="filterCardBody" style="overflow-x: auto;">
                    <form id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/coupons" style="display: flex; gap: 12px; align-items: flex-end; flex-wrap: nowrap; overflow-x: auto; padding-bottom: 8px; width: 100%;">
                        
                        <!-- Trạng thái -->
                        <div class="filter-field" style="min-width: 140px;">
                            <label for="filterStatus">Trạng thái</label>
                            <select name="status" id="filterStatus" class="filter-control" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <% if (statusLabels != null) {
                                    for (Map.Entry<Integer,String> e : statusLabels.entrySet()) { %>
                                <option value="<%= e.getKey() %>" <%= e.getKey().equals(curStatus) ? "selected" : "" %>><%= e.getValue() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>
                        
                        <!-- Loại giảm giá -->
                        <div class="filter-field" style="min-width: 140px;">
                            <label for="filterType">Loại giảm</label>
                            <select name="discountType" id="filterType" class="filter-control" onchange="this.form.submit()">
                                <option value="">Tất cả loại giảm</option>
                                <% if (typeLabels != null) {
                                    for (Map.Entry<Integer,String> e : typeLabels.entrySet()) { %>
                                <option value="<%= e.getKey() %>" <%= e.getKey().equals(curType) ? "selected" : "" %>><%= e.getValue() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <!-- Từ ngày -->
                        <div class="filter-field" style="min-width: 160px;">
                            <label for="fromDateFilter">Từ ngày</label>
                            <div style="display: flex; gap: 8px;">
                                <input type="date" id="fromDateFilter" name="fromDate" class="filter-control" value="<%= fromDate != null ? fromDate : "" %>" onchange="document.getElementById('searchForm').submit()" style="flex: 1;">
                                <% if (fromDate != null && !fromDate.isEmpty()) { %>
                                <button type="button" onclick="document.getElementById('fromDateFilter').value=''; document.getElementById('searchForm').submit();" style="padding: 0 12px; background: #fff; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; color: #64748b;" title="Xoá ngày">✕</button>
                                <% } %>
                            </div>
                        </div>
                        
                        <!-- Đến ngày -->
                        <div class="filter-field" style="min-width: 160px;">
                            <label for="toDateFilter">Đến ngày</label>
                            <div style="display: flex; gap: 8px;">
                                <input type="date" id="toDateFilter" name="toDate" class="filter-control" value="<%= toDate != null ? toDate : "" %>" onchange="document.getElementById('searchForm').submit()" style="flex: 1;">
                                <% if (toDate != null && !toDate.isEmpty()) { %>
                                <button type="button" onclick="document.getElementById('toDateFilter').value=''; document.getElementById('searchForm').submit();" style="padding: 0 12px; background: #fff; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer; color: #64748b;" title="Xoá ngày">✕</button>
                                <% } %>
                            </div>
                        </div>

                        <!-- Tìm kiếm -->
                        <div class="filter-field" style="min-width: 250px;">
                            <label for="searchInput">Tìm kiếm</label>
                            <input type="text" id="searchInput" name="q" class="filter-control" placeholder="Nhập mã / tên..." value="<%= keyword != null ? keyword : "" %>" autocomplete="off" onchange="document.getElementById('searchForm').submit()">
                        </div>
                        
                        <!-- Đặt lại -->
                        <% if ((keyword != null && !keyword.isEmpty()) || curType != null || curStatus != null || (fromDate != null && !fromDate.isEmpty()) || (toDate != null && !toDate.isEmpty())) { %>
                        <div class="filter-field" style="flex-shrink: 0;">
                            <a href="${pageContext.request.contextPath}/admin/coupons" class="btn-reset-filter" id="btnReset" title="Đặt lại toàn bộ bộ lọc" style="display: flex; align-items: center; justify-content: center; gap: 6px; padding: 10px 16px; font-weight: 600; border-radius: 6px; border: 1px solid #cbd5e1; background: #ffffff; color: #475569; text-decoration: none; height: 38px; box-sizing: border-box;">
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
                <a href="${pageContext.request.contextPath}/admin/coupons/export-excel" class="btn-export" style="background-color: #1e293b; border: 1px solid #1e293b; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="8" y1="13" x2="16" y2="13"></line><line x1="8" y1="17" x2="16" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    <span>Xuất Excel</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/coupons/add" class="btn-add" style="background-color: #E11D48; border: 1px solid #E11D48; display: inline-flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none; color: #ffffff; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; height: 38px;">
                    <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    <span>Thêm phiếu giảm giá</span>
                </a>
            </div>

            <!-- KHU VỰC BẢNG DỮ LIỆU PHIẾU GIẢM GIÁ: Hiển thị danh sách các mã giảm giá -->
            <div class="custom-card">
                <div class="card-header-bar">
                    <span class="card-header-title">&#8226; Bảng dữ liệu phiếu giảm giá</span>
                </div>
                <div class="il-table-wrap" style="background:#fff; overflow-x:auto;">
                    <table class="invoice-table" style="width:100%; table-layout: fixed; min-width:780px;">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã giảm giá</th>
                        <th>Tên chương trình</th>
                        <th>Giá trị giảm</th>
                        <th>Đơn hàng tối thiểu</th>
                        <th>Số lượng</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Trạng thái</th>
                        <th style="width: 100px; text-align:center;">Hành động</th>
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
                                    case 1:  ttCls = "dang-ap-dung";   ttLbl = "Đang kích hoạt";   break;
                                    case 2:  ttCls = "ket-thuc";       ttLbl = "Hết hạn";          break;
                                    default: ttCls = "chua-kich-hoat"; ttLbl = "Chưa kích hoạt";   break;
                                }

                                boolean isOn = (tt == 1);
                    %>
                    <tr>
                        <td style="color:#64748b; font-size:13px; text-align:center;"><%= stt++ %></td>
                        <td><span class="product-id-text"><%= c.getCode() != null ? c.getCode() : "" %></span></td>
                        <td style="font-weight:600;color:#111827;max-width:180px;">
                            <%= c.getName() != null ? c.getName() : "" %>
                        </td>
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
                        <td><span class="badge-status <%= ttCls %>"><%= ttLbl %></span></td>
                        <td style="text-align:center;">
                            <div style="display:flex;gap:4px;justify-content:center;align-items:center;">
                                <a href="${pageContext.request.contextPath}/admin/coupons/edit?id=<%= c.getId() %>"
                                   class="action-icon-btn" title="Chỉnh sửa">
                                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                </a>
                              <%--  check time --%>
                                <% boolean isExpired = (c.getEndDate() != null && c.getEndDate().isBefore(java.time.LocalDateTime.now())); %>
                                <form method="post" action="${pageContext.request.contextPath}/admin/coupons/toggle-status"
                                      style="display:inline;" id="toggleForm-<%= c.getId() %>">
                                    <input type="hidden" name="id"        value="<%= c.getId() %>">
                                    <input type="hidden" name="status" value="<%= isOn ? 0 : 1 %>">
                                    <label class="toggle-switch" title="<%= isOn ? "Tắt" : "Bật" %> phiếu">
                                        <input type="checkbox" <%= isOn ? "checked" : "" %>
                                               onchange="toggleCouponStatus('<%= c.getId() %>', <%= isExpired %>, this)">
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
                </div>
                <div class="pagination-container">
                    <a href="<%= baseUrl %>page=<%= pageNo - 1 %>" class="page-btn <%= pageNo == 0 ? "disabled" : "" %>"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="15 18 9 12 15 6"></polyline></svg></a>
                    <%
                        int startP = Math.max(0, pageNo - 2);
                        int endP   = Math.min(totalPages - 1, pageNo + 2);
                        if (startP > 0) {
                    %><a href="<%= baseUrl %>page=0" class="page-btn">1</a>
                    <% if (startP > 1) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                    <%  }
                        for (int i = startP; i <= endP; i++) { %>
                    <a href="<%= baseUrl %>page=<%= i %>" class="page-btn <%= i == pageNo ? "active" : "" %>"><%= i + 1 %></a>
                    <%  }
                        if (endP < totalPages - 1) {
                            if (endP < totalPages - 2) { %><span style="padding:0 4px;color:#9ca3af">...</span><% } %>
                    <a href="<%= baseUrl %>page=<%= totalPages - 1 %>" class="page-btn"><%= totalPages %></a>
                    <%  } %>
                    <a href="<%= baseUrl %>page=<%= pageNo + 1 %>" class="page-btn <%= pageNo >= totalPages - 1 ? "disabled" : "" %>"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polyline points="9 18 15 12 9 6"></polyline></svg></a>
                </div>
                </div>
            </div>
        </div>
    </main>
</div>

<%-- KHU VỰC JAVASCRIPT: Xử lý tìm kiếm delay, toast thông báo, toggle form --%>
<script>
    // Khởi tạo ngày giờ hiện tại cho UI
    (function() {
        var d    = new Date();
        var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
        var dd   = String(d.getDate()).padStart(2,'0');
        var mm   = String(d.getMonth()+1).padStart(2,'0');
        var el   = document.getElementById('currentDate');
        if (el) el.textContent = days[d.getDay()] + ', ' + dd + '/' + mm + '/' + d.getFullYear();
    })();

    // Xử lý tìm kiếm với delay (debounce) và nút xoá
    (function () {
        var input    = document.getElementById('searchInput');
        var form     = document.getElementById('searchForm');
        var box      = document.getElementById('searchBox');
        var clearBtn = document.getElementById('clearBtn');
        var timer    = null;

        // Cập nhật trạng thái hiển thị của nút xoá tìm kiếm
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

    // Xử lý tự động ẩn thông báo thành công sau 3 giây
    (function () {
        var banner = document.getElementById('toastSuccess');
        if (banner) setTimeout(function () {
            banner.style.transition = 'opacity .4s';
            banner.style.opacity = '0';
            setTimeout(function () { banner.remove(); }, 450);
        }, 3000);
    })();
    
    // Thu gọn/mở rộng card bộ lọc
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

    // Hiển thị thông báo lỗi bằng toast
    function showErrorToast(msg) {
        if (window.showToast) {
            window.showToast(msg, 'error');
        } else {
            alert(msg);
        }
    }

    function toggleCouponStatus(couponId, isExpired, checkboxEl) {
        const isChecked = checkboxEl.checked;

        if (isExpired && isChecked) {
            showErrorToast('Phiếu giảm giá đã hết hạn, vui lòng gia hạn trước khi kích hoạt!');
            checkboxEl.checked = false;
            return;
        }

        const targetStatusText = isChecked ? 'hoạt động' : 'vô hiệu hóa';

        Swal.fire({
            title: 'Xác nhận',
            text: 'Bạn có muốn thay đổi trạng thái của phiếu giảm giá thành ' + targetStatusText + ' hay không?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3B82F6',
            cancelButtonColor: '#94A3B8',
            confirmButtonText: 'Đồng ý',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('toggleForm-' + couponId).submit();
            } else {
                checkboxEl.checked = !isChecked; // Rollback
            }
        });
    }
</script>
<jsp:include page="/WEB-INF/views/layout/toast.jsp" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>

