package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CouponController", value = "/admin/coupons")
public class CouponController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Quản lý phiếu giảm giá");
        request.getRequestDispatcher("/WEB-INF/views/admin/under-construction.jsp").forward(request, response);
    }
}
