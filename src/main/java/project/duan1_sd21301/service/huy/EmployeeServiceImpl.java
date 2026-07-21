package project.duan1_sd21301.service.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;
import project.duan1_sd21301.model.huy.Role;

import java.util.List;

public class EmployeeServiceImpl implements EmployeeService {

    // Gọi sang lớp thực thi Repository của bạn
    private final EmployeeRepository employeeRepo = new EmployeeRepositoryImpl();

    @Override
    public List<Employee> getAllEmployees() {
        return employeeRepo.findAll();
    }

    @Override
    public Employee getEmployeeById(int id) {
        return employeeRepo.findById(id);
    }

    @Override
    public List<Role> getAllRoles() {
        return employeeRepo.findAllRoles();
    }

    @Override
    public boolean addEmployee(Employee emp) {
        // 1. Kiểm tra trùng lặp email hệ thống qua hàm bạn đã viết
        if (employeeRepo.findByEmail(emp.getEmail()) != null) {
            System.out.println("LOG SERVICE: Email đã tồn tại trong hệ thống, không thể thêm mới!");
            return false;
        }

        // 2. Nếu trên giao diện Form không nhập mật khẩu, tự động đặt mật khẩu mặc định
        if (emp.getPassword() == null || emp.getPassword().trim().isEmpty()) {
            emp.setPassword("123456");
        }

        // 3. Tự sinh mã nhân viên (ma_nhan_vien) tuần tự
        if (emp.getMaNhanVien() == null || emp.getMaNhanVien().isEmpty()) {
            emp.setMaNhanVien(employeeRepo.getNextMaNhanVien());
        }

        // 4. Gọi Repo lưu dữ liệu vào bảng nhan_vien
        boolean isInserted = employeeRepo.insert(emp);

        // 4. Khi lưu thành công, kích hoạt luồng phụ (Thread) chạy độc lập để gửi Email
        if (isInserted) {
            final String recipientEmail = emp.getEmail();
            final String rawPassword = emp.getPassword();

            new Thread(() -> {
                try {
                    // TODO: Nhúng class gửi mail thực tế của nhóm bạn tại đây khi hoàn thiện công nghệ
                    System.out.println("====== LUỒNG TỰ ĐỘNG GỬI MAIL NHÂN VIÊN MỚI ======");
                    System.out.println("Gửi tới địa chỉ email: " + recipientEmail);
                    System.out.println("Tài khoản đăng nhập: " + recipientEmail);
                    System.out.println("Mật khẩu truy cập hệ thống: " + rawPassword);
                    System.out.println("=================================================");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }).start();
        }

        return isInserted;
    }

    @Override
    public boolean updateEmployee(Employee emp) {
        // Xử lý nghiệp vụ Mật khẩu khi sửa:
        // Nếu người dùng bỏ trống ô mật khẩu trên Form sửa -> Tìm lại mật khẩu cũ đang lưu trong DB đắp vào để không bị mất mật khẩu cũ
        if (emp.getPassword() == null || emp.getPassword().trim().isEmpty()) {
            Employee oldEmp = employeeRepo.findById(emp.getId());
            if (oldEmp != null) {
                emp.setPassword(oldEmp.getPassword());
            }
        }
        return employeeRepo.update(emp);
    }

    @Override
    public boolean deleteEmployee(int id) {
        // Soft delete: set status to 0 (inactive)
        Employee currentEmp = employeeRepo.findById(id);
        if (currentEmp != null) {
            currentEmp.setStatus(0);
            return employeeRepo.update(currentEmp);
        }
        return false;
    }
}