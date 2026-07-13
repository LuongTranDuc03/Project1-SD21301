package project.duan1_sd21301.repository;

import project.duan1_sd21301.model.Employee;
import project.duan1_sd21301.model.Role;
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
    public Employee findById(String id) {
        String sql = "SELECT nv.*, vt.ten_vai_tro FROM nhan_vien nv " +
                "LEFT JOIN vai_tro vt ON nv.id_vai_tro = vt.id " +
                "WHERE nv.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
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
    public boolean insert(Employee entity) {
        String sql = "INSERT INTO nhan_vien (id, id_vai_tro, ho_ten, email, mat_khau, so_dien_thoai, " +
                "ngay_sinh, gioi_tinh, cccd, luong, ngay_vao_lam, anh_dai_dien, trang_thai) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entity.getId());
            ps.setInt(2, entity.getRoleId());
            ps.setString(3, entity.getFullName());
            ps.setString(4, entity.getEmail());
            ps.setString(5, entity.getPassword());
            ps.setString(6, entity.getPhoneNumber());

            if (entity.getBirthday() != null) {
                ps.setDate(7, new java.sql.Date(entity.getBirthday().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }

            if (entity.getGender() != null) {
                ps.setBoolean(8, entity.getGender());
            } else {
                ps.setNull(8, Types.BIT);
            }

            ps.setString(9, entity.getCccd());
            ps.setDouble(10, entity.getSalary());

            if (entity.getHireDate() != null) {
                ps.setDate(11, new java.sql.Date(entity.getHireDate().getTime()));
            } else {
                ps.setDate(11, new java.sql.Date(System.currentTimeMillis()));
            }

            ps.setString(12, entity.getAvatar());
            ps.setInt(13, entity.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Employee entity) {
        String sql = "UPDATE nhan_vien SET id_vai_tro = ?, ho_ten = ?, email = ?, mat_khau = ?, " +
                "so_dien_thoai = ?, ngay_sinh = ?, gioi_tinh = ?, cccd = ?, luong = ?, " +
                "ngay_vao_lam = ?, anh_dai_dien = ?, trang_thai = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, entity.getRoleId());
            ps.setString(2, entity.getFullName());
            ps.setString(3, entity.getEmail());
            ps.setString(4, entity.getPassword());
            ps.setString(5, entity.getPhoneNumber());

            if (entity.getBirthday() != null) {
                ps.setDate(6, new java.sql.Date(entity.getBirthday().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            if (entity.getGender() != null) {
                ps.setBoolean(7, entity.getGender());
            } else {
                ps.setNull(7, Types.BIT);
            }

            ps.setString(8, entity.getCccd());
            ps.setDouble(9, entity.getSalary());

            if (entity.getHireDate() != null) {
                ps.setDate(10, new java.sql.Date(entity.getHireDate().getTime()));
            } else {
                ps.setNull(10, Types.DATE);
            }

            ps.setString(11, entity.getAvatar());
            ps.setInt(12, entity.getStatus());
            ps.setString(13, entity.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(String id) {
        String sql = "DELETE FROM nhan_vien WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setId(rs.getString("id"));
        emp.setRoleId(rs.getInt("id_vai_tro"));
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

        emp.setCccd(rs.getString("cccd"));
        emp.setSalary(rs.getDouble("luong"));
        emp.setHireDate(rs.getDate("ngay_vao_lam"));
        emp.setAvatar(rs.getString("anh_dai_dien"));
        emp.setStatus(rs.getInt("trang_thai"));

        // Helper field
        emp.setRoleName(rs.getString("ten_vai_tro"));

        return emp;
    }

}
