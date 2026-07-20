package project.duan1_sd21301.repository.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.Role;
import project.duan1_sd21301.repository.BaseRepository;

import java.util.List;

public interface EmployeeRepository extends BaseRepository<Employee, Integer> {
    Employee findByEmail(String email);
    List<Role> findAllRoles();
    String getNextMaNhanVien();
    boolean isEmailExist(String email, Integer excludeId);
    boolean isPhoneExist(String phone, Integer excludeId);
    boolean isMaNhanVienExist(String maNhanVien, Integer excludeId);
    Employee login(String email, String password);
}
