<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.HoaDon" %>
<%@ page import="project.duan1_sd21301.model.ChiTietHoaDon" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In hoá đơn - <%= request.getAttribute("hoaDon") != null ? "#HD-" + ((HoaDon)request.getAttribute("hoaDon")).getId() : "" %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        /* ===== Print Page Layout ===== */
        .print-topbar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 0 40px; height: 60px; background: #fff;
            border-bottom: 1px solid #e5e7eb; position: sticky; top: 0; z-index: 10;
        }
        .back-link {
            display: inline-flex; align-items: center; gap: 8px;
            color: #374151; text-decoration: none; font-size: 13px; font-weight: 500;
        }
        .back-link:hover { color: #E11D48; }
        .print-title { font-size: 13px; color: #6b7280; font-weight: 500; }
        .btn-print-now {
            display: inline-flex; align-items: center; gap: 8px;
            background: #E11D48; color: #fff; border: none;
            padding: 9px 18px; border-radius: 8px; font-size: 13px;
            font-weight: 600; cursor: pointer; text-decoration: none;
        }
        .btn-print-now:hover { background: #be123c; }

        .print-area {
            max-width: 780px;
            margin: 32px auto;
            padding: 0 20px 40px;
        }

        /* Invoice document */
        .invoice-doc {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e5e7eb;
            padding: 40px;
            box-shadow: 0 4px 24px rgba(0,0,0,.06);
        }

        /* Header: company + invoice title */
        .doc-header {
            display: flex; justify-content: space-between; align-items: flex-start;
            padding-bottom: 20px; border-bottom: 2px solid #f3f4f6; margin-bottom: 24px;
        }
        .company-logo {
            width: 44px; height: 44px; border-radius: 10px;
            background: linear-gradient(135deg, #FB7185, #E11D48);
            display: flex; align-items: center; justify-content: center;
            color: #fff; margin-bottom: 8px;
        }
        .company-name { font-size: 18px; font-weight: 800; color: #111827; }
        .company-sub  { font-size: 11px; color: #9ca3af; margin-bottom: 8px; }
        .company-info { font-size: 11px; color: #6b7280; line-height: 1.7; }

        .doc-title-block { text-align: right; }
        .doc-title { font-size: 26px; font-weight: 800; color: #E11D48; letter-spacing: 1px; }
        .doc-id    { font-size: 15px; font-weight: 700; color: #111827; margin: 4px 0; }
        .doc-date  { font-size: 12px; color: #6b7280; margin-bottom: 8px; }
        .doc-status {
            display: inline-flex; align-items: center; padding: 4px 12px;
            border-radius: 20px; font-size: 11px; font-weight: 700;
            border: 1.5px solid;
        }
        .doc-status.hoan-thanh { color: #166534; border-color: #86efac; background: #f0fdf4; }
        .doc-status.dang-giao  { color: #854d0e; border-color: #fde68a; background: #fefce8; }
        .doc-status.cho-xu-ly  { color: #0c4a6e; border-color: #bae6fd; background: #f0f9ff; }
        .doc-status.da-huy     { color: #991b1b; border-color: #fca5a5; background: #fff1f2; }

        /* Customer + Delivery row */
        .doc-parties {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 24px; margin-bottom: 24px;
        }
        .party-label {
            font-size: 10px; font-weight: 700; color: #9ca3af;
            text-transform: uppercase; letter-spacing: .06em; margin-bottom: 8px;
        }
        .party-name  { font-size: 14px; font-weight: 700; color: #111827; margin-bottom: 6px; }
        .party-info  { font-size: 12px; color: #6b7280; line-height: 1.7; }

        /* Product table */
        .doc-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .doc-table thead { background: #111827; }
        .doc-table thead th {
            padding: 10px 14px; color: #fff; font-size: 12px; font-weight: 600;
            text-align: left;
        }
        .doc-table thead th:not(:first-child) { text-align: right; }
        .doc-table thead th:first-child { border-radius: 6px 0 0 6px; }
        .doc-table thead th:last-child  { border-radius: 0 6px 6px 0; }
        .doc-table tbody tr { border-bottom: 1px solid #f3f4f6; }
        .doc-table tbody tr:last-child { border-bottom: none; }
        .doc-table tbody td {
            padding: 12px 14px; font-size: 13px; color: #374151;
        }
        .doc-table tbody td:not(:first-child) { text-align: right; }

        /* Financial block */
        .doc-fin { margin-left: auto; width: 260px; }
        .doc-fin-row {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 13px; padding: 7px 0;
            border-bottom: 1px dashed #f3f4f6;
        }
        .doc-fin-row:last-child { border-bottom: none; }
        .doc-fin-row .lbl { color: #6b7280; }
        .doc-fin-row .val { font-weight: 600; color: #111827; }
        .doc-fin-total {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 15px; font-weight: 800; margin-top: 10px;
            padding-top: 12px; border-top: 2px solid #111827;
        }
        .doc-fin-total .val { color: #E11D48; font-size: 18px; }
        .doc-fin-sub { font-size: 11px; color: #9ca3af; text-align: right; margin-top: 4px; }

        /* Note + Footer */
        .doc-note { margin-top: 28px; padding-top: 20px; border-top: 1px solid #f3f4f6; }
        .doc-note-label { font-size: 11px; font-weight: 700; color: #6b7280; text-transform: uppercase; letter-spacing: .04em; margin-bottom: 6px; }
        .doc-note-text  { font-size: 12px; color: #374151; line-height: 1.7; }
        .doc-footer {
            text-align: center; margin-top: 32px; padding-top: 20px;
            border-top: 1px solid #f3f4f6; font-size: 11px; color: #9ca3af; line-height: 1.7;
        }

        /* Print @media */
        @media print {
            .print-topbar { display: none !important; }
            .print-area { margin: 0; padding: 0; max-width: 100%; }
            .invoice-doc { border: none; border-radius: 0; box-shadow: none; padding: 20px; }
            body { background: #fff !important; }
        }
    </style>
</head>
<body style="background:#F1F5F9; font-family:'Inter',sans-serif;">
<%
    HoaDon hd = (HoaDon) request.getAttribute("hoaDon");
    List<ChiTietHoaDon> chiTietList = (List<ChiTietHoaDon>) request.getAttribute("chiTietList");
    Map<Integer, String> trangThaiLabels = (Map<Integer, String>) request.getAttribute("trangThaiLabels");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    if (hd == null) { response.sendRedirect(request.getContextPath() + "/admin/orders"); return; }

    int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;
    java.util.function.Function<Integer, String> bClass = (t) -> {
        if (t == null) return "cho-xu-ly";
        if (t == 3) return "hoan-thanh";
        if (t == 2) return "dang-giao";
        if (t == 1) return "da-xac-nhan";
        if (t == 4) return "da-huy";
        return "cho-xu-ly";
    };
    String badgeClass = bClass.apply(tt);
    String badgeLabel = trangThaiLabels != null ? trangThaiLabels.getOrDefault(tt, "?") : "?";

    String tenKH    = hd.getTenKhachHang()   != null ? hd.getTenKhachHang()   : "Khách vãng lai";
    String sdtKH    = hd.getSdtKhachHang()   != null ? hd.getSdtKhachHang()   : "—";
    String emailKH  = hd.getEmailKhachHang() != null ? hd.getEmailKhachHang() : "—";
    String diaChiKH = hd.getDiaChiKhachHang()!= null ? hd.getDiaChiKhachHang(): "—";
    String pttt     = hd.getPhuongThucThanhToan() != null ? hd.getPhuongThucThanhToan().getTenPhuongThuc() : "—";
    String ngayDat  = hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "—";
%>

<!-- Top bar (hidden when printing) -->
<div class="print-topbar">
    <a href="${pageContext.request.contextPath}/admin/orders/detail?id=<%= hd.getId() %>" class="back-link">
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
                    for (ChiTietHoaDon ct : chiTietList) {
                        String donGia    = ct.getDonGia()    != null ? String.format("%,.0fđ", ct.getDonGia()).replace(",",".")    : "—";
                        String thanhTien = ct.getThanhTien() != null ? String.format("%,.0fđ", ct.getThanhTien()).replace(",",".") : "—";
                        String spName = ct.getChiTietSanPham() != null ? "Sản phẩm #" + ct.getChiTietSanPham().getId() : "—";
            %>
                <tr>
                    <td style="color:#9ca3af;"><%= idx++ %></td>
                    <td style="font-weight:500;color:#111827;"><%= spName %></td>
                    <td><%= donGia %></td>
                    <td><%= ct.getSoLuong() != null ? ct.getSoLuong() : 0 %></td>
                    <td style="font-weight:700;"><%= thanhTien %></td>
                </tr>
            <%  }
                } else { %>
                <tr><td colspan="5" style="text-align:center;padding:24px;color:#9ca3af;">Không có sản phẩm.</td></tr>
            <% } %>
            </tbody>
        </table>

        <!-- Financial -->
        <div class="doc-fin">
            <div class="doc-fin-row">
                <span class="lbl">Tạm tính</span>
                <span class="val"><%= hd.getTamTinh() != null ? String.format("%,.0fđ", hd.getTamTinh()).replace(",",".") : "—" %></span>
            </div>
            <% if (hd.getTienGiamHoaDon() != null && hd.getTienGiamHoaDon() > 0) { %>
            <div class="doc-fin-row">
                <span class="lbl">Giảm giá</span>
                <span class="val" style="color:#22c55e;">-<%= String.format("%,.0fđ", hd.getTienGiamHoaDon()).replace(",",".") %></span>
            </div>
            <% } %>
            <div class="doc-fin-total">
                <span>TỔNG CỘNG</span>
                <span class="val"><%= hd.getTongThanhToan() != null ? String.format("%,.0fđ", hd.getTongThanhToan()).replace(",",".") : "—" %></span>
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
