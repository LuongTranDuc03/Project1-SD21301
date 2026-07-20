package project.duan1_sd21301.repository.phuc;

import org.hibernate.Session;
import project.duan1_sd21301.util.HibernateUtil;
import project.duan1_sd21301.model.phuc.Invoice;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatisticRepository {

    // Lấy thông tin tổng quan (Doanh thu, số đơn, trạng thái) theo khoảng thời gian
    public Map<String, Object> getOverviewStats(LocalDateTime start, LocalDateTime end) {
        Map<String, Object> stats = new HashMap<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            
            // 1. Thống kê Hoá đơn
            String hqlInvoice = "SELECT " +
                    "SUM(CASE WHEN i.orderStatus = 2 THEN i.totalAmount ELSE 0 END), " +
                    "COUNT(i.id), " +
                    "SUM(CASE WHEN i.orderStatus = 2 THEN 1 ELSE 0 END), " +
                    "SUM(CASE WHEN i.orderStatus = 3 THEN 1 ELSE 0 END), " +
                    "SUM(CASE WHEN i.orderStatus IN (0,1) THEN 1 ELSE 0 END) " +
                    "FROM Invoice i WHERE i.orderDate BETWEEN :start AND :end";
            
            Object[] invResult = (Object[]) session.createQuery(hqlInvoice, Object[].class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .uniqueResult();
            
            Double revenue = 0.0;
            Long totalOrders = 0L;
            Long countCompleted = 0L;
            Long countCancelled = 0L;
            Long countProcessing = 0L;
            
            if (invResult != null) {
                revenue = invResult[0] != null ? ((Number) invResult[0]).doubleValue() : 0.0;
                totalOrders = invResult[1] != null ? ((Number) invResult[1]).longValue() : 0L;
                countCompleted = invResult[2] != null ? ((Number) invResult[2]).longValue() : 0L;
                countCancelled = invResult[3] != null ? ((Number) invResult[3]).longValue() : 0L;
                countProcessing = invResult[4] != null ? ((Number) invResult[4]).longValue() : 0L;
            }
            
            // 2. Thống kê Sản phẩm đã bán (chỉ tính đơn hoàn thành)
            String hqlProducts = "SELECT SUM(d.quantity) FROM InvoiceDetail d JOIN d.invoice i " +
                    "WHERE i.orderStatus = 2 AND i.orderDate BETWEEN :start AND :end";
            Long productsSold = session.createQuery(hqlProducts, Long.class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .uniqueResult();
            if (productsSold == null) productsSold = 0L;
            
            stats.put("revenue", revenue);
            stats.put("totalOrders", totalOrders);
            stats.put("countCompleted", countCompleted);
            stats.put("countCancelled", countCancelled);
            stats.put("countProcessing", countProcessing);
            stats.put("productsSold", productsSold);
            
        } catch (Exception e) {
            e.printStackTrace();
            stats.put("revenue", 0.0);
            stats.put("totalOrders", 0L);
            stats.put("countCompleted", 0L);
            stats.put("countCancelled", 0L);
            stats.put("countProcessing", 0L);
            stats.put("productsSold", 0L);
        }
        return stats;
    }

    // Biểu đồ doanh thu theo khoảng thời gian
    public List<Object[]> getRevenueByDate(LocalDateTime start, LocalDateTime end) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql = "SELECT CAST(ngay_dat_hang AS DATE) AS d, SUM(tong_thanh_toan) " +
                         "FROM hoa_don " +
                         "WHERE trang_thai_don_hang = 2 " +
                         "AND ngay_dat_hang BETWEEN :start AND :end " +
                         "GROUP BY CAST(ngay_dat_hang AS DATE) " +
                         "ORDER BY d ASC";
            return session.createNativeQuery(sql, Object[].class)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Top sản phẩm bán chạy (có cột Tồn)
    public List<Object[]> getTopSellingProducts(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql = "SELECT TOP " + limit + " p.name, SUM(ct.so_luong) as total_sold, MAX(p.stock) as ton_kho " +
                         "FROM chi_tiet_hoa_don ct " +
                         "JOIN chi_tiet_san_pham pd ON ct.id_chi_tiet_san_pham = pd.id " +
                         "JOIN san_pham p ON pd.product_id = p.code " +
                         "JOIN hoa_don hd ON ct.id_hoa_don = hd.id " +
                         "WHERE hd.trang_thai_don_hang = 2 " +
                         "GROUP BY p.name, p.code " +
                         "ORDER BY total_sold DESC";
            return session.createNativeQuery(sql, Object[].class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Khách hàng tiềm năng (Top chi tiêu)
    public List<Object[]> getTopCustomers(int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String sql = "SELECT TOP " + limit + " hd.ten_khach_hang, COUNT(hd.id) as so_don, SUM(hd.tong_thanh_toan) as chi_tieu " +
                         "FROM hoa_don hd " +
                         "WHERE hd.trang_thai_don_hang = 2 AND hd.ten_khach_hang IS NOT NULL AND hd.ten_khach_hang != '' " +
                         "GROUP BY hd.ten_khach_hang, hd.sdt_khach_hang " +
                         "ORDER BY chi_tieu DESC";
            return session.createNativeQuery(sql, Object[].class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
