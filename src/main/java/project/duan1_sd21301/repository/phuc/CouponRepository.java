package project.duan1_sd21301.repository.phuc;

import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CouponRepository {

    public void updateExpiredCoupons() {
        String sql = "UPDATE phieu_giam_gia SET trang_thai = 2 WHERE trang_thai != 2 AND ngay_ket_thuc < CAST(GETDATE() AS DATE)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Coupon save(Coupon coupon) {
        if (coupon.getCode() == null || coupon.getCode().trim().isEmpty()) {
            coupon.setCode("PGG" + System.currentTimeMillis() % 100000);
        }
        String sql = "INSERT INTO phieu_giam_gia (phieu_giam_gia_code, ten_chuong_trinh, loai_giam, gia_tri_giam, " +
                "gia_tri_don_hang_toi_thieu, giam_toi_da, so_luong, da_su_dung, han_su_dung_moi_khach, ngay_bat_dau, ngay_ket_thuc, mo_ta, trang_thai) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getName());
            if (coupon.getDiscountType() != null) ps.setInt(3, coupon.getDiscountType()); else ps.setNull(3, Types.INTEGER);
            if (coupon.getDiscountValue() != null) ps.setDouble(4, coupon.getDiscountValue()); else ps.setNull(4, Types.DOUBLE);
            if (coupon.getMinOrderValue() != null) ps.setDouble(5, coupon.getMinOrderValue()); else ps.setNull(5, Types.DOUBLE);
            if (coupon.getMaxDiscountAmount() != null) ps.setDouble(6, coupon.getMaxDiscountAmount()); else ps.setNull(6, Types.DOUBLE);
            if (coupon.getQuantity() != null) ps.setInt(7, coupon.getQuantity()); else ps.setNull(7, Types.INTEGER);
            ps.setInt(8, coupon.getUsedQuantity() != null ? coupon.getUsedQuantity() : 0);
            ps.setInt(9, coupon.getUsagePerCustomer() != null ? coupon.getUsagePerCustomer() : 1);
            if (coupon.getStartDate() != null) ps.setTimestamp(10, Timestamp.valueOf(coupon.getStartDate())); else ps.setNull(10, Types.TIMESTAMP);
            if (coupon.getEndDate() != null) ps.setTimestamp(11, Timestamp.valueOf(coupon.getEndDate())); else ps.setNull(11, Types.TIMESTAMP);
            ps.setString(12, coupon.getDescription());
            ps.setInt(13, coupon.getStatus() != null ? coupon.getStatus() : 1);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        coupon.setId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return coupon;
    }

    public Coupon update(Coupon coupon) {
        String sql = "UPDATE phieu_giam_gia SET phieu_giam_gia_code = ?, ten_chuong_trinh = ?, loai_giam = ?, gia_tri_giam = ?, " +
                "gia_tri_don_hang_toi_thieu = ?, giam_toi_da = ?, so_luong = ?, da_su_dung = ?, han_su_dung_moi_khach = ?, ngay_bat_dau = ?, ngay_ket_thuc = ?, mo_ta = ?, trang_thai = ? " +
                "WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getName());
            if (coupon.getDiscountType() != null) ps.setInt(3, coupon.getDiscountType()); else ps.setNull(3, Types.INTEGER);
            if (coupon.getDiscountValue() != null) ps.setDouble(4, coupon.getDiscountValue()); else ps.setNull(4, Types.DOUBLE);
            if (coupon.getMinOrderValue() != null) ps.setDouble(5, coupon.getMinOrderValue()); else ps.setNull(5, Types.DOUBLE);
            if (coupon.getMaxDiscountAmount() != null) ps.setDouble(6, coupon.getMaxDiscountAmount()); else ps.setNull(6, Types.DOUBLE);
            if (coupon.getQuantity() != null) ps.setInt(7, coupon.getQuantity()); else ps.setNull(7, Types.INTEGER);
            ps.setInt(8, coupon.getUsedQuantity() != null ? coupon.getUsedQuantity() : 0);
            ps.setInt(9, coupon.getUsagePerCustomer() != null ? coupon.getUsagePerCustomer() : 1);
            if (coupon.getStartDate() != null) ps.setTimestamp(10, Timestamp.valueOf(coupon.getStartDate())); else ps.setNull(10, Types.TIMESTAMP);
            if (coupon.getEndDate() != null) ps.setTimestamp(11, Timestamp.valueOf(coupon.getEndDate())); else ps.setNull(11, Types.TIMESTAMP);
            ps.setString(12, coupon.getDescription());
            ps.setInt(13, coupon.getStatus() != null ? coupon.getStatus() : 1);
            ps.setInt(14, coupon.getId());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return coupon;
    }

    public void toggleStatus(int id, int newStatus) {
        String sql = "UPDATE phieu_giam_gia SET trang_thai = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Coupon mapResultSetToCoupon(ResultSet rs) throws SQLException {
        Coupon c = new Coupon();
        c.setId(rs.getInt("id"));
        c.setCode(rs.getString("phieu_giam_gia_code"));
        c.setName(rs.getString("ten_chuong_trinh"));
        c.setDiscountType(rs.getObject("loai_giam") != null ? rs.getInt("loai_giam") : null);
        c.setDiscountValue(rs.getObject("gia_tri_giam") != null ? rs.getDouble("gia_tri_giam") : null);
        c.setMinOrderValue(rs.getObject("gia_tri_don_hang_toi_thieu") != null ? rs.getDouble("gia_tri_don_hang_toi_thieu") : null);
        c.setMaxDiscountAmount(rs.getObject("giam_toi_da") != null ? rs.getDouble("giam_toi_da") : null);
        c.setQuantity(rs.getObject("so_luong") != null ? rs.getInt("so_luong") : null);
        c.setUsedQuantity(rs.getObject("da_su_dung") != null ? rs.getInt("da_su_dung") : 0);
        c.setUsagePerCustomer(rs.getObject("han_su_dung_moi_khach") != null ? rs.getInt("han_su_dung_moi_khach") : 1);
        Timestamp sd = rs.getTimestamp("ngay_bat_dau");
        if (sd != null) c.setStartDate(sd.toLocalDateTime());
        Timestamp ed = rs.getTimestamp("ngay_ket_thuc");
        if (ed != null) c.setEndDate(ed.toLocalDateTime());
        c.setDescription(rs.getString("mo_ta"));
        c.setStatus(rs.getObject("trang_thai") != null ? rs.getInt("trang_thai") : 1);
        Timestamp ct = rs.getTimestamp("created_at");
        if (ct != null) c.setCreatedAt(ct.toLocalDateTime());
        return c;
    }

    public Coupon findById(int id) {
        String sql = "SELECT * FROM phieu_giam_gia WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToCoupon(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Coupon findByCode(String code) {
        String sql = "SELECT * FROM phieu_giam_gia WHERE LOWER(LTRIM(RTRIM(phieu_giam_gia_code))) = LOWER(LTRIM(RTRIM(?)))";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToCoupon(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Coupon> findAll(Integer discountType, Integer status,
                                String keyword, String fromDateStr, String toDateStr, int page, int size) {
        List<Coupon> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM phieu_giam_gia WHERE 1=1 ");
        
        if (discountType != null) sql.append("AND loai_giam = ? ");
        if (status != null) sql.append("AND trang_thai = ? ");
        
        java.time.LocalDate fromDate = null;
        java.time.LocalDate toDate = null;
        
        if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
            try { fromDate = java.time.LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
        }
        if (toDateStr != null && !toDateStr.trim().isEmpty()) {
            try { toDate = java.time.LocalDate.parse(toDateStr); } catch (Exception ignored) {}
        }

        if (fromDate != null) sql.append("AND ngay_bat_dau >= ? ");
        if (toDate != null) sql.append("AND ngay_bat_dau <= ? ");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append("AND (LOWER(phieu_giam_gia_code) LIKE ? OR LOWER(ten_chuong_trinh) LIKE ?) ");
        }
        
        sql.append("ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int index = 1;
            if (discountType != null) ps.setInt(index++, discountType);
            if (status != null) ps.setInt(index++, status);
            if (fromDate != null) ps.setDate(index++, Date.valueOf(fromDate));
            if (toDate != null) ps.setDate(index++, Date.valueOf(toDate));
            if (hasKeyword) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(index++, kw);
                ps.setString(index++, kw);
            }
            ps.setInt(index++, page * size);
            ps.setInt(index++, size);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCoupon(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi SQL khi findAll Coupon: " + e.getMessage(), e);
        }
        return list;
    }

    public long countAll(Integer discountType, Integer status, String keyword, String fromDateStr, String toDateStr) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM phieu_giam_gia WHERE 1=1 ");
        
        if (discountType != null) sql.append("AND loai_giam = ? ");
        if (status != null) sql.append("AND trang_thai = ? ");
        
        java.time.LocalDate fromDate = null;
        java.time.LocalDate toDate = null;
        
        if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
            try { fromDate = java.time.LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
        }
        if (toDateStr != null && !toDateStr.trim().isEmpty()) {
            try { toDate = java.time.LocalDate.parse(toDateStr); } catch (Exception ignored) {}
        }

        if (fromDate != null) sql.append("AND ngay_bat_dau >= ? ");
        if (toDate != null) sql.append("AND ngay_bat_dau <= ? ");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append("AND (LOWER(phieu_giam_gia_code) LIKE ? OR LOWER(ten_chuong_trinh) LIKE ?) ");
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int index = 1;
            if (discountType != null) ps.setInt(index++, discountType);
            if (status != null) ps.setInt(index++, status);
            if (fromDate != null) ps.setDate(index++, Date.valueOf(fromDate));
            if (toDate != null) ps.setDate(index++, Date.valueOf(toDate));
            if (hasKeyword) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(index++, kw);
                ps.setString(index++, kw);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi SQL khi countAll Coupon: " + e.getMessage(), e);
        }
        return 0;
    }

    public List<Coupon> findActive() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT * FROM phieu_giam_gia " +
                "WHERE trang_thai = 1 " +
                "AND (da_su_dung IS NULL OR so_luong IS NULL OR da_su_dung < so_luong) " +
                "AND (ngay_bat_dau IS NULL OR ngay_bat_dau <= CAST(GETDATE() AS DATE)) " +
                "AND (ngay_ket_thuc IS NULL OR ngay_ket_thuc >= CAST(GETDATE() AS DATE)) " +
                "ORDER BY ngay_ket_thuc ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToCoupon(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean existsCode(String code, int excludeId) {
        String sql = "SELECT COUNT(*) FROM phieu_giam_gia WHERE LOWER(LTRIM(RTRIM(phieu_giam_gia_code))) = LOWER(LTRIM(RTRIM(?))) AND id <> ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
