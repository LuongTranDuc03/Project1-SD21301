package project.duan1_sd21301.service.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.Role;
import java.util.List;

public interface EmployeeService {
    List<Employee> getAllEmployees();
    Employee getEmployeeById(int id);
    List<Role> getAllRoles();
    boolean addEmployee(Employee emp);
    boolean updateEmployee(Employee emp);
    boolean deleteEmployee(int id); // Hàm này để xử lý nghiệp vụ xóa mềm
}