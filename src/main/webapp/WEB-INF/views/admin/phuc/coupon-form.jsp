<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Coupon" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - <%= request.getAttribute("pageTitle") %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<%
    Coupon coupon = (Coupon) request.getAttribute("coupon");
    boolean isEdit      = Boolean.TRUE.equals(request.getAttribute("isEdit"));
    Map<Integer,String> typeLabels = (Map<Integer,String>) request.getAttribute("discountTypeLabels");
    String err = request.getParameter("err");

    DateTimeFormatter isoFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    String code        = (coupon != null && coupon.getCode()        != null) ? coupon.getCode()        : "";
    String name          = (coupon != null && coupon.getName() != null) ? coupon.getName() : "";
    int    discountType       = (coupon != null && coupon.getDiscountType()       != null) ? coupon.getDiscountType()       : 0;
    String discountValue     = (coupon != null && coupon.getDiscountValue()     != null) ? String.valueOf(coupon.getDiscountValue().intValue())     : "";
    String minOrderValue     = (coupon != null && coupon.getMinOrderValue() != null) ? String.valueOf(coupon.getMinOrderValue().intValue()) : "";
    String maxDiscountAmount      = (coupon != null && coupon.getMaxDiscountAmount()     != null) ? String.valueOf(coupon.getMaxDiscountAmount().intValue())     : "";
    String quantity        = (coupon != null && coupon.getQuantity()        != null) ? String.valueOf(coupon.getQuantity())        : "";
    String usedQuantity       = (coupon != null && coupon.getUsedQuantity()       != null) ? String.valueOf(coupon.getUsedQuantity())       : "0";
    String startDate     = (coupon != null && coupon.getStartDate()     != null) ? coupon.getStartDate().format(isoFmt)     : "";
    String endDate    = (coupon != null && coupon.getEndDate()    != null) ? coupon.getEndDate().format(isoFmt)    : "";
    String description           = (coupon != null && coupon.getDescription()           != null) ? coupon.getDescription()           : "";
    int    status      = (coupon != null && coupon.getStatus()      != null) ? coupon.getStatus()      : 1;
    int    couponId       = (coupon != null) ? coupon.getId() : 0;
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <a href="${pageContext.request.contextPath}/admin/coupons" style="color:#6b7280;text-decoration:none;">Quản lý phiếu giảm giá</a>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <span class="active-crumb"><%= isEdit ? "Chỉnh sửa" : "Thêm mới" %></span>
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
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <div>
                    <h1 class="page-title-text"><%= isEdit ? "Chỉnh sửa phiếu giảm giá" : "Thêm phiếu giảm giá mới" %></h1>
                    <div class="page-subtitle-text"><%= isEdit ? "Cập nhật thông tin phiếu giảm giá" : "Tạo chương trình giảm giá công khai mới" %></div>
                </div>
                <a href="${pageContext.request.contextPath}/admin/coupons" class="btn-reset">
                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                    Quay lại
                </a>
            </div>

            <% if ("missing".equals(err)) { %>
            <div class="cf-err">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                Vui lòng điền đầy đủ các trường bắt buộc.
            </div>
            <% } else if ("dup".equals(err)) { %>
            <div class="cf-err">
                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                Mã phiếu giảm giá đã tồn tại. Vui lòng chọn mã khác.
            </div>
            <% } %>

            <div class="cf-card" style="max-width: 960px; width: 100%;">
                <form method="post" action="${pageContext.request.contextPath}/admin/coupons/save" id="couponForm" novalidate>
                    <input type="hidden" name="id" value="<%= couponId %>">

                    <div class="cf-grid" style="gap: 20px 24px; align-items: start;">
                        <!-- Row 1 -->
                        <div class="cf-group">
                            <label class="cf-label" for="name">Tên phiếu giảm giá <span class="req">*</span></label>
                            <input type="text" id="name" name="name" class="cf-input"
                                   placeholder="Tên phiếu giảm giá"
                                   value="<%= name %>"
                                   maxlength="255" required>
                        </div>
                        <div class="cf-group">
                            <label class="cf-label" for="quantity">Số lượng <span class="req">*</span></label>
                            <input type="number" id="quantity" name="quantity" class="cf-input"
                                   placeholder="1"
                                   value="<%= quantity %>"
                                   min="1" step="1" required>
                        </div>

                        <!-- Row 2 -->
                        <div class="cf-group">
                            <label class="cf-label" for="startDate">Ngày bắt đầu <span class="req">*</span></label>
                            <input type="date" id="startDate" name="startDate" class="cf-input"
                                   value="<%= startDate %>" required>
                        </div>
                        <div class="cf-group">
                            <label class="cf-label" for="endDate">Ngày kết thúc <span class="req">*</span></label>
                            <input type="date" id="endDate" name="endDate" class="cf-input"
                                   value="<%= endDate %>" required>
                        </div>

                        <!-- Row 3 -->
                        <div class="cf-group">
                            <label class="cf-label" for="discountType">Loại giảm</label>
                            <select id="discountType" name="discountType" class="cf-select" required onchange="onTypeChange()">
                                <option value="0" <%= discountType == 0 ? "selected" : "" %>>Giảm %</option>
                                <option value="1" <%= discountType == 1 ? "selected" : "" %>>Giảm tiền</option>
                            </select>
                        </div>
                        <div class="cf-group">
                            <label class="cf-label" for="discountValue">Giá trị giảm <span class="req">*</span></label>
                            <div style="position:relative;">
                                <input type="number" id="discountValue" name="discountValue" class="cf-input"
                                       placeholder="1"
                                       value="<%= discountValue %>"
                                       min="0" step="1" required style="padding-right:48px;">
                                <span id="unitLabel" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);
                                    font-size:12px;color:#9ca3af;font-weight:600;pointer-events:none;">
                                    <%= discountType == 0 ? "%" : "VNĐ" %>
                                </span>
                            </div>
                        </div>

                        <!-- Row 4 -->
                        <div class="cf-group" id="maxDiscountGroup" style="<%= discountType == 1 ? "display:none;" : "" %>">
                            <label class="cf-label" for="maxDiscountAmount">Giảm tối đa (VNĐ) <span class="req">*</span></label>
                            <input type="number" id="maxDiscountAmount" name="maxDiscountAmount" class="cf-input"
                                   placeholder="0"
                                   value="<%= maxDiscountAmount %>"
                                   min="0" step="1000">
                        </div>
                        <div class="cf-group" id="minOrderGroup" style="grid-column: <%= discountType == 1 ? "1" : "2" %>;">
                            <label class="cf-label" for="minOrderValue">Đơn hàng tối thiểu</label>
                            <div style="position:relative;">
                                <input type="number" id="minOrderValue" name="minOrderValue" class="cf-input"
                                       placeholder="0"
                                       value="<%= minOrderValue %>"
                                       min="0" step="1000" style="padding-right:48px;">
                                <span style="position:absolute;right:12px;top:50%;transform:translateY(-50%);
                                    font-size:12px;color:#9ca3af;font-weight:600;pointer-events:none;">VNĐ</span>
                            </div>
                        </div>

                        <!-- Row 5 (Extra fields not in image 2 but required) -->
                        <div class="cf-group">
                            <label class="cf-label" for="code">Mã phiếu giảm giá <span class="req">*</span></label>
                            <input type="text" id="code" name="code" class="cf-input"
                                   placeholder="VD: SALE15"
                                   value="<%= code %>"
                                   maxlength="50" required>
                        </div>
                        <% if (isEdit) { %>
                        <div class="cf-group">
                            <label class="cf-label" for="usedQuantity">Đã sử dụng</label>
                            <input type="number" id="usedQuantity" name="usedQuantity" class="cf-input"
                                   value="<%= usedQuantity %>"
                                   min="0" step="1" readonly style="background-color: #f9fafb;">
                        </div>
                        <% } else { %>
                        <div class="cf-group"></div>
                        <% } %>

                        <!-- Row 6 -->
                        <div class="cf-group span2">
                            <label class="cf-label" for="description">Mô tả</label>
                            <textarea id="description" name="description" class="cf-textarea"
                                      placeholder="Nhập mô tả..."><%= description %></textarea>
                        </div>
                        
                        <!-- Row 7 -->
                        <div class="cf-group span2">
                            <label class="cf-label">Trạng thái <span class="req">*</span></label>
                            <div style="display: flex; gap: 24px; align-items: center; margin-top: 6px;">
                                <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; color: #374151;">
                                    <input type="radio" name="status" value="0" <%= status == 0 ? "checked" : "" %> style="accent-color: #3b82f6; width: 16px; height: 16px;"> Chưa kích hoạt
                                </label>
                                <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; color: #374151;">
                                    <input type="radio" name="status" value="1" <%= status == 1 ? "checked" : "" %> style="accent-color: #3b82f6; width: 16px; height: 16px;"> Đang áp dụng
                                </label>
                                <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; color: #374151;">
                                    <input type="radio" name="status" value="2" <%= status == 2 ? "checked" : "" %> style="accent-color: #3b82f6; width: 16px; height: 16px;"> Kết thúc
                                </label>
                                <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; color: #374151;">
                                    <input type="radio" name="status" value="3" <%= status == 3 ? "checked" : "" %> style="accent-color: #3b82f6; width: 16px; height: 16px;"> Đã huỷ
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="cf-actions" style="justify-content: flex-end; padding-top: 16px; margin-top: 8px; border-top: none;">
                        <a href="${pageContext.request.contextPath}/admin/coupons" class="btn-reset" style="padding: 10px 24px; font-weight: 600;">Hủy</a>
                        <button type="submit" class="btn-primary" id="btnSubmit" style="padding: 10px 24px; font-weight: 600; background: #0f172a; border: 1px solid #0f172a; color: #fff; border-radius: 8px; cursor: pointer; transition: all 0.2s;">
                            <%= isEdit ? "Lưu thay đổi" : "Lưu phiếu giảm giá" %>
                        </button>
                    </div>
                </form>
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

    function onTypeChange() {
        var sel    = document.getElementById('discountType');
        var unit   = document.getElementById('unitLabel');
        var grp    = document.getElementById('maxDiscountGroup');
        var isPct  = sel.value === '0';
        unit.textContent  = isPct ? '%' : 'VNĐ';
        grp.style.display = isPct ? '' : 'none';
        if (!isPct) document.getElementById('maxDiscountAmount').value = '';
    }

    document.getElementById('code').addEventListener('input', function() {
        var pos = this.selectionStart;
        this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        this.setSelectionRange(pos, pos);
    });

    document.getElementById('couponForm').addEventListener('submit', function(e) {
        var bd = document.getElementById('startDate').value;
        var kt = document.getElementById('endDate').value;
        if (bd && kt && bd > kt) {
            e.preventDefault();
            alert('Ngày kết thúc phải sau ngày bắt đầu!');
        }
    });
</script>
</body>
</html>
