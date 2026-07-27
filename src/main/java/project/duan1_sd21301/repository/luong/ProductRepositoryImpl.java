package project.duan1_sd21301.repository.luong;

import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ProductRepositoryImpl implements ProductRepository {

    private static final String BASE_SELECT_PRODUCT = "SELECT sp.*, dm.ten_danh_muc, th.ten_thuong_hieu, xx.ten_xuat_xu "
            +
            "FROM san_pham sp " +
            "LEFT JOIN danh_muc dm ON sp.id_danh_muc = dm.id " +
            "LEFT JOIN thuong_hieu th ON sp.id_thuong_hieu = th.id " +
            "LEFT JOIN xuat_xu xx ON sp.id_xuat_xu = xx.id ";

    @Override
    public List<Product> findAll() {
        seedSampleProductsIfEmpty();
        List<Product> products = new ArrayList<>();
        String sql = BASE_SELECT_PRODUCT + "ORDER BY sp.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                p.setDetails(findDetailsByProductId(conn, p.getId()));
                products.add(p);
            }
        } catch (SQLException e) {
            System.err.println("❌ ProductRepositoryImpl.findAll Error: " + e.getMessage());
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM san_pham ORDER BY id DESC");
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    p.setDetails(findDetailsByProductId(conn, p.getId()));
                    products.add(p);
                }
            } catch (SQLException ex) {
                System.err.println("❌ Fallback Product SELECT * Error: " + ex.getMessage());
            }
        }
        return products;
    }

    @Override
    public Product findById(int id) {
        String sql = BASE_SELECT_PRODUCT + "WHERE sp.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    p.setDetails(findDetailsByProductId(conn, p.getId()));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Product findByCode(String code) {
        if (code == null)
            return null;
        String sql = BASE_SELECT_PRODUCT + "WHERE LOWER(LTRIM(RTRIM(sp.san_pham_code))) = LOWER(LTRIM(RTRIM(?)))";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = mapResultSetToProduct(rs);
                    p.setDetails(findDetailsByProductId(conn, p.getId()));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insert(Product product) {
        if (product.getCode() == null || product.getCode().trim().isEmpty()) {
            product.setCode(getNextProductCode());
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null)
                return false;

            int categoryId = findOrCreateCategory(conn, product.getCategory());
            int brandId = findOrCreateBrand(conn, product.getBrand());
            int originId = findOrCreateOrigin(conn, product.getOrigin());
            String sql = "INSERT INTO san_pham (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, mo_ta, doi_tuong, id_xuat_xu, huong_dan_bao_quan, gia_ban, da_ban, trang_thai) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, product.getCode());
                ps.setString(2, product.getName());
                if (categoryId > 0)
                    ps.setInt(3, categoryId);
                else
                    ps.setNull(3, Types.INTEGER);
                if (brandId > 0)
                    ps.setInt(4, brandId);
                else
                    ps.setNull(4, Types.INTEGER);
                ps.setString(5, product.getDescription());
                ps.setNull(6, Types.NVARCHAR); // doi_tuong
                if (originId > 0)
                    ps.setInt(7, originId);
                else
                    ps.setNull(7, Types.INTEGER);
                ps.setString(8, product.getCareInstructions());
                ps.setDouble(9, product.getPrice());
                ps.setInt(10, product.getSold());
                ps.setInt(11, product.getStatus() != null ? product.getStatus() : 1);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            product.setId(rs.getInt(1));
                        }
                    }
                    if (product.getDetails() != null) {
                        for (ProductDetail detail : product.getDetails()) {
                            detail.setProduct(product);
                            insertDetailInternal(conn, detail);
                        }
                    }
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Product product) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null)
                return false;

            int categoryId = findOrCreateCategory(conn, product.getCategory());
            int brandId = findOrCreateBrand(conn, product.getBrand());
            int originId = findOrCreateOrigin(conn, product.getOrigin());
            String sql = "UPDATE san_pham SET san_pham_code = ?, ten_san_pham = ?, id_danh_muc = ?, id_thuong_hieu = ?, "
                    +
                    "mo_ta = ?, doi_tuong = ?, id_xuat_xu = ?, huong_dan_bao_quan = ?, gia_ban = ?, da_ban = ?, trang_thai = ? "
                    +
                    "WHERE id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, product.getCode());
                ps.setString(2, product.getName());
                if (categoryId > 0)
                    ps.setInt(3, categoryId);
                else
                    ps.setNull(3, Types.INTEGER);
                if (brandId > 0)
                    ps.setInt(4, brandId);
                else
                    ps.setNull(4, Types.INTEGER);
                ps.setString(5, product.getDescription());
                ps.setNull(6, Types.NVARCHAR); // doi_tuong
                if (originId > 0)
                    ps.setInt(7, originId);
                else
                    ps.setNull(7, Types.INTEGER);
                ps.setString(8, product.getCareInstructions());
                ps.setDouble(9, product.getPrice());
                ps.setInt(10, product.getSold());
                ps.setInt(11, product.getStatus() != null ? product.getStatus() : 1);
                ps.setInt(12, product.getId());

                boolean updated = ps.executeUpdate() > 0;
                if (updated && product.getDetails() != null) {
                    syncDeletedDetails(conn, product.getId(), product.getDetails());
                    for (ProductDetail detail : product.getDetails()) {
                        detail.setProduct(product);
                        if (detail.getId() > 0) {
                            updateDetail(detail);
                        } else {
                            insertDetailInternal(conn, detail);
                        }
                    }
                }
                return updated;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM san_pham WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<ProductDetail> findDetailsByProductId(int productId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return findDetailsByProductId(conn, productId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    private List<ProductDetail> findDetailsByProductId(Connection conn, int productId) throws SQLException {
        List<ProductDetail> details = new ArrayList<>();
        String sql = "SELECT ctsp.*, kt.ten_kich_thuoc, ms.ten_mau, kd.ten_kieu_dang " +
                "FROM chi_tiet_san_pham ctsp " +
                "LEFT JOIN kich_thuoc kt ON ctsp.id_kich_thuoc = kt.id " +
                "LEFT JOIN mau_sac ms ON ctsp.id_mau_sac = ms.id " +
                "LEFT JOIN kieu_dang kd ON ctsp.id_kieu_dang = kd.id " +
                "WHERE ctsp.id_san_pham = ? ORDER BY ctsp.id ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetail d = mapResultSetToProductDetail(rs);
                    d.setImages(findImagesByDetailId(conn, d.getId()));
                    details.add(d);
                }
            }
        }
        return details;
    }

    @Override
    public ProductDetail findDetailById(int detailId) {
        String sql = "SELECT ctsp.*, kt.ten_kich_thuoc, ms.ten_mau, kd.ten_kieu_dang " +
                "FROM chi_tiet_san_pham ctsp " +
                "LEFT JOIN kich_thuoc kt ON ctsp.id_kich_thuoc = kt.id " +
                "LEFT JOIN mau_sac ms ON ctsp.id_mau_sac = ms.id " +
                "LEFT JOIN kieu_dang kd ON ctsp.id_kieu_dang = kd.id " +
                "WHERE ctsp.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductDetail d = mapResultSetToProductDetail(rs);
                    d.setImages(findImagesByDetailId(conn, d.getId()));
                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insertDetail(ProductDetail detail) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return insertDetailInternal(conn, detail);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean insertDetailInternal(Connection conn, ProductDetail detail) throws SQLException {
        if (detail.getCode() == null || detail.getCode().trim().isEmpty()) {
            detail.setCode("CT" + System.currentTimeMillis() % 100000);
        }
        int sizeId = findOrCreateSize(conn, detail.getSize());
        int colorId = findOrCreateColor(conn, detail.getColor());
        int styleId = findOrCreateStyle(conn, detail.getStyle());

        String sql = "INSERT INTO chi_tiet_san_pham (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, ma_vach, gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String vCode = detail.getCode();
        if (vCode == null || vCode.trim().isEmpty()) {
            String pCode = (detail.getProduct() != null && detail.getProduct().getCode() != null)
                    ? detail.getProduct().getCode()
                    : "CTSP";
            String color = detail.getColor() != null ? detail.getColor() : "";
            String size = detail.getSize() != null ? detail.getSize() : "";
            vCode = (pCode + "-" + color + "-" + size).replaceAll("\\s+", "");
            if (vCode.length() > 50)
                vCode = vCode.substring(0, 50);
        }

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, vCode);
            ps.setInt(2, detail.getProduct() != null ? detail.getProduct().getId() : 0);
            if (sizeId > 0)
                ps.setInt(3, sizeId);
            else
                ps.setNull(3, Types.INTEGER);
            if (colorId > 0)
                ps.setInt(4, colorId);
            else
                ps.setNull(4, Types.INTEGER);
            if (styleId > 0)
                ps.setInt(5, styleId);
            else
                ps.setNull(5, Types.INTEGER);
            ps.setString(6, detail.getBarcode());
            ps.setDouble(7, detail.getImportPrice());
            ps.setDouble(8, detail.getPrice());
            ps.setInt(9, detail.getStock());
            ps.setDouble(10, detail.getWeight());
            ps.setDouble(11, detail.getLength());
            ps.setDouble(12, detail.getWidth());
            ps.setDouble(13, detail.getThickness());
            ps.setInt(14, detail.getStatus() != null ? detail.getStatus() : 1);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        detail.setId(rs.getInt(1));
                    }
                }
                if (detail.getImages() != null) {
                    saveImages(conn, detail.getId(), detail.getImages());
                }
                return true;
            }
        } catch (SQLException ex1) {
            String sqlFallback = "INSERT INTO chi_tiet_san_pham (id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, so_luong_ton, trong_luong, trang_thai) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlFallback, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, detail.getProduct() != null ? detail.getProduct().getId() : 0);
                if (sizeId > 0)
                    ps.setInt(2, sizeId);
                else
                    ps.setNull(2, Types.INTEGER);
                if (colorId > 0)
                    ps.setInt(3, colorId);
                else
                    ps.setNull(3, Types.INTEGER);
                if (styleId > 0)
                    ps.setInt(4, styleId);
                else
                    ps.setNull(4, Types.INTEGER);
                ps.setDouble(5, detail.getImportPrice());
                ps.setDouble(6, detail.getPrice());
                ps.setInt(7, detail.getStock());
                ps.setDouble(8, detail.getWeight());
                ps.setInt(9, detail.getStatus() != null ? detail.getStatus() : 1);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            detail.setId(rs.getInt(1));
                        }
                    }
                    if (detail.getImages() != null) {
                        saveImages(conn, detail.getId(), detail.getImages());
                    }
                    return true;
                }
            } catch (SQLException ignored) {
            }
        }
        return false;
    }

    @Override
    public boolean updateDetail(ProductDetail detail) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null)
                return false;
            int sizeId = findOrCreateSize(conn, detail.getSize());
            int colorId = findOrCreateColor(conn, detail.getColor());
            int styleId = findOrCreateStyle(conn, detail.getStyle());

            String sql = "UPDATE chi_tiet_san_pham SET chi_tiet_san_pham_code = ?, id_kich_thuoc = ?, id_mau_sac = ?, id_kieu_dang = ?, "
                    + "ma_vach = ?, gia_nhap = ?, gia_ban = ?, so_luong = ?, trong_luong = ?, chieu_dai = ?, chieu_rong = ?, do_day = ?, trang_thai = ? "
                    + "WHERE id = ?";

            String vCode = detail.getCode();
            if (vCode == null || vCode.trim().isEmpty()) {
                String pCode = (detail.getProduct() != null && detail.getProduct().getCode() != null)
                        ? detail.getProduct().getCode()
                        : "CTSP";
                String color = detail.getColor() != null ? detail.getColor() : "";
                String size = detail.getSize() != null ? detail.getSize() : "";
                vCode = (pCode + "-" + color + "-" + size).replaceAll("\\s+", "");
                if (vCode.length() > 50)
                    vCode = vCode.substring(0, 50);
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, vCode);
                if (sizeId > 0)
                    ps.setInt(2, sizeId);
                else
                    ps.setNull(2, Types.INTEGER);
                if (colorId > 0)
                    ps.setInt(3, colorId);
                else
                    ps.setNull(3, Types.INTEGER);
                if (styleId > 0)
                    ps.setInt(4, styleId);
                else
                    ps.setNull(4, Types.INTEGER);
                ps.setString(5, detail.getBarcode());
                ps.setDouble(6, detail.getImportPrice());
                ps.setDouble(7, detail.getPrice());
                ps.setInt(8, detail.getStock());
                ps.setDouble(9, detail.getWeight());
                ps.setDouble(10, detail.getLength());
                ps.setDouble(11, detail.getWidth());
                ps.setDouble(12, detail.getThickness());
                ps.setInt(13, detail.getStatus() != null ? detail.getStatus() : 1);
                ps.setInt(14, detail.getId());

                boolean success = ps.executeUpdate() > 0;
                if (success && detail.getImages() != null) {
                    saveImages(conn, detail.getId(), detail.getImages());
                }
                return success;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void syncDeletedDetails(Connection conn, int productId, List<ProductDetail> keptDetails) {
        try {
            Map<Integer, ProductDetail> dbVariantMap = new HashMap<>();
            Map<String, Integer> dbKeyToIdMap = new HashMap<>();

            String sql = "SELECT ct.id, kt.ten_kich_thuoc, ms.ten_mau_sac "
                    + "FROM chi_tiet_san_pham ct "
                    + "LEFT JOIN kich_thuoc kt ON ct.id_kich_thuoc = kt.id "
                    + "LEFT JOIN mau_sac ms ON ct.id_mau_sac = ms.id "
                    + "WHERE ct.id_san_pham = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int dbId = rs.getInt("id");
                        String size = rs.getString("ten_kich_thuoc");
                        String color = rs.getString("ten_mau_sac");
                        if (size == null)
                            size = "";
                        if (color == null)
                            color = "";
                        String key = (color.trim() + "|" + size.trim()).toLowerCase();
                        dbVariantMap.put(dbId, ProductDetail.builder().id(dbId).color(color).size(size).build());
                        dbKeyToIdMap.put(key, dbId);
                    }
                }
            }

            Set<Integer> matchedDbIds = new HashSet<>();

            if (keptDetails != null) {
                for (ProductDetail d : keptDetails) {
                    if (d.getId() > 0 && dbVariantMap.containsKey(d.getId())) {
                        matchedDbIds.add(d.getId());
                    } else {
                        String c = d.getColor() != null ? d.getColor().trim() : "";
                        String s = d.getSize() != null ? d.getSize().trim() : "";
                        String key = (c + "|" + s).toLowerCase();
                        if (dbKeyToIdMap.containsKey(key)) {
                            int matchedId = dbKeyToIdMap.get(key);
                            d.setId(matchedId);
                            matchedDbIds.add(matchedId);
                        }
                    }
                }
            }

            for (Integer dbId : dbVariantMap.keySet()) {
                if (!matchedDbIds.contains(dbId)) {
                    try (PreparedStatement psImg = conn
                            .prepareStatement("DELETE FROM hinh_anh WHERE id_chi_tiet_san_pham = ?")) {
                        psImg.setInt(1, dbId);
                        psImg.executeUpdate();
                    }
                    try (PreparedStatement psDel = conn
                            .prepareStatement("DELETE FROM chi_tiet_san_pham WHERE id = ?")) {
                        psDel.setInt(1, dbId);
                        psDel.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ Warning during syncDeletedDetails: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteDetail(int detailId) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null)
                return false;
            try (PreparedStatement psImg = conn
                    .prepareStatement("DELETE FROM hinh_anh WHERE id_chi_tiet_san_pham = ?")) {
                psImg.setInt(1, detailId);
                psImg.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM chi_tiet_san_pham WHERE id = ?")) {
                ps.setInt(1, detailId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private List<String> findImagesByDetailId(Connection conn, int detailId) throws SQLException {
        List<String> images = new ArrayList<>();
        String sql = "SELECT duong_dan FROM hinh_anh WHERE id_chi_tiet_san_pham = ? ORDER BY thu_tu ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detailId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("duong_dan"));
                }
            }
        }
        return images;
    }

    private void saveImages(Connection conn, int detailId, List<String> images) throws SQLException {
        try (PreparedStatement delPs = conn.prepareStatement("DELETE FROM hinh_anh WHERE id_chi_tiet_san_pham = ?")) {
            delPs.setInt(1, detailId);
            delPs.executeUpdate();
        }
        if (images == null || images.isEmpty())
            return;

        String sql = "INSERT INTO hinh_anh (hinh_anh_code, id_chi_tiet_san_pham, duong_dan, anh_chinh, thu_tu) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < images.size(); i++) {
                ps.setString(1, "HA" + System.currentTimeMillis() % 100000 + "_" + i);
                ps.setInt(2, detailId);
                ps.setString(3, images.get(i));
                ps.setBoolean(4, i == 0);
                ps.setInt(5, i + 1);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    @Override
    public List<String> findAllCategories() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_danh_muc FROM danh_muc ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_danh_muc") != null && !rs.getString("ten_danh_muc").trim().isEmpty()) {
                    list.add(rs.getString("ten_danh_muc"));
                }
            }
        } catch (SQLException ignored) {
        }
        return list;
    }

    @Override
    public List<String> findAllBrands() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_thuong_hieu FROM thuong_hieu ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_thuong_hieu") != null && !rs.getString("ten_thuong_hieu").trim().isEmpty()) {
                    list.add(rs.getString("ten_thuong_hieu"));
                }
            }
        } catch (SQLException ignored) {
        }
        return list;
    }

    @Override
    public List<String> findAllColors() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_mau FROM mau_sac ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_mau") != null && !rs.getString("ten_mau").trim().isEmpty()) {
                    list.add(rs.getString("ten_mau"));
                }
            }
        } catch (SQLException ignored) {
        }
        return list;
    }

    @Override
    public List<String> findAllSizes() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_kich_thuoc FROM kich_thuoc ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_kich_thuoc") != null && !rs.getString("ten_kich_thuoc").trim().isEmpty()) {
                    list.add(rs.getString("ten_kich_thuoc"));
                }
            }
        } catch (SQLException ignored) {
        }
        return list;
    }

    @Override
    public List<String> findAllStyles() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_kieu_dang FROM kieu_dang ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_kieu_dang") != null && !rs.getString("ten_kieu_dang").trim().isEmpty()) {
                    list.add(rs.getString("ten_kieu_dang"));
                }
            }
        } catch (SQLException ignored) {
        }
        return list;
    }

    @Override
    public List<String> findAllOrigins() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT ten_xuat_xu FROM xuat_xu ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                if (rs.getString("ten_xuat_xu") != null && !rs.getString("ten_xuat_xu").trim().isEmpty()) {
                    list.add(rs.getString("ten_xuat_xu"));
                }
            }
        } catch (SQLException ignored) {
        }

        return list;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        try {
            p.setCode(rs.getString("san_pham_code"));
        } catch (SQLException ignored) {
        }
        try {
            p.setName(rs.getString("ten_san_pham"));
        } catch (SQLException ignored) {
        }
        try {
            p.setDescription(rs.getString("mo_ta"));
        } catch (SQLException ignored) {
        }
        try {
            p.setOrigin(rs.getString("ten_xuat_xu"));
        } catch (SQLException ignored) {
        }
        try {
            p.setCareInstructions(rs.getString("huong_dan_bao_quan"));
        } catch (SQLException ignored) {
        }
        try {
            p.setPrice(rs.getDouble("gia_ban"));
        } catch (SQLException ignored) {
        }
        try {
            p.setSold(rs.getInt("da_ban"));
        } catch (SQLException ignored) {
        }
        try {
            p.setStatus(rs.getInt("trang_thai"));
        } catch (SQLException ignored) {
        }
        try {
            p.setCategory(rs.getString("ten_danh_muc"));
        } catch (SQLException ignored) {
        }
        try {
            p.setBrand(rs.getString("ten_thuong_hieu"));
        } catch (SQLException ignored) {
        }
        return p;
    }

    private ProductDetail mapResultSetToProductDetail(ResultSet rs) throws SQLException {
        ProductDetail d = new ProductDetail();
        d.setId(rs.getInt("id"));
        try {
            d.setCode(rs.getString("chi_tiet_san_pham_code"));
        } catch (SQLException ignored) {
        }
        try {
            d.setImportPrice(rs.getDouble("gia_nhap"));
        } catch (SQLException ignored) {
        }
        try {
            d.setPrice(rs.getDouble("gia_ban"));
        } catch (SQLException ignored) {
        }
        try {
            d.setStock(rs.getInt("so_luong"));
        } catch (SQLException ignored) {
        }
        try {
            d.setWeight(rs.getDouble("trong_luong"));
        } catch (SQLException ignored) {
        }
        try {
            d.setLength(rs.getDouble("chieu_dai"));
        } catch (SQLException ignored) {
        }
        try {
            d.setWidth(rs.getDouble("chieu_rong"));
        } catch (SQLException ignored) {
        }
        try {
            d.setThickness(rs.getDouble("do_day"));
        } catch (SQLException ignored) {
        }
        try {
            d.setStatus(rs.getInt("trang_thai"));
        } catch (SQLException ignored) {
        }
        try {
            d.setSize(rs.getString("ten_kich_thuoc"));
        } catch (SQLException ignored) {
        }
        try {
            d.setColor(rs.getString("ten_mau"));
        } catch (SQLException ignored) {
        }
        try {
            d.setStyle(rs.getString("ten_kieu_dang"));
        } catch (SQLException ignored) {
        }
        return d;
    }

    private int findOrCreateOrigin(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM xuat_xu WHERE LOWER(LTRIM(RTRIM(ten_xuat_xu))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException ignored) {
        }
        String sqlIns = "INSERT INTO xuat_xu (xuat_xu_code, ten_xuat_xu, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "XX" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException ignored) {
        }
        return 0;
    }

    private int findOrCreateCategory(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM danh_muc WHERE LOWER(LTRIM(RTRIM(ten_danh_muc))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        String sqlIns = "INSERT INTO danh_muc (danh_muc_code, ten_danh_muc, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "DM" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    private int findOrCreateBrand(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM thuong_hieu WHERE LOWER(LTRIM(RTRIM(ten_thuong_hieu))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        String sqlIns = "INSERT INTO thuong_hieu (thuong_hieu_code, ten_thuong_hieu, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "TH" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    private int findOrCreateSize(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM kich_thuoc WHERE LOWER(LTRIM(RTRIM(ten_kich_thuoc))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        String sqlIns = "INSERT INTO kich_thuoc (kich_thuoc_code, ten_kich_thuoc, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "KT" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    private int findOrCreateColor(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM mau_sac WHERE LOWER(LTRIM(RTRIM(ten_mau))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        String sqlIns = "INSERT INTO mau_sac (mau_sac_code, ten_mau, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "MS" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    private int findOrCreateStyle(Connection conn, String name) throws SQLException {
        if (name == null || name.trim().isEmpty())
            return 0;
        String sqlSelect = "SELECT id FROM kieu_dang WHERE LOWER(LTRIM(RTRIM(ten_kieu_dang))) = LOWER(LTRIM(RTRIM(?)))";
        try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
            ps.setString(1, name.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        String sqlIns = "INSERT INTO kieu_dang (kieu_dang_code, ten_kieu_dang, trang_thai) VALUES (?, ?, N'Hoạt động')";
        try (PreparedStatement ps = conn.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "KD" + System.currentTimeMillis() % 100000);
            ps.setString(2, name.trim());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return 0;
    }

    private String getNextProductCode() {
        int max = 0;
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT san_pham_code FROM san_pham");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String ma = rs.getString("san_pham_code");
                if (ma != null && ma.startsWith("SP")) {
                    try {
                        int num = Integer.parseInt(ma.substring(2));
                        if (num > max)
                            max = num;
                    } catch (Exception ignored) {
                    }
                }
            }
        } catch (SQLException ignored) {
        }
        return "SP" + String.format("%03d", max + 1);
    }

    private void seedSampleProductsIfEmpty() {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null)
                return;
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM san_pham")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    System.out.println("🌱 Initializing sample product data into SQL Server FamiCoats DB...");

                    int dmAoKhoacDa = findOrCreateCategory(conn, "Áo khoác da");
                    int dmBomber = findOrCreateCategory(conn, "Áo bomber");
                    int dmDenim = findOrCreateCategory(conn, "Áo denim");

                    int thFamiCoats = findOrCreateBrand(conn, "FamiCoats");
                    int thZara = findOrCreateBrand(conn, "Zara");
                    int thLevis = findOrCreateBrand(conn, "Levi's");

                    int ktM = findOrCreateSize(conn, "M");
                    int ktL = findOrCreateSize(conn, "L");
                    int ktXL = findOrCreateSize(conn, "XL");

                    int msDen = findOrCreateColor(conn, "Đen");
                    int msBe = findOrCreateColor(conn, "Be");
                    int msNavy = findOrCreateColor(conn, "Navy");

                    int kdSlim = findOrCreateStyle(conn, "Slim-fit");
                    int kdOversize = findOrCreateStyle(conn, "Oversize");
                    int kdVintage = findOrCreateStyle(conn, "Vintage");

                    // SP001
                    String sqlSP1 = "INSERT INTO san_pham (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, mo_ta, xuat_xu, huong_dan_bao_quan, gia_ban, da_ban, trang_thai) "
                            +
                            "VALUES ('SP001', N'Áo khoác da nam Premium', " + dmAoKhoacDa + ", " + thFamiCoats
                            + ", N'Áo khoác da nam chất liệu da cừu tự nhiên cao cấp, bề mặt da mềm mịn.', N'Việt Nam', N'Chỉ giặt khô, không giặt máy.', 1850000, 324, 'AVAILABLE')";
                    stmt.executeUpdate(sqlSP1, Statement.RETURN_GENERATED_KEYS);
                    int sp1Id = 1;
                    try (ResultSet keys = stmt.getGeneratedKeys()) {
                        if (keys.next())
                            sp1Id = keys.getInt(1);
                    }

                    String sqlCT1 = "INSERT INTO chi_tiet_san_pham (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES "
                            +
                            "('CT001', " + sp1Id + ", " + ktM + ", " + msDen + ", " + kdSlim
                            + ", 600000, 950000, 20, 0.8, 95, 48, 2.5, 'AVAILABLE'), " +
                            "('CT002', " + sp1Id + ", " + ktL + ", " + msBe + ", " + kdOversize
                            + ", 600000, 950000, 28, 0.85, 98, 50, 2.5, 'AVAILABLE')";
                    stmt.executeUpdate(sqlCT1);

                    // SP002
                    String sqlSP2 = "INSERT INTO san_pham (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, mo_ta, xuat_xu, huong_dan_bao_quan, gia_ban, da_ban, trang_thai) "
                            +
                            "VALUES ('SP002', N'Bomber jacket oversize unisex', " + dmBomber + ", " + thZara
                            + ", N'Áo bomber form rộng thời trang unisex thích hợp cho cả nam và nữ.', N'Nhập khẩu', N'Giặt máy chế độ nhẹ với nước ấm.', 1290000, 287, 'AVAILABLE')";
                    stmt.executeUpdate(sqlSP2, Statement.RETURN_GENERATED_KEYS);
                    int sp2Id = 2;
                    try (ResultSet keys = stmt.getGeneratedKeys()) {
                        if (keys.next())
                            sp2Id = keys.getInt(1);
                    }

                    String sqlCT2 = "INSERT INTO chi_tiet_san_pham (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES "
                            +
                            "('CT003', " + sp2Id + ", " + ktL + ", " + msNavy + ", " + kdOversize
                            + ", 500000, 799000, 18, 1.1, 75, 60, 5, 'AVAILABLE'), " +
                            "('CT004', " + sp2Id + ", " + ktXL + ", " + msDen + ", " + kdOversize
                            + ", 500000, 799000, 14, 1.2, 78, 62, 5, 'AVAILABLE')";
                    stmt.executeUpdate(sqlCT2);

                    // SP003
                    String sqlSP3 = "INSERT INTO san_pham (san_pham_code, ten_san_pham, id_danh_muc, id_thuong_hieu, mo_ta, xuat_xu, huong_dan_bao_quan, gia_ban, da_ban, trang_thai) "
                            +
                            "VALUES ('SP003', N'Áo denim wash nữ vintage', " + dmDenim + ", " + thLevis
                            + ", N'Áo khoác bò denim dáng lửng phong cách retro vintage cho nữ.', N'Việt Nam', N'Giặt riêng bằng tay hoặc máy chế độ thường.', 890000, 241, 'AVAILABLE')";
                    stmt.executeUpdate(sqlSP3, Statement.RETURN_GENERATED_KEYS);
                    int sp3Id = 3;
                    try (ResultSet keys = stmt.getGeneratedKeys()) {
                        if (keys.next())
                            sp3Id = keys.getInt(1);
                    }

                    String sqlCT3 = "INSERT INTO chi_tiet_san_pham (chi_tiet_san_pham_code, id_san_pham, id_kich_thuoc, id_mau_sac, id_kieu_dang, gia_nhap, gia_ban, so_luong, trong_luong, chieu_dai, chieu_rong, do_day, trang_thai) VALUES "
                            +
                            "('CT005', " + sp3Id + ", " + ktM + ", " + msDen + ", " + kdVintage
                            + ", 750000, 1200000, 10, 0.9, 100, 52, 1.8, 'AVAILABLE'), " +
                            "('CT006', " + sp3Id + ", " + ktL + ", " + msNavy + ", " + kdVintage
                            + ", 750000, 1200000, 5, 0.95, 103, 54, 1.8, 'AVAILABLE')";
                    stmt.executeUpdate(sqlCT3);
                }
            } catch (SQLException ignored) {
            }
        } catch (SQLException e) {
            System.err.println("Seed product DB error: " + e.getMessage());
        }
    }
}
