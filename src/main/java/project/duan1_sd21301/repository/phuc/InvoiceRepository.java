//package project.duan1_sd21301.repository.phuc;
//
//import org.hibernate.Session;
//import org.hibernate.Transaction;
//import org.hibernate.query.Query;
//import project.duan1_sd21301.model.phuc.Invoice;
//import project.duan1_sd21301.model.phuc.InvoiceDetail;
//import project.duan1_sd21301.model.phuc.InvoiceHistory;
//import project.duan1_sd21301.util.HibernateUtil;
//
//import java.util.List;
//
//public class InvoiceRepository {
//
//    public Invoice save(Invoice hoaDon) {
//        Transaction tx = null;
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            tx = session.beginTransaction();
//            session.persist(hoaDon);
//            tx.commit();
//            return hoaDon;
//        } catch (Exception e) {
//            if (tx != null) tx.rollback();
//            throw new RuntimeException("Lỗi khi lưu hóa đơn", e);
//        }
//    }
//
//    /**
//     * Cập nhật hóa đơn đã tồn tại.
//     */
//    public Invoice update(Invoice hoaDon) {
//        Transaction tx = null;
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            tx = session.beginTransaction();
//            Invoice merged = session.merge(hoaDon);
//            tx.commit();
//            return merged;
//        } catch (Exception e) {
//            if (tx != null) tx.rollback();
//            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
//        }
//    }
//
//    /**
//     * Xóa mềm hóa đơn theo id bằng cách set trang_thai = 0.
//     */
//    public void softDelete(Integer id) {
//        Transaction tx = null;
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            tx = session.beginTransaction();
//            Invoice hoaDon = session.get(Invoice.class, id);
//            if (hoaDon != null) {
//                hoaDon.setTrangThai(0);
//                session.merge(hoaDon);
//            }
//            tx.commit();
//        } catch (Exception e) {
//            if (tx != null) tx.rollback();
//            throw new RuntimeException("Lỗi khi xóa hóa đơn", e);
//        }
//    }
//
//    /**
//     * Cập nhật trạng thái hóa đơn, xử lý tồn kho và ghi lịch sử — trong một transaction duy nhất.
//     *
//     * @param hoaDon            entity hóa đơn đã được set trạng thái mới
//     * @param hoadonchitietList danh sách chi tiết (dùng xử lý tồn kho)
//     * @param lichSu            bản ghi lịch sử cần lưu
//     * @param xuLyKho           true = cần xử lý tồn kho
//     * @param tangTonKho        true = hoàn kho (hủy đơn), false = trừ kho (phục hồi từ hủy)
//     */
//    public void capNhatTrangThaiVaGhiLichSu(Invoice hoaDon,
//                                            List<InvoiceDetail> hoadonchitietList,
//                                            InvoiceHistory lichSu,
//                                            boolean xuLyKho,
//                                            boolean tangTonKho) {
//        Transaction tx = null;
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            tx = session.beginTransaction();
//
//            // 1. Xử lý tồn kho nếu cần
//            if (xuLyKho && hoadonchitietList != null) {
//                for (InvoiceDetail ct : hoadonchitietList) {
//                    if (ct.productDetail() != null && ct.getSoLuong() != null) {
//                        ChiTietSanPham sp = session.get(ChiTietSanPham.class, ct.getChiTietSanPham().getId());
//                        if (sp != null) {
//                            int delta = tangTonKho ? ct.getSoLuong() : -ct.getSoLuong();
//                            sp.setSoLuongTon(sp.getSoLuongTon() + delta);
//                            session.merge(sp);
//                        }
//                    }
//                }
//            }
//
//            // 2. Cập nhật hóa đơn
//            session.merge(hoaDon);
//
//            // 3. Ghi lịch sử
//            session.persist(lichSu);
//
//            tx.commit();
//        } catch (Exception e) {
//            if (tx != null) tx.rollback();
//            throw new RuntimeException("Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage(), e);
//        }
//    }
//
//    // ===========================
//    // READ
//    // ===========================
//
//    /**
//     * Tìm hóa đơn theo ID (có fetch các quan hệ thường dùng).
//     */
//    public Invoice findById(int id) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String hql = "FROM Invoice hd "
//                    + "LEFT JOIN FETCH hd.khachHang "
//                    + "LEFT JOIN FETCH hd.nhanVien "
//                    + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                    + "LEFT JOIN FETCH hd.diaChi "
//                    + "WHERE hd.id = :id";
//            return session.createQuery(hql, Invoice.class)
//                    .setParameter("id", id)
//                    .uniqueResult();
//        }
//    }
//
//    /**
//     * Lấy danh sách hóa đơn có phân trang và lọc theo trạng thái đơn hàng.
//     *
//     * @param trangThaiDonHang null = tất cả; 0/1/2/3/4 = lọc theo trạng thái
//     * @param page             số trang (bắt đầu từ 0)
//     * @param size             số lượng mỗi trang
//     */
//    public List<Invoice> findAll(Integer trangThaiDonHang, int page, int size) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String hql;
//            Query<Invoice> query;
//
//            if (trangThaiDonHang != null) {
//                hql = "FROM Invoice hd "
//                        + "LEFT JOIN FETCH hd.khachHang "
//                        + "LEFT JOIN FETCH hd.nhanVien "
//                        + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                        + "WHERE hd.trangThaiDonHang = :trangThai "
//                        + "ORDER BY hd.ngayDatHang DESC";
//                query = session.createQuery(hql, Invoice.class);
//                query.setParameter("trangThai", trangThaiDonHang);
//            } else {
//                hql = "FROM Invoice hd "
//                        + "LEFT JOIN FETCH hd.khachHang "
//                        + "LEFT JOIN FETCH hd.nhanVien "
//                        + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                        + "ORDER BY hd.ngayDatHang DESC";
//                query = session.createQuery(hql, Invoice.class);
//            }
//
//            query.setFirstResult(page * size);
//            query.setMaxResults(size);
//            return query.getResultList();
//        }
//    }
//
//    /**
//     * Đếm tổng số hóa đơn theo trạng thái (dùng cho phân trang).
//     */
//    public long countAll(Integer trangThaiDonHang) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String hql;
//            Query<Long> query;
//
//            if (trangThaiDonHang != null) {
//                hql = "SELECT COUNT(hd) FROM Invoice hd WHERE hd.trangThaiDonHang = :trangThai";
//                query = session.createQuery(hql, Long.class);
//                query.setParameter("trangThai", trangThaiDonHang);
//            } else {
//                hql = "SELECT COUNT(hd) FROM Invoice hd";
//                query = session.createQuery(hql, Long.class);
//            }
//
//            return query.uniqueResult();
//        }
//    }
//
//    /**
//     * Tìm hóa đơn theo khách hàng.
//     */
//    public List<Invoice> findByKhachHang(Integer khachHangId) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String hql = "FROM Invoice hd "
//                    + "LEFT JOIN FETCH hd.khachHang "
//                    + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                    + "WHERE hd.khachHang.id = :khId "
//                    + "ORDER BY hd.ngayDatHang DESC";
//            return session.createQuery(hql, Invoice.class)
//                    .setParameter("khId", khachHangId)
//                    .getResultList();
//        }
//    }
//
//    /**
//     * Tìm kiếm hóa đơn theo từ khóa (tên KH hoặc mã hóa đơn) có phân trang.
//     */
//    public List<Invoice> search(String keyword, int page, int size) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String like = "%" + keyword.trim().toLowerCase() + "%";
//
//            // Nếu keyword là số nguyên → tìm thêm theo mã hóa đơn
//            Integer idSearch = null;
//            try {
//                idSearch = Integer.parseInt(keyword.trim());
//            } catch (NumberFormatException ignored) {
//            }
//
//            String hql;
//            Query<Invoice> query;
//            if (idSearch != null) {
//                hql = "FROM Invoice hd "
//                        + "LEFT JOIN FETCH hd.khachHang "
//                        + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                        + "WHERE hd.id = :id OR LOWER(hd.tenKhachHang) LIKE :kw "
//                        + "ORDER BY hd.ngayDatHang DESC";
//                query = session.createQuery(hql, Invoice.class);
//                query.setParameter("id", idSearch);
//                query.setParameter("kw", like);
//            } else {
//                hql = "FROM Invoice hd "
//                        + "LEFT JOIN FETCH hd.khachHang "
//                        + "LEFT JOIN FETCH hd.phuongThucThanhToan "
//                        + "WHERE LOWER(hd.tenKhachHang) LIKE :kw "
//                        + "ORDER BY hd.ngayDatHang DESC";
//                query = session.createQuery(hql, Invoice.class);
//                query.setParameter("kw", like);
//            }
//            query.setFirstResult(page * size);
//            query.setMaxResults(size);
//            return query.getResultList();
//        }
//    }
//
//    /**
//     * Đếm số hóa đơn khớp với tên khách hàng hoặc mã hóa đơn.
//     */
//    public long countSearch(String keyword) {
//        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
//            String like = "%" + keyword.trim().toLowerCase() + "%";
//
//            Integer idSearch = null;
//            try {
//                idSearch = Integer.parseInt(keyword.trim());
//            } catch (NumberFormatException ignored) {
//            }
//
//            String hql;
//            Query<Long> query;
//            if (idSearch != null) {
//                hql = "SELECT COUNT(hd) FROM Invoice hd "
//                        + "WHERE hd.id = :id OR LOWER(hd.tenKhachHang) LIKE :kw";
//                query = session.createQuery(hql, Long.class);
//                query.setParameter("id", idSearch);
//                query.setParameter("kw", like);
//            } else {
//                hql = "SELECT COUNT(hd) FROM Invoice hd "
//                        + "WHERE LOWER(hd.tenKhachHang) LIKE :kw";
//                query = session.createQuery(hql, Long.class);
//                query.setParameter("kw", like);
//            }
//            return query.uniqueResult();
//        }
//    }
//}