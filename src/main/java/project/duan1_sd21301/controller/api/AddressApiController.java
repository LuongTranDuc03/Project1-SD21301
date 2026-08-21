package project.duan1_sd21301.controller.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.util.DatabaseConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "AddressApiController", value = "/api/address/locations")
public class AddressApiController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        String type = request.getParameter("type"); // "provinces", "districts", "wards"
        String province = request.getParameter("province");
        String district = request.getParameter("district");

        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("provinces".equalsIgnoreCase(type)) {
                String sql = "SELECT DISTINCT tinh FROM dia_chi WHERE tinh IS NOT NULL ORDER BY tinh";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) json.append(",");
                        json.append("\"").append(escapeJson(rs.getString("tinh"))).append("\"");
                        first = false;
                    }
                }
            } else if ("districts".equalsIgnoreCase(type)) {
                String sql = "SELECT DISTINCT huyen FROM dia_chi WHERE tinh = ? AND huyen IS NOT NULL ORDER BY huyen";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, province);
                    try (ResultSet rs = ps.executeQuery()) {
                        boolean first = true;
                        while (rs.next()) {
                            if (!first) json.append(",");
                            json.append("\"").append(escapeJson(rs.getString("huyen"))).append("\"");
                            first = false;
                        }
                    }
                }
            } else if ("wards".equalsIgnoreCase(type)) {
                String sql = "SELECT DISTINCT xa FROM dia_chi WHERE tinh = ? AND huyen = ? AND xa IS NOT NULL ORDER BY xa";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, province);
                    ps.setString(2, district);
                    try (ResultSet rs = ps.executeQuery()) {
                        boolean first = true;
                        while (rs.next()) {
                            if (!first) json.append(",");
                            json.append("\"").append(escapeJson(rs.getString("xa"))).append("\"");
                            first = false;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi API địa chỉ: " + e.getMessage());
        }

        json.append("]");
        out.print(json.toString());
        out.flush();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"");
    }
}
