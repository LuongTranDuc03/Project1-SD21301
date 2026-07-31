package project.duan1_sd21301.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDB {
    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT chi_tiet_san_pham_code, so_luong FROM chi_tiet_san_pham WHERE chi_tiet_san_pham_code IN ('CTSP024', 'CTSP025')";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        System.out.println(rs.getString(1) + ": " + rs.getInt(2));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
