<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="project.duan1_sd21301.util.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>DB Test</title></head>
<body>
    <h1>Database Test</h1>
    <pre>
<%
    out.println("Starting test...");
    try (Connection conn = DatabaseConnection.getConnection()) {
        out.println("Connection successful!");
        conn.setAutoCommit(true);
        // Try a simple update on nhan_vien or khach_hang that will fail or succeed
        // E.g., updating a non-existent record to see if it throws an exception or just returns 0
        
        out.println("Testing UPDATE khach_hang (non-existent id)...");
        try (PreparedStatement ps = conn.prepareStatement("UPDATE khach_hang SET trang_thai = 1 WHERE id = -999")) {
            int rows = ps.executeUpdate();
            out.println("Rows updated: " + rows);
        } catch(SQLException ex) {
            out.println("UPDATE Exception: " + ex.getMessage());
            ex.printStackTrace(new PrintWriter(out));
        }

        out.println("\nTesting INSERT khach_hang...");
        String sql = "INSERT INTO khach_hang (khach_hang_code, ho_ten, email, so_dien_thoai, trang_thai) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "TEST_CODE_" + System.currentTimeMillis());
            ps.setString(2, "Test Name");
            ps.setString(3, "test@test.com");
            ps.setString(4, "0123456789");
            ps.setInt(5, 1);
            int rows = ps.executeUpdate();
            out.println("Rows inserted: " + rows);
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if(rs.next()) {
                    out.println("Generated ID: " + rs.getInt(1));
                }
            }
        } catch(SQLException ex) {
            out.println("INSERT Exception: " + ex.getMessage());
            ex.printStackTrace(new PrintWriter(out));
        }

    } catch (Exception e) {
        out.println("Connection Exception: " + e.getMessage());
        e.printStackTrace(new PrintWriter(out));
    }
%>
    </pre>
</body>
</html>
