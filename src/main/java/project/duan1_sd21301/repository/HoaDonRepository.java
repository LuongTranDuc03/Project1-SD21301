package project.duan1_sd21301.repository;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;
import java.util.Optional;

/**
 * Repository thao tác CRUD và tìm kiếm cho entity HoaDon.
 */
public class HoaDonRepository {

    // ===========================
    // CREATE / UPDATE / DELETE
    // ===========================

    /**
     * Lưu mới hoặc merge (update) một hóa đơn.
     */
    public HoaDon save(HoaDon hoaDon) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(hoaDon);
            tx.commit();
            return hoaDon;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi lưu hóa đơn", e);
        }
    }

    /**
     * Cập nhật hóa đơn đã tồn tại.
     */
    public HoaDon update(HoaDon hoaDon) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            HoaDon merged = session.merge(hoaDon);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
        }
    }

    /**
     * Xóa (soft-delete) hóa đơn theo id bằng cách set trang_thai = 0.
     */
    public void softDelete(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            HoaDon hoaDon = session.get(HoaDon.class, id);
            if (hoaDon != null) {
                hoaDon.setTrangThai(0);
                session.merge(hoaDon);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa hóa đơn", e);
        }
    }

    // ===========================
    // READ
    // ===========================

    /**
     * Tìm hóa đơn theo ID.
     */
    public Optional<HoaDon> findById(Integer id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang " +
                         "LEFT JOIN FETCH hd.nhanVien " +
                         "LEFT JOIN FETCH hd.phuongThucThanhToan " +
                         "LEFT JOIN FETCH hd.diaChi " +
                         "WHERE hd.id = :id";
            HoaDon hoaDon = session.createQuery(hql, HoaDon.class)
                                   .setParameter("id", id)
                                   .uniqueResult();
            return Optional.ofNullable(hoaDon);
        }
    }

    /**
     * Lấy danh sách tất cả hóa đơn có phân trang và lọc theo trạng thái đơn hàng.
     *
     * @param trangThaiDonHang null = tất cả, 0/1/2/3 = lọc theo trạng thái
     * @param page  số trang (bắt đầu từ 0)
     * @param size  số lượng mỗi trang
     */
    public List<HoaDon> findAll(Integer trangThaiDonHang, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql;
            Query<HoaDon> query;

            if (trangThaiDonHang != null) {
                hql = "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang LEFT JOIN FETCH hd.nhanVien LEFT JOIN FETCH hd.phuongThucThanhToan " +
                      "WHERE hd.trangThaiDonHang = :trangThai " +
                      "ORDER BY hd.ngayDatHang DESC";
                query = session.createQuery(hql, HoaDon.class);
                query.setParameter("trangThai", trangThaiDonHang);
            } else {
                hql = "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang LEFT JOIN FETCH hd.nhanVien LEFT JOIN FETCH hd.phuongThucThanhToan " +
                      "ORDER BY hd.ngayDatHang DESC";
                query = session.createQuery(hql, HoaDon.class);
            }

            query.setFirstResult(page * size);
            query.setMaxResults(size);
            return query.getResultList();
        }
    }

    /**
     * Đếm tổng số hóa đơn theo trạng thái (dùng cho phân trang).
     */
    public long countAll(Integer trangThaiDonHang) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql;
            Query<Long> query;

            if (trangThaiDonHang != null) {
                hql = "SELECT COUNT(hd) FROM HoaDon hd WHERE hd.trangThaiDonHang = :trangThai";
                query = session.createQuery(hql, Long.class);
                query.setParameter("trangThai", trangThaiDonHang);
            } else {
                hql = "SELECT COUNT(hd) FROM HoaDon hd";
                query = session.createQuery(hql, Long.class);
            }

            return query.uniqueResult();
        }
    }

    /**
     * Tìm hóa đơn theo khách hàng.
     */
    public List<HoaDon> findByKhachHang(Integer khachHangId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang LEFT JOIN FETCH hd.phuongThucThanhToan WHERE hd.khachHang.id = :khId ORDER BY hd.ngayDatHang DESC";
            return session.createQuery(hql, HoaDon.class)
                          .setParameter("khId", khachHangId)
                          .getResultList();
        }
    }

    /**
     * Tìm kiếm hóa đơn theo từ khóa (tên KH, SĐT, email KH).
     */
    public List<HoaDon> search(String keyword, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String like = "%" + keyword.trim().toLowerCase() + "%";
            String hql = "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang LEFT JOIN FETCH hd.phuongThucThanhToan " +
                         "WHERE LOWER(hd.tenKhachHang) LIKE :kw " +
                         "   OR LOWER(hd.sdtKhachHang) LIKE :kw " +
                         "   OR LOWER(hd.emailKhachHang) LIKE :kw " +
                         "ORDER BY hd.ngayDatHang DESC";
            return session.createQuery(hql, HoaDon.class)
                          .setParameter("kw", like)
                          .setFirstResult(page * size)
                          .setMaxResults(size)
                          .getResultList();
        }
    }
}
