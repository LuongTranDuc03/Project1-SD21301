package project.duan1_sd21301.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    // Cấu hình thông tin kết nối Database
    // Hướng dẫn: Đổi tên DB, Username và Password phù hợp với máy của bạn.
    
    // --- CẤU HÌNH SQL SERVER ---
    private static final String DRIVER_CLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=FamiCoatsDB;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123456";

    // --- CẤU HÌNH MYSQL (Bỏ comment nếu dùng MySQL) ---
    // private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
    // private static final String URL = "jdbc:mysql://localhost:3306/famicoats_db?useSSL=false&serverTimezone=UTC";
    // private static final String USER = "root";
    // private static final String PASS = "root";

    static {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy Driver kết nối Database: " + e.getMessage());
        }
    }

    /**
     * Lấy kết nối tới Database.
     * @return Connection đối tượng kết nối SQL
     * @throws SQLException nếu xảy ra lỗi kết nối
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Phương thức test nhanh kết nối Database.
     */
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Kết nối tới Database thành công!");
            }
        } catch (SQLException e) {
            System.err.println("Kết nối thất bại: " + e.getMessage());
        }
    }
}
