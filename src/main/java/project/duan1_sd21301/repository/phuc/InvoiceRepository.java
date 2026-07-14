package project.duan1_sd21301.repository.phuc;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.util.HibernateUtil;

import java.util.List;

public class InvoiceRepository {

    // ===========================
    // WRITE
    // ===========================

    /**
     * Lưu mới hóa đơn.
     */
    public Invoice save(Invoice invoice) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(invoice);
            tx.commit();
            return invoice;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi lưu hóa đơn", e);
        }
    }

    /**
     * Cập nhật hóa đơn đã tồn tại.
     */
    public Invoice update(Invoice invoice) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Invoice merged = session.merge(invoice);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
        }
    }

    /**
     * Xóa mềm hóa đơn theo id bằng cách set status = 0.
     */
    public void softDelete(int id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Invoice invoice = session.get(Invoice.class, id);
            if (invoice != null) {
                invoice.setStatus(0);
                session.merge(invoice);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa hóa đơn", e);
        }
    }

    /**
     * Cập nhật trạng thái hóa đơn, xử lý tồn kho và ghi lịch sử — trong một transaction duy nhất.
     *
     * @param invoice      entity hóa đơn đã được set trạng thái mới
     * @param detailList   danh sách chi tiết (dùng xử lý tồn kho)
     * @param history      bản ghi lịch sử cần lưu
     * @param updateStock  true = cần xử lý tồn kho
     * @param increaseStock true = hoàn kho (hủy đơn), false = trừ kho (phục hồi từ hủy)
     */
    public void updateStatusAndSaveHistory(Invoice invoice,
                                           List<InvoiceDetail> detailList,
                                           InvoiceHistory history,
                                           boolean updateStock,
                                           boolean increaseStock) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // 1. Xử lý tồn kho nếu cần
            if (updateStock && detailList != null) {
                for (InvoiceDetail detail : detailList) {
                    if (detail.getProductDetail() != null) {
                        ProductDetail product = session.get(ProductDetail.class, detail.getProductDetail().getId());
                        if (product != null) {
                            int delta = increaseStock ? detail.getQuantity() : -detail.getQuantity();
                            product.setStock(product.getStock() + delta);
                            session.merge(product);
                        }
                    }
                }
            }

            // 2. Cập nhật hóa đơn
            session.merge(invoice);

            // 3. Ghi lịch sử
            session.persist(history);

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage(), e);
        }
    }

    // ===========================
    // READ
    // ===========================

    /**
     * Tìm hóa đơn theo ID (có fetch address và paymentMethod).
     */
    public Invoice findById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM Invoice hd "
                    + "LEFT JOIN FETCH hd.address "
                    + "LEFT JOIN FETCH hd.paymentMethod "
                    + "WHERE hd.id = :id";
            return session.createQuery(hql, Invoice.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    /**
     * Lấy danh sách chi tiết hóa đơn theo id hóa đơn (có fetch productDetail).
     */
    public List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM InvoiceDetail ct "
                    + "LEFT JOIN FETCH ct.productDetail "
                    + "WHERE ct.invoice.id = :invId";
            return session.createQuery(hql, InvoiceDetail.class)
                    .setParameter("invId", invoiceId)
                    .getResultList();
        }
    }

    /**
     * Lấy lịch sử hóa đơn theo id hóa đơn, sắp xếp mới nhất trước.
     */
    public List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "FROM InvoiceHistory h "
                    + "WHERE h.invoice.id = :invId "
                    + "ORDER BY h.updatedAt DESC";
            return session.createQuery(hql, InvoiceHistory.class)
                    .setParameter("invId", invoiceId)
                    .getResultList();
        }
    }

    /**
     * Lấy danh sách hóa đơn có phân trang, lọc theo orderStatus và keyword.
     *
     * @param orderStatus null = tất cả; 0/1/2/3/4 = lọc theo trạng thái
     * @param keyword     từ khóa tìm kiếm (tên KH, sdt, mã HD số); null hoặc rỗng = bỏ qua
     * @param page        số trang (bắt đầu từ 0)
     * @param size        số lượng mỗi trang
     */
    public List<Invoice> findAll(Integer orderStatus, String keyword, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "FROM Invoice hd LEFT JOIN FETCH hd.paymentMethod WHERE 1=1 ");

            if (orderStatus != null) {
                hql.append("AND hd.orderStatus = :orderStatus ");
            }

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            Integer idSearch = null;
            if (hasKeyword) {
                try { idSearch = Integer.parseInt(keyword.trim()); }
                catch (NumberFormatException ignored) { }

                if (idSearch != null) {
                    hql.append("AND (hd.id = :idSearch OR LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                } else {
                    hql.append("AND (LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                }
            }

            hql.append("ORDER BY hd.orderDate DESC");

            Query<Invoice> query = session.createQuery(hql.toString(), Invoice.class);

            if (orderStatus != null)    query.setParameter("orderStatus", orderStatus);
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (idSearch != null)   query.setParameter("idSearch", idSearch);
            }

            query.setFirstResult(page * size);
            query.setMaxResults(size);
            return query.getResultList();
        }
    }

    /**
     * Đếm tổng số hóa đơn theo orderStatus và keyword (dùng cho phân trang).
     */
    public long countAll(Integer orderStatus, String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(hd) FROM Invoice hd WHERE 1=1 ");

            if (orderStatus != null) {
                hql.append("AND hd.orderStatus = :orderStatus ");
            }

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            Integer idSearch = null;
            if (hasKeyword) {
                try { idSearch = Integer.parseInt(keyword.trim()); }
                catch (NumberFormatException ignored) { }

                if (idSearch != null) {
                    hql.append("AND (hd.id = :idSearch OR LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                } else {
                    hql.append("AND (LOWER(hd.customerName) LIKE :kw OR hd.customerPhone LIKE :kw) ");
                }
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);

            if (orderStatus != null)    query.setParameter("orderStatus", orderStatus);
            if (hasKeyword) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                if (idSearch != null)   query.setParameter("idSearch", idSearch);
            }

            return query.uniqueResult();
        }
    }
}