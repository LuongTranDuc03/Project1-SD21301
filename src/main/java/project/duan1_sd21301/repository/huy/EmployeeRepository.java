package project.duan1_sd21301.repository.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;
import project.duan1_sd21301.repository.BaseRepository;

import java.util.List;

public interface EmployeeRepository extends BaseRepository<Employee, Integer> {
    Employee findByEmail(String email);
    List<Role> findAllRoles();
    String getNextCode();
    boolean isEmailExist(String email, Integer excludeId);
    boolean isPhoneExist(String phone, Integer excludeId);
    boolean isCodeExist(String code, Integer excludeId);
    Employee login(String email, String password);

    @Deprecated
    default String getNextMaNhanVien() { return getNextCode(); }
    @Deprecated
    default boolean isMaNhanVienExist(String maNhanVien, Integer excludeId) { return isCodeExist(maNhanVien, excludeId); }
}
