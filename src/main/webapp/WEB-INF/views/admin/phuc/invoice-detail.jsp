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
<%
    Invoice hd = (Invoice) request.getAttribute("hoaDon");
    List<InvoiceDetail>  chiTietList = (List<InvoiceDetail>)  request.getAttribute("chiTietList");
    List<InvoiceHistory> lichSuList  = (List<InvoiceHistory>) request.getAttribute("lichSuList");
    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");
    DateTimeFormatter dtf     = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dtfFull = DateTimeFormatter.ofPattern("dd/MM/yyyy - HH:mm");

    if (hd == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

    int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;
    java.util.function.Function<Integer, String> bClassFn = (t) -> {
        if (t == null)  return "cho-xu-ly";
        if (t == 4)     return "da-huy";
        if (t == 3)     return "hoan-thanh";
        if (t == 2)     return "dang-giao";
        if (t == 1)     return "da-xac-nhan";
        return "cho-xu-ly";
    };
    String badgeClass = bClassFn.apply(tt);
    String badgeLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";

    String tenKH   = hd.getTenKhachHang()    != null ? hd.getTenKhachHang()    : "";
    char avatarChar = tenKH.trim().isEmpty() ? 'K' : tenKH.trim().charAt(0);
    String sdtKH   = hd.getSdtKhachHang()    != null ? hd.getSdtKhachHang()    : "—";
    String emailKH = hd.getEmailKhachHang()   != null ? hd.getEmailKhachHang()  : "—";
    String diaChiKH= hd.getDiaChiKhachHang()  != null ? hd.getDiaChiKhachHang() : "—";
    String pttt    = hd.getPaymentMethod()    != null ? hd.getPaymentMethod().getTenPhuongThuc() : "Chưa xác định";
    boolean daTT   = hd.getTrangThaiThanhToan() != null && hd.getTrangThaiThanhToan() == 1;
%>
<div class="app-container">
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <main class="main-content">
        <!-- Navbar -->
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
            <!-- Top actions bar -->
            <div class="detail-topbar">
                <a href="${pageContext.request.contextPath}/admin/invoices" class="back-link">
                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                    Quay lại danh sách
                </a>
                <div class="topbar-actions">
                    <a href="${pageContext.request.contextPath}/admin/invoices/print?id=<%= hd.getId() %>" class="btn-print" target="_blank">
                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                        In hoá đơn
                    </a>
                    <% if (tt != 4 && tt != 3) { %>
                    <button class="btn-action" style="background:#3b82f6;color:white;border:none;" onclick="openModal('update', null, 'Cập nhật trạng thái')">Cập nhật trạng thái</button>
                    <% } %>
                    <% if (tt != 4 && tt != 3) { %>
                    <button class="btn-action btn-huy" onclick="openModal('cancel', null, 'Huỷ đơn')">Huỷ đơn</button>
                    <% } %>
                </div>
            </div>

            <!-- Thông báo sau action -->
            <% String msgParam = request.getParameter("msg");
                if (msgParam != null) { %>
            <div style="background:#dcfce7;border:1px solid #86efac;color:#166534;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-size:13px;font-weight:500;">
                ✅ <%= "cancelled".equals(msgParam) ? "Huỷ đơn thành công, tồn kho đã được hoàn trả." : "Cập nhật trạng thái thành công!" %>
            </div>
            <% } %>

            <!-- Main 2-column layout -->
            <div class="detail-layout">

                <!-- LEFT: Main content -->
                <div class="detail-main">

                    <!-- Invoice heading card -->
                    <div class="detail-card">
                        <div class="invoice-heading">
                            <div class="invoice-icon-row">
                                <div>
                                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;margin-bottom:2px;letter-spacing:0.05em;">MÃ HOÁ ĐƠN</div>
                                    <div class="invoice-id">HD<%= hd.getId() %></div>
                                    <div class="invoice-date">Ngày đặt: <%= hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "—" %></div>
                                    <% if (hd.getNgayXacNhan() != null) { %>
                                    <div class="invoice-date">Ngày xác nhận: <%= hd.getNgayXacNhan().format(dtf) %></div>
                                    <% } %>
                                </div>
                                <span class="badge <%= badgeClass %>"><%= badgeLabel %></span>
                            </div>
                        </div>

                        <!-- Product table -->
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
                                if (chiTietList != null && !chiTietList.isEmpty()) {
                                    for (InvoiceDetail ct : chiTietList) {
                                        String donGia    = ct.getDonGia()    != null ? String.format("%,.0fđ", ct.getDonGia()).replace(",", ".")    : "—";
                                        String giaGiam   = ct.getGiaGiam()   != null && ct.getGiaGiam() > 0
                                                ? "-" + String.format("%,.0fđ", ct.getGiaGiam()).replace(",", ".") : "—";
                                        String thanhTien = ct.getThanhTien() != null ? String.format("%,.0fđ", ct.getThanhTien()).replace(",", ".") : "—";
                                        String spName;
                                        if (ct.getProductDetail() != null) {
                                            spName = "SP #" + ct.getProductDetail().getId();
                                            if (ct.getProductDetail().getSize() != null) spName += " - " + ct.getProductDetail().getSize();
                                            if (ct.getProductDetail().getColor() != null) spName += " / " + ct.getProductDetail().getColor();
                                        } else {
                                            spName = "Sản phẩm không xác định";
                                        }
                            %>
                            <tr>
                                <td style="font-weight:500;color:#111827;"><%= spName %></td>
                                <td><%= donGia %></td>
                                <td style="color:#22c55e;"><%= giaGiam %></td>
                                <td><%= ct.getSoLuong() != null ? ct.getSoLuong() : 0 %></td>
                                <td style="font-weight:700;"><%= thanhTien %></td>
                            </tr>
                            <%
                                    }
                                } else { %>
                            <tr><td colspan="5" style="text-align:center;padding:30px;color:#9ca3af;">Chưa có sản phẩm.</td></tr>
                            <% } %>
                            </tbody>
                        </table>

                        <!-- Financial summary -->
                        <div style="border-top:1px solid #f3f4f6;margin-top:8px;">
                            <div class="fin-row">
                                <span class="fin-label">Tạm tính</span>
                                <span class="fin-value"><%= hd.getTamTinh() != null ? String.format("%,.0fđ", hd.getTamTinh()).replace(",", ".") : "—" %></span>
                            </div>
                            <% if (hd.getTienGiamHoaDon() != null && hd.getTienGiamHoaDon() > 0) { %>
                            <div class="fin-row">
                                <span class="fin-label">Giảm giá hoá đơn</span>
                                <span class="fin-value" style="color:#22c55e;">-<%= String.format("%,.0fđ", hd.getTienGiamHoaDon()).replace(",", ".") %></span>
                            </div>
                            <% } %>
                            <hr class="fin-divider">
                            <div class="fin-total">
                                <span class="label">Tổng thanh toán</span>
                                <span class="value"><%= hd.getTongThanhToan() != null ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—" %></span>
                            </div>
                            <% if (hd.getDaThanhToan() != null) { %>
                            <div class="fin-row">
                                <span class="fin-label">Đã thanh toán</span>
                                <span class="fin-value" style="color:#3b82f6;"><%= String.format("%,.0fđ", hd.getDaThanhToan()).replace(",", ".") %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Timeline card -->
                    <div class="detail-card">
                        <div class="timeline-section">
                            <h3>Lịch sử xử lý đơn hàng</h3>
                            <ul class="tl-list">
                                <%
                                    if (lichSuList != null && !lichSuList.isEmpty()) {
                                        for (InvoiceHistory ls : lichSuList) {
                                            String moiLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(ls.getTrangThaiMoi(), "?") : "?";
                                            String cuLabel  = trangThaiLabels != null ? trangThaiLabels.getOrDefault(ls.getTrangThaiCu(),  "?") : "?";
                                            String timeStr  = ls.getThoiGianCapNhat() != null ? ls.getThoiGianCapNhat().format(dtfFull) : "";
                                %>
                                <li class="tl-item">
                                    <div class="tl-dot"></div>
                                    <div class="tl-title"><%= cuLabel %> → <%= moiLabel %></div>
                                    <div class="tl-time"><%= timeStr %></div>
                                    <% if (ls.getGhiChu() != null && !ls.getGhiChu().isEmpty()) { %>
                                    <div class="tl-note"><%= ls.getGhiChu() %></div>
                                    <% } %>
                                </li>
                                <%
                                        }
                                    } else { %>
                                <li style="color:#9ca3af;font-size:13px;">Chưa có lịch sử thay đổi trạng thái.</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                </div><!-- /detail-main -->

                <!-- RIGHT: Sidebar info -->
                <div class="detail-side">

                    <!-- Customer info -->
                    <div class="side-card">
                        <div class="side-card-title">Thông tin khách hàng</div>
                        <div class="kh-avatar-row">
                            <div class="kh-avatar"><%= avatarChar %></div>
                            <div>
                                <div class="kh-info-name"><%= tenKH %></div>
                                <div class="kh-info-role">Khách hàng</div>
                            </div>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.62 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l.81-.81a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 17z"/></svg>
                            <span class="contact-value"><%= sdtKH %></span>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                            <span class="contact-value"><%= emailKH %></span>
                        </div>
                        <div class="contact-row">
                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                            <span class="contact-value"><%= diaChiKH %></span>
                        </div>
                    </div>

                    <!-- Payment info -->
                    <div class="side-card">
                        <div class="side-card-title">Thanh toán</div>
                        <div class="pay-method-row">
                            <div class="pay-icon">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                            </div>
                            <div>
                                <div class="pay-method-name"><%= pttt %></div>
                                <div class="pay-method-sub">Phương thức thanh toán</div>
                            </div>
                        </div>
                        <div class="pay-row">
                            <span class="lbl">Trạng thái TT</span>
                            <span class="val <%= daTT ? "paid" : "unpaid" %>">
                                <%= daTT ? "Đã thanh toán" : "Chưa thanh toán" %>
                            </span>
                        </div>
                        <div class="pay-row" style="border-top:1px solid #f3f4f6;padding-top:10px;margin-top:4px;">
                            <span class="lbl" style="font-weight:700;color:#111827;">Tổng tiền</span>
                            <span class="val total">
                                <%= hd.getTongThanhToan() != null ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—" %>
                            </span>
                        </div>
                    </div>

                    <!-- Note -->
                    <div class="side-card">
                        <div class="side-card-title">Ghi chú đơn hàng</div>
                        <p class="note-text">
                            <%= (hd.getGhiChu() != null && !hd.getGhiChu().isEmpty()) ? hd.getGhiChu() : "Không có ghi chú." %>
                        </p>
                    </div>

                </div><!-- /detail-side -->
            </div><!-- /detail-layout -->
        </div><!-- /content-wrapper -->
    </main>
</div>

<!-- Modal: Cập nhật trạng thái -->
<div class="modal-overlay" id="confirmModal">
    <div class="modal-box">
        <h3 id="modalTitle">Cập nhật trạng thái</h3>
        <p id="modalDesc">Chọn trạng thái mới cho đơn hàng này:</p>
        <form method="post" action="${pageContext.request.contextPath}/admin/invoices/update-status">
            <input type="hidden" name="hoaDonId" value="<%= hd.getId() %>">
            <div class="modal-field">
                <label>Trạng thái mới</label>
                <select name="trangThaiMoi" id="trangThaiSelect">
                    <option value="0" <%= tt == 0 ? "selected" : "" %>>Chờ xác nhận</option>
                    <option value="1" <%= tt == 1 ? "selected" : "" %>>Đã xác nhận</option>
                    <option value="2" <%= tt == 2 ? "selected" : "" %>>Đang giao hàng</option>
                    <option value="3" <%= tt == 3 ? "selected" : "" %>>Hoàn thành</option>
                </select>
            </div>
            <div class="modal-field">
                <label>Ghi chú (tuỳ chọn)</label>
                <textarea name="ghiChu" rows="3" placeholder="Ghi chú kèm theo..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel-m" onclick="closeModal('confirmModal')">Huỷ</button>
                <button type="submit" class="btn-ok blue" id="btnOk">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Huỷ đơn -->
<div class="modal-overlay" id="cancelModal">
    <div class="modal-box">
        <h3 style="color:#ef4444;">⚠️ Xác nhận huỷ đơn hàng</h3>
        <p>Thao tác này sẽ hoàn trả tồn kho và không thể hoàn tác.</p>
        <form method="post" action="${pageContext.request.contextPath}/admin/invoices/update-status">
            <input type="hidden" name="hoaDonId" value="<%= hd.getId() %>">
            <input type="hidden" name="trangThaiMoi" value="4">
            <div class="modal-field">
                <label>Lý do huỷ đơn *</label>
                <textarea name="ghiChu" rows="3" placeholder="Nhập lý do huỷ..."></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-cancel-m" onclick="closeModal('cancelModal')">Quay lại</button>
                <button type="submit" class="btn-ok red">Xác nhận huỷ</button>
            </div>
        </form>
    </div>
</div>

<% if ("updated".equals(request.getParameter("msg")) || "cancelled".equals(request.getParameter("msg"))) { %>
<div class="toast-notification" id="toastSuccess" style="position:fixed;top:24px;right:24px;background:#fff;border:1px solid #d1fae5;border-radius:12px;padding:14px 18px;display:flex;align-items:center;gap:12px;box-shadow:0 8px 24px rgba(0,0,0,.12);z-index:9999;">
    <svg viewBox="0 0 24 24" width="24" height="24" stroke="#10B981" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <div>
        <div style="font-weight:700;font-size:13px;color:#111827;">Thành công!</div>
        <div style="font-size:12px;color:#6b7280;"><%= "cancelled".equals(request.getParameter("msg")) ? "Đã huỷ đơn thành công." : "Cập nhật trạng thái thành công." %></div>
    </div>
    <button onclick="document.getElementById('toastSuccess').style.display='none'" style="border:none;background:none;cursor:pointer;color:#9ca3af;margin-left:8px;">✕</button>
</div>
<% } %>

<script>
    // Ngày hiện tại
    (function() {
        var d = new Date();
        var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
        var dd = String(d.getDate()).padStart(2,'0');
        var mm = String(d.getMonth()+1).padStart(2,'0');
        var el = document.getElementById('currentDate');
        if (el) el.textContent = days[d.getDay()] + ', ' + dd + '/' + mm + '/' + d.getFullYear();
    })();

    function openModal(type) {
        if (type === 'cancel') {
            document.getElementById('cancelModal').classList.add('show');
        } else {
            document.getElementById('confirmModal').classList.add('show');
        }
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('show');
    }

    // Close on overlay click
    document.querySelectorAll('.modal-overlay').forEach(function(o) {
        o.addEventListener('click', function(e) { if (e.target === o) o.classList.remove('show'); });
    });

    // Auto-hide toast sau 4 giây
    (function() {
        var toast = document.getElementById('toastSuccess');
        if (toast) setTimeout(function() { toast.style.display = 'none'; }, 4000);
    })();
</script>
</body>
</html>
