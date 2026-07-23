package project.duan1_sd21301.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    // Cấu hình thông tin kết nối Database
    private static final String DRIVER_CLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=FamiCoats;encrypt=true;trustServerCertificate=true;loginTimeout=5;";
    private static final String USER = "sa";
    private static final String PASS = "123";

    static {
        try {
            Class.forName(DRIVER_CLASS);
            DriverManager.setLoginTimeout(5);
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
