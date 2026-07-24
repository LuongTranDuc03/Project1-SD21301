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
    out.println("Kiểm tra trạng thái đơn hàng trong DB...");
    try (Connection conn = DatabaseConnection.getConnection()) {
        try (PreparedStatement ps = conn.prepareStatement("SELECT id, trang_thai_don_hang FROM hoa_don")) {
            ResultSet rs = ps.executeQuery();
            int c0 = 0, c1 = 0, c2 = 0, c3 = 0, c4 = 0, cOther = 0;
            while(rs.next()) {
                int status = rs.getInt("trang_thai_don_hang");
                if (status == 0) c0++;
                else if (status == 1) c1++;
                else if (status == 2) c2++;
                else if (status == 3) c3++;
                else if (status == 4) c4++;
                else cOther++;
            }
            out.println("0 (Chờ xác nhận): " + c0);
            out.println("1 (Đã xác nhận): " + c1);
            out.println("2 (Hoàn thành): " + c2);
            out.println("3 (Đã hủy): " + c3);
            out.println("4 (Đã hoàn tiền): " + c4);
            out.println("Khác: " + cOther);
        }
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
    }
%>
    </pre>
</body>
</html>
