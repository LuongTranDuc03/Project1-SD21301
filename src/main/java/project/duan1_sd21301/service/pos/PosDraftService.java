package project.duan1_sd21301.service.pos;

import project.duan1_sd21301.dto.pos.PosOrderRequestDTO;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PosDraftService {

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

    public Map<String, Object> createDraftOrder(Employee loggedInUser) {
        Map<String, Object> result = new HashMap<>();
        String sql = "INSERT INTO hoa_don (hoa_don_code, id_nhan_vien, loai_hoa_don, trang_thai_don_hang, trang_thai_thanh_toan, "
                +
                "ten_khach_nhan, tam_tinh, tong_thanh_toan, tong_so_luong, ngay_dat_hang) VALUES (?, ?, 0, 1, 0, N'Khách lẻ', 0, 0, 0, GETDATE())";
        try (Connection conn = DatabaseConnection.getConnection()) {
            String code = generateInvoiceCode(conn);
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, code);
                if (loggedInUser != null) {
                    ps.setInt(2, loggedInUser.getId());
                } else {
                    ps.setNull(2, Types.INTEGER);
                }
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        result.put("success", true);
                        result.put("id", rs.getInt(1));
                        result.put("code", code);
                        return result;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        result.put("success", false);
        return result;
    }

    public Map<String, Object> addOrUpdateItem(int invoiceId, String variantCode, int quantity, String variantName,
            double price, String colorSize) {
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 0. Lock invoice to prevent deadlock
            String lockSql = "SELECT id FROM hoa_don WITH (UPDLOCK, ROWLOCK) WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setInt(1, invoiceId);
                try (ResultSet rs = ps.executeQuery()) {}
            }

            // 1. Get Product Detail ID and current stock
            Integer pdId = null;
            int currentStock = 0;
            String pdSql = "SELECT id, so_luong FROM chi_tiet_san_pham WHERE chi_tiet_san_pham_code = ?";
            try (PreparedStatement ps = conn.prepareStatement(pdSql)) {
                ps.setString(1, variantCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        pdId = rs.getInt("id");
                        currentStock = rs.getInt("so_luong");
                    } else {
                        throw new Exception("Variant not found");
                    }
                }
            }

            // 2. Check if item already in draft
            Integer cthdId = null;
            int existingQty = 0;
            String checkSql = "SELECT id, so_luong FROM chi_tiet_hoa_don WHERE id_hoa_don = ? AND id_chi_tiet_san_pham = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, invoiceId);
                ps.setInt(2, pdId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cthdId = rs.getInt("id");
                        existingQty = rs.getInt("so_luong");
                    }
                }
            }

            // 3. Calculate stock diff
            int qtyDiff = quantity - existingQty;
            if (qtyDiff > 0 && currentStock < qtyDiff) {
                throw new Exception("Sản phẩm không đủ số lượng (còn " + currentStock + ")");
            }

            // 4. Update InvoiceDetail
            if (cthdId == null) {
                if (quantity > 0) {
                    String insertCthd = "INSERT INTO chi_tiet_hoa_don (chi_tiet_hoa_don_code, id_hoa_don, id_chi_tiet_san_pham, don_gia, so_luong, thanh_tien, ten_sp_tai_thoi_diem, mo_ta_variant) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(insertCthd)) {
                        ps.setString(1, "CTHD" + System.currentTimeMillis() % 100000);
                        ps.setInt(2, invoiceId);
                        ps.setInt(3, pdId);
                        ps.setDouble(4, price);
                        ps.setInt(5, quantity);
                        ps.setDouble(6, price * quantity);
                        ps.setString(7, variantName);
                        ps.setString(8, colorSize);
                        ps.executeUpdate();
                    }
                }
            } else {
                if (quantity > 0) {
                    String updateCthd = "UPDATE chi_tiet_hoa_don SET so_luong = ?, thanh_tien = ? WHERE id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateCthd)) {
                        ps.setInt(1, quantity);
                        ps.setDouble(2, price * quantity);
                        ps.setInt(3, cthdId);
                        ps.executeUpdate();
                    }
                } else {
                    String deleteCthd = "DELETE FROM chi_tiet_hoa_don WHERE id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(deleteCthd)) {
                        ps.setInt(1, cthdId);
                        ps.executeUpdate();
                    }
                }
            }

            // 5. Update stock
            if (qtyDiff != 0) {
                String updateStock = "UPDATE chi_tiet_san_pham SET so_luong = so_luong - ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateStock)) {
                    ps.setInt(1, qtyDiff);
                    ps.setInt(2, pdId);
                    ps.executeUpdate();
                }
            }

            // 6. Update invoice total
            updateInvoiceTotal(conn, invoiceId);

            conn.commit();
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            result.put("success", false);
            result.put("message", e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public Map<String, Object> removeItem(int invoiceId, String variantCode) {
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 0. Lock invoice to prevent deadlock
            String lockSql = "SELECT id FROM hoa_don WITH (UPDLOCK, ROWLOCK) WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setInt(1, invoiceId);
                try (ResultSet rs = ps.executeQuery()) {}
            }

            // Find pdId
            int pdId = -1;
            String findPd = "SELECT id FROM chi_tiet_san_pham WHERE chi_tiet_san_pham_code = ?";
            try (PreparedStatement ps = conn.prepareStatement(findPd)) {
                ps.setString(1, variantCode);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        pdId = rs.getInt("id");
                    }
                }
            }

            if (pdId == -1) {
                throw new Exception("Sản phẩm không tồn tại");
            }

            // Find existing qty
            int existingQty = 0;
            Integer cthdId = null;
            String checkSql = "SELECT id, so_luong FROM chi_tiet_hoa_don WHERE id_hoa_don = ? AND id_chi_tiet_san_pham = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, invoiceId);
                ps.setInt(2, pdId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cthdId = rs.getInt("id");
                        existingQty = rs.getInt("so_luong");
                    }
                }
            }

            if (cthdId != null) {
                // Restore stock
                String updateStock = "UPDATE chi_tiet_san_pham SET so_luong = so_luong + ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateStock)) {
                    ps.setInt(1, existingQty);
                    ps.setInt(2, pdId);
                    ps.executeUpdate();
                }

                // Delete cthd
                String deleteCthd = "DELETE FROM chi_tiet_hoa_don WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(deleteCthd)) {
                    ps.setInt(1, cthdId);
                    ps.executeUpdate();
                }

                // Update invoice total
                updateInvoiceTotal(conn, invoiceId);
            }

            conn.commit();
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            result.put("success", false);
            result.put("message", e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    private void updateInvoiceTotal(Connection conn, int invoiceId) throws SQLException {
        String sql = "UPDATE hoa_don SET tong_so_luong = (SELECT ISNULL(SUM(so_luong), 0) FROM chi_tiet_hoa_don WHERE id_hoa_don = ?), "
                +
                "tam_tinh = (SELECT ISNULL(SUM(thanh_tien), 0) FROM chi_tiet_hoa_don WHERE id_hoa_don = ?), " +
                "tong_thanh_toan = (SELECT ISNULL(SUM(thanh_tien), 0) FROM chi_tiet_hoa_don WHERE id_hoa_don = ?) + ISNULL(phi_van_chuyen, 0) - ISNULL(tien_giam_hoa_don, 0) "
                +
                "WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ps.setInt(2, invoiceId);
            ps.setInt(3, invoiceId);
            ps.setInt(4, invoiceId);
            ps.executeUpdate();
        }
    }

    public Map<String, Object> deleteDraftOrder(int invoiceId) {
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 0. Lock invoice to prevent deadlock
            String lockSql = "SELECT id FROM hoa_don WITH (UPDLOCK, ROWLOCK) WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setInt(1, invoiceId);
                try (ResultSet rs = ps.executeQuery()) {}
            }

            // 1. Restore stock
            String getItems = "SELECT id_chi_tiet_san_pham, so_luong FROM chi_tiet_hoa_don WHERE id_hoa_don = ?";
            try (PreparedStatement ps = conn.prepareStatement(getItems)) {
                ps.setInt(1, invoiceId);
                try (ResultSet rs = ps.executeQuery()) {
                    String updateStock = "UPDATE chi_tiet_san_pham SET so_luong = so_luong + ? WHERE id = ?";
                    try (PreparedStatement psStock = conn.prepareStatement(updateStock)) {
                        while (rs.next()) {
                            psStock.setInt(1, rs.getInt("so_luong"));
                            psStock.setInt(2, rs.getInt("id_chi_tiet_san_pham"));
                            psStock.addBatch();
                        }
                        psStock.executeBatch();
                    }
                }
            }

            // 2. Delete details
            String delDetails = "DELETE FROM chi_tiet_hoa_don WHERE id_hoa_don = ?";
            try (PreparedStatement ps = conn.prepareStatement(delDetails)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            // 2.5 Delete history to prevent FK constraints
            String delHistory = "DELETE FROM lich_su_hoa_don WHERE id_hoa_don = ?";
            try (PreparedStatement ps = conn.prepareStatement(delHistory)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            String delPaymentHistory = "DELETE FROM lich_su_thanh_toan WHERE id_hoa_don = ?";
            try (PreparedStatement ps = conn.prepareStatement(delPaymentHistory)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            // 3. Delete invoice
            String delInvoice = "DELETE FROM hoa_don WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(delInvoice)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            conn.commit();
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            result.put("success", false);
            result.put("message", e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
    }

    public Map<String, Object> updateDraftInfo(PosOrderRequestDTO dto) {
        Map<String, Object> result = new HashMap<>();
        if (dto.getId() == null || dto.getId().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Invalid invoice ID");
            return result;
        }

        int invoiceId = Integer.parseInt(dto.getId());

        String sql = "UPDATE hoa_don SET " +
                "id_khach_hang = (SELECT id FROM khach_hang WHERE khach_hang_code = ?), " +
                "id_ma_giam_gia = (SELECT id FROM phieu_giam_gia WHERE phieu_giam_gia_code = ?), " +
                "ghi_chu = ?, ten_khach_nhan = ?, sdt_khach_nhan = ?, dia_chi_khach_nhan = ?, phi_van_chuyen = ?, loai_hoa_don = ? " +
                "WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String cusCode = dto.getCustomerCode();
            if (cusCode == null || cusCode.trim().isEmpty() || cusCode.equals("Khách lẻ")) {
                ps.setNull(1, Types.VARCHAR);
            } else {
                ps.setString(1, cusCode);
            }

            String disCode = dto.getDiscountCode();
            if (disCode == null || disCode.trim().isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, disCode);
            }

            ps.setString(3, dto.getNote());
            
            if (dto.isDelivery()) {
                ps.setString(4, dto.getRecipientName());
                ps.setString(5, dto.getDeliveryPhone());
                String addressFull = "";
                if (dto.getDeliveryAddress() != null) addressFull += dto.getDeliveryAddress();
                if (dto.getWard() != null) addressFull += ", " + dto.getWard();
                if (dto.getDistrict() != null) addressFull += ", " + dto.getDistrict();
                if (dto.getProvince() != null) addressFull += ", " + dto.getProvince();
                ps.setString(6, addressFull);
                
                double ship = 0;
                try { ship = Double.parseDouble(dto.getShippingFee()); } catch(Exception ignored){}
                ps.setDouble(7, ship);
                ps.setInt(8, 0); // Still 0 for POS draft
            } else {
                ps.setNull(4, Types.VARCHAR);
                ps.setNull(5, Types.VARCHAR);
                ps.setNull(6, Types.VARCHAR);
                ps.setDouble(7, 0);
                ps.setInt(8, 0);
            }

            ps.setInt(9, invoiceId);

            ps.executeUpdate();
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    public List<Map<String, Object>> getPendingDrafts(int employeeId) {
        List<Map<String, Object>> drafts = new ArrayList<>();
        // Select invoices that are POS (loai_hoa_don=0) and unpaid (trang_thai_don_hang=0)
        // created by the specific employee
        String sql = "SELECT hd.id, hd.hoa_don_code, hd.ghi_chu, hd.ten_khach_nhan, hd.sdt_khach_nhan, hd.dia_chi_khach_nhan, hd.phi_van_chuyen, " +
                     "kh.khach_hang_code, kh.ho_ten as ten_khach_hang, kh.so_dien_thoai as sdt_khach_hang, " +
                     "pg.phieu_giam_gia_code, pg.gia_tri_giam " +
                     "FROM hoa_don hd " +
                     "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                     "LEFT JOIN phieu_giam_gia pg ON hd.id_ma_giam_gia = pg.id " +
                     "WHERE hd.loai_hoa_don = 0 AND hd.trang_thai_don_hang = 1 AND hd.id_nhan_vien = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> draft = new HashMap<>();
                draft.put("id", rs.getInt("id"));
                draft.put("code", rs.getString("hoa_don_code"));
                
                draft.put("customerCode", rs.getString("khach_hang_code") != null ? rs.getString("khach_hang_code") : "");
                draft.put("customerName", rs.getString("ten_khach_hang") != null ? rs.getString("ten_khach_hang") : "Khách lẻ");
                draft.put("customerPhone", rs.getString("sdt_khach_hang") != null ? rs.getString("sdt_khach_hang") : "");
                
                draft.put("discountCode", rs.getString("phieu_giam_gia_code") != null ? rs.getString("phieu_giam_gia_code") : "");
                draft.put("discountValue", rs.getString("gia_tri_giam") != null ? rs.getString("gia_tri_giam") : "");
                
                draft.put("note", rs.getString("ghi_chu") != null ? rs.getString("ghi_chu") : "");
                
                draft.put("recipientName", rs.getString("ten_khach_nhan") != null ? rs.getString("ten_khach_nhan") : "");
                draft.put("deliveryPhone", rs.getString("sdt_khach_nhan") != null ? rs.getString("sdt_khach_nhan") : "");
                
                String addressFull = rs.getString("dia_chi_khach_nhan");
                draft.put("deliveryAddress", addressFull != null ? addressFull : "");
                
                boolean isDelivery = (addressFull != null && !addressFull.trim().isEmpty()) || 
                                     (rs.getString("ten_khach_nhan") != null && !rs.getString("ten_khach_nhan").trim().isEmpty());
                draft.put("isDelivery", isDelivery);
                
                double shippingFee = rs.getDouble("phi_van_chuyen");
                draft.put("shippingFee", shippingFee > 0 ? String.valueOf(shippingFee) : "");

                // Get items
                List<Map<String, Object>> items = new ArrayList<>();
                String itemSql = "SELECT ct.so_luong, ct.don_gia, ct.ten_sp_tai_thoi_diem, ct.mo_ta_variant, sp.chi_tiet_san_pham_code, "
                        +
                        "sp.so_luong as stock, p.san_pham_code as productCode, " +
                        "(SELECT TOP 1 h.duong_dan FROM hinh_anh h WHERE h.id_chi_tiet_san_pham = sp.id ORDER BY h.thu_tu ASC) as image "
                        +
                        "FROM chi_tiet_hoa_don ct " +
                        "JOIN chi_tiet_san_pham sp ON ct.id_chi_tiet_san_pham = sp.id " +
                        "JOIN san_pham p ON sp.id_san_pham = p.id " +
                        "WHERE ct.id_hoa_don = ?";
                try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                    psItem.setInt(1, rs.getInt("id"));
                    try (ResultSet rsItem = psItem.executeQuery()) {
                        while (rsItem.next()) {
                            Map<String, Object> item = new HashMap<>();
                            item.put("code", rsItem.getString("chi_tiet_san_pham_code"));
                            item.put("productCode", rsItem.getString("productCode"));
                            item.put("name", rsItem.getString("ten_sp_tai_thoi_diem"));
                            item.put("image", rsItem.getString("image"));
                            item.put("stock", rsItem.getInt("stock"));

                            // parse color/size from mo_ta_variant (e.g. "Red - L")
                            String desc = rsItem.getString("mo_ta_variant");
                            if (desc != null && desc.contains(" - ")) {
                                String[] parts = desc.split(" - ");
                                item.put("color", parts[0]);
                                item.put("size", parts.length > 1 ? parts[1] : "");
                            } else {
                                item.put("color", "");
                                item.put("size", desc);
                            }

                            item.put("price", rsItem.getDouble("don_gia"));
                            item.put("quantity", rsItem.getInt("so_luong"));
                            items.add(item);
                        }
                    }
                }
                draft.put("items", items);
                drafts.add(draft);
            }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drafts;
    }

    public void cleanupOldDrafts() {
        String findSql = "SELECT id FROM hoa_don WHERE loai_hoa_don = 0 AND trang_thai_don_hang = 1 AND CAST(ngay_dat_hang AS DATE) < CAST(GETDATE() AS DATE)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(findSql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                deleteDraftOrder(id);
                System.out.println("Cleaned up old POS draft: " + id);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }}

    
    
        
    
    

    
        
        
        // 
        
        
        
                
                
            
                
                
                

                
                
                
                        
                        
                        
                
                    
                    
                        
                            
                            
                            

                            
                            
                            
                                
                                
                                
                            
                                
                                
                            

                            
                            
                            
                        
                    
                
                
                
            
        
            
        
        
    

    
        
        
                
                

            
                
                
                
            
        
            
        
    

