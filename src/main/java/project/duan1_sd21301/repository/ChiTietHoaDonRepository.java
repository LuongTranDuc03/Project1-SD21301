package project.duan1_sd21301.repository;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import project.duan1_sd21301.model.ChiTietHoaDon;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;

/**
 * Repository thao tác CRUD cho entity ChiTietHoaDon.
 */
public class ChiTietHoaDonRepository {

    /**
     * Lưu mới một chi tiết hóa đơn.
     */
    public ChiTietHoaDon save(ChiTietHoaDon chiTiet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(chiTiet);
            tx.commit();
            return chiTiet;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi lưu chi tiết hóa đơn", e);
        }
    }

    /**
     * Lấy danh sách chi tiết sản phẩm theo ID hóa đơn.
     * Eager fetch chiTietSanPham để tránh N+1.
     */
    public List<ChiTietHoaDon> findByHoaDonId(Integer hoaDonId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM ChiTietHoaDon ct " +
                         "LEFT JOIN FETCH ct.chiTietSanPham " +
                         "WHERE ct.hoaDon.id = :hdId";
            return session.createQuery(hql, ChiTietHoaDon.class)
                          .setParameter("hdId", hoaDonId)
                          .getResultList();
        }
    }

    /**
     * Tính tổng tiền của hóa đơn dựa trên chi tiết.
     */
    public Double tinhTongTien(Integer hoaDonId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT SUM(ct.thanhTien) FROM ChiTietHoaDon ct WHERE ct.hoaDon.id = :hdId";
            Query<Double> query = session.createQuery(hql, Double.class);
            query.setParameter("hdId", hoaDonId);
            Double result = query.uniqueResult();
            return result != null ? result : 0.0;
        }
    }

    /**
     * Xóa tất cả chi tiết của một hóa đơn (dùng khi hủy đơn và hoàn hàng).
     */
    public void deleteByHoaDonId(Integer hoaDonId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.createMutationQuery(
                    "DELETE FROM ChiTietHoaDon ct WHERE ct.hoaDon.id = :hdId")
                   .setParameter("hdId", hoaDonId)
                   .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa chi tiết hóa đơn", e);
        }
    }
}
