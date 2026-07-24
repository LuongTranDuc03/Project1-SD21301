package project.duan1_sd21301.controller.admin.ha;

import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;

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
            List<CustomerAddress> addresses,
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

        // 2. Họ tên khách hàng (Không số, không ký tự đặc biệt)
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Họ tên khách hàng không được để trống.");
        } else if (fullName.trim().length() < 2 || fullName.trim().length() > 50) {
            errors.add("Họ tên khách hàng phải từ 2 đến 50 ký tự.");
        } else if (!fullName.trim().matches("^[\\p{L}\\s]+$")) {
            errors.add("Họ tên khách hàng chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.");
        }

        // 3. Email
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email không được để trống.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.add("Email không đúng định dạng.");
        } else if (customers != null) {
            for (Customer c : customers) {
                if (!isEdit || !c.getCode().equalsIgnoreCase(code)) {
                    if (c.getEmail().equalsIgnoreCase(email.trim())) {
                        errors.add("Email đã được sử dụng cho một khách hàng khác.");
                        break;
                    }
                }
            }
        }

        // 4. Số điện thoại chính
        if (phone == null || phone.trim().isEmpty()) {
            errors.add("Số điện thoại khách hàng không được để trống.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại khách hàng phải gồm đúng 10 số và bắt đầu bằng 0.");
        }

        // 5. Ngày sinh (Phải từ 18 tuổi trở lên)
        if (birthday == null) {
            errors.add("Ngày sinh không được để trống.");
        } else if (birthday.after(new Date())) {
            errors.add("Ngày sinh không hợp lệ.");
        } else {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.YEAR, -18);
            Date eighteenYearsAgo = cal.getTime();
            if (birthday.after(eighteenYearsAgo)) {
                errors.add("Khách hàng phải từ 18 tuổi trở lên.");
            }
        }

        // 6. Giới tính
        if (gender == null || gender.trim().isEmpty()) {
            errors.add("Vui lòng chọn giới tính.");
        }

        // 7. Trạng thái
        if (status == null || status.trim().isEmpty()) {
            errors.add("Vui lòng chọn trạng thái.");
        }

        // 8. Validate Địa chỉ (Mặc định & Địa chỉ phụ)
        if (addresses == null || addresses.isEmpty()) {
            errors.add("Vui lòng nhập thông tin địa chỉ mặc định.");
        } else {
            for (int i = 0; i < addresses.size(); i++) {
                CustomerAddress ca = addresses.get(i);
                String prefix = ca.isDefault() ? "Địa chỉ mặc định: " : ("Địa chỉ phụ " + i + ": ");

                // Validate Tên người nhận
                if (ca.getRecipientName() == null || ca.getRecipientName().trim().isEmpty()) {
                    errors.add(prefix + "Tên người nhận không được để trống.");
                } else if (!ca.getRecipientName().trim().matches("^[\\p{L}\\s]+$")) {
                    errors.add(prefix + "Tên người nhận chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.");
                }

                // Validate SĐT người nhận
                if (ca.getPhoneNumber() == null || ca.getPhoneNumber().trim().isEmpty()) {
                    errors.add(prefix + "Số điện thoại người nhận không được để trống.");
                } else if (!ca.getPhoneNumber().trim().matches("^0\\d{9}$")) {
                    errors.add(prefix + "Số điện thoại người nhận phải gồm đúng 10 số và bắt đầu bằng 0.");
                }

                // Validate Địa chỉ chi tiết (Tỉnh, Huyện, Xã, Số nhà)
                Address a = ca.getAddress();
                if (a == null) {
                    errors.add(prefix + "Vui lòng nhập đầy đủ Tỉnh/Thành, Quận/Huyện, Phường/Xã và số nhà.");
                } else {
                    if (a.getProvince() == null || a.getProvince().trim().isEmpty()) {
                        errors.add(prefix + "Vui lòng chọn Tỉnh/Thành phố.");
                    }
                    if (a.getDistrict() == null || a.getDistrict().trim().isEmpty()) {
                        errors.add(prefix + "Vui lòng chọn Quận/Huyện.");
                    }
                    if (a.getWard() == null || a.getWard().trim().isEmpty()) {
                        errors.add(prefix + "Vui lòng chọn Phường/Xã.");
                    }
                    if (a.getDetailedAddress() == null || a.getDetailedAddress().trim().isEmpty()) {
                        errors.add(prefix + "Số nhà, tên đường không được để trống.");
                    }
                }
            }
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