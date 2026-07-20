package project.duan1_sd21301.repository.phuc;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import project.duan1_sd21301.model.phuc.Coupon;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;

/**
 * CouponRepository – Lớp thao tác trực tiếp với database cho bảng phiếu giảm giá.
 *
 * Nhiệm vụ duy nhất của Repository là:
 *   - Lưu dữ liệu vào database
 *   - Đọc dữ liệu từ database
 *   - Không chứa logic nghiệp vụ
 */
public class CouponRepository {

    /**
     * Tự động cập nhật trạng thái các phiếu giảm giá đã hết hạn thành Hết hạn (2).
     */
    public void updateExpiredCoupons() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            String hql = "UPDATE Coupon c SET c.status = 2 WHERE c.status != 2 AND c.endDate < CURRENT_DATE";
            session.createMutationQuery(hql).executeUpdate();
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // =========================================================
    //  GHI DỮ LIỆU (WRITE)
    // =========================================================

    /**
     * Thêm mới một phiếu giảm giá vào database.
     * Dùng session.persist() để INSERT một bản ghi mới.
     */
    public Coupon save(Coupon coupon) {
        // Transaction đảm bảo: nếu có lỗi thì toàn bộ thao tác sẽ bị hủy (rollback)
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction(); // Bắt đầu giao dịch

            session.persist(coupon);         // INSERT INTO phieu_giam_gia (...)

            tx.commit();                     // Lưu vào DB thật sự
            return coupon;
        } catch (Exception e) {
            if (tx != null) tx.rollback();   // Có lỗi thì hoàn tác
            throw new RuntimeException("Lỗi khi lưu phiếu giảm giá", e);
        }
    }

    /**
     * Cập nhật thông tin của một phiếu giảm giá đã tồn tại.
     * Dùng session.merge() để UPDATE bản ghi theo id.
     */
    public Coupon update(Coupon coupon) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // merge(): nếu coupon đã có id thì UPDATE, nếu chưa có thì INSERT
            Coupon saved = session.merge(coupon);

            tx.commit();
            return saved;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật phiếu giảm giá", e);
        }
    }

    /**
     * Đổi trạng thái (bật/tắt) một phiếu giảm giá theo id.
     *
     * @param id        id của phiếu giảm giá cần đổi
     * @param newStatus trạng thái mới (0 = tắt, 1 = bật, ...)
     */
    public void toggleStatus(int id, int newStatus) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // Tìm phiếu giảm giá theo id
            Coupon coupon = session.get(Coupon.class, id);

            if (coupon != null) {
                coupon.setStatus(newStatus); // Đổi trạng thái
                session.merge(coupon);       // Lưu lại vào DB
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi đổi trạng thái phiếu giảm giá", e);
        }
    }

    // =========================================================
    //  ĐỌC DỮ LIỆU (READ)
    // =========================================================

    /**
     * Tìm một phiếu giảm giá theo ID.
     * Trả về null nếu không tìm thấy.
     */
    public Coupon findById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // session.get() tương đương: SELECT * FROM phieu_giam_gia WHERE id = ?
            return session.get(Coupon.class, id);
        }
    }

    /**
     * Tìm một phiếu giảm giá theo mã code (không phân biệt chữ hoa/thường).
     * Trả về null nếu không tìm thấy.
     */
    public Coupon findByCode(String code) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // HQL (Hibernate Query Language) tương tự SQL nhưng dùng tên Class thay vì tên bảng
            String hql = "FROM Coupon c WHERE LOWER(c.code) = LOWER(:code)";

            return session.createQuery(hql, Coupon.class)
                    .setParameter("code", code.trim()) // Gán giá trị cho :code
                    .uniqueResult();                   // Lấy đúng 1 kết quả (hoặc null)
        }
    }

    /**
     * Lấy danh sách phiếu giảm giá có lọc và phân trang.
     *
     * @param discountType null = không lọc; 0 = giảm %, 1 = giảm tiền
     * @param status       null = không lọc; 0/1/2/3 = lọc theo trạng thái
     * @param keyword      từ khóa tìm theo mã hoặc tên; null/rỗng = không lọc
     * @param page         số trang hiện tại (bắt đầu từ 0)
     * @param size         số bản ghi mỗi trang
     */
    public List<Coupon> findAll(Integer discountType, Integer status,
                                String keyword, String fromDateStr, String toDateStr, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Xây dựng câu HQL động tùy theo các điều kiện lọc
            StringBuilder hql = new StringBuilder("FROM Coupon c WHERE 1=1 ");

            // Thêm điều kiện lọc nếu người dùng có chọn
            if (discountType != null) hql.append("AND c.discountType = :discountType ");
            if (status != null)       hql.append("AND c.status = :status ");

            java.time.LocalDate fromDate = null;
            java.time.LocalDate toDate = null;
            
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                try { fromDate = java.time.LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                try { toDate = java.time.LocalDate.parse(toDateStr); } catch (Exception ignored) {}
            }

            if (fromDate != null) {
                hql.append("AND c.startDate >= :startOfDay ");
            }
            if (toDate != null) {
                hql.append("AND c.startDate <= :endOfDay ");
            }

            // Kiểm tra có từ khóa tìm kiếm không
            boolean coTuKhoa = keyword != null && !keyword.trim().isEmpty();
            if (coTuKhoa) {
                // Tìm theo mã HOẶC tên (không phân biệt hoa/thường)
                hql.append("AND (LOWER(c.code) LIKE :kw OR LOWER(c.name) LIKE :kw) ");
            }

            hql.append("ORDER BY c.createdAt DESC"); // Mới nhất hiển thị trước

            // Tạo query và gán các tham số
            Query<Coupon> query = session.createQuery(hql.toString(), Coupon.class);
            if (discountType != null) query.setParameter("discountType", discountType);
            if (status != null)       query.setParameter("status", status);
            if (coTuKhoa)             query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            if (fromDate != null)     query.setParameter("startOfDay", fromDate);
            if (toDate != null)       query.setParameter("endOfDay", toDate);

            // Phân trang: bỏ qua (page * size) bản ghi đầu, lấy tiếp (size) bản ghi
            query.setFirstResult(page * size);
            query.setMaxResults(size);

            return query.getResultList();
        }
    }

    /**
     * Đếm tổng số phiếu giảm giá theo điều kiện lọc.
     * Dùng để tính tổng số trang cho phân trang.
     */
    public long countAll(Integer discountType, Integer status, String keyword, String fromDateStr, String toDateStr) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // SELECT COUNT(c) thay vì SELECT c để chỉ đếm số lượng
            StringBuilder hql = new StringBuilder("SELECT COUNT(c) FROM Coupon c WHERE 1=1 ");

            if (discountType != null) hql.append("AND c.discountType = :discountType ");
            if (status != null)       hql.append("AND c.status = :status ");

            java.time.LocalDate fromDate = null;
            java.time.LocalDate toDate = null;
            
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                try { fromDate = java.time.LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                try { toDate = java.time.LocalDate.parse(toDateStr); } catch (Exception ignored) {}
            }

            if (fromDate != null) {
                hql.append("AND c.startDate >= :startOfDay ");
            }
            if (toDate != null) {
                hql.append("AND c.startDate <= :endOfDay ");
            }

            boolean coTuKhoa = keyword != null && !keyword.trim().isEmpty();
            if (coTuKhoa) {
                hql.append("AND (LOWER(c.code) LIKE :kw OR LOWER(c.name) LIKE :kw) ");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);
            if (discountType != null) query.setParameter("discountType", discountType);
            if (status != null)       query.setParameter("status", status);
            if (coTuKhoa)             query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            if (fromDate != null)     query.setParameter("startOfDay", fromDate);
            if (toDate != null)       query.setParameter("endOfDay", toDate);

            return query.uniqueResult();
        }
    }

    /**
     * Lấy danh sách phiếu giảm giá đang hoạt động:
     *   - Trạng thái = 1 (đang áp dụng)
     *   - Còn lượt sử dụng (usedQuantity < quantity)
     *   - Trong thời hạn hiệu lực (startDate <= hôm nay <= endDate)
     * Sắp xếp theo ngày hết hạn gần nhất lên đầu.
     */
    public List<Coupon> findActive() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Coupon c "
                    + "WHERE c.status = 1 "
                    + "AND c.usedQuantity < c.quantity "
                    + "AND c.startDate <= CURRENT_DATE "
                    + "AND c.endDate >= CURRENT_DATE "
                    + "ORDER BY c.endDate ASC";
            return session.createQuery(hql, Coupon.class).getResultList();
        }
    }

    /**
     * Kiểm tra mã coupon đã tồn tại trong database chưa.
     * Bỏ qua bản ghi có id = excludeId (dùng khi chỉnh sửa để không bị trùng chính nó).
     *
     * @param code      mã cần kiểm tra
     * @param excludeId khi thêm mới truyền 0; khi chỉnh sửa truyền id hiện tại
     * @return true nếu mã đã tồn tại
     */
    public boolean existsCode(String code, int excludeId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(c) FROM Coupon c "
                    + "WHERE LOWER(c.code) = LOWER(:code) AND c.id <> :excludeId";

            Long soLuong = session.createQuery(hql, Long.class)
                    .setParameter("code", code.trim())
                    .setParameter("excludeId", excludeId)
                    .uniqueResult();

            return soLuong != null && soLuong > 0;
        }
    }
}
