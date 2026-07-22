package project.duan1_sd21301.repository.ha;

import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerRepositoryImpl implements CustomerRepository {

    @Override
    public List<Customer> findAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT id, khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai FROM khach_hang ORDER BY id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer c = mapResultSetToCustomer(rs);
                c.setAddresses(findAddressesByCustomerId(c.getId(), conn));
                list.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đọc danh sách Khách hàng từ Database: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Customer findById(int id) {
        String sql = "SELECT id, khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai FROM khach_hang WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = mapResultSetToCustomer(rs);
                    c.setAddresses(findAddressesByCustomerId(c.getId(), conn));
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm Khách hàng theo ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public Customer findByCode(String code) {
        String sql = "SELECT id, khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai FROM khach_hang WHERE khach_hang_code = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = mapResultSetToCustomer(rs);
                    c.setAddresses(findAddressesByCustomerId(c.getId(), conn));
                    return c;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm Khách hàng theo Code: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean add(Customer customer) {
        String sql = "INSERT INTO khach_hang (khach_hang_code, ho_ten, email, mat_khau, so_dien_thoai, ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getCode());
            ps.setString(2, customer.getFullName());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPassword());
            ps.setString(5, customer.getPhoneNumber());
            if (customer.getDateOfBirth() != null) {
                ps.setDate(6, new java.sql.Date(customer.getDateOfBirth().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            ps.setString(7, customer.getGender());
            ps.setString(8, customer.getAvatar());
            ps.setString(9, customer.getStatus() != null ? customer.getStatus() : "Hoạt động");
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int newCustomerId = keys.getInt(1);
                        customer.setId(newCustomerId);
                        // Thêm danh sách địa chỉ giao hàng vào SQL Server
                        if (customer.getAddresses() != null) {
                            for (CustomerAddress ca : customer.getAddresses()) {
                                saveAddressAndLinkToCustomer(newCustomerId, ca, conn);
                            }
                        }
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm Khách hàng vào CSDL: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean update(Customer customer) {
        String sql = "UPDATE khach_hang SET ho_ten=?, email=?, mat_khau=?, so_dien_thoai=?, ngay_sinh=?, gioi_tinh=?, anh_dai_dien=?, trang_thai=? WHERE khach_hang_code=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPassword());
            ps.setString(4, customer.getPhoneNumber());
            if (customer.getDateOfBirth() != null) {
                ps.setDate(5, new java.sql.Date(customer.getDateOfBirth().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            ps.setString(6, customer.getGender());
            ps.setString(7, customer.getAvatar());
            ps.setString(8, customer.getStatus());
            ps.setString(9, customer.getCode());

            boolean updated = ps.executeUpdate() > 0;
            if (updated && customer.getId() > 0 && customer.getAddresses() != null) {
                for (CustomerAddress ca : customer.getAddresses()) {
                    if (ca.getId() == 0) {
                        saveAddressAndLinkToCustomer(customer.getId(), ca, conn);
                    }
                }
            }
            return updated;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật Khách hàng: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM khach_hang WHERE id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa Khách hàng: " + e.getMessage());
        }
        return false;
    }

    public boolean saveAddressAndLinkToCustomer(int customerId, CustomerAddress ca, Connection conn) {
        if (ca == null) return false;
        try {
            int addressId = 0;
            if (ca.getAddress() != null) {
                Address a = ca.getAddress();
                if (a.getId() > 0) {
                    addressId = a.getId();
                } else {
                    String sqlAddr = "INSERT INTO dia_chi (dia_chi_code, tinh, huyen, xa, dia_chi_chi_tiet) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement psAddr = conn.prepareStatement(sqlAddr, Statement.RETURN_GENERATED_KEYS)) {
                        String code = a.getCode() != null ? a.getCode() : "DC" + System.currentTimeMillis();
                        psAddr.setString(1, code);
                        psAddr.setString(2, a.getProvince());
                        psAddr.setString(3, a.getDistrict());
                        psAddr.setString(4, a.getWard());
                        psAddr.setString(5, a.getDetailedAddress());
                        psAddr.executeUpdate();
                        try (ResultSet rsK = psAddr.getGeneratedKeys()) {
                            if (rsK.next()) addressId = rsK.getInt(1);
                        }
                    }
                }
            }

            if (addressId > 0) {
                String sqlLink = "INSERT INTO khach_hang_dia_chi (id_khach_hang, id_dia_chi, nguoi_nhan, so_dien_thoai, mac_dinh, ghi_chu) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psLink = conn.prepareStatement(sqlLink)) {
                    psLink.setInt(1, customerId);
                    psLink.setInt(2, addressId);
                    psLink.setString(3, ca.getRecipientName());
                    psLink.setString(4, ca.getPhoneNumber());
                    psLink.setBoolean(5, ca.isDefault());
                    psLink.setString(6, ca.getNote());
                    return psLink.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lưu và nối địa chỉ cho Khách hàng: " + e.getMessage());
        }
        return false;
    }

    private List<CustomerAddress> findAddressesByCustomerId(int customerId, Connection conn) {
        List<CustomerAddress> list = new ArrayList<>();
        String sql = "SELECT khd.id AS khd_id, khd.nguoi_nhan, khd.so_dien_thoai AS sdt_nhan, khd.mac_dinh, khd.ghi_chu, " +
                     "dc.id AS dc_id, dc.dia_chi_code, dc.tinh, dc.huyen, dc.xa, dc.dia_chi_chi_tiet " +
                     "FROM khach_hang_dia_chi khd " +
                     "JOIN dia_chi dc ON khd.id_dia_chi = dc.id " +
                     "WHERE khd.id_khach_hang = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address addr = Address.builder()
                            .id(rs.getInt("dc_id"))
                            .code(rs.getString("dia_chi_code"))
                            .province(rs.getString("tinh"))
                            .district(rs.getString("huyen"))
                            .ward(rs.getString("xa"))
                            .detailedAddress(rs.getString("dia_chi_chi_tiet"))
                            .build();

                    CustomerAddress ca = CustomerAddress.builder()
                            .id(rs.getInt("khd_id"))
                            .recipientName(rs.getString("nguoi_nhan"))
                            .phoneNumber(rs.getString("sdt_nhan"))
                            .isDefault(rs.getBoolean("mac_dinh"))
                            .note(rs.getString("ghi_chu"))
                            .address(addr)
                            .build();
                    list.add(ca);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đọc địa chỉ của Khách hàng: " + e.getMessage());
        }
        return list;
    }

    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        return Customer.builder()
                .id(rs.getInt("id"))
                .code(rs.getString("khach_hang_code"))
                .fullName(rs.getString("ho_ten"))
                .email(rs.getString("email"))
                .password(rs.getString("mat_khau"))
                .phoneNumber(rs.getString("so_dien_thoai"))
                .dateOfBirth(rs.getDate("ngay_sinh"))
                .gender(rs.getString("gioi_tinh"))
                .avatar(rs.getString("anh_dai_dien"))
                .status(rs.getString("trang_thai"))
                .build();
    }
}
