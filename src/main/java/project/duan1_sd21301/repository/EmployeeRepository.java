package project.duan1_sd21301.repository;

import project.duan1_sd21301.model.Employee;
import project.duan1_sd21301.model.Role;
import java.util.List;

public interface EmployeeRepository extends BaseRepository<Employee, String> {
    Employee findByEmail(String email);
    List<Role> findAllRoles(); // Lấy danh sách vai trò để đưa vào combobox giao diện
}
