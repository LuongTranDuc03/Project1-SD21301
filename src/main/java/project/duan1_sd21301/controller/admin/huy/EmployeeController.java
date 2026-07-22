package project.duan1_sd21301.controller.admin.huy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.service.huy.EmployeeService;
import project.duan1_sd21301.service.huy.EmployeeServiceImpl;
import project.duan1_sd21301.util.EmailUtil;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "EmployeeController", urlPatterns = { "/admin/employees", "/admin/profile",
        "/admin/change-password" })
public class EmployeeController extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("/profile")) {
            showProfile(request, response);
            return;
        }
        if (uri.contains("/change-password")) {
            showChangePassword(request, response);
            return;
        }

        // Lấy tham số 'action' từ URL (vd: ?action=add, ?action=edit, ?action=delete)
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định nếu không truyền action thì hiển thị danh sách
        }

        switch (action) {
            case "list":
                listEmployees(request, response);
                break;
            case "add":
            case "edit":
                showForm(request, response);
                break;
            case "delete":
            case "toggleStatus":
                toggleEmployeeStatus(request, response);
                break;
            case "view":
            case "detail":
                showDetail(request, response);
                break;
            case "sendMailAll":
                sendMailAll(request, response);
                break;
            default:
                listEmployees(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // Lấy action từ form (vd: <input type="hidden" name="action" value="add">)
        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            toggleEmployeeStatus(request, response);
            return;
        }

        if ("create".equals(action)) {
            // Hàm xử lý lưu nhân viên mới
            createEmployee(request, response);
        } else if ("update".equals(action)) {
            // Hàm xử lý cập nhật nhân viên cũ
            updateEmployee(request, response);
        } else if ("sendMail".equals(action)) {
            sendMailSingle(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách nhân viên từ CSDL qua Service
        List<Employee> employees = employeeService.getAllEmployees();
        List<Role> roles = employeeService.getAllRoles();

        if (roles != null) {
            roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                    .collect(java.util.stream.Collectors.toList());
        }

        long totalActive = employees != null ? employees.stream().filter(emp -> emp.getStatus() == 1).count() : 0;
        long totalInactive = employees != null ? employees.stream().filter(emp -> emp.getStatus() == 0).count() : 0;

        request.setAttribute("employees", employees != null ? employees : new java.util.ArrayList<>());
        request.setAttribute("roles", roles != null ? roles : new java.util.ArrayList<>());
        request.setAttribute("totalActive", totalActive);
        request.setAttribute("totalInactive", totalInactive);
        request.setAttribute("totalAll", employees != null ? employees.size() : 0);

        String toastMessage = (String) request.getSession().getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", request.getSession().getAttribute("toastType"));
            request.getSession().removeAttribute("toastMessage");
            request.getSession().removeAttribute("toastType");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/huy/employee-list.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }
        int id = Integer.parseInt(idStr);
        Employee employee = employeeService.getEmployeeById(id);

        if (employee == null) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/admin/huy/employee-detail.jsp").forward(request, response);
    }

    private void forwardToForm(HttpServletRequest request, HttpServletResponse response, Employee employee,
            boolean isEdit) throws ServletException, IOException {
        request.setAttribute("employee", employee);
        request.setAttribute("isEdit", isEdit);
        List<Role> roles = employeeService.getAllRoles();
        if (roles != null) {
            roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                    .collect(java.util.stream.Collectors.toList());
        }
        request.setAttribute("roles", roles != null ? roles : new java.util.ArrayList<>());

        String toastMessage = (String) request.getSession().getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", request.getSession().getAttribute("toastType"));
            request.getSession().removeAttribute("toastMessage");
            request.getSession().removeAttribute("toastType");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/huy/employee-form.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Employee employee = null;
        boolean isEdit = false;
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            employee = employeeService.getEmployeeById(id);
            isEdit = true;
        }
        forwardToForm(request, response, employee, isEdit);
    }

    private void createEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, true);

        // Validate with EmployeeValidator
        java.util.Map<String, String> errors = EmployeeValidator.validate(emp);
        if (!errors.isEmpty()) {
            String firstError = errors.values().iterator().next();
            request.getSession().setAttribute("toastMessage", firstError);
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, false);
            return;
        }

        // Check Duplicates qua CSDL
        boolean success = employeeService.addEmployee(emp);

        if (success) {
            try {
                String host = "smtp.gmail.com";
                int port = 587;
                String username = "pdhuy190107@gmail.com";
                String password = "huy19010700";
                String from = "pdhuy190107@gmail.com";
                EmailUtil emailUtil = new EmailUtil(host, port, username, password, from);

                String subject = "Thong tin dang nhap he thong FamiCoats";
                String html = "<!DOCTYPE html><html><body style='font-family:Inter,sans-serif;background:#f8fafc;margin:0;padding:20px;'>"
                        + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);'>"
                        + "<div style='background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:28px 32px;color:#fff;'>"
                        + "<h2 style='margin:0;font-size:20px;'>🔑 Thong tin dang nhap</h2>"
                        + "<p style='margin:6px 0 0;opacity:0.85;font-size:13px;'>He thong quan ly FamiCoats</p>"
                        + "</div>"
                        + "<div style='padding:28px 32px;'>"
                        + "<p style='margin:0 0 16px;color:#374151;'>Xin chao <strong>" + emp.getFullName()
                        + "</strong>,</p>"
                        + "<p style='margin:0 0 20px;color:#6b7280;font-size:14px;'>Duoi day la thong tin dang nhap he thong cua ban:</p>"
                        + "<div style='background:#f3f4f6;border-radius:10px;padding:16px 20px;border-left:4px solid #6366f1;'>"
                        + "<table style='border-collapse:collapse;width:100%;font-size:14px;'>"
                        + "<tr><td style='padding:6px 0;color:#6b7280;width:100px;'>📧 Email</td>"
                        + "<td style='padding:6px 0;font-weight:600;color:#1f2937;'>" + emp.getEmail() + "</td></tr>"
                        + "<tr><td style='padding:6px 0;color:#6b7280;'>🔑 Mat khau</td>"
                        + "<td style='padding:6px 0;font-weight:700;color:#dc2626;font-family:monospace;font-size:15px;'>"
                        + emp.getPassword() + "</td></tr>"
                        + "</table></div>"
                        + "<p style='margin:20px 0 0;font-size:13px;color:#9ca3af;'> Vui long dang nhap va <strong style='color:#374151;'>doi mat khau ngay</strong> de bao mat tai khoan.</p>"
                        + "</div>"
                        + "<div style='padding:16px 32px;background:#f8fafc;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;'>Tran trong, <strong>Team FamiCoats</strong></div>"
                        + "</div></body></html>";
                emailUtil.sendHtmlMail(emp.getEmail(), subject, html);
                request.getSession().setAttribute("toastMessage",
                        "Thêm nhân viên thành công và đã tự động gửi email tài khoản!");
                request.getSession().setAttribute("toastType", "success");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("toastMessage", "Thêm nhân viên thành công nhưng lỗi gửi email!");
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage",
                    "Thêm nhân viên thất bại (Email đã tồn tại hoặc lỗi CSDL)!");
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, false);

        // Validate với EmployeeValidator
        java.util.Map<String, String> errors = EmployeeValidator.validate(emp);
        if (!errors.isEmpty()) {
            String firstError = errors.values().iterator().next();
            request.getSession().setAttribute("toastMessage", firstError);
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, true);
            return;
        }

        boolean success = employeeService.updateEmployee(emp);
        if (success) {
            request.getSession().setAttribute("toastMessage", "Cập nhật thành công!");
            request.getSession().setAttribute("toastType", "success");
        } else {
            request.getSession().setAttribute("toastMessage", "Không tìm thấy nhân viên hoặc cập nhật thất bại.");
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void toggleEmployeeStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }
        int id = Integer.parseInt(idStr);
        String statusStr = request.getParameter("status");

        Employee employee = employeeService.getEmployeeById(id);

        if (employee != null) {
            int newStatus;
            if (statusStr != null && !statusStr.isEmpty()) {
                newStatus = Integer.parseInt(statusStr);
            } else {
                newStatus = employee.getStatus() == 1 ? 0 : 1;
            }

            employee.setStatus(newStatus);
            boolean success = employeeService.updateEmployee(employee);

            String msg = success
                    ? (newStatus == 1 ? "Da kich hoat tai khoan nhan vien!" : "Da chuyen trang thai nghi viec!")
                    : "Cap nhat trang thai that bai!";

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (success) {
                    response.getWriter().write("{\"success\":true, \"message\":\"" + msg + "\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\":false, \"message\":\"" + msg + "\"}");
                }
                return;
            }

            if (success) {
                request.getSession().setAttribute("toastMessage", msg);
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", msg);
                request.getSession().setAttribute("toastType", "error");
            }
        } else {
            request.getSession().setAttribute("toastMessage", "Không tìm thấy nhân viên!");
            request.getSession().setAttribute("toastType", "error");
        }

        String redirect = request.getParameter("redirect");
        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/admin/employees?action=view&id=" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
        }
    }

    private void sendMailAll(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String host = "smtp.gmail.com";
        int port = 587;
        String username = "pdhuy190107@gmail.com";
        String password = "huy19010700";
        String from = "pdhuy190107@gmail.com";
        EmailUtil emailUtil = new EmailUtil(host, port, username, password, from);

        List<Employee> employees = employeeService.getAllEmployees();
        if (employees != null) {
            for (Employee emp : employees) {
                if (emp.getStatus() != 1)
                    continue;
                String to = emp.getEmail();
                String subject = "Thong tin tai khoan FamiCoats";
                String html = "<p>Xin chao " + emp.getFullName() + ",</p>"
                        + "<p>Day la thong tin dang nhap he thong:</p>"
                        + "<ul><li>Email: " + emp.getEmail() + "</li>"
                        + "<li>Mat khau: " + emp.getPassword() + "</li></ul>"
                        + "<p>Vui long dang nhap va doi mat khau ngay.</p>"
                        + "<p>Tran trong,<br/>Team FamiCoats</p>";
                try {
                    emailUtil.sendHtmlMail(to, subject, html);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        request.getSession().setAttribute("successMsg", "Gui mail thanh cong toi cac nhan vien hoat dong.");
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void sendMailSingle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String employeeIdStr = request.getParameter("employeeId");
        if (employeeIdStr == null || employeeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }
        int employeeId = Integer.parseInt(employeeIdStr);

        Employee emp = employeeService.getEmployeeById(employeeId);

        if (emp == null) {
            request.getSession().setAttribute("errorMsg", "Khong tim thay nhan vien!");
            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        String host = "smtp.gmail.com";
        int port = 587;
        String username = "pdhuy190107@gmail.com";
        String password = "huy19010700";
        String from = "pdhuy190107@gmail.com";
        EmailUtil emailUtil = new EmailUtil(host, port, username, password, from);

        String subject = "Thong tin dang nhap he thong FamiCoats";
        String html = "<!DOCTYPE html><html><body style='font-family:Inter,sans-serif;background:#f8fafc;margin:0;padding:20px;'>"
                + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);'>"
                + "<div style='background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:28px 32px;color:#fff;'>"
                + "<h2 style='margin:0;font-size:20px;'>🔑 Thong tin dang nhap</h2>"
                + "<p style='margin:6px 0 0;opacity:0.85;font-size:13px;'>He thong quan ly FamiCoats</p>"
                + "</div>"
                + "<div style='padding:28px 32px;'>"
                + "<p style='margin:0 0 16px;color:#374151;'>Xin chao <strong>" + emp.getFullName() + "</strong>,</p>"
                + "<p style='margin:0 0 20px;color:#6b7280;font-size:14px;'>Duoi day la thong tin dang nhap he thong cua ban:</p>"
                + "<div style='background:#f3f4f6;border-radius:10px;padding:16px 20px;border-left:4px solid #6366f1;'>"
                + "<table style='border-collapse:collapse;width:100%;font-size:14px;'>"
                + "<tr><td style='padding:6px 0;color:#6b7280;width:100px;'>📧 Email</td>"
                + "<td style='padding:6px 0;font-weight:600;color:#1f2937;'>" + emp.getEmail() + "</td></tr>"
                + "<tr><td style='padding:6px 0;color:#6b7280;'>🔑 Mat khau</td>"
                + "<td style='padding:6px 0;font-weight:700;color:#dc2626;font-family:monospace;font-size:15px;'>"
                + emp.getPassword() + "</td></tr>"
                + "</table></div>"
                + "<p style='margin:20px 0 0;font-size:13px;color:#9ca3af;'> Vui long dang nhap va <strong style='color:#374151;'>doi mat khau ngay</strong> de bao mat tai khoan.</p>"
                + "</div>"
                + "<div style='padding:16px 32px;background:#f8fafc;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;'>Tran trong, <strong>Team FamiCoats</strong></div>"
                + "</div></body></html>";

        try {
            emailUtil.sendHtmlMail(emp.getEmail(), subject, html);
            request.getSession().setAttribute("successMsg",
                    "✓ Da gui thong tin dang nhap toi " + emp.getFullName() + " (" + emp.getEmail() + ")!");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMsg",
                    "Gui mail that bai: " + ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private Employee buildEmployeeFromRequest(HttpServletRequest req, boolean isNew) {
        Employee emp = new Employee();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            emp.setId(Integer.parseInt(idStr));
        }

        String codeParam = req.getParameter("code");
        if (codeParam == null || codeParam.trim().isEmpty()) {
            codeParam = req.getParameter("maNhanVien");
        }
        if (codeParam != null && !codeParam.trim().isEmpty()) {
            emp.setCode(codeParam.trim());
        }
        emp.setFullName(req.getParameter("fullName"));
        emp.setEmail(req.getParameter("email"));
        emp.setPhoneNumber(req.getParameter("phoneNumber"));

        String combinedAddress = req.getParameter("address");
        if (combinedAddress != null && !combinedAddress.isEmpty()) {
            emp.setAddressString(combinedAddress);
        }

        emp.setCccd(req.getParameter("cccd"));

        String roleIdStr = req.getParameter("roleId");
        int roleId = roleIdStr != null && !roleIdStr.isEmpty() ? Integer.parseInt(roleIdStr) : 0;

        List<Role> roles = employeeService.getAllRoles();
        if (roles != null) {
            roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                    .collect(java.util.stream.Collectors.toList());
        }

        Role selectedRole = roles != null ? roles.stream().filter(r -> r.getId() == roleId).findFirst()
                .orElse(new Role(roleId, "", 1)) : new Role(roleId, "", 1);
        emp.setRole(selectedRole);

        String pwd = req.getParameter("password");
        if (isNew) {
            emp.setPassword("123456");
        } else {
            if (pwd == null || pwd.trim().isEmpty()) {
                Employee oldEmp = (idStr != null && !idStr.isEmpty())
                        ? employeeService.getEmployeeById(Integer.parseInt(idStr))
                        : null;
                emp.setPassword(oldEmp != null ? oldEmp.getPassword() : "123456");
            } else {
                emp.setPassword(pwd);
            }
        }

        String dobStr = req.getParameter("birthday");
        if (dobStr != null && !dobStr.isEmpty())
            emp.setBirthday(parseDate(dobStr));

        String genderStr = req.getParameter("gender");
        if (genderStr != null && !genderStr.isEmpty())
            emp.setGender("1".equals(genderStr));

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

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserIdStr == null) {
            currentUserIdStr = "1";
        }

        int currentUserId = Integer.parseInt(currentUserIdStr);
        Employee employee = employeeService.getEmployeeById(currentUserId);

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/admin/huy/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserIdStr == null) {
            currentUserIdStr = "1";
        }
        int currentUserId = Integer.parseInt(currentUserIdStr);

        Employee employee = employeeService.getEmployeeById(currentUserId);

        if (employee != null) {
            employee.setPhoneNumber(request.getParameter("phoneNumber"));
            employee.setAddressString(request.getParameter("address"));
            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.trim().isEmpty()) {
                employee.setAvatar(avatar);
            }

            boolean success = employeeService.updateEmployee(employee);

            request.getSession().setAttribute("currentUserName", employee.getFullName());
            request.getSession().setAttribute("currentUserEmail", employee.getEmail());
            request.getSession().setAttribute("successMsg", "Cap nhat thong tin ca nhan thanh cong!");
        } else {
            request.getSession().setAttribute("errorMsg", "Khong tim thay thong tin nhan vien!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }

    private void showChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/huy/change-password.jsp").forward(request, response);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = (String) request.getSession().getAttribute("currentUserId");
        if (currentUserIdStr == null) {
            currentUserIdStr = "1";
        }
        int currentUserId = Integer.parseInt(currentUserIdStr);

        Employee employee = employeeService.getEmployeeById(currentUserId);

        String currentPwd = request.getParameter("currentPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        if (employee == null) {
            request.getSession().setAttribute("errorMsg", "Khong tim thay thong tin nhan vien!");
        } else if (!employee.getPassword().equals(currentPwd)) {
            request.getSession().setAttribute("errorMsg", "Mat khau hien tai khong chinh xac!");
        } else if (!newPwd.equals(confirmPwd)) {
            request.getSession().setAttribute("errorMsg", "Mat khau moi va xac nhan mat khau khong trung khop!");
        } else {
            employee.setPassword(newPwd);
            boolean success = employeeService.updateEmployee(employee);
            request.getSession().setAttribute("successMsg", "Doi mat khau thanh cong!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/change-password");
    }
}