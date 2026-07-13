package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DashboardController", value = "/admin/dashboard")
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể bổ sung nạp dữ liệu thống kê từ Service ở đây
        // Ví dụ:
        // request.setAttribute("totalRevenue", "190,000,000đ");
        // request.setAttribute("totalOrders", 2401);
        
        // Điều hướng sang giao diện JSP nằm trong WEB-INF/views (bảo mật)
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
