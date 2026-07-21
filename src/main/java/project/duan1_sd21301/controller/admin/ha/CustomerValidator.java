package project.duan1_sd21301.controller.admin.ha;

import project.duan1_sd21301.model.ha.Customer;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CustomerValidator {

    public static List<String> validate(
            String code,
            String fullName,
            String email,
            String phone,
            Date birthday,
            String gender,
            String status,
            String defaultAddress,
            List<Customer> customers,
            boolean isEdit
    ) {
        List<String> errors = new ArrayList<>();

        // 1. Mã khách hàng
        if (code == null || code.trim().isEmpty()) {
            errors.add("Mã khách hàng không được để trống.");
        } else if (customers != null) {
            for (Customer c : customers) {
                if (!isEdit || !c.getCode().equalsIgnoreCase(code)) {
                    if (c.getCode().equalsIgnoreCase(code.trim())) {
                        errors.add("Mã khách hàng đã tồn tại.");
                        break;
                    }
                }
            }
        }

        // 2. Họ tên
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Họ tên không được để trống.");
        } else if (fullName.length() < 2 || fullName.length() > 50) {
            errors.add("Họ tên phải từ 2 đến 50 ký tự.");
        }

        // 3. Email
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email không được để trống.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.add("Email không đúng định dạng.");
        }

        // 4. Số điện thoại
        if (phone == null || phone.trim().isEmpty()) {
            errors.add("Số điện thoại không được để trống.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải gồm đúng 10 số.");
        }

        // 5. Ngày sinh
        if (birthday == null) {
            errors.add("Ngày sinh không được để trống.");
        } else if (birthday.after(new Date())) {
            errors.add("Ngày sinh không hợp lệ.");
        }

        // 6. Giới tính
        if (gender == null || gender.trim().isEmpty()) {
            errors.add("Vui lòng chọn giới tính.");
        }

        // 7. Trạng thái
        if (status == null || status.trim().isEmpty()) {
            errors.add("Vui lòng chọn trạng thái.");
        }

        // 8. Địa chỉ mặc định
        if (defaultAddress == null || defaultAddress.trim().isEmpty()
                || defaultAddress.trim().replaceAll("[,\\s]+", "").isEmpty()) {
            errors.add("Địa chỉ mặc định không được để trống hoặc không hợp lệ.");
        }

        // 9. Email duy nhất
        if (customers != null && email != null) {
            for (Customer c : customers) {
                if (!isEdit || !c.getCode().equalsIgnoreCase(code)) {
                    if (c.getEmail().equalsIgnoreCase(email.trim())) {
                        errors.add("Email đã tồn tại.");
                        break;
                    }
                }
            }
        }

        // 10. Số điện thoại duy nhất
        if (customers != null && phone != null) {
            for (Customer c : customers) {
                if (!isEdit || !c.getCode().equalsIgnoreCase(code)) {
                    if (c.getPhoneNumber().equals(phone.trim())) {
                        errors.add("Số điện thoại đã tồn tại.");
                        break;
                    }
                }
            }
        }

        return errors;
    }
}