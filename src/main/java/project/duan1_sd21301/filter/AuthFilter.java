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
        
        // 1 = Quản lý, 2 = Nhân viên
        boolean isStaff = (user.getRoleId() == 2);
        
        if (isStaff) {
            boolean isBlocked = false;
            
            // Block dashboard and employees
            if (path.contains("/admin/dashboard") || path.contains("/admin/employees")) {
                isBlocked = true;
            }
            // Block product and variant modifications
            else if (path.contains("/admin/products/create") || path.contains("/admin/products/edit") || path.contains("/admin/products/delete") || path.contains("/admin/products/toggle") || path.contains("/admin/products/status")) {
                isBlocked = true;
            }
            else if (path.contains("/admin/variants/create") || path.contains("/admin/variants/edit") || path.contains("/admin/variants/delete") || path.contains("/admin/variants/toggle") || path.contains("/admin/variants/status")) {
                isBlocked = true;
            }
            // Block settings/account management
            else if (path.contains("/admin/settings") || path.contains("/admin/accounts")) {
                isBlocked = true;
            }
            // Block coupons - nhân viên không có quyền xem module phiếu giảm giá
            else if (path.contains("/admin/coupons")) {
                isBlocked = true;
            }
            // Block customer edits
            else if (path.contains("/admin/customers/edit") || path.contains("/admin/customers/delete")) {
                isBlocked = true;
            }
            
            if (isBlocked) {
                session.setAttribute("toastMessage", "Tài khoản Nhân viên không có quyền truy cập chức năng này!");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/pos");
                return;
            }
        }

        // Chuyển tiếp request
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
