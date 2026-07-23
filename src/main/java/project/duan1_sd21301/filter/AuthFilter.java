package project.duan1_sd21301.filter;

import project.duan1_sd21301.model.huy.Employee;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getRequestURI();
        
        // Let user access static assets without login if they are within /admin/ (unlikely, but just in case)
        if (path.contains("/assets/") || path.contains("/css/") || path.contains("/js/") || path.contains("/images/")) {
            filterChain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("loggedInUser") != null);

        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- Role-Based Authorization ---
        Employee user = (Employee) session.getAttribute("loggedInUser");
        
        // Màn Quản lý nhân viên chỉ dành cho Admin hoặc Quản lý (Nhân viên tuyệt đối không được truy cập)
        String roleName = user.getRoleName();
        boolean isStaff = "Nhân viên".equalsIgnoreCase(roleName);
        boolean isAdminOrManager = !isStaff && (
            (user.getRole() != null && user.getRoleId() == 1) ||
            (roleName != null && (roleName.equalsIgnoreCase("Admin") || roleName.equalsIgnoreCase("Quản lý")))
        );
        
        if (path.contains("/admin/employees") && !isAdminOrManager) {
            // Không có quyền, chuyển về trang chủ (dashboard)
            session.setAttribute("toastMessage", "Tài khoản Nhân viên không có quyền truy cập vào Quản lý nhân viên!");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        // Chuyển tiếp request
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
