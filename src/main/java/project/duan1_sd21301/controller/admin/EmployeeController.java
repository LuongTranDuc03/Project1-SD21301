package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Employee;
import project.duan1_sd21301.model.Role;
import project.duan1_sd21301.util.EmailUtil;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "EmployeeController", urlPatterns = {"/admin/employees", "/admin/profile", "/admin/change-password"})
public class EmployeeController extends HttpServlet {

    // HARDCODED MOCK DATA: Chạy giao diện không cần DB
    private static final List<Role> mockRoles = new ArrayList<>();
    private static final List<Employee> mockEmployees = new ArrayList<>();

    static {
        mockRoles.add(new Role(1, "Quản lý", "Quản lý", 1));
        mockRoles.add(new Role(2, "Nhân viên", "Nhân viên", 1));

        // Init Mock Employees (Figma UI)
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            mockEmployees.add(new Employee("NV001", 1, "Nguyễn Cảnh Quỳnh", "quynhnc@famicoats.vn", "123456", "0987654321", sdf.parse("1995-05-15"), true, "001095000001", 35000000.0, sdf.parse("2023-01-10"), "https://i.pravatar.cc/150?img=11", 1, "Hà Nội"));
            mockEmployees.add(new Employee("NV002", 2, "Trần Đình Long", "longtd@famicoats.vn", "123456", "0912345678", sdf.parse("1998-10-20"), true, "001098000002", 25000000.0, sdf.parse("2023-03-15"), "https://i.pravatar.cc/150?img=13", 1, "TP. Hồ Chí Minh"));
            mockEmployees.add(new Employee("NV003", 2, "Lê Thị Hương Giang", "gianglth@famicoats.vn", "123456", "0909090909", sdf.parse("2000-02-28"), false, "001100000003", 18000000.0, sdf.parse("2023-05-20"), "https://i.pravatar.cc/150?img=5", 1, "Đà Nẵng"));
            mockEmployees.add(new Employee("NV004", 2, "Vũ Phương Nga", "ngavp@famicoats.vn", "123456", "0933777888", sdf.parse("1997-07-01"), false, "001097000004", 16500000.0, sdf.parse("2023-07-01"), "https://i.pravatar.cc/150?img=9", 1, "Hải Phòng"));
            mockEmployees.add(new Employee("NV005", 2, "Nguyễn Mai Lan", "lannm@famicoats.vn", "123456", "0922111333", sdf.parse("1999-09-15"), false, "001099000005", 14000000.0, sdf.parse("2023-10-05"), "https://i.pravatar.cc/150?img=1", 1, "Hà Nội"));
            mockEmployees.add(new Employee("NV006", 1, "Đinh Bảo Trâm", "tramdb@famicoats.vn", "123456", "0988777666", sdf.parse("1990-11-22"), false, "001090000007", 22000000.0, sdf.parse("2022-12-01"), "https://i.pravatar.cc/150?img=19", 1, "TP. Hồ Chí Minh"));
            mockEmployees.add(new Employee("NV007", 2, "Hoàng Quốc Việt", "viethq@famicoats.vn", "123456", "0977112233", sdf.parse("1994-08-08"), true, "001094000008", 15000000.0, sdf.parse("2023-06-12"), "https://i.pravatar.cc/150?img=59", 1, "Đà Nẵng"));
            mockEmployees.add(new Employee("NV011", 2, "Lý Phương Dung", "dunglp@famicoats.vn", "123456", "0934999888", sdf.parse("1998-05-19"), false, "001098000011", 15000000.0, sdf.parse("2023-02-10"), "https://i.pravatar.cc/150?img=35", 1, "Cần Thơ"));
            mockEmployees.add(new Employee("NV012", 2, "Bùi Tấn Tài", "taibt@famicoats.vn", "123456", "0999888777", sdf.parse("1995-12-25"), true, "001095000012", 12000000.0, sdf.parse("2023-08-05"), "https://i.pravatar.cc/150?img=12", 1, "Nha Trang"));
            
            // Map RoleName
            for (Employee emp : mockEmployees) {
                emp.setRoleName(getRoleName(emp.getRoleId()));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String getRoleName(int roleId) {
        return mockRoles.stream().filter(r -> r.getId() == roleId).map(Role::getRoleName).findFirst().orElse("");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("/profile")) {
            showProfile(request, response);
            return;
        }
        if (uri.contains("/change-password")) {
            showChangePassword(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "delete": doDeleteEmployee(request, response); break;
            case "add": showForm(request, response); break;
            case "edit": showForm(request, response); break;
            case "view": showDetail(request, response); break;
            case "sendMailAll": sendMailAll(request, response); break;
            default: listEmployees(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();
        if (uri.contains("/profile")) {
            updateProfile(request, response);
            return;
        }
        if (uri.contains("/change-password")) {
            updatePassword(request, response);
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createEmployee(request, response);
        } else if ("update".equals(action)) {
            updateEmployee(request, response);
        } else if ("sendMail".equals(action)) {
            sendMailSingle(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long totalActive = mockEmployees.stream().filter(emp -> emp.getStatus() == 1).count();
        long totalInactive = mockEmployees.stream().filter(emp -> emp.getStatus() == 0).count();

        request.setAttribute("employees", mockEmployees);
        request.setAttribute("roles", mockRoles);
        request.setAttribute("totalActive", totalActive);
        request.setAttribute("totalInactive", totalInactive);
        request.setAttribute("totalAll", mockEmployees.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/employee-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Employee employee = mockEmployees.stream().filter(e -> e.getId().equals(id)).findFirst().orElse(null);
        
        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/admin/employee-detail.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id != null) {
            Employee employee = mockEmployees.stream().filter(e -> e.getId().equals(id)).findFirst().orElse(null);
            request.setAttribute("employee", employee);
            request.setAttribute("isEdit", true);
        } else {
            request.setAttribute("isEdit", false);
        }

        request.setAttribute("roles", mockRoles);
        request.getRequestDispatcher("/WEB-INF/views/admin/employee-form.jsp").forward(request, response);
    }

    private void createEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, true);
        
        boolean exists = mockEmployees.stream().anyMatch(e -> e.getId().equals(emp.getId()) || e.getEmail().equals(emp.getEmail()));
        
        if (!exists) {
            mockEmployees.add(0, emp); // Add to top
            request.getSession().setAttribute("successMsg", "Thêm nhân viên (Ảo) thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Trùng ID hoặc Email!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, false);
        
        for (int i = 0; i < mockEmployees.size(); i++) {
            if (mockEmployees.get(i).getId().equals(emp.getId())) {
                mockEmployees.set(i, emp);
                request.getSession().setAttribute("successMsg", "Cập nhật (Ảo) thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/employees");
                return;
            }
        }
        
        request.getSession().setAttribute("errorMsg", "Không tìm thấy nhân viên.");
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void doDeleteEmployee(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        
        for (Employee e : mockEmployees) {
            if (e.getId().equals(id)) {
                e.setStatus(0); // Soft delete
                request.getSession().setAttribute("successMsg", "Đã chuyển trạng thái nghỉ việc (Ảo)!");
                response.sendRedirect(request.getContextPath() + "/admin/employees");
                return;
            }
        }
        
        request.getSession().setAttribute("errorMsg", "Xóa thất bại!");
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }
    // Handles sending email to all active employees
    private void sendMailAll(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // SMTP config
        String host = "smtp.gmail.com";
        int port = 587;
        String username = "pdhuy190107@gmail.com";
        String password = "huy19010700";
        String from = "pdhuy190107@gmail.com";
        EmailUtil emailUtil = new EmailUtil(host, port, username, password, from);
        for (Employee emp : mockEmployees) {
            if (emp.getStatus() != 1) continue;
            String to = emp.getEmail();
            String subject = "Thông tin tài khoản FamiCoats";
            String html = "<p>Xin chào " + emp.getFullName() + ",</p>"
                    + "<p>Đây là thông tin đăng nhập hệ thống:</p>"
                    + "<ul><li>Email: " + emp.getEmail() + "</li>"
                    + "<li>Mật khẩu: " + emp.getPassword() + "</li></ul>"
                    + "<p>Vui lòng đăng nhập và đổi mật khẩu ngay.</p>"
                    + "<p>Trân trọng,<br/>Team FamiCoats</p>";
            try {
                emailUtil.sendHtmlMail(to, subject, html);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        request.getSession().setAttribute("successMsg", "Gửi mail thành công tới các nhân viên hoạt động.");
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    // Handles sending login credentials (email + password) to a specific employee
    private void sendMailSingle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String employeeId = request.getParameter("employeeId");

        Employee emp = mockEmployees.stream()
                .filter(e -> e.getId().equals(employeeId))
                .findFirst().orElse(null);

        if (emp == null) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy nhân viên!");
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        // SMTP config
        String host     = "smtp.gmail.com";
        int port        = 587;
        String username = "pdhuy190107@gmail.com";
        String password = "huy19010700";
        String from     = "pdhuy190107@gmail.com";
        EmailUtil emailUtil = new EmailUtil(host, port, username, password, from);

        String subject = "Thông tin đăng nhập hệ thống FamiCoats";
        String html = "<!DOCTYPE html><html><body style='font-family:Inter,sans-serif;background:#f8fafc;margin:0;padding:20px;'>"
                + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);'>"
                + "<div style='background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:28px 32px;color:#fff;'>"
                + "<h2 style='margin:0;font-size:20px;'>🔑 Thông tin đăng nhập</h2>"
                + "<p style='margin:6px 0 0;opacity:0.85;font-size:13px;'>Hệ thống quản lý FamiCoats</p>"
                + "</div>"
                + "<div style='padding:28px 32px;'>"
                + "<p style='margin:0 0 16px;color:#374151;'>Xin chào <strong>" + emp.getFullName() + "</strong>,</p>"
                + "<p style='margin:0 0 20px;color:#6b7280;font-size:14px;'>Dưới đây là thông tin đăng nhập hệ thống của bạn:</p>"
                + "<div style='background:#f3f4f6;border-radius:10px;padding:16px 20px;border-left:4px solid #6366f1;'>"
                + "<table style='border-collapse:collapse;width:100%;font-size:14px;'>"
                + "<tr><td style='padding:6px 0;color:#6b7280;width:100px;'>📧 Email</td>"
                + "<td style='padding:6px 0;font-weight:600;color:#1f2937;'>" + emp.getEmail() + "</td></tr>"
                + "<tr><td style='padding:6px 0;color:#6b7280;'>🔑 Mật khẩu</td>"
                + "<td style='padding:6px 0;font-weight:700;color:#dc2626;font-family:monospace;font-size:15px;'>" + emp.getPassword() + "</td></tr>"
                + "</table></div>"
                + "<p style='margin:20px 0 0;font-size:13px;color:#9ca3af;'>⚠ Vui lòng đăng nhập và <strong style='color:#374151;'>đổi mật khẩu ngay</strong> để bảo mật tài khoản.</p>"
                + "</div>"
                + "<div style='padding:16px 32px;background:#f8fafc;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;'>Trân trọng, <strong>Team FamiCoats</strong></div>"
                + "</div></body></html>";

        try {
            emailUtil.sendHtmlMail(emp.getEmail(), subject, html);
            request.getSession().setAttribute("successMsg",
                    "✓ Đã gửi thông tin đăng nhập tới " + emp.getFullName() + " (" + emp.getEmail() + ")!");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMsg",
                    "Gửi mail thất bại: " + ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private Employee buildEmployeeFromRequest(HttpServletRequest req, boolean isNew) {
        Employee emp = new Employee();
        String id = req.getParameter("id");
        emp.setId(id);
        emp.setFullName(req.getParameter("fullName"));
        emp.setEmail(req.getParameter("email"));
        emp.setPhoneNumber(req.getParameter("phoneNumber"));
        emp.setCccd(req.getParameter("cccd"));
        emp.setAddress(req.getParameter("address"));
        
        String roleIdStr = req.getParameter("roleId");
        int roleId = roleIdStr != null && !roleIdStr.isEmpty() ? Integer.parseInt(roleIdStr) : 0;
        emp.setRoleId(roleId);
        emp.setRoleName(getRoleName(roleId));
        
        String salaryStr = req.getParameter("salary");
        if (salaryStr != null && !salaryStr.isEmpty()) {
            emp.setSalary(Double.parseDouble(salaryStr.replace(",", "").replace(".", "")));
        } else {
            emp.setSalary(0.0);
        }
        
        String pwd = req.getParameter("password");
        if (isNew) {
            emp.setPassword(pwd != null && !pwd.isEmpty() ? pwd : "123456");
        } else {
            if (pwd == null || pwd.trim().isEmpty()) {
                Employee oldEmp = mockEmployees.stream().filter(e -> e.getId().equals(id)).findFirst().orElse(null);
                emp.setPassword(oldEmp != null ? oldEmp.getPassword() : "");
            } else {
                emp.setPassword(pwd);
            }
        }
        
        String dobStr = req.getParameter("birthday");
        if (dobStr != null && !dobStr.isEmpty()) emp.setBirthday(parseDate(dobStr));
        
        String hireStr = req.getParameter("hireDate");
        if (hireStr != null && !hireStr.isEmpty()) emp.setHireDate(parseDate(hireStr));
        
        String genderStr = req.getParameter("gender");
        if (genderStr != null && !genderStr.isEmpty()) emp.setGender("1".equals(genderStr));
        
        String statusStr = req.getParameter("status");
        emp.setStatus(statusStr != null && !statusStr.isEmpty() ? Integer.parseInt(statusStr) : 1);
        
        emp.setAvatar(req.getParameter("avatar"));
        
        return emp;
    }

    private Date parseDate(String dateStr) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentUserId = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserId == null) currentUserId = "NV001";

        final String finalId = currentUserId;
        Employee employee = mockEmployees.stream().filter(e -> e.getId().equals(finalId)).findFirst().orElse(null);

        if (employee == null && "NV001".equals(currentUserId)) {
            employee = new Employee("NV001", 1, "Admin User", "jacketzone@admin.vn", "123456", "0987654321", new Date(), true, "001095000001", 35000000.0, new Date(), "", 1, "Hà Nội");
            employee.setRoleName("Admin");
        }

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentUserId = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserId == null) currentUserId = "NV001";

        final String finalId = currentUserId;
        Employee employee = mockEmployees.stream().filter(e -> e.getId().equals(finalId)).findFirst().orElse(null);

        if (employee != null) {
            employee.setPhoneNumber(request.getParameter("phoneNumber"));
            employee.setAddress(request.getParameter("address"));
            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.trim().isEmpty()) {
                employee.setAvatar(avatar);
            }
            request.getSession().setAttribute("currentUserName", employee.getFullName());
            request.getSession().setAttribute("currentUserEmail", employee.getEmail());
            request.getSession().setAttribute("successMsg", "Cập nhật thông tin cá nhân thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy thông tin nhân viên!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }

    private void showChangePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/change-password.jsp").forward(request, response);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentUserId = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserId == null) currentUserId = "NV001";

        final String finalId = currentUserId;
        Employee employee = mockEmployees.stream().filter(e -> e.getId().equals(finalId)).findFirst().orElse(null);

        String currentPwd = request.getParameter("currentPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        if (employee == null) {
            request.getSession().setAttribute("errorMsg", "Không tìm thấy thông tin nhân viên!");
        } else if (!employee.getPassword().equals(currentPwd)) {
            request.getSession().setAttribute("errorMsg", "Mật khẩu hiện tại không chính xác!");
        } else if (!newPwd.equals(confirmPwd)) {
            request.getSession().setAttribute("errorMsg", "Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
        } else {
            employee.setPassword(newPwd);
            request.getSession().setAttribute("successMsg", "Đổi mật khẩu thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/change-password");
    }
    // Duplicate sendMailAll method removed
}