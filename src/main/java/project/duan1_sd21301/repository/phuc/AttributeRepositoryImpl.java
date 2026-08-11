package project.duan1_sd21301.repository.phuc;

import project.duan1_sd21301.dto.phuc.AttributeDTO;
import project.duan1_sd21301.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttributeRepositoryImpl implements AttributeRepository {

    private static class TableConfig {
        String tableName;
        String codeColumn;
        String nameColumn;

        TableConfig(String tableName, String codeColumn, String nameColumn) {
            this.tableName = tableName;
            this.codeColumn = codeColumn;
            this.nameColumn = nameColumn;
        }
    }

    private TableConfig getConfig(String type) {
        switch (type.toLowerCase()) {
            case "category": return new TableConfig("danh_muc", "danh_muc_code", "ten_danh_muc");
            case "brand": return new TableConfig("thuong_hieu", "thuong_hieu_code", "ten_thuong_hieu");
            case "origin": return new TableConfig("xuat_xu", "xuat_xu_code", "ten_xuat_xu");
            case "color": return new TableConfig("mau_sac", "mau_sac_code", "ten_mau");
            case "size": return new TableConfig("kich_thuoc", "kich_thuoc_code", "ten_kich_thuoc");
            case "style": return new TableConfig("kieu_dang", "kieu_dang_code", "ten_kieu_dang");
            default: throw new IllegalArgumentException("Unknown attribute type: " + type);
        }
    }

    @Override
    public List<AttributeDTO> findAll(String type) {
        TableConfig config = getConfig(type);
        List<AttributeDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM " + config.tableName + " ORDER BY id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AttributeDTO dto = new AttributeDTO();
                dto.setId(rs.getInt("id"));
                dto.setCode(rs.getString(config.codeColumn));
                dto.setName(rs.getString(config.nameColumn));
                dto.setStatus(rs.getInt("trang_thai"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<AttributeDTO> findAll(String type, int page, int size) {
        TableConfig config = getConfig(type);
        List<AttributeDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM " + config.tableName + " ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, page * size);
            ps.setInt(2, size);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttributeDTO dto = new AttributeDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setCode(rs.getString(config.codeColumn));
                    dto.setName(rs.getString(config.nameColumn));
                    dto.setStatus(rs.getInt("trang_thai"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public long countAll(String type) {
        TableConfig config = getConfig(type);
        String sql = "SELECT COUNT(*) FROM " + config.tableName;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public AttributeDTO findById(String type, int id) {
        TableConfig config = getConfig(type);
        String sql = "SELECT * FROM " + config.tableName + " WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AttributeDTO dto = new AttributeDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setCode(rs.getString(config.codeColumn));
                    dto.setName(rs.getString(config.nameColumn));
                    dto.setStatus(rs.getInt("trang_thai"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    return dto;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean insert(String type, AttributeDTO dto) {
        TableConfig config = getConfig(type);
        String sql = "INSERT INTO " + config.tableName + " (" + config.codeColumn + ", " + config.nameColumn + ", trang_thai) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dto.getCode());
            ps.setString(2, dto.getName());
            ps.setInt(3, dto.getStatus() != null ? dto.getStatus() : 1);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(String type, AttributeDTO dto) {
        TableConfig config = getConfig(type);
        String sql = "UPDATE " + config.tableName + " SET " + config.codeColumn + " = ?, " + config.nameColumn + " = ?, trang_thai = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, dto.getCode());
            ps.setString(2, dto.getName());
            ps.setInt(3, dto.getStatus() != null ? dto.getStatus() : 1);
            ps.setInt(4, dto.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public String generateNextCode(String type) {
        TableConfig config = getConfig(type);
        String sql = "SELECT TOP 1 " + config.codeColumn + " FROM " + config.tableName + " ORDER BY id DESC";
        String prefix = getPrefixForType(type);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastCode = rs.getString(config.codeColumn);
                if (lastCode != null && lastCode.startsWith(prefix)) {
                    try {
                        int num = Integer.parseInt(lastCode.substring(prefix.length()));
                        return prefix + String.format("%03d", num + 1);
                    } catch (NumberFormatException ignored) {}
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prefix + "001";
    }

    private String getPrefixForType(String type) {
        switch (type.toLowerCase()) {
            case "category": return "DM";
            case "brand": return "TH";
            case "origin": return "XX";
            case "color": return "MS";
            case "size": return "KT";
            case "style": return "KD";
            default: return "TT";
        }
    }
}
