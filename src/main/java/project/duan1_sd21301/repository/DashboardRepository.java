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
                "SUM(CASE WHEN trang_thai_don_hang = 2 THEN tong_thanh_toan ELSE 0 END) AS revenue, " +
                "COUNT(*) AS totalOrders, " +
                "SUM(CASE WHEN trang_thai_don_hang = 2 THEN tong_so_luong ELSE 0 END) AS productsSold, " +
                "SUM(CASE WHEN trang_thai_don_hang = 2 THEN 1 ELSE 0 END) AS countCompleted, " +
                "SUM(CASE WHEN trang_thai_don_hang IN (3, 4) THEN 1 ELSE 0 END) AS countCancelled, " +
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
                "WHERE hd.trang_thai_don_hang = 2 ";
        
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
                "WHERE hd.trang_thai_don_hang = 2 ";
                
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
                "WHERE YEAR(ngay_dat_hang) = ? AND MONTH(ngay_dat_hang) = ? AND trang_thai_don_hang = 2 " +
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
}
