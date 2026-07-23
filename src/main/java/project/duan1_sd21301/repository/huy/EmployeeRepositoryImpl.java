package project.duan1_sd21301.repository.huy;

import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeRepositoryImpl implements EmployeeRepository {

    private static final String SELECT_BASE = 
            "SELECT nv.*, vt.ten_vai_tro, dc.dia_chi_code, dc.tinh, dc.huyen, dc.xa, dc.dia_chi_chi_tiet " +
            "FROM nhan_vien nv " +
            "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
            "LEFT JOIN dia_chi dc ON nv.id_dia_chi = dc.id ";

    @Override
    public List<Employee> findAll() {
        List<Employee> list = new ArrayList<>();
        String sql = SELECT_BASE + "ORDER BY nv.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException e) {
            System.err.println("❌ EmployeeRepositoryImpl.findAll Error: " + e.getMessage());
            // Fallback query without JOIN if vai_tro or dia_chi table missing
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM nhan_vien ORDER BY id DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToEmployee(rs));
                }
            } catch (SQLException ex) {
                System.err.println("❌ Fallback SELECT * FROM nhan_vien Error: " + ex.getMessage());
            }
        }
        return list;
    }

    @Override
    public Employee findById(Integer id) {
        String sql = SELECT_BASE + "WHERE nv.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (SQLException e) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM nhan_vien WHERE id = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToEmployee(rs);
                    }
                }
            } catch (SQLException ignored) {}
        }
        return null;
    }

    @Override
    public Employee findByEmail(String email) {
        if (email == null) return null;

        String sql = SELECT_BASE + "WHERE LOWER(LTRIM(RTRIM(nv.email))) = LOWER(LTRIM(RTRIM(?)))";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (SQLException e) {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM nhan_vien WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(LTRIM(RTRIM(?)))")) {
                ps.setString(1, email.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapResultSetToEmployee(rs);
                    }
                }
            } catch (SQLException ignored) {}
        }
        return null;
    }

    @Override
    public List<Role> findAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM vai_tro WHERE trang_thai = 1 ORDER BY id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Role(
                        rs.getInt("id"),
                        rs.getString("ten_vai_tro"),
                        rs.getInt("trang_thai")));
            }
        } catch (SQLException e) {
            System.err.println("❌ EmployeeRepositoryImpl.findAllRoles Error: " + e.getMessage());
        }
        return list;
    }

    @Override
    public String getNextCode() {
        int max = 0;
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT nhan_vien_code FROM nhan_vien");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String ma = rs.getString("nhan_vien_code");
                if (ma != null && ma.startsWith("NV")) {
                    try {
                        int num = Integer.parseInt(ma.substring(2));
                        if (num > max)
                            max = num;
                    } catch (Exception ignored) {
                    }
                }
            }
        } catch (SQLException e) {
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement("SELECT code FROM nhan_vien");
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ma = rs.getString("code");
                    if (ma != null && ma.startsWith("NV")) {
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
        }
        return "NV" + String.format("%03d", max + 1);
    }

    @Override
    public boolean isCodeExist(String code, Integer excludeId) {
        String sql = "SELECT 1 FROM nhan_vien WHERE (nhan_vien_code = ? OR code = ?)";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, code);
            if (excludeId != null) {
                ps.setInt(3, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean isCodeExist(String code) {
        return isCodeExist(code, null);
    }

    @Override
    public boolean isEmailExist(String email, Integer excludeId) {
        String sql = "SELECT 1 FROM nhan_vien WHERE email = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isPhoneExist(String phone, Integer excludeId) {
        String sql = "SELECT 1 FROM nhan_vien WHERE so_dien_thoai = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean isCccdExist(String cccd, Integer excludeId) {
        if (cccd == null || cccd.trim().isEmpty()) return false;
        String sql = "SELECT 1 FROM nhan_vien WHERE cccd = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cccd.trim());
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    private int saveOrUpdateAddress(Connection conn, Address address) {
        if (address == null) return 0;
        String formatted = address.getFormattedAddress();
        if (formatted == null || formatted.trim().isEmpty()) return 0;

        if (address.getId() > 0) {
            String sql = "UPDATE dia_chi SET tinh = ?, huyen = ?, xa = ?, dia_chi_chi_tiet = ? WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, address.getProvince());
                ps.setString(2, address.getDistrict());
                ps.setString(3, address.getWard());
                ps.setString(4, address.getDetailedAddress());
                ps.setInt(5, address.getId());
                ps.executeUpdate();
                return address.getId();
            } catch (SQLException e) {
                System.err.println("Update dia_chi table error: " + e.getMessage());
                return address.getId();
            }
        } else {
            String code = address.getCode();
            if (code == null || code.trim().isEmpty()) {
                code = "DC" + System.currentTimeMillis() % 1000000;
            }
            String sql = "INSERT INTO dia_chi (dia_chi_code, tinh, huyen, xa, dia_chi_chi_tiet) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, code);
                ps.setString(2, address.getProvince());
                ps.setString(3, address.getDistrict());
                ps.setString(4, address.getWard());
                ps.setString(5, address.getDetailedAddress());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        address.setId(newId);
                        return newId;
                    }
                }
            } catch (SQLException e) {
                System.err.println("Insert dia_chi table error: " + e.getMessage());
            }
        }
        return 0;
    }

    @Override
    public boolean insert(Employee entity) {
        if (entity.getCode() == null || entity.getCode().isEmpty()) {
            entity.setCode(getNextCode());
        }

        if (isCodeExist(entity.getCode())) {
            System.out.println("Mã nhân viên đã tồn tại, bỏ qua insert: " + entity.getCode());
            return false;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) return false;
            int addressId = saveOrUpdateAddress(conn, entity.getAddress());

            String sql = "INSERT INTO nhan_vien (nhan_vien_code, id_vai_tro, id_dia_chi, ten_nhan_vien, cccd, email, mat_khau, so_dien_thoai, " +
                    "ngay_sinh, gioi_tinh, anh_dai_dien, trang_thai) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, entity.getCode());
                ps.setInt(2, entity.getRoleId());
                if (addressId > 0) {
                    ps.setInt(3, addressId);
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setString(4, entity.getFullName());
                ps.setString(5, entity.getCccd());
                ps.setString(6, entity.getEmail());
                ps.setString(7, entity.getPassword());
                ps.setString(8, entity.getPhoneNumber());

                if (entity.getBirthday() != null) {
                    ps.setDate(9, new Date(entity.getBirthday().getTime()));
                } else {
                    ps.setNull(9, Types.DATE);
                }

                if (entity.getGender() != null) {
                    ps.setBoolean(10, entity.getGender());
                } else {
                    ps.setNull(10, Types.BIT);
                }

                ps.setString(11, entity.getAvatar());
                ps.setInt(12, entity.getStatus());

                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                String fallbackSql = "INSERT INTO nhan_vien (code, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, " +
                        "ngay_sinh, gioi_tinh, anh_dai_dien, cccd, trang_thai, id_dia_chi) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                    ps.setString(1, entity.getCode());
                    ps.setInt(2, entity.getRoleId());
                    ps.setString(3, entity.getFullName());
                    ps.setString(4, entity.getEmail());
                    ps.setString(5, entity.getPassword());
                    ps.setString(6, entity.getPhoneNumber());
                    if (entity.getBirthday() != null) ps.setDate(7, new Date(entity.getBirthday().getTime())); else ps.setNull(7, Types.DATE);
                    if (entity.getGender() != null) ps.setBoolean(8, entity.getGender()); else ps.setNull(8, Types.BIT);
                    ps.setString(9, entity.getAvatar());
                    ps.setString(10, entity.getCccd());
                    ps.setInt(11, entity.getStatus());
                    if (addressId > 0) ps.setInt(12, addressId); else ps.setNull(12, Types.INTEGER);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Employee entity) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) return false;
            int addressId = saveOrUpdateAddress(conn, entity.getAddress());

            String sql = "UPDATE nhan_vien SET nhan_vien_code = ?, id_vai_tro = ?, id_dia_chi = ?, ten_nhan_vien = ?, " +
                    "cccd = ?, email = ?, mat_khau = ?, so_dien_thoai = ?, ngay_sinh = ?, gioi_tinh = ?, " +
                    "anh_dai_dien = ?, trang_thai = ? WHERE id = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, entity.getCode());
                ps.setInt(2, entity.getRoleId());
                if (addressId > 0) {
                    ps.setInt(3, addressId);
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setString(4, entity.getFullName());
                ps.setString(5, entity.getCccd());
                ps.setString(6, entity.getEmail());
                ps.setString(7, entity.getPassword());
                ps.setString(8, entity.getPhoneNumber());

                if (entity.getBirthday() != null) {
                    ps.setDate(9, new Date(entity.getBirthday().getTime()));
                } else {
                    ps.setNull(9, Types.DATE);
                }

                if (entity.getGender() != null) {
                    ps.setBoolean(10, entity.getGender());
                } else {
                    ps.setNull(10, Types.BIT);
                }

                ps.setString(11, entity.getAvatar());
                ps.setInt(12, entity.getStatus());
                ps.setInt(13, entity.getId());

                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                String fallbackSql = "UPDATE nhan_vien SET code = ?, id_vai_tro = ?, ho_ten = ?, email = ?, mat_khau = ?, " +
                        "so_dien_thoai = ?, ngay_sinh = ?, gioi_tinh = ?, " +
                        "anh_dai_dien = ?, cccd = ?, trang_thai = ?, id_dia_chi = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                    ps.setString(1, entity.getCode());
                    ps.setInt(2, entity.getRoleId());
                    ps.setString(3, entity.getFullName());
                    ps.setString(4, entity.getEmail());
                    ps.setString(5, entity.getPassword());
                    ps.setString(6, entity.getPhoneNumber());
                    if (entity.getBirthday() != null) ps.setDate(7, new Date(entity.getBirthday().getTime())); else ps.setNull(7, Types.DATE);
                    if (entity.getGender() != null) ps.setBoolean(8, entity.getGender()); else ps.setNull(8, Types.BIT);
                    ps.setString(9, entity.getAvatar());
                    ps.setString(10, entity.getCccd());
                    ps.setInt(11, entity.getStatus());
                    if (addressId > 0) ps.setInt(12, addressId); else ps.setNull(12, Types.INTEGER);
                    ps.setInt(13, entity.getId());
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(Integer id) {
        String sql = "DELETE FROM nhan_vien WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setId(rs.getInt("id"));
        
        try {
            emp.setCode(rs.getString("nhan_vien_code"));
        } catch (SQLException e) {
            try { emp.setCode(rs.getString("code")); } catch (SQLException ignored) {}
        }

        try {
            emp.setFullName(rs.getString("ten_nhan_vien"));
        } catch (SQLException e) {
            try { emp.setFullName(rs.getString("ho_ten")); } catch (SQLException ignored) {}
        }

        emp.setEmail(rs.getString("email"));
        emp.setPassword(rs.getString("mat_khau"));
        emp.setPhoneNumber(rs.getString("so_dien_thoai"));
        emp.setBirthday(rs.getDate("ngay_sinh"));

        boolean genderVal = rs.getBoolean("gioi_tinh");
        if (rs.wasNull()) {
            emp.setGender(null);
        } else {
            emp.setGender(genderVal);
        }

        emp.setAvatar(rs.getString("anh_dai_dien"));
        emp.setCccd(rs.getString("cccd"));
        emp.setStatus(rs.getInt("trang_thai"));

        Address addr = null;
        try {
            int idDiaChi = rs.getInt("id_dia_chi");
            if (!rs.wasNull() && idDiaChi > 0) {
                addr = new Address();
                addr.setId(idDiaChi);
                try { addr.setCode(rs.getString("dia_chi_code")); } catch (SQLException ignored) {}
                try { addr.setProvince(rs.getString("tinh")); } catch (SQLException ignored) {}
                try { addr.setDistrict(rs.getString("huyen")); } catch (SQLException ignored) {}
                try { addr.setWard(rs.getString("xa")); } catch (SQLException ignored) {}
                try { addr.setDetailedAddress(rs.getString("dia_chi_chi_tiet")); } catch (SQLException ignored) {}
            }
        } catch (SQLException ignored) {}
        emp.setAddress(addr);

        Role role = new Role();
        int roleId = rs.getInt("id_vai_tro");
        role.setId(roleId);
        try {
            String roleName = rs.getString("ten_vai_tro");
            if (roleName != null && !roleName.trim().isEmpty()) {
                role.setRoleName(roleName.trim());
            }
        } catch (SQLException ignored) {
        }
        if (role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            if (roleId == 1) role.setRoleName("Quản lý");
            else role.setRoleName("Nhân viên");
        }
        emp.setRole(role);

        return emp;
    }

    @Override
    public Employee login(String email, String password) {
        String sql = SELECT_BASE + "WHERE nv.email = ? AND nv.mat_khau = ? AND nv.trang_thai = 1";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
