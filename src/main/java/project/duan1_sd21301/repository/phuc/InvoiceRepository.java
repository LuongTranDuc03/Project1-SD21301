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
    public Invoice save(Invoice hoaDon) {
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
    public Invoice update(Invoice hoaDon) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Invoice merged = session.merge(hoaDon);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
        }
    }

    /**
     * Xóa mềm hóa đơn theo id bằng cách set trang_thai = 0.
     */
    public void softDelete(Integer id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Invoice hoaDon = session.get(Invoice.class, id);
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

    /**
     * Cập nhật trạng thái hóa đơn, xử lý tồn kho và ghi lịch sử — trong một transaction duy nhất.
     *
     * @param hoaDon            entity hóa đơn đã được set trạng thái mới
     * @param hoadonchitietList danh sách chi tiết (dùng xử lý tồn kho)
     * @param lichSu            bản ghi lịch sử cần lưu
     * @param xuLyKho           true = cần xử lý tồn kho
     * @param tangTonKho        true = hoàn kho (hủy đơn), false = trừ kho (phục hồi từ hủy)
     */
    public void capNhatTrangThaiVaGhiLichSu(Invoice hoaDon,
                                            List<InvoiceDetail> hoadonchitietList,
                                            InvoiceHistory lichSu,
                                            boolean xuLyKho,
                                            boolean tangTonKho) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();

            // 1. Xử lý tồn kho nếu cần
            if (xuLyKho && hoadonchitietList != null) {
                for (InvoiceDetail ct : hoadonchitietList) {
                    if (ct.getProductDetail() != null && ct.getSoLuong() != null) {
                        ProductDetail sp = session.get(ProductDetail.class, ct.getProductDetail().getId());
                        if (sp != null) {
                            int delta = tangTonKho ? ct.getSoLuong() : -ct.getSoLuong();
                            sp.setStock(sp.getStock() + delta);
                            session.merge(sp);
                        }
                    }
                }
            }

            // 2. Cập nhật hóa đơn
            session.merge(hoaDon);

            // 3. Ghi lịch sử
            session.persist(lichSu);

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
     * Tìm hóa đơn theo ID (có fetch các quan hệ thường dùng).
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
            String hql = "FROM InvoiceHistory ls "
                    + "WHERE ls.invoice.id = :invId "
                    + "ORDER BY ls.thoiGianCapNhat DESC";
            return session.createQuery(hql, InvoiceHistory.class)
                    .setParameter("invId", invoiceId)
                    .getResultList();
        }
    }

    /**
     * Lấy danh sách hóa đơn có phân trang và lọc theo trạng thái đơn hàng.
     *
     * @param trangThaiDonHang null = tất cả; 0/1/2/3/4 = lọc theo trạng thái
     * @param keyword          từ khóa tìm kiếm (tên KH, sdt, mã HD số); null hoặc rỗng = bỏ qua
     * @param page             số trang (bắt đầu từ 0)
     * @param size             số lượng mỗi trang
     */
    public List<Invoice> findAll(Integer trangThaiDonHang, String keyword, int page, int size) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("FROM Invoice hd "
                    + "LEFT JOIN FETCH hd.paymentMethod "
                    + "WHERE 1=1 ");

            if (trangThaiDonHang != null) {
                hql.append("AND hd.trangThaiDonHang = :trangThai ");
            }

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            Integer idSearch = null;
            if (hasKeyword) {
                try {
                    idSearch = Integer.parseInt(keyword.trim());
                } catch (NumberFormatException ignored) { }

                if (idSearch != null) {
                    hql.append("AND (hd.id = :idSearch OR LOWER(hd.tenKhachHang) LIKE :kw OR hd.sdtKhachHang LIKE :kw) ");
                } else {
                    hql.append("AND (LOWER(hd.tenKhachHang) LIKE :kw OR hd.sdtKhachHang LIKE :kw) ");
                }
            }

            hql.append("ORDER BY hd.ngayDatHang DESC");

            Query<Invoice> query = session.createQuery(hql.toString(), Invoice.class);

            if (trangThaiDonHang != null) {
                query.setParameter("trangThai", trangThaiDonHang);
            }
            if (hasKeyword) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                query.setParameter("kw", like);
                if (idSearch != null) {
                    query.setParameter("idSearch", idSearch);
                }
            }

            query.setFirstResult(page * size);
            query.setMaxResults(size);
            return query.getResultList();
        }
    }

    /**
     * Đếm tổng số hóa đơn theo trạng thái và keyword (dùng cho phân trang).
     */
    public long countAll(Integer trangThaiDonHang, String keyword) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder("SELECT COUNT(hd) FROM Invoice hd WHERE 1=1 ");

            if (trangThaiDonHang != null) {
                hql.append("AND hd.trangThaiDonHang = :trangThai ");
            }

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            Integer idSearch = null;
            if (hasKeyword) {
                try {
                    idSearch = Integer.parseInt(keyword.trim());
                } catch (NumberFormatException ignored) { }

                if (idSearch != null) {
                    hql.append("AND (hd.id = :idSearch OR LOWER(hd.tenKhachHang) LIKE :kw OR hd.sdtKhachHang LIKE :kw) ");
                } else {
                    hql.append("AND (LOWER(hd.tenKhachHang) LIKE :kw OR hd.sdtKhachHang LIKE :kw) ");
                }
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);

            if (trangThaiDonHang != null) {
                query.setParameter("trangThai", trangThaiDonHang);
            }
            if (hasKeyword) {
                String like = "%" + keyword.trim().toLowerCase() + "%";
                query.setParameter("kw", like);
                if (idSearch != null) {
                    query.setParameter("idSearch", idSearch);
                }
            }

            return query.uniqueResult();
        }
    }
}