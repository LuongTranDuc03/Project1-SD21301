package project.duan1_sd21301.controller.admin.huy;

import project.duan1_sd21301.model.huy.Employee;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class EmployeeValidator {

    private static final String PHONE_REGEX = "^(03|05|07|08|09)\\d{8}$";
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String CCCD_REGEX = "^\\d{12}$";

    public static Map<String, String> validate(Employee emp) {
        Map<String, String> errors = new HashMap<>();

        if (emp.getFullName() == null || emp.getFullName().trim().isEmpty()) {
            errors.put("fullName", "Họ tên không được để trống");
        }

        if (emp.getEmail() == null || emp.getEmail().trim().isEmpty()) {
            errors.put("email", "Email không được để trống");
        } else if (!Pattern.matches(EMAIL_REGEX, emp.getEmail())) {
            errors.put("email", "Email không đúng định dạng");
        }

        // Phone validation based on Role as it was in controller
        if ("Nhan vien".equalsIgnoreCase(emp.getRoleName()) || "Employee".equalsIgnoreCase(emp.getRoleName()) || emp.getRoleId() == 3) {
            if (emp.getPhoneNumber() == null || emp.getPhoneNumber().trim().isEmpty()) {
                errors.put("phoneNumber", "Số điện thoại bắt buộc đối với Nhân viên");
            } else if (!Pattern.matches(PHONE_REGEX, emp.getPhoneNumber())) {
                errors.put("phoneNumber", "Số điện thoại không hợp lệ (10 chữ số, đầu 03, 05, 07, 08, 09)");
            }
        } else {
            // Manager: Phone can be empty, but if provided, should be valid
            if (emp.getPhoneNumber() != null && !emp.getPhoneNumber().trim().isEmpty()) {
                if (!Pattern.matches(PHONE_REGEX, emp.getPhoneNumber())) {
                    errors.put("phoneNumber", "Số điện thoại không hợp lệ (10 chữ số, đầu 03, 05, 07, 08, 09)");
                }
            }
        }

        if (emp.getCccd() == null || emp.getCccd().trim().isEmpty()) {
            errors.put("cccd", "CCCD không được để trống");
        } else if (!Pattern.matches(CCCD_REGEX, emp.getCccd())) {
            errors.put("cccd", "CCCD phải bao gồm đúng 12 chữ số");
        }

        return errors;
    }
}
