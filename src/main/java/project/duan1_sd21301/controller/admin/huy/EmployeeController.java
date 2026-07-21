package project.duan1_sd21301.controller.admin.huy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.util.EmailUtil;
import project.duan1_sd21301.util.huy.EmployeeMockData;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "EmployeeController", urlPatterns = { "/admin/employees", "/admin/profile",
        "/admin/change-password" })
public class EmployeeController extends HttpServlet {

    private final EmployeeRepository repository = new EmployeeRepositoryImpl();

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
        List<Employee> employees = repository.findAll();
        List<Role> roles = repository.findAllRoles();

        // Load mock data
        List<Employee> mockEmployees = EmployeeMockData.loadAll();
        List<Role> mockRoles = EmployeeMockData.loadAllRoles();

        // Merge: Mock data sẽ đè lên DB data nếu trùng ID (để xử lý trường hợp update
        // DB lỗi nhưng update mock thành công)
        java.util.Map<Integer, Employee> mergedMap = new java.util.LinkedHashMap<>();

        // 1. Nạp data từ DB trước
        if (employees != null) {
            for (Employee e : employees) {
                mergedMap.put(e.getId(), e);
            }
        }

        // 2. Ghi đè hoặc thêm mới từ Mock data
        if (mockEmployees != null) {
            for (Employee me : mockEmployees) {
                mergedMap.put(me.getId(), me);
            }
        }

        // Cập nhật lại danh sách employees
        employees = new java.util.ArrayList<>(mergedMap.values());
        // Sắp xếp giảm dần theo ID để nhân viên mới nhất (hoặc vừa sửa) lên đầu
        employees.sort((e1, e2) -> Integer.compare(e2.getId(), e1.getId()));

        if (roles == null || roles.isEmpty()) {
            roles = mockRoles != null ? mockRoles : new java.util.ArrayList<>();
        }
        roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                .collect(java.util.stream.Collectors.toList());

        long totalActive = employees.stream().filter(emp -> emp.getStatus() == 1).count();
        long totalInactive = employees.stream().filter(emp -> emp.getStatus() == 0).count();

        request.setAttribute("employees", employees);
        request.setAttribute("roles", roles);
        request.setAttribute("totalActive", totalActive);
        request.setAttribute("totalInactive", totalInactive);
        request.setAttribute("totalAll", employees.size());

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
        Employee employee = repository.findById(id);

        // Fallback mock data
        if (employee == null) {
            employee = EmployeeMockData.findById(id);
        }

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
        List<Role> roles = repository.findAllRoles();
        if (roles == null || roles.isEmpty()) {
            roles = EmployeeMockData.loadAllRoles();
        }
        roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                .collect(java.util.stream.Collectors.toList());
        request.setAttribute("roles", roles);

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
            employee = repository.findById(id);
            if (employee == null) {
                employee = EmployeeMockData.findById(id);
            }
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

        // Check Duplicates
        boolean emailExists = repository.isEmailExist(emp.getEmail(), null)
                || EmployeeMockData.isEmailExist(emp.getEmail(), null);
        if (emailExists) {
            request.getSession().setAttribute("toastMessage", "Email đã tồn tại trong hệ thống!");
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, false);
            return;
        }
        boolean phoneExists = (emp.getPhoneNumber() != null && !emp.getPhoneNumber().isEmpty()) &&
                (repository.isPhoneExist(emp.getPhoneNumber(), null)
                        || EmployeeMockData.isPhoneExist(emp.getPhoneNumber(), null));
        if (phoneExists) {
            request.getSession().setAttribute("toastMessage", "Số điện thoại đã tồn tại trong hệ thống!");
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, false);
            return;
        }

        // Check Ma Nhan Vien Duplicate
        if (emp.getMaNhanVien() != null && !emp.getMaNhanVien().isEmpty()) {
            boolean maNvExists = repository.isMaNhanVienExist(emp.getMaNhanVien(), null)
                    || EmployeeMockData.isMaNhanVienExist(emp.getMaNhanVien(), null);
            if (maNvExists) {
                request.getSession().setAttribute("toastMessage", "Mã nhân viên đã tồn tại trong hệ thống!");
                request.getSession().setAttribute("toastType", "error");
                forwardToForm(request, response, emp, false);
                return;
            }
        } else {
            emp.setMaNhanVien(repository.getNextMaNhanVien());
            if ("NV001".equals(emp.getMaNhanVien())) {
                emp.setMaNhanVien(EmployeeMockData.getNextMaNhanVien());
            }
        }

        boolean success = repository.insert(emp);
        if (!success) {
            success = EmployeeMockData.insert(emp);
        }

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
            request.getSession().setAttribute("toastMessage", "Thêm nhân viên thất bại từ Database!");
            request.getSession().setAttribute("toastType", "error");
        }
        // Remove old existing duplicate block
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, false);

        // Validate with EmployeeValidator
        java.util.Map<String, String> errors = EmployeeValidator.validate(emp);
        if (!errors.isEmpty()) {
            // Get first error to display
            String firstError = errors.values().iterator().next();
            request.getSession().setAttribute("toastMessage", firstError);
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, true);
            return;
        }

        // Check Duplicates
        boolean emailExists = repository.isEmailExist(emp.getEmail(), emp.getId())
                || EmployeeMockData.isEmailExist(emp.getEmail(), emp.getId());
        if (emailExists) {
            request.getSession().setAttribute("toastMessage", "Email đã tồn tại trong hệ thống!");
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, true);
            return;
        }
        boolean phoneExists = (emp.getPhoneNumber() != null && !emp.getPhoneNumber().isEmpty()) &&
                (repository.isPhoneExist(emp.getPhoneNumber(), emp.getId())
                        || EmployeeMockData.isPhoneExist(emp.getPhoneNumber(), emp.getId()));
        if (phoneExists) {
            request.getSession().setAttribute("toastMessage", "Số điện thoại đã tồn tại trong hệ thống!");
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, true);
            return;
        }

        if (emp.getMaNhanVien() != null && !emp.getMaNhanVien().isEmpty()) {
            boolean maNvExists = repository.isMaNhanVienExist(emp.getMaNhanVien(), emp.getId())
                    || EmployeeMockData.isMaNhanVienExist(emp.getMaNhanVien(), emp.getId());
            if (maNvExists) {
                request.getSession().setAttribute("toastMessage", "Mã nhân viên đã tồn tại trong hệ thống!");
                request.getSession().setAttribute("toastType", "error");
                forwardToForm(request, response, emp, true);
                return;
            }
        } else {
            // Keep old maNhanVien if empty on update
            Employee oldEmp = repository.findById(emp.getId());
            if (oldEmp == null)
                oldEmp = EmployeeMockData.findById(emp.getId());
            if (oldEmp != null) {
                emp.setMaNhanVien(oldEmp.getMaNhanVien());
            }
        }

        boolean success = repository.update(emp);
        if (!success) {
            success = EmployeeMockData.update(emp);
        }
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

        Employee employee = repository.findById(id);
        if (employee == null) {
            employee = EmployeeMockData.findById(id);
        }

        if (employee != null) {
            int newStatus;
            if (statusStr != null && !statusStr.isEmpty()) {
                newStatus = Integer.parseInt(statusStr);
            } else {
                newStatus = employee.getStatus() == 1 ? 0 : 1;
            }

            employee.setStatus(newStatus);
            boolean success = repository.update(employee);
            if (!success) {
                success = EmployeeMockData.update(employee);
            }

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

        List<Employee> employees = repository.findAll();
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

        Employee emp = repository.findById(employeeId);

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

        String maNV = req.getParameter("maNhanVien");
        if (maNV != null && !maNV.trim().isEmpty()) {
            emp.setMaNhanVien(maNV.trim());
        }
        emp.setFullName(req.getParameter("fullName"));
        emp.setEmail(req.getParameter("email"));
        emp.setPhoneNumber(req.getParameter("phoneNumber"));

        String combinedAddress = req.getParameter("address");
        if (combinedAddress != null && !combinedAddress.isEmpty()) {
            emp.setAddress(combinedAddress);
        }

        emp.setCccd(req.getParameter("cccd"));

        String roleIdStr = req.getParameter("roleId");
        int roleId = roleIdStr != null && !roleIdStr.isEmpty() ? Integer.parseInt(roleIdStr) : 0;

        List<Role> roles = repository.findAllRoles();
        if (roles == null || roles.isEmpty()) {
            roles = EmployeeMockData.loadAllRoles();
        }
        roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                .collect(java.util.stream.Collectors.toList());

        // Xây dựng Role object và gán vào Employee
        Role selectedRole = roles.stream().filter(r -> r.getId() == roleId).findFirst()
                .orElse(new Role(roleId, "", 1));
        emp.setRole(selectedRole);

        String pwd = req.getParameter("password");
        if (isNew) {
            emp.setPassword("123456");
        } else {
            if (pwd == null || pwd.trim().isEmpty()) {
                Employee oldEmp = (idStr != null && !idStr.isEmpty()) ? repository.findById(Integer.parseInt(idStr))
                        : null;
                if (oldEmp == null && idStr != null && !idStr.isEmpty()) {
                    oldEmp = EmployeeMockData.findById(Integer.parseInt(idStr));
                }
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
            currentUserIdStr = "1"; // Default or redirect
        }

        int currentUserId = Integer.parseInt(currentUserIdStr);
        Employee employee = repository.findById(currentUserId);

        if (employee == null) {
            employee = EmployeeMockData.findById(currentUserId);
        }

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

        Employee employee = repository.findById(currentUserId);
        if (employee == null) {
            employee = EmployeeMockData.findById(currentUserId);
        }

        if (employee != null) {
            employee.setPhoneNumber(request.getParameter("phoneNumber"));
            employee.setAddress(request.getParameter("address"));
            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.trim().isEmpty()) {
                employee.setAvatar(avatar);
            }

            boolean success = repository.update(employee);
            if (!success) {
                success = EmployeeMockData.update(employee);
            }

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

        Employee employee = repository.findById(currentUserId);
        if (employee == null) {
            employee = EmployeeMockData.findById(currentUserId);
        }

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
            boolean success = repository.update(employee);
            if (!success) {
                success = EmployeeMockData.update(employee);
            }
            request.getSession().setAttribute("successMsg", "Doi mat khau thanh cong!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/change-password");
    }
}