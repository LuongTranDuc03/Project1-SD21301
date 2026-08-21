package project.duan1_sd21301.service.pos;

import project.duan1_sd21301.dto.pos.PosOrderItemDTO;
import project.duan1_sd21301.dto.pos.PosOrderRequestDTO;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;

public class PosCheckoutService {

    public String processCheckout(PosOrderRequestDTO orderDTO, Employee loggedInUser) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Generate Invoice Code
            String invoiceCode = generateInvoiceCode(conn);

            // 2. Lookup Customer ID
            Integer customerId = null;
            if (orderDTO.getCustomerCode() != null && !orderDTO.getCustomerCode().trim().isEmpty()) {
                customerId = getCustomerId(conn, orderDTO.getCustomerCode());
            }

            // 3. Recalculate totals first so we can validate coupon conditions
            int totalQuantity = 0;
            double sumTotal = 0;
            for (PosOrderItemDTO item : orderDTO.getItems()) {
                totalQuantity += item.getQuantity();
                sumTotal += (item.getPrice() * item.getQuantity());
            }

            // 4. Lookup Coupon ID & Validate Usage/Expiration/Changes
            Integer couponId = null;
            double discountAmt = 0;
            if (orderDTO.getDiscountCode() != null && !orderDTO.getDiscountCode().trim().isEmpty()) {
                String couponSql = "SELECT id, so_luong, da_su_dung, han_su_dung_moi_khach, trang_thai, ngay_ket_thuc, gia_tri_don_hang_toi_thieu, loai_giam, gia_tri_giam, giam_toi_da FROM phieu_giam_gia WHERE phieu_giam_gia_code = ?";
                try (PreparedStatement ps = conn.prepareStatement(couponSql)) {
                    ps.setString(1, orderDTO.getDiscountCode());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            couponId = rs.getInt("id");
                            int soLuong = rs.getInt("so_luong");
                            int daSuDung = rs.getInt("da_su_dung");
                            int hanSuDungMoiKhach = rs.getInt("han_su_dung_moi_khach");
                            int trangThai = rs.getInt("trang_thai");
                            Timestamp ngayKetThuc = rs.getTimestamp("ngay_ket_thuc");
                            double donToiThieu = rs.getDouble("gia_tri_don_hang_toi_thieu");
                            int loaiGiam = rs.getInt("loai_giam");
                            double giaTriGiam = rs.getDouble("gia_tri_giam");
                            double giamToiDa = rs.getDouble("giam_toi_da");

                            // Check status and expiration
                            if (trangThai != 1) {
                                throw new RuntimeException(
                                        "COUPON_CHANGED:Phiếu giảm giá đã thay đổi trạng thái không kích hoạt.");
                            }
                            if (ngayKetThuc != null && ngayKetThuc.before(new java.util.Date())) {
                                throw new RuntimeException("COUPON_CHANGED:Phiếu giảm giá đã hết hạn.");
                            }
                            if (sumTotal < donToiThieu) {
                                throw new RuntimeException(
                                        "COUPON_CHANGED:Phiếu giảm giá đã thay đổi điều kiện đơn tối thiểu.");
                            }

                            // Check total quantity
                            if (rs.getObject("so_luong") != null && daSuDung >= soLuong) {
                                throw new RuntimeException("Mã giảm giá đã hết lượt sử dụng toàn hệ thống!");
                            }

                            // Check usage limit per customer
                            if (customerId != null) {
                                String countSql = "SELECT COUNT(*) FROM hoa_don WHERE id_khach_hang = ? AND id_ma_giam_gia = ? AND trang_thai_don_hang != 3"; // 3
                                                                                                                                                              // =
                                                                                                                                                              // Đã
                                                                                                                                                              // huỷ
                                try (PreparedStatement psCount = conn.prepareStatement(countSql)) {
                                    psCount.setInt(1, customerId);
                                    psCount.setInt(2, couponId);
                                    try (ResultSet rsCount = psCount.executeQuery()) {
                                        if (rsCount.next()) {
                                            int usedByCustomer = rsCount.getInt(1);
                                            if (usedByCustomer >= hanSuDungMoiKhach) {
                                                throw new RuntimeException("Khách hàng này đã sử dụng mã giảm giá này "
                                                        + usedByCustomer + " lần (Hạn mức: " + hanSuDungMoiKhach
                                                        + " lần/khách)!");
                                            }
                                        }
                                    }
                                }
                            }

                            // Recalculate discount value
                            double expectedDiscount = 0;
                            if (loaiGiam == 1) { // Fixed Amount
                                expectedDiscount = giaTriGiam;
                            } else if (loaiGiam == 0) { // Percentage
                                expectedDiscount = sumTotal * (giaTriGiam / 100.0);
                                if (giamToiDa > 0 && expectedDiscount > giamToiDa) {
                                    expectedDiscount = giamToiDa;
                                }
                            }
                            if (expectedDiscount > sumTotal) {
                                expectedDiscount = sumTotal;
                            }

                            double frontendDiscount = 0;
                            try {
                                frontendDiscount = Double.parseDouble(orderDTO.getDiscountValue());
                            } catch (Exception ignored) {
                            }

                            // If calculated discount differs from what frontend sent, it means the coupon
                            // config was changed by admin
                            if (Math.abs(expectedDiscount - frontendDiscount) > 1.0) {
                                throw new RuntimeException(
                                        "COUPON_CHANGED:Phiếu giảm giá đã bị thay đổi giá trị hoặc thông tin.");
                            }

                            discountAmt = expectedDiscount;
                            updateCouponUsage(conn, couponId);
                        } else {
                            throw new RuntimeException("Mã giảm giá không tồn tại!");
                        }
                    }
                }
            }

            // 5. Lookup Payment Method ID
            String paymentMethod = orderDTO.getPaymentMethod() != null ? orderDTO.getPaymentMethod() : "CASH";
            int paymentMethodId = paymentMethod.equals("TRANSFER") ? 2 : 1;
            String paymentMethodName = paymentMethod.equals("TRANSFER") ? "Chuyển khoản" : "Tiền mặt";

            // 6. Determine Order Status - Luồng bán tại quầy: 2 = Đã thanh toán
            int orderStatus = 2; // Tất cả đơn POS đều là tại quầy = Đã thanh toán

            double shippingFee = 0;
            try {
                shippingFee = Double.parseDouble(orderDTO.getShippingFee());
            } catch (Exception ignored) {
            }

            double finalTotal = sumTotal + shippingFee - discountAmt;
            if (finalTotal < 0)
                finalTotal = 0;

            double customerPay = finalTotal; // Assume full payment upon confirm for POS

            // 6. Insert or Update Invoice (hoa_don)
            String addressFull = "";
            if (orderDTO.isDelivery()) {
                addressFull = orderDTO.getDeliveryAddress() + ", " + orderDTO.getWard() + ", " + orderDTO.getDistrict()
                        + ", " + orderDTO.getProvince();
            }

            int invoiceId = -1;
            boolean isDraft = false;
            if (orderDTO.getId() != null && orderDTO.getId().matches("\\d+")) {
                invoiceId = Integer.parseInt(orderDTO.getId());
                isDraft = true;
            }

            if (isDraft) {
                // UPDATE existing draft invoice
                String updateInvoiceSql = "UPDATE hoa_don SET id_khach_hang = ?, id_nhan_vien = ?, id_phuong_thuc_thanh_toan = ?, id_ma_giam_gia = ?, "
                        +
                        "trang_thai_don_hang = ?, trang_thai_thanh_toan = 1, da_thanh_toan = ?, " +
                        "ten_khach_nhan = ?, sdt_khach_nhan = ?, dia_chi_khach_nhan = ?, ghi_chu = ?, " +
                        "tong_so_luong = ?, tam_tinh = ?, tien_giam_hoa_don = ?, tong_thanh_toan = ?, phi_van_chuyen = ?, "
                        +
                        "ngay_xac_nhan = GETDATE(), ngay_hoan_thanh = ?, loai_hoa_don = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateInvoiceSql)) {
                    if (customerId != null)
                        ps.setInt(1, customerId);
                    else
                        ps.setNull(1, Types.INTEGER);
                    ps.setInt(2, loggedInUser.getId());
                    ps.setInt(3, paymentMethodId);
                    if (couponId != null)
                        ps.setInt(4, couponId);
                    else
                        ps.setNull(4, Types.INTEGER);
                    ps.setInt(5, orderStatus);
                    ps.setDouble(6, customerPay);
                    ps.setString(7, orderDTO.isDelivery() ? orderDTO.getRecipientName() : orderDTO.getCustomerName());
                    ps.setString(8, orderDTO.isDelivery() ? orderDTO.getDeliveryPhone() : orderDTO.getCustomerPhone());
                    ps.setString(9, orderDTO.isDelivery() ? addressFull : null);
                    ps.setString(10, orderDTO.getNote());
                    ps.setInt(11, totalQuantity);
                    ps.setDouble(12, sumTotal);
                    ps.setDouble(13, discountAmt);
                    ps.setDouble(14, finalTotal);
                    ps.setDouble(15, shippingFee);

                    if (!orderDTO.isDelivery()) {
                        ps.setTimestamp(16, new Timestamp(System.currentTimeMillis()));
                    } else {
                        ps.setNull(16, Types.TIMESTAMP);
                    }
                    ps.setInt(17, orderDTO.isDelivery() ? 1 : 0);
                    ps.setInt(18, invoiceId);
                    ps.executeUpdate();
                }

                // Get invoice code for response
                try (PreparedStatement ps = conn.prepareStatement("SELECT hoa_don_code FROM hoa_don WHERE id = ?")) {
                    ps.setInt(1, invoiceId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            invoiceCode = rs.getString(1);
                        }
                    }
                }
            } else {
                // INSERT new invoice (fallback)
                String insertInvoiceSqlFixed = "INSERT INTO hoa_don (hoa_don_code, id_khach_hang, id_nhan_vien, id_phuong_thuc_thanh_toan, id_ma_giam_gia, "
                        +
                        "loai_hoa_don, trang_thai_don_hang, trang_thai_thanh_toan, da_thanh_toan, " +
                        "ten_khach_nhan, sdt_khach_nhan, dia_chi_khach_nhan, ghi_chu, " +
                        "tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, phi_van_chuyen, " +
                        "ngay_dat_hang, ngay_xac_nhan, ngay_hoan_thanh) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";

                try (PreparedStatement ps = conn.prepareStatement(insertInvoiceSqlFixed,
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, invoiceCode);
                    if (customerId != null)
                        ps.setInt(2, customerId);
                    else
                        ps.setNull(2, Types.INTEGER);
                    ps.setInt(3, loggedInUser.getId());
                    ps.setInt(4, paymentMethodId);
                    if (couponId != null)
                        ps.setInt(5, couponId);
                    else
                        ps.setNull(5, Types.INTEGER);
                    ps.setInt(6, orderDTO.isDelivery() ? 1 : 0);
                    ps.setInt(7, orderStatus);
                    ps.setDouble(8, customerPay);
                    ps.setString(9, orderDTO.isDelivery() ? orderDTO.getRecipientName() : orderDTO.getCustomerName());
                    ps.setString(10, orderDTO.isDelivery() ? orderDTO.getDeliveryPhone() : orderDTO.getCustomerPhone());
                    ps.setString(11, orderDTO.isDelivery() ? addressFull : null);
                    ps.setString(12, orderDTO.getNote());
                    ps.setInt(13, totalQuantity);
                    ps.setDouble(14, sumTotal);
                    ps.setDouble(15, discountAmt);
                    ps.setDouble(16, finalTotal);
                    ps.setDouble(17, shippingFee);

                    if (!orderDTO.isDelivery()) {
                        ps.setTimestamp(18, new Timestamp(System.currentTimeMillis()));
                    } else {
                        ps.setNull(18, Types.TIMESTAMP);
                    }

                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            invoiceId = rs.getInt(1);
                        }
                    }
                }
            }

            // 7. Delete old invoice details (if draft) then re-insert + update stock
            if (isDraft) {
                // Get old details to restore stock first
                String oldDetailsSql = "SELECT id_chi_tiet_san_pham, so_luong FROM chi_tiet_hoa_don WHERE id_hoa_don = ?";
                try (PreparedStatement ps = conn.prepareStatement(oldDetailsSql)) {
                    ps.setInt(1, invoiceId);
                    try (ResultSet rs = ps.executeQuery()) {
                        String restoreStockSql = "UPDATE chi_tiet_san_pham SET so_luong = so_luong + ? WHERE id = ?";
                        try (PreparedStatement psRestore = conn.prepareStatement(restoreStockSql)) {
                            while (rs.next()) {
                                psRestore.setInt(1, rs.getInt("so_luong"));
                                psRestore.setInt(2, rs.getInt("id_chi_tiet_san_pham"));
                                psRestore.addBatch();
                            }
                            psRestore.executeBatch();
                        }
                    }
                }
                // Delete old details
                try (PreparedStatement ps = conn
                        .prepareStatement("DELETE FROM chi_tiet_hoa_don WHERE id_hoa_don = ?")) {
                    ps.setInt(1, invoiceId);
                    ps.executeUpdate();
                }
            }

            // Always insert new invoice details and deduct stock
            {
                String detailSql = "INSERT INTO chi_tiet_hoa_don (chi_tiet_hoa_don_code, id_hoa_don, id_chi_tiet_san_pham, don_gia, so_luong, thanh_tien, ten_sp_tai_thoi_diem, mo_ta_variant) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                String stockSql = "UPDATE chi_tiet_san_pham SET so_luong = so_luong - ? WHERE id = ?";

                try (PreparedStatement psDetail = conn.prepareStatement(detailSql);
                        PreparedStatement psStock = conn.prepareStatement(stockSql)) {

                    int cthdIndex = 1;
                    for (PosOrderItemDTO item : orderDTO.getItems()) {
                        Integer productDetailId = getProductDetailId(conn, item.getCode());
                        if (productDetailId == null) {
                            throw new SQLException("Product variant not found: " + item.getCode());
                        }

                        // Insert detail
                        String cthdCode = "CTHD" + System.currentTimeMillis() + "-" + cthdIndex++;
                        psDetail.setString(1, cthdCode);
                        psDetail.setInt(2, invoiceId);
                        psDetail.setInt(3, productDetailId);
                        psDetail.setDouble(4, item.getPrice());
                        psDetail.setInt(5, item.getQuantity());
                        psDetail.setDouble(6, item.getPrice() * item.getQuantity());
                        psDetail.setString(7, item.getName());
                        psDetail.setString(8, item.getColor() + " - " + item.getSize());
                        psDetail.addBatch();

                        // Update stock
                        psStock.setInt(1, item.getQuantity());
                        psStock.setInt(2, productDetailId);
                        psStock.addBatch();
                    }
                    psDetail.executeBatch();
                    psStock.executeBatch();
                }
            }

            // 8. Insert Invoice History
            String historySql = "INSERT INTO lich_su_hoa_don (lich_su_hoa_don_code, id_hoa_don, id_nguoi_thuc_hien, id_khach_hang, trang_thai_cu, trang_thai_moi, ghi_chu, thoi_gian_cap_nhat, trang_thai) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), 1)";
            try (PreparedStatement ps = conn.prepareStatement(historySql)) {
                ps.setString(1, "LSHD" + System.currentTimeMillis());
                ps.setInt(2, invoiceId);
                ps.setInt(3, loggedInUser.getId());
                if (customerId != null)
                    ps.setInt(4, customerId);
                else
                    ps.setNull(4, Types.INTEGER);
                ps.setInt(5, 0); // Trạng thái cũ (0 = chưa có gì)
                ps.setInt(6, orderStatus);
                ps.setString(7, "Khách thanh toán tại quầy thành công");
                ps.executeUpdate();
            }

            // 9. Insert Payment History
            String paymentSql = "INSERT INTO lich_su_thanh_toan (lich_su_thanh_toan_code, id_hoa_don, ma_giao_dich_cong, so_tien, noi_dung, trang_thai, thoi_gian_giao_dich) VALUES (?, ?, ?, ?, ?, 1, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(paymentSql)) {
                ps.setString(1, "LSTT" + System.currentTimeMillis());
                ps.setInt(2, invoiceId);
                ps.setString(3, "POS_" + invoiceCode); // Transaction code
                ps.setDouble(4, customerPay);
                ps.setString(5, "Thanh toán " + paymentMethodName);
                ps.executeUpdate();
            }

            conn.commit();
            // Trả về dạng "invoiceId|invoiceCode" để controller có thể truyền cả hai giá
            // trị
            return invoiceId + "|" + invoiceCode;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw new RuntimeException(e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private String generateInvoiceCode(Connection conn) throws SQLException {
        String sql = "SELECT MAX(id) FROM hoa_don";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                int maxId = rs.getInt(1);
                return String.format("HD%04d", maxId + 1);
            }
        }
        return "HD0001";
    }

    private Integer getCustomerId(Connection conn, String code) throws SQLException {
        String sql = "SELECT id FROM khach_hang WHERE khach_hang_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return null;
    }

    private Integer getCouponId(Connection conn, String code) throws SQLException {
        String sql = "SELECT id FROM phieu_giam_gia WHERE phieu_giam_gia_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return null;
    }

    private void updateCouponUsage(Connection conn, int couponId) throws SQLException {
        String sql = "UPDATE phieu_giam_gia SET da_su_dung = ISNULL(da_su_dung, 0) + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            ps.executeUpdate();
        }
    }

    private Integer getProductDetailId(Connection conn, String variantCode) throws SQLException {
        String sql = "SELECT id FROM chi_tiet_san_pham WHERE chi_tiet_san_pham_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, variantCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return null;
    }
}
