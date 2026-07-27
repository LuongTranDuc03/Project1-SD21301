package project.duan1_sd21301.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBConnection {
    public static void main(String[] args) {
        // Cấu hình thông tin kết nối Database
        String url = "jdbc:sqlserver://localhost:1433;databaseName=FamiCoats;encrypt=true;trustServerCertificate=true;";
        String user = "sa";
        String pass = "123456"; // Đổi lại mật khẩu sa của bạn nếu khác

        System.out.println("==================================================");
        System.out.println("Đang kiểm tra kết nối tới CSDL SQL Server: FamiCoats...");
        System.out.println("==================================================");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                if (conn != null && !conn.isClosed()) {
                    System.out.println("✅ KẾT NỐI THÀNH CÔNG TỚI DATABASE [FamiCoats]!");
                    
                    // Đọc thử bảng dia_chi để xác nhận
                    try (Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM dia_chi")) {
                        if (rs.next()) {
                            System.out.println("📊 Đã truy vấn thành công bảng 'dia_chi' (Hiện có " + rs.getInt("total") + " bản ghi).");
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("❌ KẾT NỐI THẤT BẠI: " + e.getMessage());
            System.err.println("👉 Gợi ý: Hãy kiểm tra lại tài khoản (sa) và mật khẩu SQL Server trong file này cho đúng với máy của bạn.");
        }
    }
}
