package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.service.HoaDonService;
import project.duan1_sd21301.service.impl.HoaDonServiceImpl;

import java.io.IOException;

/**
 * Servlet xử lý trang dashboard quản trị.
 * URL: GET /admin/dashboard
 */
@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private final HoaDonService hoaDonService = new HoaDonServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Thống kê tổng số đơn hàng theo từng trạng thái
        long tongDon       = hoaDonService.countHoaDons(null, null);
        long choXacNhan    = hoaDonService.countHoaDons(0, null);
        long daXacNhan     = hoaDonService.countHoaDons(1, null);
        long dangGiao      = hoaDonService.countHoaDons(2, null);
        long thanhCong     = hoaDonService.countHoaDons(3, null);
        long daHuy         = hoaDonService.countHoaDons(4, null);

        // Lấy 5 hóa đơn mới nhất (trang 0, size 5)
        req.setAttribute("recentOrders", hoaDonService.getHoaDons(null, null, 0, 5));

        req.setAttribute("tongDon", tongDon);
        req.setAttribute("choXacNhan", choXacNhan);
        req.setAttribute("daXacNhan", daXacNhan);
        req.setAttribute("dangGiao", dangGiao);
        req.setAttribute("thanhCong", thanhCong);
        req.setAttribute("daHuy", daHuy);
        req.setAttribute("pageTitle", "Dashboard");

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
