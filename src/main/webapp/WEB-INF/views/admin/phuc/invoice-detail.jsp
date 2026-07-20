<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Invoice" %>
<%@ page import="project.duan1_sd21301.model.phuc.InvoiceDetail" %>
<%@ page import="project.duan1_sd21301.model.phuc.InvoiceHistory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FamiCoats Admin - Chi tiết hoá đơn</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-detail.css">
</head>
<body>
<%-- KHU VỰC LOGIC JSP: Xử lý dữ liệu từ Controller truyền sang giao diện --%>
<%
    // Lấy thông tin hoá đơn, chi tiết hoá đơn và lịch sử trạng thái từ Request
    Invoice inv = (Invoice) request.getAttribute("invoice");
    List<InvoiceDetail>  detailList  = (List<InvoiceDetail>)  request.getAttribute("detailList");
    List<InvoiceHistory> historyList = (List<InvoiceHistory>) request.getAttribute("historyList");
    
    // Lấy danh sách map hiển thị nhãn trạng thái (ví dụ: 0 -> Chờ xác nhận)
    Map<Integer, String> statusLabels = (Map<Integer, String>) request.getAttribute("orderStatusLabels");
    
    // Khởi tạo các đối tượng format ngày tháng
    DateTimeFormatter dtf     = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dtfFull = DateTimeFormatter.ofPattern("dd/MM/yyyy - HH:mm");

    // Nếu không tìm thấy hoá đơn, điều hướng về trang danh sách để tránh lỗi
    if (inv == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

    int orderStatus = inv.getOrderStatus();
    
    // Hàm lambda mapping trạng thái sang class CSS để đổi màu badge (nhãn)
    java.util.function.Function<Integer, String> bClassFn = (s) -> {
        if (s == null)  return "cho-xu-ly";
        if (s == 4)     return "da-hoan-tien";
        if (s == 3)     return "da-huy";
        if (s == 2)     return "hoan-thanh";
        if (s == 1)     return "da-xac-nhan";
        return "cho-xu-ly";
    };
    String badgeClass = bClassFn.apply(orderStatus);
    String badgeLabel = statusLabels != null ? statusLabels.getOrDefault(orderStatus, "?") : "?";

    // Chuẩn bị các chuỗi thông tin khách hàng, fallback (mặc định) sang chuỗi rỗng hoặc "—" nếu null
    String customerName    = inv.getCustomerName()    != null ? inv.getCustomerName()    : "";
    char   avatarChar      = customerName.trim().isEmpty() ? 'K' : customerName.trim().charAt(0); // Lấy chữ cái đầu làm avatar
    String customerPhone   = inv.getCustomerPhone()   != null ? inv.getCustomerPhone()   : "—";
    String customerEmail   = inv.getCustomerEmail()   != null ? inv.getCustomerEmail()   : "—";
    String customerAddress = inv.getCustomerAddress() != null ? inv.getCustomerAddress() : "—";
    String payMethod       = inv.getPaymentMethod()   != null ? inv.getPaymentMethod().getName() : "Chưa xác định";
    boolean paid           = inv.getPaymentStatus() == 1; // 1 = Đã thanh toán
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats Admin</span>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <a href="${pageContext.request.contextPath}/admin/invoices" style="color:#6b7280;text-decoration:none;">Quản lý hoá đơn</a>
                <span style="margin:0 6px;color:#d1d5db">/</span>
                <span class="active-crumb">Chi tiết hoá đơn</span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn">
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
                        <%-- KHU VỰC TOPBAR: Chứa nút quay lại và các thao tác (In, Cập nhật, Huỷ) --%>
                        <div class="detail-topbar">
                <a href="${pageContext.request.contextPath}/admin/invoices" class="back-link">
                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                    Quay lại danh sách
                </a>
                <div class="topbar-actions">
                    <button class="btn-action" style="background:#fff;color:#374151;border:1px solid #cbd5e1;" onclick="openQrModal()">
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 6px;"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><rect x="7" y="7" width="3" height="3"/><rect x="14" y="7" width="3" height="3"/><rect x="7" y="14" width="3" height="3"/><rect x="14" y="14" width="3" height="3"/></svg>
                        Mã QR
                    </button>
                    <%-- Link mở trang in hoá đơn trên tab mới --%>
                    <a href="${pageContext.request.contextPath}/admin/invoices/print?id=<%= inv.getId() %>" class="btn-print" target="_blank">
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                        In hoá đơn
                    </a>
                    <%-- Nếu đơn hàng chưa bị huỷ (3) hoặc chưa hoàn tiền (4) thì mới hiển thị nút cập nhật/huỷ --%>
                    <% if (orderStatus != 4 && orderStatus != 3) { %>
                    <button class="btn-action" style="background:#3b82f6;color:white;border:none;" onclick="openModal('update')">Cập nhật trạng thái</button>
                    <button class="btn-action btn-huy" onclick="openModal('cancel')">Huỷ đơn</button>
                    <% } %>
                </div>
            </div>

            <% String msgParam = request.getParameter("msg"); %>

                        <div class="detail-layout">

                                <div class="detail-main">

                                        <div class="detail-card">
                        <div class="invoice-heading">
                            <div class="invoice-icon-row">
                                <div>
                                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;margin-bottom:2px;letter-spacing:.05em;">MÃ HOÁ ĐƠN</div>
                                    <div class="invoice-id">HD<%= inv.getId() %></div>
                                    <div class="invoice-date">Ngày đặt: <%= inv.getOrderDate() != null ? inv.getOrderDate().format(dtf) : "—" %></div>
                                    <% if (inv.getConfirmDate() != null) { %>
                                    <div class="invoice-date">Ngày xác nhận: <%= inv.getConfirmDate().format(dtf) %></div>
                                    <% } %>
                                </div>
                                <span class="badge <%= badgeClass %>"><%= badgeLabel %></span>
                            </div>
                        </div>

                                                <%-- KHU VỰC BẢNG SẢN PHẨM: Hiển thị chi tiết danh sách sản phẩm trong hoá đơn --%>
                       <table class="prod-table">
                            <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Giảm</th>
                                <th>SL</th>
                                <th>Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if (detailList != null && !detailList.isEmpty()) {
                                    for (InvoiceDetail detail : detailList) {
                                        String unitPrice    = detail.getUnitPrice()    != null ? String.format("%,.0fđ", detail.getUnitPrice()).replace(",", ".")    : "—";
                                        String discountPrice= detail.getDiscountPrice()!= null && detail.getDiscountPrice() > 0
                                                ? "-" + String.format("%,.0fđ", detail.getDiscountPrice()).replace(",", ".") : "—";
                                        String totalPrice   = detail.getTotalPrice()   != null ? String.format("%,.0fđ", detail.getTotalPrice()).replace(",", ".") : "—";
                                        String spName;
                                        if (detail.getProductDetail() != null) {
                                            spName = "SP #" + detail.getProductDetail().getId();
                                            if (detail.getProductDetail().getSize()  != null) spName += " - " + detail.getProductDetail().getSize();
                                            if (detail.getProductDetail().getColor() != null) spName += " / " + detail.getProductDetail().getColor();
                                        } else {
                                            spName = "Sản phẩm không xác định";
                                        }
                            %>
                            <tr>
                                <td style="font-weight:500;color:#111827;"><%= spName %></td>
                                <td><%= unitPrice %></td>
                                <td style="color:#22c55e;"><%= discountPrice %></td>
                                <td><%= detail.getQuantity() %></td>
                                <td style="font-weight:700;"><%= totalPrice %></td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="5" style="text-align:center;padding:30px;color:#9ca3af;">Chưa có sản phẩm.</td></tr>
                            <% } %>
                            </tbody>
                        </table>

                        <div style="border-top:1px solid #f3f4f6;margin-top:8px;">
                            <div class="fin-row">
                                <span class="fin-label">Tạm tính</span>
                                <span class="fin-value"><%= inv.getSubtotal() != null ? String.format("%,.0fđ", inv.getSubtotal()).replace(",", ".") : "—" %></span>
                            </div>
                            <% if (inv.getDiscountAmount() != null && inv.getDiscountAmount() > 0) { %>
                            <div class="fin-row">
                                <span class="fin-label">Giảm giá hoá đơn</span>
                                <span class="fin-value" style="color:#22c55e;">-<%= String.format("%,.0fđ", inv.getDiscountAmount()).replace(",", ".") %></span>
                            </div>
                            <% } %>
                            <hr class="fin-divider">
                            <div class="fin-total">
                                <span class="label">Tổng thanh toán</span>
                                <span class="value"><%= inv.getTotalAmount() != null ? String.format("%,.0fđ", inv.getTotalAmount()).replace(",", ".") : "—" %></span>
                            </div>
                            <% if (inv.getPaidAmount() != null) { %>
                            <div class="fin-row">
                                <span class="fin-label">Đã thanh toán</span>
                                <span class="fin-value" style="color:#3b82f6;"><%= String.format("%,.0fđ", inv.getPaidAmount()).replace(",", ".") %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>

                                        <%-- KHU VỰC LỊCH SỬ XỬ LÝ: Hiển thị các bước đổi trạng thái đơn hàng dạng timeline --%>
                                        <div class="detail-card">
                        <div class="timeline-section">
                            <h3>Lịch sử xử lý đơn hàng</h3>
                            <ul class="tl-list">
                                <%
                                    if (historyList != null && !historyList.isEmpty()) {
                                        for (InvoiceHistory h : historyList) {
                                            String newLabel = statusLabels != null ? statusLabels.getOrDefault(h.getNewStatus(), "?") : "?";
                                            String oldLabel = statusLabels != null ? statusLabels.getOrDefault(h.getOldStatus(), "?") : "?";
                                            String timeStr  = h.getUpdatedAt() != null ? h.getUpdatedAt().format(dtfFull) : "";
                                %>
                                <li class="tl-item">
                                    <div class="tl-dot"></div>
                                    <div class="tl-title"><%= oldLabel %> → <%= newLabel %></div>
                                    <div class="tl-time"><%= timeStr %></div>
                                    <% if (h.getNote() != null && !h.getNote().isEmpty()) { %>
                                    <div class="tl-note"><%= h.getNote() %></div>
                                    <% } %>
                                </li>
                                <% } } else { %>
                                <li style="color:#9ca3af;font-size:13px;">Chưa có lịch sử thay đổi trạng thái.</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>
                                <%-- KHU VỰC THÔNG TIN BÊN PHẢI (SIDEBAR): Thông tin khách hàng, Thanh toán, Ghi chú --%>
                                <div class="detail-side">
                                        <div class="side-card">
                        <div class="side-card-title">Thông tin khách hàng</div>
                        <div class="kh-avatar-row">
                            <div class="kh-avatar"><%= avatarChar %></div>
                            <div>
                                <div class="kh-info-name"><%= customerName %></div>
                                <div class="kh-info-role">Khách hàng</div>
                            </div>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.62 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l.81-.81a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 17z"/></svg>
                            <span class="contact-value"><%= customerPhone %></span>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                            <span class="contact-value"><%= customerEmail %></span>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                            <span class="contact-value"><%= customerAddress %></span>
                        </div>
                    </div>

                                        <div class="side-card">
                        <div class="side-card-title">Thanh toán</div>
                        <div class="pay-method-row">
                            <div class="pay-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                            </div>
                            <div>
                                <div class="pay-method-name"><%= payMethod %></div>
                                <div class="pay-method-sub">Phương thức thanh toán</div>
                            </div>
                        </div>
                        <div class="pay-row">
                            <span class="lbl">Trạng thái TT</span>
                            <span class="val <%= paid ? "paid" : "unpaid" %>"><%= paid ? "Đã thanh toán" : "Chưa thanh toán" %></span>
                        </div>
                        <div class="pay-row" style="border-top:1px solid #f3f4f6;padding-top:10px;margin-top:4px;">
                            <span class="lbl" style="font-weight:700;color:#111827;">Tổng tiền</span>
                            <span class="val total"><%= inv.getTotalAmount() != null ? String.format("%,.0fđ", inv.getTotalAmount()).replace(",", ".") : "—" %></span>
                        </div>
                    </div>

                                        <div class="side-card">
                        <div class="side-card-title">Ghi chú đơn hàng</div>
                        <p class="note-text"><%= (inv.getNote() != null && !inv.getNote().isEmpty()) ? inv.getNote() : "Không có ghi chú." %></p>
                    </div>
                </div>            </div>        </div>    </main>
</div>

<%-- KHU VỰC MODAL CẬP NHẬT TRẠNG THÁI --%>
<div class="modal-overlay" id="confirmModal">
    <div class="modal-box">
        <h3>Cập nhật trạng thái</h3>
        <p>Chọn trạng thái mới cho đơn hàng này:</p>
        <form method="post" action="${pageContext.request.contextPath}/admin/invoices/update-status">
            <input type="hidden" name="invoiceId" value="<%= inv.getId() %>">
            <div class="modal-field">
                <label>Trạng thái mới</label>
                <select name="newStatus" id="newStatusSelect">
                    <option value="0" <%= orderStatus == 0 ? "selected" : "" %>>Chờ xác nhận</option>
                    <option value="1" <%= orderStatus == 1 ? "selected" : "" %>>Đã xác nhận</option>
                    <option value="2" <%= orderStatus == 2 ? "selected" : "" %>>Hoàn thành</option>
                    <option value="3" <%= orderStatus == 3 ? "selected" : "" %>>Đã huỷ</option>
                    <option value="4" <%= orderStatus == 4 ? "selected" : "" %>>Đã hoàn tiền</option>
                </select>
            </div>
            <div class="modal-field">
                <label>Ghi chú (tuỳ chọn)</label>
                <textarea name="note" rows="3" placeholder="Ghi chú kèm theo..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel-m" onclick="closeModal('confirmModal')">Huỷ</button>
                <button type="submit" class="btn-ok blue">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<%-- KHU VỰC MODAL HUỶ ĐƠN HÀNG --%>
<div class="modal-overlay" id="cancelModal">
    <div class="modal-box">
        <h3 style="color:#ef4444;">⚠️ Xác nhận huỷ đơn hàng</h3>
        <p>Thao tác này sẽ hoàn trả tồn kho và không thể hoàn tác.</p>
        <form method="post" action="${pageContext.request.contextPath}/admin/invoices/update-status">
            <input type="hidden" name="invoiceId" value="<%= inv.getId() %>">
            <input type="hidden" name="newStatus" value="3">
            <div class="modal-field">
                <label>Lý do huỷ đơn *</label>
                <textarea name="note" rows="3" placeholder="Nhập lý do huỷ..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel-m" onclick="closeModal('cancelModal')">Quay lại</button>
                <button type="submit" class="btn-ok red">Xác nhận huỷ</button>
            </div>
        </form>
    </div>
</div>

<%-- KHU VỰC MODAL MÃ QR --%>
<div class="modal-overlay" id="qrModal">
    <div class="modal-box" style="text-align: center;">
        <h3>Mã QR Hoá đơn #<%= inv.getId() %></h3>
        <p style="margin-bottom: 16px; font-size: 13px; color: #6b7280;">Quét mã này để xem hoá đơn dạng in</p>
        <div id="detail-qrcode" style="display: flex; justify-content: center; padding: 16px; background: #fff; border: 1px solid #e5e7eb; border-radius: 8px; margin: 0 auto 20px; width: max-content;"></div>
        <div class="modal-actions" style="justify-content: center;">
            <button type="button" class="btn-cancel-m" onclick="closeModal('qrModal')">Đóng</button>
        </div>
    </div>
</div>

<% if ("updated".equals(msgParam) || "cancelled".equals(msgParam)) { %>
<style>
    @keyframes slideDownToast {
        from { top: -50px; opacity: 0; }
        to { top: 24px; opacity: 1; }
    }
</style>
<div id="toastSuccess" style="position:fixed;top:24px;left:50%;transform:translateX(-50%);background:#fff;border:1px solid #d1fae5;border-radius:12px;padding:14px 18px;display:flex;align-items:center;gap:12px;box-shadow:0 8px 24px rgba(0,0,0,.12);z-index:9999;animation: slideDownToast 0.4s ease-out forwards;">
    <svg viewBox="0 0 24 24" width="24" height="24" stroke="#10B981" stroke-width="2" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
    <div>
        <div style="font-weight:700;font-size:13px;color:#111827;">Thành công!</div>
        <div style="font-size:12px;color:#6b7280;"><%= "cancelled".equals(msgParam) ? "Đã huỷ đơn thành công." : "Cập nhật trạng thái thành công." %></div>
    </div>
    <button onclick="document.getElementById('toastSuccess').style.display='none'" style="border:none;background:none;cursor:pointer;color:#9ca3af;margin-left:8px;">✕</button>
</div>
<% } %>

<%-- KHU VỰC JAVASCRIPT: Xử lý các tương tác trên giao diện người dùng --%>
<script>
    // Logic 1: Hiển thị ngày giờ hiện tại ở thanh navbar (góc trên bên phải)
    (function() {
        var d = new Date();
        var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
        var el = document.getElementById('currentDate');
        if (el) el.textContent = days[d.getDay()] + ', ' + String(d.getDate()).padStart(2,'0') + '/' + String(d.getMonth()+1).padStart(2,'0') + '/' + d.getFullYear();
    })();

    // Logic 2: Hàm mở modal theo loại (update = cập nhật trạng thái, cancel = huỷ đơn)
    function openModal(type) {
        document.getElementById(type === 'cancel' ? 'cancelModal' : 'confirmModal').classList.add('show');
    }

    // Logic 3: Hàm đóng modal khi bấm nút Huỷ/Quay lại
    function closeModal(id) {
        document.getElementById(id).classList.remove('show');
    }

    // Logic 4: Lắng nghe sự kiện click ra ngoài vùng form modal để tự động đóng modal
    document.querySelectorAll('.modal-overlay').forEach(function(o) {
        o.addEventListener('click', function(e) { if (e.target === o) o.classList.remove('show'); });
    });

    // Logic 5: Tự động ẩn thông báo thành công (toast message) sau 4 giây để không vướng màn hình
    (function() {
        var toast = document.getElementById('toastSuccess');
        if (toast) setTimeout(function() { toast.style.display = 'none'; }, 4000);
    })();
    // Logic 6: Mở modal mã QR và tự động tạo mã nếu chưa có
    var isQrGenerated = false;
    function openQrModal() {
        document.getElementById('qrModal').classList.add('show');
        if (!isQrGenerated) {
            var detailUrl = window.location.origin + '${pageContext.request.contextPath}/admin/invoices/print?id=<%= inv.getId() %>';
            new QRCode(document.getElementById("detail-qrcode"), {
                text: detailUrl,
                width: 180,
                height: 180,
                colorDark : "#111827",
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.L
            });
            isQrGenerated = true;
        }
    }
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
</body>
</html>
