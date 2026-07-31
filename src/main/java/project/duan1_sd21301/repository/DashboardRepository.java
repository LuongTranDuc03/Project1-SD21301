package project.duan1_sd21301.repository;

import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardRepository {

    public Map<String, Object> getStatsForPeriod(String type) {
        Map<String, Object> result = new HashMap<>();
        result.put("revenue", 0.0);
        result.put("totalOrders", 0L);
        result.put("productsSold", 0L);
        result.put("countCompleted", 0L);
        result.put("countCancelled", 0L);
        result.put("countProcessing", 0L);

        String condition = "";
        switch (type) {
            case "today":
                condition = "CAST(ngay_dat_hang AS DATE) = CAST(GETDATE() AS DATE)";
                break;
            case "week":
                condition = "DATEPART(isoww, ngay_dat_hang) = DATEPART(isoww, GETDATE()) AND YEAR(ngay_dat_hang) = YEAR(GETDATE())";
                break;
            case "month":
                condition = "MONTH(ngay_dat_hang) = MONTH(GETDATE()) AND YEAR(ngay_dat_hang) = YEAR(GETDATE())";
                break;
            case "year":
                condition = "YEAR(ngay_dat_hang) = YEAR(GETDATE())";
                break;
            default:
                condition = "1=1";
        }

        String sql = "SELECT " +
                "SUM(CASE WHEN trang_thai_don_hang = 3 OR (trang_thai_don_hang = 4 AND trang_thai_thanh_toan = 1) THEN tong_thanh_toan ELSE 0 END) AS revenue, " +
                "COUNT(*) AS totalOrders, " +
                "SUM(CASE WHEN trang_thai_don_hang = 3 THEN tong_so_luong ELSE 0 END) AS productsSold, " +
                "SUM(CASE WHEN trang_thai_don_hang = 3 THEN 1 ELSE 0 END) AS countCompleted, " +
                "SUM(CASE WHEN trang_thai_don_hang IN (4, 5) THEN 1 ELSE 0 END) AS countCancelled, " +
                "SUM(CASE WHEN trang_thai_don_hang IN (0, 1) THEN 1 ELSE 0 END) AS countProcessing " +
                "FROM hoa_don WHERE " + condition;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                result.put("revenue", rs.getDouble("revenue"));
                result.put("totalOrders", (long) rs.getInt("totalOrders"));
                // tong_so_luong maybe int
                long productsSold = 0;
                if (rs.getObject("productsSold") != null) {
                    productsSold = rs.getLong("productsSold");
                }
                result.put("productsSold", productsSold);
                result.put("countCompleted", (long) rs.getInt("countCompleted"));
                result.put("countCancelled", (long) rs.getInt("countCancelled"));
                result.put("countProcessing", (long) rs.getInt("countProcessing"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getTopProducts(int limit, String fromDate, String toDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " " +
                "p.ten_san_pham AS name, " +
                "SUM(ct.so_luong) AS quantity, " +
                "(SELECT SUM(pd2.so_luong) FROM chi_tiet_san_pham pd2 WHERE pd2.id_san_pham = p.id) AS stock " +
                "FROM chi_tiet_hoa_don ct " +
                "JOIN chi_tiet_san_pham pd ON ct.id_chi_tiet_san_pham = pd.id " +
                "JOIN san_pham p ON pd.id_san_pham = p.id " +
                "JOIN hoa_don hd ON ct.id_hoa_don = hd.id " +
                "WHERE hd.trang_thai_don_hang = 3 ";
        
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += "AND CAST(hd.ngay_dat_hang AS DATE) >= ? ";
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += "AND CAST(hd.ngay_dat_hang AS DATE) <= ? ";
        }
        
        sql += "GROUP BY p.id, p.ten_san_pham " +
                "ORDER BY quantity DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(paramIndex++, toDate);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("name", rs.getString("name"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("stock", rs.getInt("stock"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getTopCustomers(int limit, String fromDate, String toDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " " +
                "kh.ho_ten AS name, " +
                "COUNT(hd.id) AS orders, " +
                "SUM(hd.tong_thanh_toan) AS spent " +
                "FROM hoa_don hd " +
                "JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                "WHERE (hd.trang_thai_don_hang = 3 OR (hd.trang_thai_don_hang = 4 AND hd.trang_thai_thanh_toan = 1)) ";
                
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += "AND CAST(hd.ngay_dat_hang AS DATE) >= ? ";
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += "AND CAST(hd.ngay_dat_hang AS DATE) <= ? ";
        }
        
        sql += "GROUP BY kh.id, kh.ho_ten " +
                "ORDER BY spent DESC";
                
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            int paramIndex = 1;
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(paramIndex++, toDate);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("name", rs.getString("name"));
                    map.put("orders", rs.getInt("orders"));
                    map.put("spent", rs.getDouble("spent"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<Integer, Double> getMonthlyChartData(int year, int month) {
        Map<Integer, Double> map = new HashMap<>();
        String sql = "SELECT DAY(ngay_dat_hang) AS day, SUM(tong_thanh_toan) AS revenue " +
                "FROM hoa_don " +
                "WHERE YEAR(ngay_dat_hang) = ? AND MONTH(ngay_dat_hang) = ? AND (trang_thai_don_hang = 3 OR (trang_thai_don_hang = 4 AND trang_thai_thanh_toan = 1)) " +
                "GROUP BY DAY(ngay_dat_hang) " +
                "ORDER BY day ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("day"), rs.getDouble("revenue"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Map<String, Object>> getMonthlyRevenue(int year) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT MONTH(ngay_dat_hang) AS month, " +
                "SUM(tong_thanh_toan) AS revenue " +
                "FROM hoa_don " +
                "WHERE YEAR(ngay_dat_hang) = ? " +
                "AND (trang_thai_don_hang = 3 OR (trang_thai_don_hang = 4 AND trang_thai_thanh_toan = 1)) " +
                "GROUP BY MONTH(ngay_dat_hang) " +
                "ORDER BY month";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("month", rs.getInt("month"));
                    map.put("revenue", rs.getDouble("revenue"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getInventoryStats(int page, int pageSize, Integer month, Integer brandId, Integer status, String searchQuery) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM ( " +
            "   SELECT " +
            "       p.san_pham_code AS productCode, " +
            "       pd.chi_tiet_san_pham_code AS variantCode, " +
            "       p.ten_san_pham AS productName, " +
            "       ISNULL(ms.ten_mau, '') + ' - ' + ISNULL(kt.ten_kich_thuoc, '') + ' - ' + ISNULL(kd.ten_kieu_dang, '') AS attributes, " +
            "       pd.so_luong AS stock, " +
            "       ( " +
            "           SELECT ISNULL(SUM(cthd.so_luong), 0) " +
            "           FROM chi_tiet_hoa_don cthd " +
            "           JOIN hoa_don hd ON cthd.id_hoa_don = hd.id " +
            "           WHERE cthd.id_chi_tiet_san_pham = pd.id " +
            "             AND hd.trang_thai_don_hang = 3 " +
            "       ) AS totalSold, " +
            "       ( " +
            "           SELECT ISNULL(SUM(cthd.so_luong), 0) " +
            "           FROM chi_tiet_hoa_don cthd " +
            "           JOIN hoa_don hd ON cthd.id_hoa_don = hd.id " +
            "           WHERE cthd.id_chi_tiet_san_pham = pd.id " +
            "             AND hd.trang_thai_don_hang = 3 "
        );
        
        if (month != null && month > 0) {
            sql.append(" AND MONTH(hd.ngay_dat_hang) = ? AND YEAR(hd.ngay_dat_hang) = YEAR(GETDATE()) ");
        }
                     
        sql.append(
            "       ) AS soldInPeriod, " +
            "       ROW_NUMBER() OVER(ORDER BY p.id DESC, pd.id DESC) as RowNum " +
            "   FROM chi_tiet_san_pham pd " +
            "   JOIN san_pham p ON pd.id_san_pham = p.id " +
            "   LEFT JOIN kich_thuoc kt ON pd.id_kich_thuoc = kt.id " +
            "   LEFT JOIN mau_sac ms ON pd.id_mau_sac = ms.id " +
            "   LEFT JOIN kieu_dang kd ON pd.id_kieu_dang = kd.id " +
            "   WHERE pd.trang_thai = 1 AND p.trang_thai = 1 "
        );
        
        if (month != null && month > 0) {
            sql.append(" AND EXISTS (SELECT 1 FROM chi_tiet_hoa_don cthd2 JOIN hoa_don hd2 ON cthd2.id_hoa_don = hd2.id WHERE cthd2.id_chi_tiet_san_pham = pd.id AND hd2.trang_thai_don_hang = 3 AND MONTH(hd2.ngay_dat_hang) = ? AND YEAR(hd2.ngay_dat_hang) = YEAR(GETDATE())) ");
        }
        
        if (brandId != null && brandId > 0) {
            sql.append(" AND p.id_thuong_hieu = ? ");
        }
        
        if (status != null) {
            if (status == 1) {
                sql.append(" AND pd.so_luong >= 10 ");
            } else if (status == 2) {
                sql.append(" AND pd.so_luong > 0 AND pd.so_luong < 10 ");
            } else if (status == 0) {
                sql.append(" AND pd.so_luong = 0 ");
            }
        }
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.ten_san_pham LIKE ? OR p.san_pham_code LIKE ? OR pd.chi_tiet_san_pham_code LIKE ? OR ms.ten_mau LIKE ? OR kt.ten_kich_thuoc LIKE ? OR kd.ten_kieu_dang LIKE ?) ");
        }
        
        sql.append(" ) AS Result WHERE RowNum > ? AND RowNum <= ?");
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (month != null && month > 0) {
                ps.setInt(paramIndex++, month); // For soldInPeriod
                ps.setInt(paramIndex++, month); // For the EXISTS clause (ngay_dat_hang)
            }
            if (brandId != null && brandId > 0) {
                ps.setInt(paramIndex++, brandId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String likeQ = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, page * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("productCode", rs.getString("productCode"));
                    map.put("variantCode", rs.getString("variantCode"));
                    map.put("productName", rs.getString("productName"));
                    
                    String attributes = rs.getString("attributes");
                    // Format cleanup if some are empty
                    if (attributes != null) {
                        attributes = attributes.replaceAll(" -  - ", " - ").replaceAll("^ - | - $", "").trim();
                        if (attributes.equals("-")) attributes = "";
                    }
                    map.put("attributes", attributes);
                    
                    int stock = rs.getInt("stock");
                    int totalSold = rs.getInt("totalSold");
                    int soldInPeriod = rs.getInt("soldInPeriod");
                    
                    int totalInitial = stock + totalSold; // Nhập = Tồn hiện tại + Tổng bán toàn thời gian
                    
                    map.put("stock", stock);
                    map.put("sold", soldInPeriod);
                    map.put("initial", totalInitial);
                    map.put("status", stock > 0 ? "Còn hàng" : "Hết hàng");
                    
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countInventoryStats(Integer month, Integer brandId, Integer status, String searchQuery) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM chi_tiet_san_pham pd " +
            "JOIN san_pham p ON pd.id_san_pham = p.id " +
            "LEFT JOIN mau_sac ms ON pd.id_mau_sac = ms.id " +
            "LEFT JOIN kich_thuoc kt ON pd.id_kich_thuoc = kt.id " +
            "LEFT JOIN kieu_dang kd ON pd.id_kieu_dang = kd.id " +
            "WHERE pd.trang_thai = 1 AND p.trang_thai = 1 "
        );
        
        if (month != null && month > 0) {
            sql.append(" AND EXISTS (SELECT 1 FROM chi_tiet_hoa_don cthd2 JOIN hoa_don hd2 ON cthd2.id_hoa_don = hd2.id WHERE cthd2.id_chi_tiet_san_pham = pd.id AND hd2.trang_thai_don_hang = 3 AND MONTH(hd2.ngay_dat_hang) = ? AND YEAR(hd2.ngay_dat_hang) = YEAR(GETDATE())) ");
        }
        
        if (brandId != null && brandId > 0) {
            sql.append(" AND p.id_thuong_hieu = ? ");
        }
        
        if (status != null) {
            if (status == 1) {
                sql.append(" AND pd.so_luong >= 10 ");
            } else if (status == 2) {
                sql.append(" AND pd.so_luong > 0 AND pd.so_luong < 10 ");
            } else if (status == 0) {
                sql.append(" AND pd.so_luong = 0 ");
            }
        }
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.ten_san_pham LIKE ? OR p.san_pham_code LIKE ? OR pd.chi_tiet_san_pham_code LIKE ? OR ms.ten_mau LIKE ? OR kt.ten_kich_thuoc LIKE ? OR kd.ten_kieu_dang LIKE ?) ");
        }
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (month != null && month > 0) {
                ps.setInt(paramIndex++, month);
            }
            if (brandId != null && brandId > 0) {
                ps.setInt(paramIndex++, brandId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String likeQ = "%" + searchQuery.trim() + "%";
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
                ps.setString(paramIndex++, likeQ);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Map<String, Object>> getBrands() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT id, ten_thuong_hieu FROM thuong_hieu ORDER BY ten_thuong_hieu";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("ten_thuong_hieu"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getInventoryKPIs(Integer month) {
        Map<String, Object> result = new HashMap<>();
        result.put("totalVariants", 0);
        result.put("totalStock", 0);
        result.put("soldInMonth", 0);
        result.put("lowStock", 0);

        try (Connection conn = DatabaseConnection.getConnection()) {
            // 1. Total Variants
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM chi_tiet_san_pham pd JOIN san_pham p ON pd.id_san_pham = p.id WHERE pd.trang_thai = 1 AND p.trang_thai = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) result.put("totalVariants", rs.getInt(1));
            }
            // 2. Total Stock
            try (PreparedStatement ps = conn.prepareStatement("SELECT ISNULL(SUM(pd.so_luong), 0) FROM chi_tiet_san_pham pd JOIN san_pham p ON pd.id_san_pham = p.id WHERE pd.trang_thai = 1 AND p.trang_thai = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) result.put("totalStock", rs.getInt(1));
            }
            // 3. Sold in month
            String soldSql = "SELECT ISNULL(SUM(cthd.so_luong), 0) FROM chi_tiet_hoa_don cthd JOIN hoa_don hd ON cthd.id_hoa_don = hd.id WHERE hd.trang_thai_don_hang = 3 AND MONTH(hd.ngay_dat_hang) = ? AND YEAR(hd.ngay_dat_hang) = YEAR(GETDATE())";
            if (month == null || month <= 0) {
                soldSql = "SELECT ISNULL(SUM(cthd.so_luong), 0) FROM chi_tiet_hoa_don cthd JOIN hoa_don hd ON cthd.id_hoa_don = hd.id WHERE hd.trang_thai_don_hang = 3 AND MONTH(hd.ngay_dat_hang) = MONTH(GETDATE()) AND YEAR(hd.ngay_dat_hang) = YEAR(GETDATE())";
            }
            try (PreparedStatement ps = conn.prepareStatement(soldSql)) {
                if (month != null && month > 0) {
                    ps.setInt(1, month);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) result.put("soldInMonth", rs.getInt(1));
                }
            }
            // 4. Low stock
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM chi_tiet_san_pham pd JOIN san_pham p ON pd.id_san_pham = p.id WHERE pd.so_luong > 0 AND pd.so_luong < 10 AND pd.trang_thai = 1 AND p.trang_thai = 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) result.put("lowStock", rs.getInt(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}

