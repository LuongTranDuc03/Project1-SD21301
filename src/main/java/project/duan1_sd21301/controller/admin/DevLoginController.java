package project.duan1_sd21301.controller.admin;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;
import project.duan1_sd21301.util.huy.EmployeeMockData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * DevLoginController - Tính năng đăng nhập ảo dành cho nhóm phát triển.
 * Bỏ qua mật khẩu, chỉ cần nhập email là đăng nhập được vào quyền Quản Lý.
 */
@WebServlet(name = "DevLoginController", value = "/login-dev")
public class DevLoginController extends HttpServlet {

    private EmployeeRepository employeeRepository;

    @Override
    public void init() throws ServletException {
        employeeRepository = new EmployeeRepositoryImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email để đăng nhập ảo.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Cố gắng tìm trong DB trước
        Employee employee = employeeRepository.findByEmail(email);

        // Nếu không có trong DB, tìm trong mock data
        if (employee == null) {
            for (Employee e : EmployeeMockData.loadAll()) {
                if (email.equalsIgnoreCase(e.getEmail())) {
                    employee = e;
                    break;
                }
            }
        }

        // Set session
        HttpSession session = request.getSession();
        session.setAttribute("loggedInUser", employee);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
