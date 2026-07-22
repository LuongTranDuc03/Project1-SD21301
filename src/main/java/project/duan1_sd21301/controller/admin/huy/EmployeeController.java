package project.duan1_sd21301.controller.admin.huy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;
import project.duan1_sd21301.service.EmailService;
import project.duan1_sd21301.service.huy.EmployeeService;
import project.duan1_sd21301.service.huy.EmployeeServiceImpl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "EmployeeController", urlPatterns = { "/admin/employees", "/admin/profile",
        "/admin/change-password" })
public class EmployeeController extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeServiceImpl();
    private final EmployeeRepository repository = new EmployeeRepositoryImpl();
    private final EmailService emailService = new EmailService();

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

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listEmployees(request, response);
                break;
            case "add":
            case "edit":
                showForm(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "delete":
                deleteEmployee(request, response);
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
            updateChangePassword(request, response);
            return;
        }

        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            toggleEmployeeStatus(request, response);
            return;
        }

        if ("create".equals(action)) {
            createEmployee(request, response);
        } else if ("update".equals(action)) {
            updateEmployee(request, response);
        } else if ("sendMail".equals(action)) {
            sendMailSingle(request, response);
        } else if ("sendMailAll".equals(action)) {
            sendMailAll(request, response);
        } else {
            listEmployees(request, response);
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Employee> employees = employeeService.getAllEmployees();
        List<Role> roles = employeeService.getAllRoles();

        if (roles != null) {
            roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                    .collect(Collectors.toList());
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
                    .collect(Collectors.toList());
        }
        request.setAttribute("roles", roles != null ? roles : new java.util.ArrayList<>());

        String toastMessage = (String) request.getSession().getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", request.getSession().getAttribute("toastType"));
            request.getSession().removeAttribute("toastMessage");
            request.getSession().removeAttribute("toastType");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/huy/employee-add.jsp").forward(request, response);
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

    private List<String> validateEmployeeInController(Employee emp, Integer excludeId) {
        List<String> errors = new java.util.ArrayList<>();

        // 1. Họ và tên
        if (emp.getFullName() == null || emp.getFullName().trim().isEmpty()) {
            errors.add("Họ và tên không được để trống!");
        } else if (emp.getFullName().trim().length() < 2) {
            errors.add("Họ và tên phải gồm ít nhất 2 ký tự!");
        }

        // 2. Vai trò
        if (emp.getRoleId() <= 0) {
            errors.add("Vui lòng chọn vai trò làm việc!");
        }

        // 3. Số CCCD
        if (emp.getCccd() == null || emp.getCccd().trim().isEmpty()) {
            errors.add("Số CCCD không được để trống!");
        } else if (!emp.getCccd().trim().matches("^\\d{12}$")) {
            errors.add("Số CCCD phải gồm đúng 12 chữ số!");
        } else if (repository.isCccdExist(emp.getCccd().trim(), excludeId)) {
            errors.add("Số CCCD đã tồn tại trong hệ thống!");
        }

        // 4. Số điện thoại
        if (emp.getPhoneNumber() == null || emp.getPhoneNumber().trim().isEmpty()) {
            errors.add("Số điện thoại không được để trống!");
        } else if (!emp.getPhoneNumber().trim().matches("^(03|05|07|08|09)\\d{8}$")) {
            errors.add("Số điện thoại không hợp lệ (10 số, bắt đầu bằng 03, 05, 07, 08, 09)!");
        } else if (repository.isPhoneExist(emp.getPhoneNumber().trim(), excludeId)) {
            errors.add("Số điện thoại đã tồn tại trong hệ thống!");
        }

        // 5. Email
        if (emp.getEmail() == null || emp.getEmail().trim().isEmpty()) {
            errors.add("Email không được để trống!");
        } else if (!emp.getEmail().trim().matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.add("Email không đúng định dạng chuẩn!");
        } else if (repository.isEmailExist(emp.getEmail().trim(), excludeId)) {
            errors.add("Email đã tồn tại trong hệ thống!");
        }

        // 6. Ngày sinh (Tối thiểu 18 tuổi)
        if (emp.getBirthday() != null) {
            java.util.Calendar today = java.util.Calendar.getInstance();
            java.util.Calendar dob = java.util.Calendar.getInstance();
            dob.setTime(emp.getBirthday());
            int age = today.get(java.util.Calendar.YEAR) - dob.get(java.util.Calendar.YEAR);
            if (today.get(java.util.Calendar.DAY_OF_YEAR) < dob.get(java.util.Calendar.DAY_OF_YEAR)) {
                age--;
            }
            if (age < 18) {
                errors.add("Nhân viên phải từ 18 tuổi trở lên!");
            }
        }

        // 7. Bộ Địa chỉ
        Address addr = emp.getAddress();
        if (addr == null || addr.getFormattedAddress() == null || addr.getFormattedAddress().trim().isEmpty()) {
            errors.add("Vui lòng chọn Tỉnh/Thành, Quận/Huyện, Phường/Xã và nhập Địa chỉ!");
        }

        return errors;
    }

    private void createEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, true);

        List<String> errors = validateEmployeeInController(emp, null);
        if (!errors.isEmpty()) {
            request.getSession().setAttribute("toastMessage", errors.get(0));
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, false);
            return;
        }

        if (emp.getCode() != null && !emp.getCode().isEmpty()) {
            boolean maNvExists = repository.isCodeExist(emp.getCode(), null);
            if (maNvExists) {
                request.getSession().setAttribute("toastMessage", "Mã nhân viên đã tồn tại trong hệ thống!");
                request.getSession().setAttribute("toastType", "error");
                forwardToForm(request, response, emp, false);
                return;
            }
        } else {
            emp.setCode(repository.getNextCode());
        }

        boolean success = employeeService.addEmployee(emp);

        if (success) {
            emailService.sendLoginCredentialsAsync(emp);
            request.getSession().setAttribute("toastMessage",
                    "Thêm nhân viên thành công. Email tài khoản đang được gửi!");
            request.getSession().setAttribute("toastType", "success");
        } else {
            request.getSession().setAttribute("toastMessage", "Thêm nhân viên thất bại!");
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Employee emp = buildEmployeeFromRequest(request, false);

        List<String> errors = validateEmployeeInController(emp, emp.getId());
        if (!errors.isEmpty()) {
            request.getSession().setAttribute("toastMessage", errors.get(0));
            request.getSession().setAttribute("toastType", "error");
            forwardToForm(request, response, emp, true);
            return;
        }

        if (emp.getCode() != null && !emp.getCode().isEmpty()) {
            boolean maNvExists = repository.isCodeExist(emp.getCode(), emp.getId());
            if (maNvExists) {
                request.getSession().setAttribute("toastMessage", "Mã nhân viên đã tồn tại trong hệ thống!");
                request.getSession().setAttribute("toastType", "error");
                forwardToForm(request, response, emp, true);
                return;
            }
        } else {
            Employee oldEmp = employeeService.getEmployeeById(emp.getId());
            if (oldEmp != null) {
                emp.setCode(oldEmp.getCode());
            }
        }

        boolean success = employeeService.updateEmployee(emp);

        if (success) {
            request.getSession().setAttribute("toastMessage", "Cập nhật thành công!");
            request.getSession().setAttribute("toastType", "success");
        } else {
            request.getSession().setAttribute("toastMessage", "Cập nhật thất bại!");
            request.getSession().setAttribute("toastType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            boolean success = employeeService.deleteEmployee(id);
            if (success) {
                request.getSession().setAttribute("toastMessage", "Đã khóa/nghỉ việc tài khoản nhân viên!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Xóa thất bại!");
                request.getSession().setAttribute("toastType", "error");
            }
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
                newStatus = (employee.getStatus() == 1) ? 0 : 1;
            }

            employee.setStatus(newStatus);
            boolean success = employeeService.updateEmployee(employee);

            String msg = success
                    ? (newStatus == 1 ? "Đã kích hoạt tài khoản nhân viên!" : "Đã chuyển trạng thái nghỉ việc!")
                    : "Cập nhật trạng thái thất bại!";

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + success + ", \"newStatus\": " + newStatus
                        + ", \"message\": \"" + msg + "\"}");
                return;
            } else {
                request.getSession().setAttribute("toastMessage", msg);
                request.getSession().setAttribute("toastType", success ? "success" : "error");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void sendMailSingle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            Employee emp = employeeService.getEmployeeById(id);
            if (emp != null) {
                emailService.sendLoginCredentialsAsync(emp);
                request.getSession().setAttribute("toastMessage",
                        "Đã gửi email thông tin đăng nhập tới " + emp.getEmail());
                request.getSession().setAttribute("toastType", "success");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private void sendMailAll(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Employee> employees = employeeService.getAllEmployees();
        if (employees != null) {
            for (Employee emp : employees) {
                if (emp.getStatus() == 1) {
                    emailService.sendLoginCredentialsAsync(emp);
                }
            }
        }
        request.getSession().setAttribute("toastMessage", "Đã gửi email cho tất cả nhân viên đang làm việc!");
        request.getSession().setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/admin/employees");
    }

    private Employee buildEmployeeFromRequest(HttpServletRequest req, boolean isCreate) {
        Employee emp = new Employee();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            emp.setId(Integer.parseInt(idStr));
        }

        String maNV = req.getParameter("code");
        if (maNV == null || maNV.trim().isEmpty()) {
            maNV = req.getParameter("maNhanVien");
        }
        if (maNV != null && !maNV.trim().isEmpty()) {
            emp.setCode(maNV.trim());
        }
        emp.setFullName(req.getParameter("fullName"));
        emp.setEmail(req.getParameter("email"));
        emp.setPhoneNumber(req.getParameter("phoneNumber"));

        String province = req.getParameter("province");
        if (province == null) province = req.getParameter("tinh");
        String district = req.getParameter("district");
        if (district == null) district = req.getParameter("huyen");
        String ward = req.getParameter("ward");
        if (ward == null) ward = req.getParameter("xa");
        String detailedAddress = req.getParameter("detailedAddress");
        if (detailedAddress == null) detailedAddress = req.getParameter("dia_chi_chi_tiet");
        String combinedAddress = req.getParameter("address");

        Address addressObj = new Address();
        if (idStr != null && !idStr.isEmpty()) {
            Employee oldEmp = employeeService.getEmployeeById(Integer.parseInt(idStr));
            if (oldEmp != null && oldEmp.getAddress() != null) {
                addressObj.setId(oldEmp.getAddress().getId());
            }
        }

        if (province != null && !province.trim().isEmpty()) addressObj.setProvince(province.trim());
        if (district != null && !district.trim().isEmpty()) addressObj.setDistrict(district.trim());
        if (ward != null && !ward.trim().isEmpty()) addressObj.setWard(ward.trim());
        if (detailedAddress != null && !detailedAddress.trim().isEmpty()) {
            addressObj.setDetailedAddress(detailedAddress.trim());
        } else if (combinedAddress != null && !combinedAddress.trim().isEmpty()) {
            addressObj.setDetailedAddress(combinedAddress.trim());
        }

        emp.setAddress(addressObj);
        emp.setCccd(req.getParameter("cccd"));

        String roleIdStr = req.getParameter("roleId");
        int roleId = (roleIdStr != null && !roleIdStr.isEmpty()) ? Integer.parseInt(roleIdStr) : 1;

        List<Role> roles = employeeService.getAllRoles();
        if (roles != null) {
            roles = roles.stream().filter(r -> !"Admin".equals(r.getRoleName()))
                    .collect(Collectors.toList());
        }

        final int finalRoleId = roleId;
        Role selectedRole = roles != null ? roles.stream().filter(r -> r.getId() == finalRoleId).findFirst()
                .orElse(new Role(roleId, "", 1)) : new Role(roleId, "", 1);
        emp.setRole(selectedRole);

        String pwd = req.getParameter("password");
        if (isCreate) {
            emp.setPassword("123456");
        } else {
            if (pwd == null || pwd.trim().isEmpty()) {
                Employee oldEmp = (idStr != null && !idStr.isEmpty()) ? employeeService.getEmployeeById(Integer.parseInt(idStr)) : null;
                emp.setPassword(oldEmp != null ? oldEmp.getPassword() : "123456");
            } else {
                emp.setPassword(pwd);
            }
        }

        String dobStr = req.getParameter("birthday");
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dob = sdf.parse(dobStr);
                emp.setBirthday(dob);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        String genderStr = req.getParameter("gender");
        if ("true".equalsIgnoreCase(genderStr) || "1".equals(genderStr) || "Nam".equalsIgnoreCase(genderStr)) {
            emp.setGender(true);
        } else if ("false".equalsIgnoreCase(genderStr) || "0".equals(genderStr) || "Nữ".equalsIgnoreCase(genderStr)) {
            emp.setGender(false);
        }

        String avatar = req.getParameter("avatar");
        if (avatar != null && !avatar.trim().isEmpty()) {
            emp.setAvatar(avatar);
        } else {
            emp.setAvatar("https://ui-avatars.com/api/?name=" + emp.getFullName().replace(" ", "+") + "&background=random");
        }

        String statusStr = req.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty()) {
            emp.setStatus(Integer.parseInt(statusStr));
        } else {
            emp.setStatus(1);
        }

        return emp;
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = request.getParameter("id");
        if (currentUserIdStr == null || currentUserIdStr.isEmpty()) {
            currentUserIdStr = "1";
        }

        int currentUserId = Integer.parseInt(currentUserIdStr);
        Employee employee = employeeService.getEmployeeById(currentUserId);

        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/WEB-INF/views/admin/huy/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = request.getParameter("id");
        if (currentUserIdStr == null || currentUserIdStr.isEmpty()) {
            currentUserIdStr = "1";
        }
        int currentUserId = Integer.parseInt(currentUserIdStr);

        Employee employee = employeeService.getEmployeeById(currentUserId);

        if (employee != null) {
            employee.setPhoneNumber(request.getParameter("phoneNumber"));
            Address addr = employee.getAddress();
            if (addr == null) addr = new Address();
            String combinedAddress = request.getParameter("address");
            if (combinedAddress != null) addr.setDetailedAddress(combinedAddress);
            employee.setAddress(addr);

            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.trim().isEmpty()) {
                employee.setAvatar(avatar);
            }

            employeeService.updateEmployee(employee);

            request.getSession().setAttribute("currentUserName", employee.getFullName());
            request.getSession().setAttribute("currentUserEmail", employee.getEmail());
            request.getSession().setAttribute("toastMessage", "Cập nhật thông tin cá nhân thành công!");
            request.getSession().setAttribute("toastType", "success");
        } else {
            request.getSession().setAttribute("toastMessage", "Không tìm thấy thông tin nhân viên!");
            request.getSession().setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }

    private void showChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/huy/change-password.jsp").forward(request, response);
    }

    private void updateChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentUserIdStr = request.getParameter("id");
        if (currentUserIdStr == null || currentUserIdStr.isEmpty()) {
            currentUserIdStr = "1";
        }
        int currentUserId = Integer.parseInt(currentUserIdStr);

        Employee employee = employeeService.getEmployeeById(currentUserId);

        String currentPwd = request.getParameter("currentPassword");
        String newPwd = request.getParameter("newPassword");
        String confirmPwd = request.getParameter("confirmPassword");

        if (employee == null) {
            request.getSession().setAttribute("toastMessage", "Không tìm thấy thông tin nhân viên!");
            request.getSession().setAttribute("toastType", "error");
        } else if (!employee.getPassword().equals(currentPwd)) {
            request.getSession().setAttribute("toastMessage", "Mật khẩu hiện tại không chính xác!");
            request.getSession().setAttribute("toastType", "error");
        } else if (!newPwd.equals(confirmPwd)) {
            request.getSession().setAttribute("toastMessage", "Mật khẩu mới và xác nhận mật khẩu không trùng khớp!");
            request.getSession().setAttribute("toastType", "error");
        } else {
            employee.setPassword(newPwd);
            employeeService.updateEmployee(employee);
            request.getSession().setAttribute("toastMessage", "Đổi mật khẩu thành công!");
            request.getSession().setAttribute("toastType", "success");
        }

        response.sendRedirect(request.getContextPath() + "/admin/change-password");
    }
}