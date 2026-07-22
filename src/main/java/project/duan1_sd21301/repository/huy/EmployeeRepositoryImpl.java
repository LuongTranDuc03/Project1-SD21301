package project.duan1_sd21301.repository.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeRepositoryImpl implements EmployeeRepository {

    @Override
    public List<Employee> findAll() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM nhan_vien nv " +
                "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
                "ORDER BY nv.id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToEmployee(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Employee findById(Integer id) {
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM nhan_vien nv " +
                "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
                "WHERE nv.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
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

    @Override
    public Employee findByEmail(String email) {
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM nhan_vien nv " +
                "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
                "WHERE nv.email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
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
                        rs.getString("mo_ta"),
                        rs.getInt("trang_thai")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public String getNextCode() {
        String sql = "SELECT code FROM nhan_vien";
        int max = 0;
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String ma = rs.getString("code");
                if (ma != null && ma.startsWith("NV")) {
                    try {
                        int num = Integer.parseInt(ma.substring(2));
                        if (num > max) max = num;
                    } catch (Exception ignored) {}
                }
            }
        } catch (SQLException e) {
            // Fallback try ma_nhan_vien if code column fails
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT ma_nhan_vien FROM nhan_vien");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String ma = rs.getString("ma_nhan_vien");
                    if (ma != null && ma.startsWith("NV")) {
                        try {
                            int num = Integer.parseInt(ma.substring(2));
                            if (num > max) max = num;
                        } catch (Exception ignored) {}
                    }
                }
            } catch (SQLException ignored) {}
        }
        return "NV" + String.format("%03d", max + 1);
    }

    @Override
    public boolean isCodeExist(String code, Integer excludeId) {
        String sql = "SELECT 1 FROM nhan_vien WHERE code = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            if (excludeId != null) {
                ps.setInt(2, excludeId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            // Fallback for ma_nhan_vien column name
            String fallbackSql = "SELECT 1 FROM nhan_vien WHERE ma_nhan_vien = ?";
            if (excludeId != null) fallbackSql += " AND id != ?";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                ps.setString(1, code);
                if (excludeId != null) ps.setInt(2, excludeId);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            } catch (SQLException ignored) {}
        }
        return false;
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
    public boolean insert(Employee entity) {
        if (entity.getCode() == null || entity.getCode().isEmpty()) {
            entity.setCode(getNextCode());
        }

        // Bỏ qua nếu mã nhân viên đã tồn tại (check unique code)
        if (isCodeExist(entity.getCode())) {
            System.out.println("Mã nhân viên đã tồn tại, bỏ qua insert: " + entity.getCode());
            return false;
        }

        String sql = "INSERT INTO nhan_vien (code, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, " +
                "ngay_sinh, gioi_tinh, anh_dai_dien, cccd, trang_thai, dia_chi) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entity.getCode());
            ps.setInt(2, entity.getRoleId());
            ps.setString(3, entity.getFullName());
            ps.setString(4, entity.getEmail());
            ps.setString(5, entity.getPassword());
            ps.setString(6, entity.getPhoneNumber());

            if (entity.getBirthday() != null) {
                ps.setDate(7, new Date(entity.getBirthday().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }

            if (entity.getGender() != null) {
                ps.setBoolean(8, entity.getGender());
            } else {
                ps.setNull(8, Types.BIT);
            }

            ps.setString(9, entity.getAvatar());
            ps.setString(10, entity.getCccd());
            ps.setInt(11, entity.getStatus());
            ps.setString(12, entity.getAddress());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Employee entity) {
        String sql = "UPDATE nhan_vien SET id_vai_tro = ?, ho_ten = ?, email = ?, mat_khau = ?, " +
                "so_dien_thoai = ?, ngay_sinh = ?, gioi_tinh = ?, " +
                "anh_dai_dien = ?, cccd = ?, trang_thai = ?, dia_chi = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, entity.getRoleId());
            ps.setString(2, entity.getFullName());
            ps.setString(3, entity.getEmail());
            ps.setString(4, entity.getPassword());
            ps.setString(5, entity.getPhoneNumber());

            if (entity.getBirthday() != null) {
                ps.setDate(6, new Date(entity.getBirthday().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            if (entity.getGender() != null) {
                ps.setBoolean(7, entity.getGender());
            } else {
                ps.setNull(7, Types.BIT);
            }

            ps.setString(8, entity.getAvatar());
            ps.setString(9, entity.getCccd());
            ps.setInt(10, entity.getStatus());
            ps.setString(11, entity.getAddress());
            ps.setInt(12, entity.getId());

            return ps.executeUpdate() > 0;
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
            emp.setCode(rs.getString("code"));
        } catch (SQLException e) {
            try { emp.setCode(rs.getString("ma_nhan_vien")); } catch (SQLException ignored) {}
        }
        emp.setFullName(rs.getString("ho_ten"));
        emp.setEmail(rs.getString("email"));
        emp.setPassword(rs.getString("mat_khau"));
        emp.setPhoneNumber(rs.getString("so_dien_thoai"));
        emp.setBirthday(rs.getDate("ngay_sinh"));

        // Handle null boolean
        boolean genderVal = rs.getBoolean("gioi_tinh");
        if (rs.wasNull()) {
            emp.setGender(null);
        } else {
            emp.setGender(genderVal);
        }

        emp.setAvatar(rs.getString("anh_dai_dien"));
        emp.setCccd(rs.getString("cccd"));
        emp.setStatus(rs.getInt("trang_thai"));

        // Map địa chỉ tổng hợp (thử từng cột, bỏ qua nếu cột không tồn tại)
        try { emp.setAddress(rs.getString("dia_chi")); } catch (SQLException ignored) {}

        // Xây dựng Role object từ kết quả JOIN
        Role role = new Role();
        role.setId(rs.getInt("id_vai_tro"));
        try { role.setRoleName(rs.getString("ten_vai_tro")); } catch (SQLException ignored) {}
        emp.setRole(role);

        return emp;
    }

    @Override
    public Employee login(String email, String password) {
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM nhan_vien nv " +
                "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
                "WHERE nv.email = ? AND nv.mat_khau = ? AND nv.trang_thai = 1";

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
