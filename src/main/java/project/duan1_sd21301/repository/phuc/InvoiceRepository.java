package project.duan1_sd21301.repository.phuc;

import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.Size;
import project.duan1_sd21301.model.luong.Color;
import project.duan1_sd21301.model.phuc.Invoice;
import project.duan1_sd21301.model.phuc.InvoiceDetail;
import project.duan1_sd21301.model.phuc.InvoiceHistory;
import project.duan1_sd21301.model.phuc.PaymentMethod;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class InvoiceRepository {

    public Invoice save(Invoice invoice) {
        if (invoice.getCode() == null || invoice.getCode().trim().isEmpty()) {
            invoice.setCode("HD" + System.currentTimeMillis() % 100000);
        }
        String sql = "INSERT INTO hoa_don (hoa_don_code, id_khach_hang, id_nhan_vien, id_ma_giam_gia, " +
                "id_phuong_thuc_thanh_toan, id_dia_chi, ten_khach_nhan, sdt_khach_nhan, tam_tinh, " +
                "tong_thanh_toan, ngay_dat_hang, trang_thai_don_hang, ghi_chu, ngay_giao_du_kien, ngay_hoan_thanh, dia_chi_snapshot, loai_hoa_don, phi_van_chuyen) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, invoice.getCode());
            if (invoice.getCustomer() != null)
                ps.setInt(2, invoice.getCustomer().getId());
            else
                ps.setNull(2, Types.INTEGER);
            if (invoice.getEmployee() != null)
                ps.setInt(3, invoice.getEmployee().getId());
            else
                ps.setNull(3, Types.INTEGER);
            if (invoice.getCoupon() != null)
                ps.setInt(4, invoice.getCoupon().getId());
            else
                ps.setNull(4, Types.INTEGER);
            if (invoice.getPaymentMethod() != null)
                ps.setInt(5, invoice.getPaymentMethod().getId());
            else
                ps.setNull(5, Types.INTEGER);
            if (invoice.getAddress() != null)
                ps.setInt(6, invoice.getAddress().getId());
            else
                ps.setNull(6, Types.INTEGER);
            ps.setString(7, invoice.getReceiverName());
            ps.setString(8, invoice.getReceiverPhone());
            ps.setDouble(9, invoice.getSubtotal() != null ? invoice.getSubtotal() : 0.0);
            ps.setDouble(10, invoice.getTotalAmount() != null ? invoice.getTotalAmount() : 0.0);
            if (invoice.getOrderDate() != null)
                ps.setTimestamp(11, Timestamp.valueOf(invoice.getOrderDate()));
            else
                ps.setNull(11, Types.TIMESTAMP);
            ps.setInt(12, invoice.getOrderStatus() != null ? invoice.getOrderStatus() : 0);
            ps.setString(13, invoice.getNote());
            if (invoice.getExpectedDeliveryDate() != null)
                ps.setTimestamp(14, Timestamp.valueOf(invoice.getExpectedDeliveryDate()));
            else
                ps.setNull(14, Types.TIMESTAMP);
            if (invoice.getCompletionDate() != null)
                ps.setTimestamp(15, Timestamp.valueOf(invoice.getCompletionDate()));
            else
                ps.setNull(15, Types.TIMESTAMP);
            ps.setString(16, invoice.getAddressSnapshot());
            ps.setInt(17, invoice.getOrderType() != null ? invoice.getOrderType() : 1);
            ps.setDouble(18, invoice.getShippingFee() != null ? invoice.getShippingFee() : 0.0);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        invoice.setId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lưu hóa đơn", e);
        }
        return invoice;
    }

    public Invoice update(Invoice invoice) {
        String sql = "UPDATE hoa_don SET hoa_don_code = ?, id_khach_hang = ?, id_nhan_vien = ?, id_ma_giam_gia = ?, "
                +
                "id_phuong_thuc_thanh_toan = ?, id_dia_chi = ?, ten_khach_nhan = ?, sdt_khach_nhan = ?, tam_tinh = ?, "
                +
                "tong_thanh_toan = ?, ngay_dat_hang = ?, trang_thai_don_hang = ?, ghi_chu = ?, ngay_giao_du_kien = ?, ngay_hoan_thanh = ?, dia_chi_snapshot = ?, loai_hoa_don = ?, phi_van_chuyen = ? "
                +
                "WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getCode());
            if (invoice.getCustomer() != null)
                ps.setInt(2, invoice.getCustomer().getId());
            else
                ps.setNull(2, Types.INTEGER);
            if (invoice.getEmployee() != null)
                ps.setInt(3, invoice.getEmployee().getId());
            else
                ps.setNull(3, Types.INTEGER);
            if (invoice.getCoupon() != null)
                ps.setInt(4, invoice.getCoupon().getId());
            else
                ps.setNull(4, Types.INTEGER);
            if (invoice.getPaymentMethod() != null)
                ps.setInt(5, invoice.getPaymentMethod().getId());
            else
                ps.setNull(5, Types.INTEGER);
            if (invoice.getAddress() != null)
                ps.setInt(6, invoice.getAddress().getId());
            else
                ps.setNull(6, Types.INTEGER);
            ps.setString(7, invoice.getReceiverName());
            ps.setString(8, invoice.getReceiverPhone());
            ps.setDouble(9, invoice.getSubtotal() != null ? invoice.getSubtotal() : 0.0);
            ps.setDouble(10, invoice.getTotalAmount() != null ? invoice.getTotalAmount() : 0.0);
            if (invoice.getOrderDate() != null)
                ps.setTimestamp(11, Timestamp.valueOf(invoice.getOrderDate()));
            else
                ps.setNull(11, Types.TIMESTAMP);
            ps.setInt(12, invoice.getOrderStatus() != null ? invoice.getOrderStatus() : 0);
            ps.setString(13, invoice.getNote());
            if (invoice.getExpectedDeliveryDate() != null)
                ps.setTimestamp(14, Timestamp.valueOf(invoice.getExpectedDeliveryDate()));
            else
                ps.setNull(14, Types.TIMESTAMP);
            if (invoice.getCompletionDate() != null)
                ps.setTimestamp(15, Timestamp.valueOf(invoice.getCompletionDate()));
            else
                ps.setNull(15, Types.TIMESTAMP);
            ps.setString(16, invoice.getAddressSnapshot());
            ps.setInt(17, invoice.getOrderType() != null ? invoice.getOrderType() : 1);
            ps.setDouble(18, invoice.getShippingFee() != null ? invoice.getShippingFee() : 0.0);
            ps.setInt(19, invoice.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật hóa đơn", e);
        }
        return invoice;
    }

    public void softDelete(int id) {
        String sql = "UPDATE hoa_don SET trang_thai_don_hang = 0 WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa hóa đơn", e);
        }
    }

    public void updateStatusAndSaveHistory(Invoice invoice,
            List<InvoiceDetail> detailList,
            InvoiceHistory history,
            boolean updateStock,
            boolean increaseStock) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            if (updateStock && detailList != null) {
                String updateStockSql = "UPDATE chi_tiet_san_pham SET so_luong = so_luong + ? WHERE id = ?";
                try (PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                    for (InvoiceDetail detail : detailList) {
                        if (detail.getProductDetail() != null) {
                            int change = increaseStock ? detail.getQuantity() : -detail.getQuantity();
                            psStock.setInt(1, change);
                            psStock.setInt(2, detail.getProductDetail().getId());
                            psStock.addBatch();
                        }
                    }
                    psStock.executeBatch();
                }
            }

            String updateInvoiceSql = "UPDATE hoa_don SET trang_thai_don_hang = ? WHERE id = ?";
            try (PreparedStatement psInv = conn.prepareStatement(updateInvoiceSql)) {
                psInv.setInt(1, invoice.getOrderStatus());
                psInv.setInt(2, invoice.getId());
                psInv.executeUpdate();
            }

            if (history.getCode() == null || history.getCode().trim().isEmpty()) {
                history.setCode("LSHD" + System.currentTimeMillis() % 100000);
            }
            String insertHistorySql = "INSERT INTO lich_su_hoa_don (lich_su_hoa_don_code, id_hoa_don, id_nguoi_thuc_hien, trang_thai_cu, trang_thai_moi, ghi_chu, thoi_gian_cap_nhat) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psHist = conn.prepareStatement(insertHistorySql, Statement.RETURN_GENERATED_KEYS)) {
                psHist.setString(1, history.getCode());
                psHist.setInt(2, invoice.getId());
                if (history.getEmployee() != null)
                    psHist.setInt(3, history.getEmployee().getId());
                else
                    psHist.setNull(3, Types.INTEGER);
                psHist.setInt(4, history.getOldStatus());
                psHist.setInt(5, history.getNewStatus());
                psHist.setString(6, history.getNote());
                if (history.getUpdatedAt() != null)
                    psHist.setTimestamp(7, Timestamp.valueOf(history.getUpdatedAt()));
                else
                    psHist.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));

                int rows = psHist.executeUpdate();
                if (rows > 0) {
                    try (ResultSet rs = psHist.getGeneratedKeys()) {
                        if (rs.next())
                            history.setId(rs.getInt(1));
                    }
                }
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private Invoice mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setId(rs.getInt("id"));
        invoice.setCode(rs.getString("hoa_don_code"));
        invoice.setReceiverName(rs.getString("ten_khach_nhan"));
        invoice.setReceiverPhone(rs.getString("sdt_khach_nhan"));
        invoice.setSubtotal(rs.getDouble("tam_tinh"));
        invoice.setTotalAmount(rs.getDouble("tong_thanh_toan"));
        Timestamp orderDate = rs.getTimestamp("ngay_dat_hang");
        if (orderDate != null)
            invoice.setOrderDate(orderDate.toLocalDateTime());

        Timestamp expectedDeliveryDate = rs.getTimestamp("ngay_giao_du_kien");
        if (expectedDeliveryDate != null)
            invoice.setExpectedDeliveryDate(expectedDeliveryDate.toLocalDateTime());

        Timestamp completionDate = rs.getTimestamp("ngay_hoan_thanh");
        if (completionDate != null)
            invoice.setCompletionDate(completionDate.toLocalDateTime());

        invoice.setAddressSnapshot(rs.getString("dia_chi_snapshot"));

        invoice.setOrderStatus(rs.getObject("trang_thai_don_hang") != null ? rs.getInt("trang_thai_don_hang") : 0);
        invoice.setOrderType(rs.getObject("loai_hoa_don") != null ? rs.getInt("loai_hoa_don") : 1);
        invoice.setNote(rs.getString("ghi_chu"));
        invoice.setShippingFee(rs.getDouble("phi_van_chuyen"));

        // Basic mapping for PaymentMethod if joined
        try {
            int pmId = rs.getInt("pm_id");
            if (!rs.wasNull()) {
                PaymentMethod pm = new PaymentMethod();
                pm.setId(pmId);
                pm.setCode(rs.getString("pm_code"));
                pm.setName(rs.getString("pm_name"));
                invoice.setPaymentMethod(pm);
            } else {
                int directPmId = rs.getInt("id_phuong_thuc_thanh_toan");
                if (!rs.wasNull()) {
                    PaymentMethod pm = new PaymentMethod();
                    pm.setId(directPmId);
                    invoice.setPaymentMethod(pm);
                }
            }
        } catch (SQLException ignored) {
            int directPmId = rs.getInt("id_phuong_thuc_thanh_toan");
            if (!rs.wasNull()) {
                PaymentMethod pm = new PaymentMethod();
                pm.setId(directPmId);
                invoice.setPaymentMethod(pm);
            }
        }

        // Basic mapping for Address if joined
        try {
            int adId = rs.getInt("ad_id");
            if (!rs.wasNull()) {
                Address ad = new Address();
                ad.setId(adId);
                ad.setProvince(rs.getString("ad_province"));
                ad.setDistrict(rs.getString("ad_district"));
                ad.setWard(rs.getString("ad_ward"));
                ad.setDetailedAddress(rs.getString("ad_street"));
                invoice.setAddress(ad);
            }
        } catch (SQLException ignored) {
        }

        return invoice;
    }

    public Invoice findById(int id) {
        String sql = "SELECT hd.*, " +
                "pm.id AS pm_id, pm.phuong_thuc_thanh_toan_code AS pm_code, pm.ten_phuong_thuc AS pm_name, " +
                "ad.id AS ad_id, ad.tinh AS ad_province, ad.huyen AS ad_district, ad.xa AS ad_ward, ad.dia_chi_chi_tiet AS ad_street "
                +
                "FROM hoa_don hd " +
                "LEFT JOIN phuong_thuc_thanh_toan pm ON hd.id_phuong_thuc_thanh_toan = pm.id " +
                "LEFT JOIN dia_chi ad ON hd.id_dia_chi = ad.id " +
                "WHERE hd.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<InvoiceDetail> findDetailsByInvoiceId(int invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();
        String sql = "SELECT ct.*, " +
                "pd.id AS pd_id, pd.chi_tiet_san_pham_code AS pd_code, pd.gia_ban AS pd_price, " +
                "p.id AS p_id, p.ten_san_pham AS p_name, p.san_pham_code AS p_code, " +
                "sz.id AS sz_id, sz.ten_kich_thuoc AS sz_name, " +
                "c.id AS c_id, c.ten_mau AS c_name " +
                "FROM chi_tiet_hoa_don ct " +
                "LEFT JOIN chi_tiet_san_pham pd ON ct.id_chi_tiet_san_pham = pd.id " +
                "LEFT JOIN san_pham p ON pd.id_san_pham = p.id " +
                "LEFT JOIN kich_thuoc sz ON pd.id_kich_thuoc = sz.id " +
                "LEFT JOIN mau_sac c ON pd.id_mau_sac = c.id " +
                "WHERE ct.id_hoa_don = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceDetail detail = new InvoiceDetail();
                    detail.setId(rs.getInt("id"));
                    detail.setCode(rs.getString("chi_tiet_hoa_don_code"));
                    detail.setProductNameSnapshot(rs.getString("ten_sp_tai_thoi_diem"));
                    detail.setVariantDescriptionSnapshot(rs.getString("mo_ta_variant"));
                    detail.setUnitPrice(rs.getDouble("don_gia"));
                    detail.setDiscountPrice(rs.getDouble("gia_giam"));
                    detail.setQuantity(rs.getInt("so_luong"));
                    detail.setTotalPrice(rs.getDouble("thanh_tien"));
                    detail.setNote(rs.getString("ghi_chu"));

                    int pdId = rs.getInt("pd_id");
                    if (!rs.wasNull()) {
                        ProductDetail pd = new ProductDetail();
                        pd.setId(pdId);
                        pd.setCode(rs.getString("pd_code"));
                        pd.setPrice(rs.getDouble("pd_price"));

                        int pId = rs.getInt("p_id");
                        if (!rs.wasNull()) {
                            Product p = new Product();
                            p.setId(pId);
                            p.setName(rs.getString("p_name"));
                            p.setCode(rs.getString("p_code"));
                            pd.setProduct(p);
                        }

                        int szId = rs.getInt("sz_id");
                        if (!rs.wasNull()) {
                            pd.setSize(rs.getString("sz_name"));
                        }

                        int cId = rs.getInt("c_id");
                        if (!rs.wasNull()) {
                            pd.setColor(rs.getString("c_name"));
                        }

                        detail.setProductDetail(pd);
                    }

                    Invoice invoice = new Invoice();
                    invoice.setId(rs.getInt("id_hoa_don"));
                    detail.setInvoice(invoice);

                    list.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<InvoiceHistory> findHistoryByInvoiceId(int invoiceId) {
        List<InvoiceHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM lich_su_hoa_don WHERE id_hoa_don = ? ORDER BY thoi_gian_cap_nhat DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceHistory history = new InvoiceHistory();
                    history.setId(rs.getInt("id"));
                    history.setCode(rs.getString("lich_su_hoa_don_code"));
                    history.setOldStatus(rs.getInt("trang_thai_cu"));
                    history.setNewStatus(rs.getInt("trang_thai_moi"));
                    history.setNote(rs.getString("ghi_chu"));
                    Timestamp ts = rs.getTimestamp("thoi_gian_cap_nhat");
                    if (ts != null)
                        history.setUpdatedAt(ts.toLocalDateTime());

                    Invoice invoice = new Invoice();
                    invoice.setId(rs.getInt("id_hoa_don"));
                    history.setInvoice(invoice);

                    list.add(history);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> findAll(Integer orderType, Integer orderStatus, String keyword, String fromDateStr, String toDateStr,
            Integer paymentMethodId, int page, int size) {
        List<Invoice> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT hd.*, " +
                "pm.id AS pm_id, pm.phuong_thuc_thanh_toan_code AS pm_code, pm.ten_phuong_thuc AS pm_name " +
                "FROM hoa_don hd " +
                "LEFT JOIN phuong_thuc_thanh_toan pm ON hd.id_phuong_thuc_thanh_toan = pm.id " +
                "WHERE 1=1 ");

        if (orderType != null)
            sql.append("AND hd.loai_hoa_don = ? ");
        if (orderStatus != null)
            sql.append("AND hd.trang_thai_don_hang = ? ");
        if (paymentMethodId != null)
            sql.append("AND hd.id_phuong_thuc_thanh_toan = ? ");

        LocalDate fromDate = null;
        LocalDate toDate = null;
        if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
            try {
                fromDate = LocalDate.parse(fromDateStr);
            } catch (Exception ignored) {
            }
        }
        if (toDateStr != null && !toDateStr.trim().isEmpty()) {
            try {
                toDate = LocalDate.parse(toDateStr);
            } catch (Exception ignored) {
            }
        }
        if (fromDate != null)
            sql.append("AND hd.ngay_dat_hang >= ? ");
        if (toDate != null)
            sql.append("AND hd.ngay_dat_hang <= ? ");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        Integer maHoaDon = null;
        if (hasKeyword) {
            try {
                maHoaDon = Integer.parseInt(keyword.trim());
            } catch (NumberFormatException ignored) {
            }
            if (maHoaDon != null) {
                sql.append("AND (hd.id = ? OR LOWER(hd.ten_khach_nhan) LIKE ? OR hd.sdt_khach_nhan LIKE ?) ");
            } else {
                sql.append("AND (LOWER(hd.ten_khach_nhan) LIKE ? OR hd.sdt_khach_nhan LIKE ?) ");
            }
        }

        sql.append("ORDER BY hd.ngay_dat_hang DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (orderType != null)
                ps.setInt(index++, orderType);
            if (orderStatus != null)
                ps.setInt(index++, orderStatus);
            if (paymentMethodId != null)
                ps.setInt(index++, paymentMethodId);
            if (fromDate != null)
                ps.setTimestamp(index++, Timestamp.valueOf(fromDate.atStartOfDay()));
            if (toDate != null)
                ps.setTimestamp(index++, Timestamp.valueOf(toDate.atTime(LocalTime.MAX)));
            if (hasKeyword) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                if (maHoaDon != null) {
                    ps.setInt(index++, maHoaDon);
                    ps.setString(index++, kw);
                    ps.setString(index++, kw);
                } else {
                    ps.setString(index++, kw);
                    ps.setString(index++, kw);
                }
            }
            ps.setInt(index++, page * size);
            ps.setInt(index++, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public long countAll(Integer orderType, Integer orderStatus, String keyword, String fromDateStr, String toDateStr,
            Integer paymentMethodId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM hoa_don hd WHERE 1=1 ");

        if (orderType != null)
            sql.append("AND hd.loai_hoa_don = ? ");
        if (orderStatus != null)
            sql.append("AND hd.trang_thai_don_hang = ? ");
        if (paymentMethodId != null)
            sql.append("AND hd.id_phuong_thuc_thanh_toan = ? ");

        LocalDate fromDate = null;
        LocalDate toDate = null;
        if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
            try {
                fromDate = LocalDate.parse(fromDateStr);
            } catch (Exception ignored) {
            }
        }
        if (toDateStr != null && !toDateStr.trim().isEmpty()) {
            try {
                toDate = LocalDate.parse(toDateStr);
            } catch (Exception ignored) {
            }
        }
        if (fromDate != null)
            sql.append("AND hd.ngay_dat_hang >= ? ");
        if (toDate != null)
            sql.append("AND hd.ngay_dat_hang <= ? ");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        Integer maHoaDon = null;
        if (hasKeyword) {
            try {
                maHoaDon = Integer.parseInt(keyword.trim());
            } catch (NumberFormatException ignored) {
            }
            if (maHoaDon != null) {
                sql.append("AND (hd.id = ? OR LOWER(hd.ten_khach_nhan) LIKE ? OR hd.sdt_khach_nhan LIKE ?) ");
            } else {
                sql.append("AND (LOWER(hd.ten_khach_nhan) LIKE ? OR hd.sdt_khach_nhan LIKE ?) ");
            }
        }

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (orderType != null)
                ps.setInt(index++, orderType);
            if (orderStatus != null)
                ps.setInt(index++, orderStatus);
            if (paymentMethodId != null)
                ps.setInt(index++, paymentMethodId);
            if (fromDate != null)
                ps.setTimestamp(index++, Timestamp.valueOf(fromDate.atStartOfDay()));
            if (toDate != null)
                ps.setTimestamp(index++, Timestamp.valueOf(toDate.atTime(LocalTime.MAX)));
            if (hasKeyword) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                if (maHoaDon != null) {
                    ps.setInt(index++, maHoaDon);
                    ps.setString(index++, kw);
                    ps.setString(index++, kw);
                } else {
                    ps.setString(index++, kw);
                    ps.setString(index++, kw);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<PaymentMethod> findAllPaymentMethods() {
        List<PaymentMethod> list = new ArrayList<>();
        String sql = "SELECT * FROM phuong_thuc_thanh_toan";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PaymentMethod pm = new PaymentMethod();
                pm.setId(rs.getInt("id"));
                pm.setCode(rs.getString("phuong_thuc_thanh_toan_code"));
                pm.setName(rs.getString("ten_phuong_thuc"));
                pm.setDescription(rs.getString("mo_ta"));
                pm.setStatus(rs.getObject("trang_thai") != null ? rs.getInt("trang_thai") : 1);
                list.add(pm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}