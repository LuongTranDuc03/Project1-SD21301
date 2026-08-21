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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
 
/**
 * Controller xử lý tất cả các nghiệp vụ liên quan đến Quản lý Nhân viên.
 * Bao gồm: Liệt kê danh sách (phân trang, tìm kiếm, lọc theo vai trò/trạng thái),
 * xem chi tiết, thêm mới, cập nhật, thay đổi trạng thái (hoạt động/ngừng hoạt động),
 * gửi email thông báo và xử lý ảnh đại diện (avatar).
 * 
 * Hỗ trợ các request GET (điều hướng) và POST (thao tác dữ liệu).
 */
@WebServlet(name = "EmployeeController", urlPatterns = { "/admin/employees" })
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class EmployeeController extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeServiceImpl();
    private final EmployeeRepository repository = new EmployeeRepositoryImpl();
    private final EmailService emailService = new EmailService();

    /**
     * Xử lý các yêu cầu điều hướng (GET) dựa trên tham số 'action' từ URL.
     * Chuyển hướng tới các phương thức chi tiết tương ứng.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isManagerOrAdmin(request)) {
            request.getSession().setAttribute("toastMessage", "Bạn không có quyền truy cập quản lý nhân viên!");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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
            case "view":
                showDetail(request, response);
                break;
            case "delete":
                deleteEmployee(request, response);
                break;
            case "toggleStatus":
                toggleEmployeeStatus(request, response);
                break;
            default:
                listEmployees(request, response);
                break;
        }
    }

    /**
     * Xử lý các thao tác nộp biểu mẫu (POST) dựa trên tham số 'action'.
     * Chủ yếu dùng để Thêm mới, Cập nhật, Thay đổi trạng thái, Gửi email.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!isManagerOrAdmin(request)) {
            request.getSession().setAttribute("toastMessage", "Bạn không có quyền truy cập quản lý nhân viên!");
            request.getSession().setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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

    /**
     * Hiển thị danh sách nhân viên.
     * Hỗ trợ tìm kiếm theo từ khóa, lọc theo Trạng thái (status) và Vai trò (roleId).
     * Áp dụng phân trang (page, size).
     */
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

    /**
     * Xem thông tin chi tiết của một nhân viên (Thông qua ID).
     */
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

        request.getRequestDispatcher("/WEB-INF/views/admin/huy/employee-form.jsp").forward(request, response);
    }

    /**
     * Hiển thị form Thêm mới hoặc Cập nhật thông tin nhân viên.
     * Tự động lấy danh sách Role và thiết lập mã nhân viên mặc định (nếu là tạo mới).
     */
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
        } else if (!emp.getFullName().matches("^[a-zA-ZÀ-ỹ\\s]+$")) {
            errors.add("Họ và tên không được chứa số hoặc ký tự đặc biệt!");
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
            java.time.LocalDate dob = emp.getBirthday().toInstant()
                    .atZone(java.time.ZoneId.systemDefault()).toLocalDate();
            long age = dob.until(java.time.LocalDate.now(), java.time.temporal.ChronoUnit.YEARS);
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

    /**
     * Thực hiện thêm mới nhân viên vào database (khi submit form Create).
     * Gửi email tự động thông báo tài khoản cho nhân viên sau khi thêm thành công.
     */
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

    /**
     * Thực hiện cập nhật thông tin nhân viên có sẵn (khi submit form Update).
     * Đảm bảo không ghi đè mất mật khẩu hay avatar nếu không có thay đổi.
     */
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

    /**
     * Chuyển đổi trạng thái hoạt động của nhân viên (Từ Đang hoạt động <-> Ngừng hoạt động).
     * Ngăn chặn việc tài khoản đang đăng nhập tự khóa chính mình.
     */
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

    /**
     * Hàm tiện ích thu thập dữ liệu từ request (form HTML) và đóng gói thành đối tượng Employee.
     * Xử lý riêng logic lưu ảnh đại diện (avatar) qua Multipart Request.
     * 
     * @param req      Đối tượng HttpServletRequest chứa dữ liệu form
     * @param isCreate Cờ đánh dấu là hành động Thêm mới (true) hay Cập nhật (false)
     * @return Đối tượng Employee hoàn chỉnh sẵn sàng lưu DB
     */
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
            if (oldEmp != null) {
                if (oldEmp.getAddress() != null) {
                    addressObj.setId(oldEmp.getAddress().getId());
                }
                // Giữ nguyên ngày tạo ban đầu và cập nhật thời gian sửa đổi mới nhất
                emp.setCreatedAt(oldEmp.getCreatedAt());
                emp.setUpdatedAt(java.time.LocalDateTime.now());
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

        Employee oldEmp = null;
        if (!isCreate && idStr != null && !idStr.isEmpty()) {
            oldEmp = employeeService.getEmployeeById(Integer.parseInt(idStr));
        }

        String pwd = req.getParameter("password");
        if (isCreate) {
            if (pwd != null && !pwd.trim().isEmpty()) {
                emp.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw(pwd.trim(), org.mindrot.jbcrypt.BCrypt.gensalt()));
            } else {
                emp.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw("123456", org.mindrot.jbcrypt.BCrypt.gensalt()));
            }
        } else {
            if (pwd == null || pwd.trim().isEmpty()) {
                emp.setPassword(oldEmp != null ? oldEmp.getPassword() : org.mindrot.jbcrypt.BCrypt.hashpw("123456", org.mindrot.jbcrypt.BCrypt.gensalt()));
            } else {
                emp.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw(pwd.trim(), org.mindrot.jbcrypt.BCrypt.gensalt()));
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

        try {
            Part filePart = req.getPart("anhDaiDienFile");
            if (filePart != null && filePart.getSize() > 0) {
                File uploadDir = new File(req.getServletContext().getRealPath("/"), "uploads");
                if (!uploadDir.exists()) uploadDir.mkdirs();
                String uniqueFileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(new File(uploadDir, uniqueFileName).getAbsolutePath());
                emp.setAvatar(req.getContextPath() + "/uploads/" + uniqueFileName);
            } else {
                String avatar = req.getParameter("avatar");
                if (avatar != null && !avatar.trim().isEmpty()) {
                    emp.setAvatar(avatar);
                } else if (!isCreate && oldEmp != null && oldEmp.getAvatar() != null && !oldEmp.getAvatar().trim().isEmpty()) {
                    emp.setAvatar(oldEmp.getAvatar());
                } else {
                    emp.setAvatar("https://ui-avatars.com/api/?name=" + emp.getFullName().replace(" ", "+") + "&background=random");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            String avatar = req.getParameter("avatar");
            if (avatar != null && !avatar.trim().isEmpty()) {
                emp.setAvatar(avatar);
            } else {
                emp.setAvatar("https://ui-avatars.com/api/?name=" + emp.getFullName().replace(" ", "+") + "&background=random");
            }
        }

        String statusStr = req.getParameter("status");
        if (statusStr != null && !statusStr.isEmpty()) {
            emp.setStatus(Integer.parseInt(statusStr));
        } else {
            emp.setStatus(1);
        }

        return emp;
    }

    private boolean isManagerOrAdmin(HttpServletRequest request) {
        Employee loggedInUser = (Employee) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) return false;
        if (loggedInUser.getRole() != null && loggedInUser.getRole().getRoleName() != null) {
            String roleName = loggedInUser.getRole().getRoleName();
            return "Admin".equalsIgnoreCase(roleName) || "Quản lý".equalsIgnoreCase(roleName);
        }
        return false;
    }
}