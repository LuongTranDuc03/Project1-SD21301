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

            // 3. Lookup Coupon ID & Update Usage
            Integer couponId = null;
            if (orderDTO.getDiscountCode() != null && !orderDTO.getDiscountCode().trim().isEmpty()) {
                String couponSql = "SELECT id, so_luong, da_su_dung, han_su_dung_moi_khach FROM phieu_giam_gia WHERE phieu_giam_gia_code = ?";
                try (PreparedStatement ps = conn.prepareStatement(couponSql)) {
                    ps.setString(1, orderDTO.getDiscountCode());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            couponId = rs.getInt("id");
                            int soLuong = rs.getInt("so_luong");
                            int daSuDung = rs.getInt("da_su_dung");
                            int hanSuDungMoiKhach = rs.getInt("han_su_dung_moi_khach");
                            
                            // Check total quantity
                            if (rs.getObject("so_luong") != null && daSuDung >= soLuong) {
                                throw new RuntimeException("Mã giảm giá đã hết lượt sử dụng toàn hệ thống!");
                            }
                            
                            // Check usage limit per customer
                            if (customerId != null) {
                                String countSql = "SELECT COUNT(*) FROM hoa_don WHERE id_khach_hang = ? AND id_ma_giam_gia = ? AND trang_thai_don_hang != 4"; // 4 = Cancelled
                                try (PreparedStatement psCount = conn.prepareStatement(countSql)) {
                                    psCount.setInt(1, customerId);
                                    psCount.setInt(2, couponId);
                                    try (ResultSet rsCount = psCount.executeQuery()) {
                                        if (rsCount.next()) {
                                            int usedByCustomer = rsCount.getInt(1);
                                            if (usedByCustomer >= hanSuDungMoiKhach) {
                                                throw new RuntimeException("Khách hàng này đã sử dụng mã giảm giá này " + usedByCustomer + " lần (Hạn mức: " + hanSuDungMoiKhach + " lần/khách)!");
                                            }
                                        }
                                    }
                                }
                            }
                            
                            updateCouponUsage(conn, couponId);
                        } else {
                            throw new RuntimeException("Mã giảm giá không tồn tại!");
                        }
                    }
                }
            }

            // 4. Lookup Payment Method ID
            String paymentMethod = orderDTO.getPaymentMethod() != null ? orderDTO.getPaymentMethod() : "CASH";
            int paymentMethodId = paymentMethod.equals("TRANSFER") ? 2 : 1; 
            String paymentMethodName = paymentMethod.equals("TRANSFER") ? "Chuyển khoản" : "Tiền mặt";

            // 5. Determine Order Status
            int orderStatus = orderDTO.isDelivery() ? 1 : 3; // 1: Đã xác nhận (Giao hàng), 3: Hoàn thành (Tại quầy)
            
            // Recalculate totals for safety
            int totalQuantity = 0;
            double sumTotal = 0;
            for (PosOrderItemDTO item : orderDTO.getItems()) {
                totalQuantity += item.getQuantity();
                sumTotal += (item.getPrice() * item.getQuantity());
            }
            
            double discountAmt = 0;
            try { discountAmt = Double.parseDouble(orderDTO.getDiscountValue()); } catch(Exception ignored) {}
            double shippingFee = 0;
            try { shippingFee = Double.parseDouble(orderDTO.getShippingFee()); } catch(Exception ignored) {}
            
            double finalTotal = sumTotal + shippingFee - discountAmt;
            if (finalTotal < 0) finalTotal = 0;
            
            double customerPay = finalTotal; // Assume full payment upon confirm for POS

            // 6. Insert Invoice (hoa_don)
            String addressFull = "";
            if (orderDTO.isDelivery()) {
                addressFull = orderDTO.getDeliveryAddress() + ", " + orderDTO.getWard() + ", " + orderDTO.getDistrict() + ", " + orderDTO.getProvince();
            }
            
            String insertInvoiceSql = "INSERT INTO hoa_don (hoa_don_code, id_khach_hang, id_nhan_vien, id_phuong_thuc_thanh_toan, id_ma_giam_gia, " +
                    "loai_hoa_don, trang_thai_don_hang, trang_thai_thanh_toan, da_thanh_toan, " +
                    "ten_khach_nhan, sdt_khach_nhan, dia_chi_khach_nhan, ghi_chu, " +
                    "tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, phi_van_chuyen, " +
                    "ngay_dat_hang, ngay_xac_nhan, ngay_hoan_thanh) " +
                    "VALUES (?, ?, ?, ?, ?, 0, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";
                    
            int invoiceId = -1;
            try (PreparedStatement ps = conn.prepareStatement(insertInvoiceSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, invoiceCode);
                if (customerId != null) ps.setInt(2, customerId); else ps.setNull(2, Types.INTEGER);
                ps.setInt(3, loggedInUser.getId());
                ps.setInt(4, paymentMethodId);
                if (couponId != null) ps.setInt(5, couponId); else ps.setNull(5, Types.INTEGER);
                ps.setInt(6, orderStatus);
                ps.setDouble(7, customerPay);
                ps.setString(8, orderDTO.isDelivery() ? orderDTO.getRecipientName() : null);
                ps.setString(9, orderDTO.isDelivery() ? orderDTO.getDeliveryPhone() : null);
                ps.setString(10, orderDTO.isDelivery() ? addressFull : null);
                ps.setString(11, orderDTO.getNote());
                ps.setInt(12, totalQuantity);
                ps.setDouble(13, sumTotal);
                ps.setDouble(14, discountAmt);
                ps.setDouble(15, finalTotal);
                ps.setDouble(16, shippingFee);
                
                if (!orderDTO.isDelivery()) {
                    ps.setString(17, "GETDATE()"); // SQL will fail if setString for date function. We should use Timestamp.
                } else {
                    ps.setNull(17, Types.TIMESTAMP);
                }
                // Fix for GETDATE() parameter issue
            }
            
            // Redoing insertInvoiceSql to fix Date param
            String insertInvoiceSqlFixed = "INSERT INTO hoa_don (hoa_don_code, id_khach_hang, id_nhan_vien, id_phuong_thuc_thanh_toan, id_ma_giam_gia, " +
                    "loai_hoa_don, trang_thai_don_hang, trang_thai_thanh_toan, da_thanh_toan, " +
                    "ten_khach_nhan, sdt_khach_nhan, dia_chi_khach_nhan, ghi_chu, " +
                    "tong_so_luong, tam_tinh, tien_giam_hoa_don, tong_thanh_toan, phi_van_chuyen, " +
                    "ngay_dat_hang, ngay_xac_nhan, ngay_hoan_thanh) " +
                    "VALUES (?, ?, ?, ?, ?, 0, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";
                    
            try (PreparedStatement ps = conn.prepareStatement(insertInvoiceSqlFixed, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, invoiceCode);
                if (customerId != null) ps.setInt(2, customerId); else ps.setNull(2, Types.INTEGER);
                ps.setInt(3, loggedInUser.getId());
                ps.setInt(4, paymentMethodId);
                if (couponId != null) ps.setInt(5, couponId); else ps.setNull(5, Types.INTEGER);
                ps.setInt(6, orderStatus);
                ps.setDouble(7, customerPay);
                ps.setString(8, orderDTO.isDelivery() ? orderDTO.getRecipientName() : orderDTO.getCustomerName());
                ps.setString(9, orderDTO.isDelivery() ? orderDTO.getDeliveryPhone() : orderDTO.getCustomerPhone());
                ps.setString(10, orderDTO.isDelivery() ? addressFull : null);
                ps.setString(11, orderDTO.getNote());
                ps.setInt(12, totalQuantity);
                ps.setDouble(13, sumTotal);
                ps.setDouble(14, discountAmt);
                ps.setDouble(15, finalTotal);
                ps.setDouble(16, shippingFee);
                
                if (!orderDTO.isDelivery()) {
                    ps.setTimestamp(17, new Timestamp(System.currentTimeMillis()));
                } else {
                    ps.setNull(17, Types.TIMESTAMP);
                }
                
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        invoiceId = rs.getInt(1);
                    }
                }
            }

            // 7. Insert Invoice Details and update stock
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

            // 8. Insert Invoice History
            String historySql = "INSERT INTO lich_su_hoa_don (lich_su_hoa_don_code, id_hoa_don, id_nguoi_thuc_hien, id_khach_hang, trang_thai_cu, trang_thai_moi, ghi_chu, thoi_gian_cap_nhat, trang_thai) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), 1)";
            try (PreparedStatement ps = conn.prepareStatement(historySql)) {
                ps.setString(1, "LSHD" + System.currentTimeMillis());
                ps.setInt(2, invoiceId);
                ps.setInt(3, loggedInUser.getId());
                if (customerId != null) ps.setInt(4, customerId); else ps.setNull(4, Types.INTEGER);
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
            return invoiceCode;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw new RuntimeException(e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    private Integer getCouponId(Connection conn, String code) throws SQLException {
        String sql = "SELECT id FROM phieu_giam_gia WHERE phieu_giam_gia_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
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
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }
}
