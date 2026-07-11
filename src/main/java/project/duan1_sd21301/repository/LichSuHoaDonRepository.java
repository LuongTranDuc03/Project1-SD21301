package project.duan1_sd21301.repository;

import org.hibernate.Session;
import org.hibernate.Transaction;
import project.duan1_sd21301.model.LichSuHoaDon;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;

/**
 * Repository ghi vết lịch sử trạng thái hóa đơn.
 */
public class LichSuHoaDonRepository {

    /**
     * Lưu một bản ghi lịch sử mới.
     */
    public LichSuHoaDon save(LichSuHoaDon lichSu) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(lichSu);
            tx.commit();
            return lichSu;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi ghi lịch sử hóa đơn", e);
        }
    }

    /**
     * Lấy toàn bộ lịch sử trạng thái của một hóa đơn,
     * sắp xếp theo thời gian cập nhật mới nhất lên đầu.
     */
    public List<LichSuHoaDon> findByHoaDonId(Integer hoaDonId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM LichSuHoaDon ls " +
                         "LEFT JOIN FETCH ls.nguoiThucHien " +
                         "WHERE ls.hoaDon.id = :hdId " +
                         "ORDER BY ls.thoiGianCapNhat DESC";
            return session.createQuery(hql, LichSuHoaDon.class)
                          .setParameter("hdId", hoaDonId)
                          .getResultList();
        }
    }
}
