package project.duan1_sd21301.repository.phuc;

import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatisticRepository {

    public Map<String, Object> getOverviewStats(LocalDateTime start, LocalDateTime end) {
        Map<String, Object> stats = new HashMap<>();
        
        Double revenue = 0.0;
        Long totalOrders = 0L;
        Long countCompleted = 0L;
        Long countCancelled = 0L;
        Long countProcessing = 0L;
        Long productsSold = 0L;

        String sqlInvoice = "SELECT " +
                "SUM(CASE WHEN trang_thai_don_hang = 3 THEN tong_thanh_toan ELSE 0 END), " +
                "COUNT(*), " +
                "SUM(CASE WHEN trang_thai_don_hang = 3 THEN 1 ELSE 0 END), " +
                "SUM(CASE WHEN trang_thai_don_hang = 4 THEN 1 ELSE 0 END), " +
                "SUM(CASE WHEN trang_thai_don_hang IN (0,1) THEN 1 ELSE 0 END) " +
                "FROM hoa_don WHERE ngay_dat_hang BETWEEN ? AND ?";

        String sqlProducts = "SELECT SUM(ct.so_luong) FROM chi_tiet_hoa_don ct JOIN hoa_don i ON ct.id_hoa_don = i.id " +
                "WHERE i.trang_thai_don_hang = 3 AND i.ngay_dat_hang BETWEEN ? AND ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement psInv = conn.prepareStatement(sqlInvoice);
             PreparedStatement psProd = conn.prepareStatement(sqlProducts)) {
            
            Timestamp tsStart = Timestamp.valueOf(start);
            Timestamp tsEnd = Timestamp.valueOf(end);
            
            psInv.setTimestamp(1, tsStart);
            psInv.setTimestamp(2, tsEnd);
            
            try (ResultSet rs = psInv.executeQuery()) {
                if (rs.next()) {
                    revenue = rs.getDouble(1);
                    totalOrders = rs.getLong(2);
                    countCompleted = rs.getLong(3);
                    countCancelled = rs.getLong(4);
                    countProcessing = rs.getLong(5);
                }
            }
            
            psProd.setTimestamp(1, tsStart);
            psProd.setTimestamp(2, tsEnd);
            
            try (ResultSet rs = psProd.executeQuery()) {
                if (rs.next()) {
                    productsSold = rs.getLong(1);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        stats.put("revenue", revenue);
        stats.put("totalOrders", totalOrders);
        stats.put("countCompleted", countCompleted);
        stats.put("countCancelled", countCancelled);
        stats.put("countProcessing", countProcessing);
        stats.put("productsSold", productsSold);
        
        return stats;
    }

    public List<Object[]> getRevenueByDate(LocalDateTime start, LocalDateTime end) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT CAST(ngay_dat_hang AS DATE) AS d, SUM(tong_thanh_toan) " +
                     "FROM hoa_don " +
                     "WHERE trang_thai_don_hang = 3 " +
                     "AND ngay_dat_hang BETWEEN ? AND ? " +
                     "GROUP BY CAST(ngay_dat_hang AS DATE) " +
                     "ORDER BY d ASC";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setTimestamp(1, Timestamp.valueOf(start));
            ps.setTimestamp(2, Timestamp.valueOf(end));
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Object[] { rs.getDate(1), rs.getDouble(2) });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getTopSellingProducts(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " p.ten_san_pham, SUM(ct.so_luong) as total_sold, SUM(pd.so_luong) as ton_kho " +
                     "FROM chi_tiet_hoa_don ct " +
                     "JOIN chi_tiet_san_pham pd ON ct.id_chi_tiet_san_pham = pd.id " +
                     "JOIN san_pham p ON pd.id_san_pham = p.id " +
                     "JOIN hoa_don hd ON ct.id_hoa_don = hd.id " +
                     "WHERE hd.trang_thai_don_hang = 3 " +
                     "GROUP BY p.ten_san_pham, p.id " +
                     "ORDER BY total_sold DESC";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Object[] { rs.getString(1), rs.getLong(2), rs.getLong(3) });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getTopCustomers(int limit) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " hd.ten_khach_nhan, COUNT(hd.id) as so_don, SUM(hd.tong_thanh_toan) as chi_tieu " +
                     "FROM hoa_don hd " +
                     "WHERE hd.trang_thai_don_hang = 3 AND hd.ten_khach_nhan IS NOT NULL AND hd.ten_khach_nhan != '' " +
                     "GROUP BY hd.ten_khach_nhan, hd.sdt_khach_nhan " +
                     "ORDER BY chi_tieu DESC";
                     
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Object[] { rs.getString(1), rs.getLong(2), rs.getDouble(3) });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
