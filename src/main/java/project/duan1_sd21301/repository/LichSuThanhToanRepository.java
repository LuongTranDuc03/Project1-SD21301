package project.duan1_sd21301.repository;

import org.hibernate.Session;
import org.hibernate.Transaction;
import project.duan1_sd21301.model.LichSuThanhToan;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;

/**
 * Repository ghi nhận lịch sử giao dịch thanh toán qua cổng.
 */
public class LichSuThanhToanRepository {

    /**
     * Lưu một bản ghi giao dịch thanh toán mới.
     */
    public LichSuThanhToan save(LichSuThanhToan lichSu) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(lichSu);
            tx.commit();
            return lichSu;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi ghi lịch sử thanh toán", e);
        }
    }

    /**
     * Lấy toàn bộ lịch sử thanh toán của một hóa đơn.
     */
    public List<LichSuThanhToan> findByHoaDonId(Integer hoaDonId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM LichSuThanhToan ls " +
                         "WHERE ls.hoaDon.id = :hdId " +
                         "ORDER BY ls.thoiGianGiaoDich DESC";
            return session.createQuery(hql, LichSuThanhToan.class)
                          .setParameter("hdId", hoaDonId)
                          .getResultList();
        }
    }
}
