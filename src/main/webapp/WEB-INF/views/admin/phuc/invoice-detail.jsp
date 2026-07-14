<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ page import="project.duan1_sd21301.model.HoaDon" %>--%>
<%--<%@ page import="project.duan1_sd21301.model.ChiTietHoaDon" %>--%>
<%--<%@ page import="project.duan1_sd21301.model.LichSuHoaDon" %>--%>
<%--<%@ page import="java.util.List" %>--%>
<%--<%@ page import="java.util.Map" %>--%>
<%--<%@ page import="java.time.format.DateTimeFormatter" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="vi">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>FamiCoats Admin - Chi tiết hoá đơn</title>--%>
<%--    <link rel="preconnect" href="https://fonts.googleapis.com">--%>
<%--    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>--%>
<%--    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoice-detail.css">--%>
<%--</head>--%>
<%--<body>--%>
<%--<%--%>
<%--    HoaDon hd = (HoaDon) request.getAttribute("hoaDon");--%>
<%--    List<ChiTietHoaDon> chiTietList = (List<ChiTietHoaDon>) request.getAttribute("chiTietList");--%>
<%--    List<LichSuHoaDon> lichSuList   = (List<LichSuHoaDon>) request.getAttribute("lichSuList");--%>
<%--    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");--%>
<%--    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");--%>
<%--    DateTimeFormatter dtfFull = DateTimeFormatter.ofPattern("dd/MM/yyyy - HH:mm");--%>

<%--    if (hd == null) { response.sendRedirect(request.getContextPath() + "/admin/orders"); return; }--%>

<%--    int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;--%>
<%--    java.util.function.Function<Integer, String> bClass = (t) -> {--%>
<%--        if (t == null) return "cho-xu-ly";--%>
<%--        if (t == 3) return "hoan-thanh";--%>
<%--        if (t == 2) return "dang-giao";--%>
<%--        if (t == 1) return "da-xac-nhan";--%>
<%--        if (t == 4) return "da-huy";--%>
<%--        return "cho-xu-ly";--%>
<%--    };--%>
<%--    String badgeClass = bClass.apply(tt);--%>
<%--    String badgeLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";--%>

<%--    String tenKH = hd.getTenKhachHang() != null ? hd.getTenKhachHang() : "";--%>
<%--    char avatarChar = tenKH.trim().isEmpty() ? 'K' : tenKH.trim().charAt(0);--%>
<%--    String sdtKH   = hd.getSdtKhachHang()    != null ? hd.getSdtKhachHang()    : "—";--%>
<%--    String emailKH = hd.getEmailKhachHang()   != null ? hd.getEmailKhachHang()  : "—";--%>
<%--    String diaChiKH= hd.getDiaChiKhachHang()  != null ? hd.getDiaChiKhachHang() : "—";--%>
<%--    String pttt    = hd.getPhuongThucThanhToan() != null ? hd.getPhuongThucThanhToan().getTenPhuongThuc() : "Chưa xác định";--%>
<%--    boolean daTT   = hd.getTrangThaiThanhToan() != null && hd.getTrangThaiThanhToan() == 1;--%>
<%--%>--%>
<%--<div class="app-container">--%>
<%--    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />--%>

<%--    <main class="main-content">--%>
<%--        <!-- Navbar -->--%>
<%--        <header class="navbar">--%>
<%--            <div class="breadcrumb">--%>
<%--                <span>FamiCoats Admin</span>--%>
<%--                <span style="margin:0 6px;color:#d1d5db">/</span>--%>
<%--                <a href="${pageContext.request.contextPath}/admin/orders" style="color:#6b7280;text-decoration:none;">Quản lý hoá đơn</a>--%>
<%--                <span style="margin:0 6px;color:#d1d5db">/</span>--%>
<%--                <span class="active-crumb">Chi tiết hoá đơn</span>--%>
<%--            </div>--%>
<%--            <div class="navbar-right">--%>
<%--                <button class="notif-btn">--%>
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
<%--            <!-- Top actions bar -->--%>
<%--            <div class="detail-topbar">--%>
<%--                <a href="${pageContext.request.contextPath}/admin/orders" class="back-link">--%>
<%--                    <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>--%>
<%--                    Quay lại danh sách--%>
<%--                </a>--%>
<%--                <div class="topbar-actions">--%>
<%--                    <a href="${pageContext.request.contextPath}/admin/orders/print?id=<%= hd.getId() %>" class="btn-print" target="_blank">--%>
<%--                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>--%>
<%--                        In hoá đơn--%>
<%--                    </a>--%>
<%--                    <button class="btn-action" style="background:#3b82f6;color:white;border:none;" onclick="openModal('update', null, 'Cập nhật trạng thái')">Cập nhật trạng thái</button>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Thông báo sau action -->--%>
<%--            <% String msgParam = request.getParameter("msg");--%>
<%--                if (msgParam != null) { %>--%>
<%--            <div style="background:#dcfce7;border:1px solid #86efac;color:#166534;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-size:13px;font-weight:500;">--%>
<%--                ✅ <%= "cancelled".equals(msgParam) ? "Huỷ đơn thành công, tồn kho đã được hoàn trả." : "Cập nhật trạng thái thành công!" %>--%>
<%--            </div>--%>
<%--            <% } %>--%>

<%--            <!-- Main 2-column layout -->--%>
<%--            <div class="detail-layout">--%>

<%--                <!-- LEFT: Main content -->--%>
<%--                <div class="detail-main">--%>

<%--                    <!-- Invoice heading card -->--%>
<%--                    <div class="detail-card">--%>
<%--                        <div class="invoice-heading">--%>
<%--                            <div class="invoice-icon-row">--%>
<%--                                <div>--%>
<%--                                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;margin-bottom:2px;letter-spacing:0.05em;">MÃ HOÁ ĐƠN</div>--%>
<%--                                    <div class="invoice-id">HD<%= hd.getId() %></div>--%>
<%--                                    <div class="invoice-date">Ngày đặt: <%= hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "—" %></div>--%>
<%--                                </div>--%>
<%--                                <span class="badge <%= badgeClass %>"><%= badgeLabel %></span>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- Product table -->--%>
<%--                        <table class="prod-table">--%>
<%--                            <thead>--%>
<%--                            <tr>--%>
<%--                                <th>Sản phẩm</th>--%>
<%--                                <th>Đơn giá</th>--%>
<%--                                <th>SL</th>--%>
<%--                                <th>Thành tiền</th>--%>
<%--                            </tr>--%>
<%--                            </thead>--%>
<%--                            <tbody>--%>
<%--                            <%--%>
<%--                                // Map tên sản phẩm mock vì database thiếu bảng san_pham--%>
<%--                                Map<Integer, String> mockNames = new java.util.HashMap<>();--%>
<%--                                mockNames.put(1, "Áo khoác da nam Premium");--%>
<%--                                mockNames.put(2, "Bomber jacket oversize");--%>
<%--                                mockNames.put(3, "Áo denim wash nữ");--%>
<%--                                mockNames.put(4, "Áo phao siêu nhẹ");--%>
<%--                                mockNames.put(5, "Khoác gió windbreaker");--%>

<%--                                if (chiTietList != null && !chiTietList.isEmpty()) {--%>
<%--                                    for (ChiTietHoaDon ct : chiTietList) {--%>
<%--                                        String donGia   = ct.getDonGia()   != null ? String.format("%,.0fđ", ct.getDonGia()).replace(",", ".")   : "—";--%>
<%--                                        String thanhTien= ct.getThanhTien()!= null ? String.format("%,.0fđ", ct.getThanhTien()).replace(",", ".") : "—";--%>

<%--                                        String spName = "Sản phẩm không xác định";--%>
<%--                                        if (ct.getChiTietSanPham() != null && ct.getChiTietSanPham().getIdSanPham() != null) {--%>
<%--                                            spName = mockNames.getOrDefault(ct.getChiTietSanPham().getIdSanPham(), "Chi tiết SP #" + ct.getChiTietSanPham().getId());--%>
<%--                                        }--%>
<%--                            %>--%>
<%--                            <tr>--%>
<%--                                <td style="font-weight:500; color:#111827;"><%= spName %></td>--%>
<%--                                <td><%= donGia %></td>--%>
<%--                                <td><%= ct.getSoLuong() != null ? ct.getSoLuong() : 0 %></td>--%>
<%--                                <td style="font-weight:700;"><%= thanhTien %></td>--%>
<%--                            </tr>--%>
<%--                            <%  }--%>
<%--                            } else { %>--%>
<%--                            <tr><td colspan="4" style="text-align:center;padding:30px;color:#9ca3af;">Chưa có sản phẩm.</td></tr>--%>
<%--                            <% } %>--%>
<%--                            </tbody>--%>
<%--                        </table>--%>

<%--                        <!-- Financial summary -->--%>
<%--                        <div style="border-top: 1px solid #f3f4f6; margin-top: 8px;">--%>
<%--                            <div class="fin-row">--%>
<%--                                <span class="fin-label">Tạm tính</span>--%>
<%--                                <span class="fin-value">--%>
<%--                                    <%= hd.getTamTinh() != null ? String.format("%,.0fđ", hd.getTamTinh()).replace(",", ".") : "—" %>--%>
<%--                                </span>--%>
<%--                            </div>--%>
<%--                            <% if (hd.getTienGiamHoaDon() != null && hd.getTienGiamHoaDon() > 0) { %>--%>
<%--                            <div class="fin-row">--%>
<%--                                <span class="fin-label">Giảm giá</span>--%>
<%--                                <span class="fin-value" style="color:#22c55e;">--%>
<%--                                    -<%= String.format("%,.0fđ", hd.getTienGiamHoaDon()).replace(",", ".") %>--%>
<%--                                </span>--%>
<%--                            </div>--%>
<%--                            <% } %>--%>
<%--                            <% Double phiVanChuyen = 30000.0; %>--%>
<%--                            <div class="fin-row">--%>
<%--                                <span class="fin-label">Phí vận chuyển</span>--%>
<%--                                <span class="fin-value">--%>
<%--                                    <%= String.format("%,.0fđ", phiVanChuyen).replace(",", ".") %>--%>
<%--                                </span>--%>
<%--                            </div>--%>
<%--                            <hr class="fin-divider">--%>
<%--                            <div class="fin-total">--%>
<%--                                <span class="label">Tổng cộng</span>--%>
<%--                                <span class="value">--%>
<%--                                    <%--%>
<%--                                        Double tamTinh = hd.getTamTinh() != null ? hd.getTamTinh() : 0.0;--%>
<%--                                        Double giamGia = hd.getTienGiamHoaDon() != null ? hd.getTienGiamHoaDon() : 0.0;--%>
<%--                                        Double tongDisplay = tamTinh - giamGia + phiVanChuyen;--%>
<%--                                    %>--%>
<%--                                    <%= String.format("%,.0fđ", tongDisplay).replace(",", ".") %>--%>
<%--                                </span>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- Timeline card -->--%>
<%--                    <div class="detail-card">--%>
<%--                        <div class="timeline-section">--%>
<%--                            <h3>Lịch sử xử lý đơn hàng</h3>--%>
<%--                            <ul class="tl-list">--%>
<%--                                <%--%>
<%--                                    if (lichSuList != null && !lichSuList.isEmpty()) {--%>
<%--                                        for (LichSuHoaDon ls : lichSuList) {--%>
<%--                                            String moiLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(ls.getTrangThaiMoi(), "?") : "?";--%>
<%--                                            String timeStr  = ls.getThoiGianCapNhat() != null ? ls.getThoiGianCapNhat().format(dtfFull) : "";--%>
<%--                                            String actor    = ls.getNguoiThucHien() != null ? ls.getNguoiThucHien().getHoTen()--%>
<%--                                                    : (ls.getKhachHang() != null ? ls.getKhachHang().getHoTen() : "Hệ thống");--%>
<%--                                %>--%>
<%--                                <li class="tl-item">--%>
<%--                                    <div class="tl-dot"></div>--%>
<%--                                    <div class="tl-title"><%= moiLabel %></div>--%>
<%--                                    <div class="tl-time"><%= timeStr %></div>--%>
<%--                                    <% if (ls.getGhiChu() != null && !ls.getGhiChu().isEmpty()) { %>--%>
<%--                                    <div class="tl-note"><%= ls.getGhiChu() %></div>--%>
<%--                                    <% } %>--%>
<%--                                </li>--%>
<%--                                <%  }--%>
<%--                                } else { %>--%>
<%--                                <li style="color:#9ca3af;font-size:13px;">Chưa có lịch sử thay đổi trạng thái.</li>--%>
<%--                                <% } %>--%>
<%--                            </ul>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                </div><!-- /detail-main -->--%>

<%--                <!-- RIGHT: Sidebar info -->--%>
<%--                <div class="detail-side">--%>

<%--                    <!-- Customer info -->--%>
<%--                    <div class="side-card">--%>
<%--                        <div class="side-card-title">Thông tin khách hàng</div>--%>
<%--                        <div class="kh-avatar-row">--%>
<%--                            <div class="kh-avatar"><%= avatarChar %></div>--%>
<%--                            <div>--%>
<%--                                <div class="kh-info-name"><%= tenKH %></div>--%>
<%--                                <div class="kh-info-role">Khách hàng</div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="contact-row">--%>
<%--                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.62 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l.81-.81a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 17z"/></svg>--%>
<%--                            <span class="contact-value"><%= sdtKH %></span>--%>
<%--                        </div>--%>
<%--                        <div class="contact-row">--%>
<%--                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>--%>
<%--                            <span class="contact-value"><%= emailKH %></span>--%>
<%--                        </div>--%>
<%--                        <div class="contact-row">--%>
<%--                            <svg class="contact-icon" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>--%>
<%--                            <span class="contact-value"><%= diaChiKH %></span>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- Payment info -->--%>
<%--                    <div class="side-card">--%>
<%--                        <div class="side-card-title">Thanh toán</div>--%>
<%--                        <div class="pay-method-row">--%>
<%--                            <div class="pay-icon">--%>
<%--                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>--%>
<%--                            </div>--%>
<%--                            <div>--%>
<%--                                <div class="pay-method-name"><%= pttt %></div>--%>
<%--                                <div class="pay-method-sub">Phương thức thanh toán</div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="pay-row">--%>
<%--                            <span class="lbl">Trạng thái TT</span>--%>
<%--                            <span class="val <%= daTT ? "paid" : "unpaid" %>">--%>
<%--                                <%= daTT ? "Đã thanh toán" : "Chưa thanh toán" %>--%>
<%--                            </span>--%>
<%--                        </div>--%>
<%--                        <div class="pay-row" style="border-top:1px solid #f3f4f6;padding-top:10px;margin-top:4px;">--%>
<%--                            <span class="lbl" style="font-weight:700;color:#111827;">Tổng tiền</span>--%>
<%--                            <span class="val total">--%>
<%--                                <%= hd.getTongThanhToan() != null ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—" %>--%>
<%--                            </span>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- Note -->--%>
<%--                    <div class="side-card">--%>
<%--                        <div class="side-card-title">Ghi chú đơn hàng</div>--%>
<%--                        <p class="note-text">--%>
<%--                            <%= (hd.getGhiChu() != null && !hd.getGhiChu().isEmpty()) ? hd.getGhiChu() : "Không có ghi chú." %>--%>
<%--                        </p>--%>
<%--                    </div>--%>

<%--                </div><!-- /detail-side -->--%>
<%--            </div><!-- /detail-layout -->--%>
<%--        </div><!-- /content-wrapper -->--%>
<%--    </main>--%>
<%--</div>--%>

<%--<!-- Modal: Cập nhật trạng thái -->--%>
<%--<div class="modal-overlay" id="confirmModal">--%>
<%--    <div class="modal-box">--%>
<%--        <h3 id="modalTitle">Cập nhật trạng thái</h3>--%>
<%--        <p id="modalDesc">Xác nhận thay đổi trạng thái đơn hàng?</p>--%>
<%--        <form method="post" action="${pageContext.request.contextPath}/admin/orders/update-status">--%>
<%--            <input type="hidden" name="hoaDonId" value="<%= hd.getId() %>">--%>
<%--            <input type="hidden" name="nhanVienId" value="1">--%>
<%--            <div class="modal-field">--%>
<%--                <label>Trạng thái mới</label>--%>
<%--                <select name="trangThaiMoi" id="trangThaiSelect">--%>
<%--                    <option value="0" <%= tt == 0 ? "selected" : "" %>>Chờ xác nhận</option>--%>
<%--                    <option value="1" <%= tt == 1 ? "selected" : "" %>>Đã xác nhận</option>--%>
<%--                    <option value="2" <%= tt == 2 ? "selected" : "" %>>Đang giao hàng</option>--%>
<%--                    <option value="3" <%= tt == 3 ? "selected" : "" %>>Hoàn thành</option>--%>
<%--                    <option value="4" <%= tt == 4 ? "selected" : "" %>>Đã huỷ</option>--%>
<%--                </select>--%>
<%--            </div>--%>
<%--            <div class="modal-field">--%>
<%--                <label>Ghi chú (tuỳ chọn)</label>--%>
<%--                <textarea name="ghiChu" rows="3" placeholder="Ghi chú kèm theo..."></textarea>--%>
<%--            </div>--%>
<%--            <div class="modal-actions">--%>
<%--                <button type="button" class="btn-cancel-m" onclick="closeModal('confirmModal')">Huỷ</button>--%>
<%--                <button type="submit" class="btn-ok blue" id="btnOk">Cập nhật</button>--%>
<%--            </div>--%>
<%--        </form>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- Modal: Huỷ đơn -->--%>
<%--<div class="modal-overlay" id="cancelModal">--%>
<%--    <div class="modal-box">--%>
<%--        <h3 style="color:#ef4444;">⚠️ Xác nhận huỷ đơn hàng</h3>--%>
<%--        <p>Thao tác này sẽ hoàn trả tồn kho và không thể hoàn tác.</p>--%>
<%--        <form method="post" action="${pageContext.request.contextPath}/admin/orders/cancel">--%>
<%--            <input type="hidden" name="hoaDonId" value="<%= hd.getId() %>">--%>
<%--            <input type="hidden" name="nhanVienId" value="1">--%>
<%--            <div class="modal-field">--%>
<%--                <label>Lý do huỷ đơn *</label>--%>
<%--                <textarea name="lyDo" rows="3" placeholder="Nhập lý do huỷ..."></textarea>--%>
<%--            </div>--%>
<%--            <div class="modal-actions">--%>
<%--                <button type="button" class="btn-cancel-m" onclick="closeModal('cancelModal')">Quay lại</button>--%>
<%--                <button type="submit" class="btn-ok red">Xác nhận huỷ</button>--%>
<%--            </div>--%>
<%--        </form>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<% if ("updated".equals(request.getParameter("msg"))) { %>--%>
<%--<div class="toast-notification" id="toastSuccess" style="top:24px; bottom:auto;">--%>
<%--    <div class="toast-icon">--%>
<%--        <svg viewBox="0 0 24 24" width="24" height="24" stroke="#10B981" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">--%>
<%--            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>--%>
<%--            <polyline points="22 4 12 14.01 9 11.01"></polyline>--%>
<%--        </svg>--%>
<%--    </div>--%>
<%--    <div class="toast-content">--%>
<%--        <div class="toast-title">Successfully saved!</div>--%>
<%--        <div class="toast-message">Anyone with a link can now view this file.</div>--%>
<%--    </div>--%>
<%--    <button class="toast-close" onclick="document.getElementById('toastSuccess').style.display='none'">--%>
<%--        <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round">--%>
<%--            <line x1="18" y1="6" x2="6" y2="18"></line>--%>
<%--            <line x1="6" y1="6" x2="18" y2="18"></line>--%>
<%--        </svg>--%>
<%--    </button>--%>
<%--</div>--%>
<%--<% } %>--%>

<%--<script>--%>
<%--    const MODAL_CONFIG = {--%>
<%--        confirm: {--%>
<%--            1: { title: 'Xác nhận đơn hàng', desc: 'Xác nhận đơn hàng này?', color: 'blue' },--%>
<%--            2: { title: 'Giao hàng', desc: 'Chuyển trạng thái sang Đang giao hàng?', color: 'yellow' },--%>
<%--            3: { title: 'Hoàn thành đơn hàng', desc: 'Xác nhận đơn hàng đã giao thành công?', color: 'green' },--%>
<%--        }--%>
<%--    };--%>

<%--    function openModal(type, trangThai, title) {--%>
<%--        if (type === 'cancel') {--%>
<%--            document.getElementById('cancelModal').classList.add('show');--%>
<%--        } else {--%>
<%--            document.getElementById('modalTitle').textContent = title || 'Cập nhật trạng thái';--%>
<%--            document.getElementById('modalDesc').textContent  = 'Chọn trạng thái mới cho đơn hàng này:';--%>
<%--            document.getElementById('confirmModal').classList.add('show');--%>
<%--        }--%>
<%--    }--%>

<%--    function closeModal(id) {--%>
<%--        document.getElementById(id).classList.remove('show');--%>
<%--    }--%>

<%--    // Close on overlay click--%>
<%--    document.querySelectorAll('.modal-overlay').forEach(o => {--%>
<%--        o.addEventListener('click', e => { if (e.target === o) o.classList.remove('show'); });--%>
<%--    });--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>

