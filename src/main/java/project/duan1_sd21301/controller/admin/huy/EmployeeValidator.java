package project.duan1_sd21301.controller.admin.huy;

import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.huy.Employee;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class EmployeeValidator {

    private static final String PHONE_REGEX = "^(03|05|07|08|09)\\d{8}$";
    private static final String EMAIL_REGEX = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    private static final String CCCD_REGEX = "^\\d{12}$";
    private static final String NAME_REGEX = "^[\\p{L}\\s]{2,100}$";

    public static Map<String, String> validate(Employee emp) {
        Map<String, String> errors = new HashMap<>();

        // 1. Họ và tên
        if (emp.getFullName() == null || emp.getFullName().trim().isEmpty()) {
            errors.put("fullName", "Họ và tên không được để trống");
        } else if (!Pattern.matches(NAME_REGEX, emp.getFullName().trim())) {
            errors.put("fullName", "Họ và tên chỉ chứa chữ cái và có độ dài từ 2 - 100 ký tự");
        }

        // 2. Vai trò
        if (emp.getRoleId() <= 0) {
            errors.put("roleId", "Vui lòng chọn vai trò làm việc");
        }

        // 3. CCCD
        if (emp.getCccd() == null || emp.getCccd().trim().isEmpty()) {
            errors.put("cccd", "Số CCCD không được để trống");
        } else if (!Pattern.matches(CCCD_REGEX, emp.getCccd().trim())) {
            errors.put("cccd", "Số CCCD phải bao gồm đúng 12 chữ số");
        }

        // 4. Số điện thoại
        if (emp.getPhoneNumber() == null || emp.getPhoneNumber().trim().isEmpty()) {
            errors.put("phoneNumber", "Số điện thoại không được để trống");
        } else if (!Pattern.matches(PHONE_REGEX, emp.getPhoneNumber().trim())) {
            errors.put("phoneNumber", "Số điện thoại không hợp lệ (bắt buộc 10 chữ số, đầu 03, 05, 07, 08, 09)");
        }

        // 5. Email
        if (emp.getEmail() == null || emp.getEmail().trim().isEmpty()) {
            errors.put("email", "Email không được để trống");
        } else if (!Pattern.matches(EMAIL_REGEX, emp.getEmail().trim())) {
            errors.put("email", "Email không đúng định dạng chuẩn (ví dụ: nhanvien@gmail.com)");
        }

        // 6. Ngày sinh (Tối thiểu 18 tuổi)
        if (emp.getBirthday() != null) {
            Calendar today = Calendar.getInstance();
            Calendar dob = Calendar.getInstance();
            dob.setTime(emp.getBirthday());

            int age = today.get(Calendar.YEAR) - dob.get(Calendar.YEAR);
            if (today.get(Calendar.DAY_OF_YEAR) < dob.get(Calendar.DAY_OF_YEAR)) {
                age--;
            }
            if (age < 18) {
                errors.put("birthday", "Nhân viên phải đủ từ 18 tuổi trở lên");
            }
        }

        // 7. Địa chỉ
        Address addr = emp.getAddress();
        if (addr == null || (addr.getFormattedAddress() == null || addr.getFormattedAddress().trim().isEmpty())) {
            errors.put("address", "Vui lòng chọn đầy đủ Tỉnh/Thành, Quận/Huyện, Phường/Xã và nhập Địa chỉ");
        }

        return errors;
    }
}
