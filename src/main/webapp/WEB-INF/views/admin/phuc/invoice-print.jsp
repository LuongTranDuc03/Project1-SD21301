<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.phuc.Invoice" %>
<%@ page import="project.duan1_sd21301.model.phuc.InvoiceDetail" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In hoá đơn - <%= request.getAttribute("hoaDon") != null ? "#HD-" + ((Invoice) request.getAttribute("hoaDon")).getId() : "" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/invoices/invoice-print.css">
</head>
<body style="background:#F1F5F9;font-family:'Inter',sans-serif;">
<%
    Invoice hd = (Invoice) request.getAttribute("hoaDon");
    List<InvoiceDetail> chiTietList = (List<InvoiceDetail>) request.getAttribute("chiTietList");
    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    if (hd == null) { response.sendRedirect(request.getContextPath() + "/admin/invoices"); return; }

    int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;
    java.util.function.Function<Integer, String> bClassFn = (t) -> {
        if (t == null) return "cho-xu-ly";
        if (t == 4)    return "da-huy";
        if (t == 3)    return "hoan-thanh";
        if (t == 2)    return "dang-giao";
        if (t == 1)    return "da-xac-nhan";
        return "cho-xu-ly";
    };
    String badgeClass = bClassFn.apply(tt);
    String badgeLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";

    String tenKH    = hd.getTenKhachHang()    != null ? hd.getTenKhachHang()    : "";
    String sdtKH    = hd.getSdtKhachHang()    != null ? hd.getSdtKhachHang()    : "—";
    String emailKH  = hd.getEmailKhachHang()  != null ? hd.getEmailKhachHang()  : "—";
    String diaChiKH = hd.getDiaChiKhachHang() != null ? hd.getDiaChiKhachHang() : "—";
    String pttt     = hd.getPaymentMethod()   != null ? hd.getPaymentMethod().getTenPhuongThuc() : "—";
    String ngayDat  = hd.getNgayDatHang()     != null ? hd.getNgayDatHang().format(dtf) : "—";
%>

<!-- Top bar (hidden when printing) -->
<div class="print-topbar">
    <a href="${pageContext.request.contextPath}/admin/invoices/detail?id=<%= hd.getId() %>" class="back-link">
        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        Quay lại
    </a>
    <span class="print-title">Xem trước bản in — #HD-<%= hd.getId() %></span>
    <button class="btn-print-now" onclick="window.print()">
        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
        In ngay
    </button>
</div>

<!-- Invoice document -->
<div class="print-area">
    <div class="invoice-doc">

        <!-- Header: Company + HOÁ ĐƠN -->
        <div class="doc-header">
            <div>
                <div class="company-logo">
                    <svg viewBox="0 0 24 24" width="22" height="22" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.38 3.46L16 2.14a2 2 0 0 0-1.16 0l-4.38 1.32a2 2 0 0 1-1.16 0L4.92 2.14a2 2 0 0 0-2.4 1.77L2 14a8 8 0 0 0 8 8h4a8 8 0 0 0 8-8l-.52-10.09a2 2 0 0 0-1.1-1.45z"/></svg>
                </div>
                <div class="company-name">FamiCoats</div>
                <div class="company-sub">Admin Panel</div>
                <div class="company-info">
                    123 Lê Lợi, Quận 1, TP. Hồ Chí Minh<br>
                    Hotline: 1800 1234 &nbsp;|&nbsp; info@famicoats.vn<br>
                    MST: 0123456789
                </div>
            </div>
            <div class="doc-title-block">
                <div class="doc-title">HÓA ĐƠN</div>
                <div class="doc-id">#HD-<%= hd.getId() %></div>
                <div class="doc-date">Ngày: <%= ngayDat %></div>
                <span class="doc-status <%= badgeClass %>"><%= badgeLabel %></span>
            </div>
        </div>

        <!-- Customer + Delivery -->
        <div class="doc-parties">
            <div>
                <div class="party-label">Thông tin người mua</div>
                <div class="party-name"><%= tenKH %></div>
                <div class="party-info">
                    <%= sdtKH %><br>
                    <%= emailKH %><br>
                    <%= diaChiKH %>
                </div>
            </div>
            <div>
                <div class="party-label">Địa chỉ giao hàng</div>
                <div class="party-name"><%= tenKH %></div>
                <div class="party-info">
                    <%= diaChiKH %><br>
                    SDT: <%= sdtKH %>
                </div>
            </div>
        </div>

        <!-- Product table -->
        <table class="doc-table">
            <thead>
            <tr>
                <th>STT</th>
                <th>Tên sản phẩm</th>
                <th>Đơn giá</th>
                <th>SL</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (chiTietList != null && !chiTietList.isEmpty()) {
                    int idx = 1;
                    for (InvoiceDetail ct : chiTietList) {
                        String donGia    = ct.getDonGia()    != null ? String.format("%,.0fđ", ct.getDonGia()).replace(",", ".")    : "—";
                        String thanhTien = ct.getThanhTien() != null ? String.format("%,.0fđ", ct.getThanhTien()).replace(",", ".") : "—";
                        String spName;
                        if (ct.getProductDetail() != null) {
                            spName = "SP #" + ct.getProductDetail().getId();
                            if (ct.getProductDetail().getSize()  != null) spName += " - " + ct.getProductDetail().getSize();
                            if (ct.getProductDetail().getColor() != null) spName += " / " + ct.getProductDetail().getColor();
                        } else {
                            spName = "Sản phẩm không xác định";
                        }
            %>
            <tr>
                <td style="color:#9ca3af;"><%= idx++ %></td>
                <td style="font-weight:500;color:#111827;"><%= spName %></td>
                <td><%= donGia %></td>
                <td><%= ct.getSoLuong() != null ? ct.getSoLuong() : 0 %></td>
                <td style="font-weight:700;"><%= thanhTien %></td>
            </tr>
            <%
                    }
                } else { %>
            <tr><td colspan="5" style="text-align:center;padding:24px;color:#9ca3af;">Không có sản phẩm.</td></tr>
            <% } %>
            </tbody>
        </table>

        <!-- Financial -->
        <div class="doc-fin">
            <div class="doc-fin-row">
                <span class="lbl">Tạm tính</span>
                <span class="val"><%= hd.getTamTinh() != null ? String.format("%,.0fđ", hd.getTamTinh()).replace(",", ".") : "—" %></span>
            </div>
            <% if (hd.getTienGiamHoaDon() != null && hd.getTienGiamHoaDon() > 0) { %>
            <div class="doc-fin-row">
                <span class="lbl">Giảm giá</span>
                <span class="val" style="color:#22c55e;">-<%= String.format("%,.0fđ", hd.getTienGiamHoaDon()).replace(",", ".") %></span>
            </div>
            <% } %>
            <div class="doc-fin-total">
                <span>TỔNG CỘNG</span>
                <span class="val"><%= hd.getTongThanhToan() != null ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",", ".") : "—" %></span>
            </div>
            <div class="doc-fin-sub">Thanh toán qua: <strong><%= pttt %></strong></div>
        </div>

        <!-- Note -->
        <div class="doc-note">
            <div class="doc-note-label">Ghi chú</div>
            <div class="doc-note-text">
                <%= (hd.getGhiChu() != null && !hd.getGhiChu().isEmpty())
                        ? hd.getGhiChu()
                        : "Cảm ơn bạn đã mua hàng tại FamiCoats!\nHàng đổi trả trong vòng 7 ngày nếu có lỗi từ nhà sản xuất." %>
            </div>
        </div>

        <!-- Footer -->
        <div class="doc-footer">
            FamiCoats &nbsp;·&nbsp; famicoats.vn &nbsp;·&nbsp; 1900 1234 &nbsp;·&nbsp;
            In lúc: <%= new java.util.Date() %>
        </div>

    </div><!-- /invoice-doc -->
</div><!-- /print-area -->

</body>
</html>
