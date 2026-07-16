package project.duan1_sd21301.repository.phuc;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.util.HibernateUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * InvoiceRepository – Lớp thao tác trực tiếp với database cho bảng hóa đơn.
 *
 * Nhiệm vụ duy nhất của Repository là:
 *   - Lưu/sửa/xóa dữ liệu hóa đơn vào database
 *   - Đọc dữ liệu hóa đơn từ database
 *   - Không chứa logic nghiệp vụ
 */
public class InvoiceRepository {

    // =========================================================
    //  GHI DỮ LIỆU (WRITE)
    // =========================================================

    /**
     * Thêm mới một hóa đơn vào database.
     */
    public Invoice save(Invoice invoice) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            session.persist(invoice); // INSERT vào bảng hoa_don

            tx.commit();
            return invoice;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi lưu hóa đơn", e);
        }
    }

    /**
     * Cập nhật thông tin hóa đơn đã tồn tại.
     */
    public Invoice update(Invoice invoice) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Invoice saved = session.merge(invoice); // UPDATE theo id

            tx.commit();
            return saved;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
        }
    }

    /**
     * Xóa mềm hóa đơn: không xóa thật, chỉ đặt status = 0.
     * Cách làm này giúp giữ lại lịch sử, không mất dữ liệu.
     */
    public void softDelete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            Invoice invoice = session.get(Invoice.class, id); // Tìm hóa đơn
            if (invoice != null) {
                invoice.setStatus(0);    // Đánh dấu là đã xóa (status = 0)
                session.merge(invoice);  // Lưu lại
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa hóa đơn", e);
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng + xử lý tồn kho + ghi lịch sử.
     * Tất cả được thực hiện trong MỘT transaction để đảm bảo tính nhất quán:
     * hoặc là tất cả thành công, hoặc là không có gì thay đổi (rollback).
     *
     * @param invoice       hóa đơn đã được set trạng thái mới
     * @param detailList    danh sách sản phẩm trong đơn (để tính số lượng tồn kho)
     * @param history       bản ghi lịch sử thay đổi trạng thái
     * @param updateStock   true = cần cập nhật tồn kho
     * @param increaseStock true = hoàn kho (khi hủy đơn), false = trừ kho (khi phục hồi đơn)
     */
    public void updateStatusAndSaveHistory(Invoice invoice,
                                           List<InvoiceDetail> detailList,
                                           InvoiceHistory history,
                                           boolean updateStock,
                                           boolean increaseStock) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // Bước 1: Xử lý tồn kho (nếu cần)
            if (updateStock && detailList != null) {
                for (InvoiceDetail detail : detailList) {
                    if (detail.getProductDetail() != null) {
                        // Lấy thông tin sản phẩm từ DB để cập nhật tồn kho
                        ProductDetail sanPham = session.get(ProductDetail.class, detail.getProductDetail().getId());
                        if (sanPham != null) {
                            // Tính số lượng thay đổi: dương = tăng kho, âm = giảm kho
                            int soLuongThayDoi = increaseStock
                                    ? +detail.getQuantity()   // Hủy đơn → hoàn kho (+)
                                    : -detail.getQuantity();  // Phục hồi đơn → trừ kho (-)

                            sanPham.setStock(sanPham.getStock() + soLuongThayDoi);
                            session.merge(sanPham);
                        }
                    }
                }
            }

            // Bước 2: Lưu trạng thái mới của hóa đơn
            session.merge(invoice);

            // Bước 3: Ghi lịch sử thay đổi trạng thái
            session.persist(history);

            tx.commit(); // Lưu tất cả vào DB
        } catch (Exception e) {
            if (tx != null) tx.rollback(); // Có lỗi → hủy hết, không thay đổi gì
            throw new RuntimeException("Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage(), e);
        }
    }

    // =========================================================
    //  ĐỌC DỮ LIỆU (READ)
    // =========================================================

    /**
     * Tìm một hóa đơn theo ID.
     * Dùng LEFT JOIN FETCH để lấy luôn địa chỉ và phương thức thanh toán
     * trong cùng một câu query (tránh N+1 query problem).
     *
     * Trả về null nếu không tìm thấy.
     */
    public Invoice findById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Invoice hd "
                    + "LEFT JOIN FETCH hd.address "       // Lấy kèm địa chỉ
                    + "LEFT JOIN FETCH hd.paymentMethod " // Lấy kèm phương thức thanh toán
                    + "WHERE hd.id = :id";

            return session.createQuery(hql, Invoice.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    /**
     * Lấy danh sách chi tiết sản phẩm trong một hóa đơn.
     * (Có fetch kèm thông tin sản phẩm để hiển thị tên, ảnh, ...)
     */
    public List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM InvoiceDetail ct "
                    + "LEFT JOIN FETCH ct.productDetail " // Lấy kèm thông tin sản phẩm
                    + "WHERE ct.invoice.id = :invoiceId";

            return session.createQuery(hql, InvoiceDetail.class)
                    .setParameter("invoiceId", invoiceId)
                    .getResultList();
        }
    }

    /**
     * Lấy lịch sử thay đổi trạng thái của một hóa đơn.
     * Sắp xếp mới nhất lên trước.
     */
    public List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM InvoiceHistory h "
                    + "WHERE h.invoice.id = :invoiceId "
                    + "ORDER BY h.updatedAt DESC"; // Mới nhất lên trên

            return session.createQuery(hql, InvoiceHistory.class)
                    .setParameter("invoiceId", invoiceId)
                    .getResultList();
        }
    }

    /**
     * Lấy danh sách hóa đơn có lọc và phân trang.
     *
     * @param orderStatus null = tất cả trạng thái; 0/1/2/3/4 = lọc theo trạng thái
     * @param keyword     tìm theo tên KH, SĐT, hoặc mã số hóa đơn; null/rỗng = không lọc
     * @param page        số trang (bắt đầu từ 0)
     * @param size        số bản ghi mỗi trang
     */
    public List<Invoice> findAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "FROM Invoice hd LEFT JOIN FETCH hd.paymentMethod WHERE 1=1 ");

            // Lọc theo trạng thái nếu có chọn
            if (orderStatus != null) {
                hql.append("AND hd.orderStatus = :orderStatus ");
            }

            LocalDate fromDate = null;
            LocalDate toDate = null;
            
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                try { fromDate = LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                try { toDate = LocalDate.parse(toDateStr); } catch (Exception ignored) {}
            }

            if (fromDate != null) {
                hql.append("AND hd.orderDate >= :startOfDay ");
            }
            if (toDate != null) {
                hql.append("AND hd.orderDate <= :endOfDay ");
            }

            // Xử lý từ khóa tìm kiếm
            boolean coTuKhoa = keyword != null && !keyword.trim().isEmpty();
            Integer maHoaDon = null; // Thử parse keyword thành số (tìm theo mã HD)
            if (coTuKhoa) {
                try {
                    maHoaDon = Integer.parseInt(keyword.trim());
                } catch (NumberFormatException ignored) {
                    // Nếu không phải số thì chỉ tìm theo tên/SĐT
                }

                if (maHoaDon != null) {
                    // Tìm theo mã HD (số) HOẶC tên HOẶC SĐT
                    hql.append("AND (hd.id = :maHoaDon OR LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                } else {
                    // Chỉ tìm theo tên HOẶC SĐT
                    hql.append("AND (LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                }
            }

            hql.append("ORDER BY hd.orderDate DESC"); // Đơn mới nhất hiển thị trước

            Query<Invoice> query = session.createQuery(hql.toString(), Invoice.class);

            // Gán giá trị cho các tham số
            if (orderStatus != null) query.setParameter("orderStatus", orderStatus);
            if (fromDate != null) {
                query.setParameter("startOfDay", fromDate.atStartOfDay());
            }
            if (toDate != null) {
                query.setParameter("endOfDay", toDate.atTime(LocalTime.MAX));
            }
            if (coTuKhoa) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (maHoaDon != null) query.setParameter("maHoaDon", maHoaDon);
            }

            // Phân trang
            query.setFirstResult(page * size); // Bỏ qua bao nhiêu bản ghi đầu
            query.setMaxResults(size);         // Lấy tối đa bao nhiêu bản ghi

            return query.getResultList();
        }
    }

    /**
     * Đếm tổng số hóa đơn theo điều kiện lọc.
     * Dùng để tính tổng số trang cho phân trang.
     */
    public long countAll(Integer orderStatus, String keyword, String fromDateStr, String toDateStr) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(hd) FROM Invoice hd WHERE 1=1 ");

            if (orderStatus != null) {
                hql.append("AND hd.orderStatus = :orderStatus ");
            }

            LocalDate fromDate = null;
            LocalDate toDate = null;
            
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                try { fromDate = LocalDate.parse(fromDateStr); } catch (Exception ignored) {}
            }
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                try { toDate = LocalDate.parse(toDateStr); } catch (Exception ignored) {}
            }

            if (fromDate != null) {
                hql.append("AND hd.orderDate >= :startOfDay ");
            }
            if (toDate != null) {
                hql.append("AND hd.orderDate <= :endOfDay ");
            }

            boolean coTuKhoa = keyword != null && !keyword.trim().isEmpty();
            Integer maHoaDon = null;
            if (coTuKhoa) {
                try {
                    maHoaDon = Integer.parseInt(keyword.trim());
                } catch (NumberFormatException ignored) { }

                if (maHoaDon != null) {
                    hql.append("AND (hd.id = :maHoaDon OR LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                } else {
                    hql.append("AND (LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                }
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);

            if (orderStatus != null) query.setParameter("orderStatus", orderStatus);
            if (fromDate != null) {
                query.setParameter("startOfDay", fromDate.atStartOfDay());
            }
            if (toDate != null) {
                query.setParameter("endOfDay", toDate.atTime(LocalTime.MAX));
            }
            if (coTuKhoa) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (maHoaDon != null) query.setParameter("maHoaDon", maHoaDon);
            }

            return query.uniqueResult();
        }
    }
}