package project.duan1_sd21301.service;

import project.duan1_sd21301.model.Employee;
import project.duan1_sd21301.model.Role;
import java.util.List;

public interface EmployeeService {
    List<Employee> getAllEmployees();
    Employee getEmployeeById(String id);
    List<Role> getAllRoles();
    boolean addEmployee(Employee emp);
    boolean updateEmployee(Employee emp);
    boolean deleteEmployee(String id); // Hàm này để xử lý nghiệp vụ xóa mềm
}