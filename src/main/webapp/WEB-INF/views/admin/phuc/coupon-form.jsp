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
<%-- KHU VỰC LOGIC JSP: Khởi tạo dữ liệu form và kiểm tra trạng thái Edit/Add --%>
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

            <div class="cf-card" style="max-width: 1000px; width: 100%; margin: 0 auto;">
                <form method="post" action="${pageContext.request.contextPath}/admin/coupons/save" id="couponForm" novalidate>
                    <input type="hidden" name="id" value="<%= couponId %>">

                    <!-- SECTION 1: THÔNG TIN CHUNG -->
                    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px;">
                        <h3 class="cf-section-title" style="display: flex; align-items: center; gap: 8px; color: #334155; border-bottom-color: #cbd5e1;">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                            Thông tin chung
                        </h3>
                        <div class="cf-grid" style="gap: 20px 24px; align-items: start;">
                            <div class="cf-group">
                                <label class="cf-label" for="code">Mã phiếu giảm giá <span class="req">*</span></label>
                                <input type="text" id="code" name="code" class="cf-input" value="<%= code %>" maxlength="50" required>
                            </div>
                            <div class="cf-group">
                                <label class="cf-label" for="name">Tên chương trình <span class="req">*</span></label>
                                <input type="text" id="name" name="name" class="cf-input" value="<%= name %>" maxlength="255" required>
                            </div>
                            <div class="cf-group">
                                <label class="cf-label" for="quantity">Số lượng phát hành <span class="req">*</span></label>
                                <input type="number" id="quantity" name="quantity" class="cf-input" value="<%= quantity %>" min="1" step="1" required>
                            </div>
                            <% if (isEdit) { %>
                            <div class="cf-group">
                                <label class="cf-label" for="usedQuantity">Số lượng đã dùng</label>
                                <input type="number" id="usedQuantity" name="usedQuantity" class="cf-input" value="<%= usedQuantity %>" min="0" step="1" readonly style="background-color: #f1f5f9; color: #64748b; font-weight: 600;">
                            </div>
                            <% } else { %>
                            <div class="cf-group"></div>
                            <% } %>
                        </div>
                    </div>

                    <!-- SECTION 2: CẤU HÌNH MỨC GIẢM -->
                    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px; margin-bottom: 24px;">
                        <h3 class="cf-section-title" style="display: flex; align-items: center; gap: 8px; color: #334155; border-bottom-color: #cbd5e1;">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 16 16 12 12 8"></polyline><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                            Cấu hình mức giảm
                        </h3>
                        <div class="cf-grid" style="gap: 20px 24px; align-items: start;">
                            <div class="cf-group">
                                <label class="cf-label" for="discountType">Hình thức giảm</label>
                                <select id="discountType" name="discountType" class="cf-select" required onchange="onTypeChange()">
                                    <option value="0" <%= discountType == 0 ? "selected" : "" %>>Giảm theo phần trăm (%)</option>
                                    <option value="1" <%= discountType == 1 ? "selected" : "" %>>Giảm số tiền cố định (VNĐ)</option>
                                </select>
                            </div>
                            <div class="cf-group">
                                <label class="cf-label" for="discountValue">Mức giảm <span class="req">*</span></label>
                                <div style="position:relative;">
                                    <input type="text" id="discountValue" name="discountValue" class="cf-input" value="<%= discountValue %>" required style="padding-right:48px; font-weight: 600; color: #0f172a;">
                                    <span id="unitLabel" style="position:absolute;right:12px;top:50%;transform:translateY(-50%);font-size:12px;color:#64748b;font-weight:700;pointer-events:none;">
                                        <%= discountType == 0 ? "%" : "VNĐ" %>
                                    </span>
                                </div>
                            </div>
                            <div class="cf-group" id="maxDiscountGroup" style="<%= discountType == 1 ? "display:none;" : "" %>">
                                <label class="cf-label" for="maxDiscountAmount">Giảm tối đa (VNĐ) <span class="req">*</span></label>
                                <input type="text" id="maxDiscountAmount" name="maxDiscountAmount" class="cf-input" value="<%= maxDiscountAmount %>">
                            </div>
                            <div class="cf-group" id="minOrderGroup" style="grid-column: <%= discountType == 1 ? "1" : "2" %>;">
                                <label class="cf-label" for="minOrderValue">Áp dụng cho đơn từ (VNĐ)</label>
                                <div style="position:relative;">
                                    <input type="text" id="minOrderValue" name="minOrderValue" class="cf-input" value="<%= minOrderValue %>" style="padding-right:48px;">
                                    <span style="position:absolute;right:12px;top:50%;transform:translateY(-50%);font-size:12px;color:#64748b;font-weight:700;pointer-events:none;">VNĐ</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 3: THỜI GIAN VÀ MÔ TẢ -->
                    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px;">
                        <h3 class="cf-section-title" style="display: flex; align-items: center; gap: 8px; color: #334155; border-bottom-color: #cbd5e1;">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            Thời gian & Mô tả
                        </h3>
                        <div class="cf-grid" style="gap: 20px 24px; align-items: start;">
                            <div class="cf-group">
                                <label class="cf-label" for="startDate">Thời gian bắt đầu <span class="req">*</span></label>
                                <input type="date" id="startDate" name="startDate" class="cf-input" value="<%= startDate %>" required>
                            </div>
                            <div class="cf-group">
                                <label class="cf-label" for="endDate">Thời gian kết thúc <span class="req">*</span></label>
                                <input type="date" id="endDate" name="endDate" class="cf-input" value="<%= endDate %>" required>
                            </div>
                            <div class="cf-group span2">
                                <label class="cf-label" for="description">Mô tả chương trình / Điều kiện áp dụng</label>
                                <textarea id="description" name="description" class="cf-textarea" rows="3"><%= description %></textarea>
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

<%-- KHU VỰC JAVASCRIPT: Format số tiền, validate ngày tháng và xử lý logic form --%>
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

    // Xử lý thay đổi loại giảm giá (%, VNĐ)
    function onTypeChange() {
        var sel    = document.getElementById('discountType');
        var unit   = document.getElementById('unitLabel');
        var grp    = document.getElementById('maxDiscountGroup');
        var isPct  = sel.value === '0';
        unit.textContent  = isPct ? '%' : 'VNĐ';
        grp.style.display = isPct ? '' : 'none';
        if (!isPct) document.getElementById('maxDiscountAmount').value = '';
        
        var dVal = document.getElementById('discountValue');
        if (dVal) dVal.dispatchEvent(new Event('input'));
    }

    // Tự động in hoa và loại bỏ ký tự đặc biệt cho mã giảm giá
    document.getElementById('code').addEventListener('input', function() {
        var pos = this.selectionStart;
        this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        this.setSelectionRange(pos, pos);
    });

    // Xử lý validate trước khi submit form (kiểm tra ngày, bỏ dấu chấm, logic dữ liệu)
    document.getElementById('couponForm').addEventListener('submit', function(e) {
        var code = document.getElementById('code').value.trim();
        var name = document.getElementById('name').value.trim();
        var quantity = document.getElementById('quantity').value.trim();
        var bd = document.getElementById('startDate').value;
        var kt = document.getElementById('endDate').value;
        var discountType = document.getElementById('discountType').value;
        var discountValue = document.getElementById('discountValue').value.trim().replace(/\./g, '');
        var maxDiscountAmount = document.getElementById('maxDiscountAmount').value.trim().replace(/\./g, '');
        var minOrderValue = document.getElementById('minOrderValue').value.trim().replace(/\./g, '');

        if (!code) { e.preventDefault(); showErrorToast('Vui lòng nhập mã phiếu giảm giá!'); return; }
        if (!name) { e.preventDefault(); showErrorToast('Vui lòng nhập tên phiếu giảm giá!'); return; }
        if (!quantity || parseInt(quantity) <= 0) { e.preventDefault(); showErrorToast('Số lượng phải lớn hơn 0!'); return; }
        if (!bd) { e.preventDefault(); showErrorToast('Vui lòng chọn ngày bắt đầu!'); return; }
        if (!kt) { e.preventDefault(); showErrorToast('Vui lòng chọn ngày kết thúc!'); return; }
        if (bd > kt) { e.preventDefault(); showErrorToast('Ngày kết thúc phải sau hoặc bằng ngày bắt đầu!'); return; }
        
        if (!discountValue || parseInt(discountValue) <= 0) {
            e.preventDefault();
            showErrorToast('Giá trị giảm phải lớn hơn 0!');
            return;
        }

        var minOrder = minOrderValue ? parseInt(minOrderValue) : 0;
        
        if (discountType === '0') {
            if (parseInt(discountValue) > 100) {
                e.preventDefault();
                showErrorToast('Giá trị giảm phần trăm không được vượt quá 100%!');
                return;
            }
            if (!maxDiscountAmount || parseInt(maxDiscountAmount) <= 0) {
                e.preventDefault();
                showErrorToast('Vui lòng nhập Giảm tối đa lớn hơn 0!');
                return;
            }
            if (minOrder > 0 && parseInt(maxDiscountAmount) > minOrder) {
                e.preventDefault();
                showErrorToast('Giảm tối đa không được lớn hơn Đơn hàng tối thiểu!');
                return;
            }
        } else {
            if (minOrder > 0 && parseInt(discountValue) > minOrder) {
                e.preventDefault();
                showErrorToast('Giá trị giảm không được lớn hơn Đơn hàng tối thiểu!');
                return;
            }
        }

        // Remove dot formatting before submitting
        var fields = ['discountValue', 'maxDiscountAmount', 'minOrderValue'];
        fields.forEach(function(id) {
            var el = document.getElementById(id);
            if (el && el.value) {
                el.value = el.value.replace(/\./g, '');
            }
        });
    });

    // Format số tiền nhập vào (thêm dấu chấm phân cách)
    function formatCurrencyInput(e) {
        var isPct = document.getElementById('discountType').value === '0';
        var val = this.value.replace(/\D/g, ''); // keep only digits
        
        if (this.id === 'discountValue' && isPct) {
            this.value = val; // no dots for percentage
            return;
        }
        
        if (val !== '') {
            this.value = val.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
        } else {
            this.value = '';
        }
    }

    // Khởi tạo và format các trường nhập tiền lúc load trang
    (function initCurrencyFields() {
        var fields = ['discountValue', 'maxDiscountAmount', 'minOrderValue'];
        fields.forEach(function(id) {
            var el = document.getElementById(id);
            if (el) {
                el.addEventListener('input', formatCurrencyInput);
                // format initial value
                var val = el.value.replace(/\D/g, '');
                if (val !== '') {
                    var isPct = document.getElementById('discountType').value === '0';
                    if (!(id === 'discountValue' && isPct)) {
                        el.value = val.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                    }
                }
            }
        });
    })();

    // Hiển thị thông báo lỗi bằng toast
    function showErrorToast(msg) {
        var oldToast = document.getElementById('toastError');
        if (oldToast) oldToast.remove();
        var toast = document.createElement('div');
        toast.id = 'toastError';
        toast.style.cssText = 'position:fixed;top:24px;left:50%;transform:translateX(-50%);background:#fff;border:1px solid #fecaca;border-radius:12px;padding:14px 18px;display:flex;align-items:center;gap:12px;box-shadow:0 8px 24px rgba(0,0,0,.12);z-index:9999;animation: slideDownToast 0.4s ease-out forwards;';
        toast.innerHTML = '<div style="width:24px;height:24px;background:#fee2e2;border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;"><svg viewBox="0 0 24 24" width="14" height="14" stroke="#ef4444" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></div>' +
                          '<span style="font-size:14px;font-weight:500;color:#1f2937;">' + msg + '</span>' +
                          '<button onclick="this.parentElement.remove()" style="border:none;background:none;cursor:pointer;color:#9ca3af;margin-left:8px;">✕</button>';
        
        // Ensure animation keyframes are injected
        if (!document.getElementById('toastStyles')) {
            var style = document.createElement('style');
            style.id = 'toastStyles';
            style.innerHTML = '@keyframes slideDownToast { from { top: -50px; opacity: 0; } to { top: 24px; opacity: 1; } }';
            document.head.appendChild(style);
        }
        
        document.body.appendChild(toast);
        setTimeout(function() {
            if (toast.parentElement) {
                toast.style.transition = 'opacity .4s';
                toast.style.opacity = '0';
                setTimeout(function() { if(toast.parentElement) toast.remove(); }, 450);
            }
        }, 4000);
    }
</script>
</body>
</html>
