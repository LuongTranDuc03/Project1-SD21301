package project.duan1_sd21301.controller.admin;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;


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

        // 1. Cố gắng tìm nhân viên trong DB
        Employee employee = employeeRepository.findByEmail(email);

        // 2. Nếu không tìm thấy trong DB, tự động tạo nhân viên ảo (Dev User) để đăng nhập được ngay
        if (employee == null) {
            employee = new Employee();
            employee.setId(1);
            employee.setCode("DEV001");
            employee.setEmail(email);
            employee.setFullName("Dev User (" + email + ")");
            project.duan1_sd21301.model.huy.Role devRole = new project.duan1_sd21301.model.huy.Role(1, "Quản lý", 1);
            employee.setRole(devRole);
        }

        // Set session
        HttpSession session = request.getSession();
        session.setAttribute("loggedInUser", employee);
        String roleName = (employee.getRole() != null && employee.getRole().getRoleName() != null)
                ? employee.getRole().getRoleName() : "Quản lý";
        session.setAttribute("currentUserRole", roleName);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
