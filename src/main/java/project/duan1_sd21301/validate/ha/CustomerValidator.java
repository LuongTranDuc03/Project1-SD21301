package project.duan1_sd21301.validate.ha;

import project.duan1_sd21301.model.ha.Customer;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Lớp chịu trách nhiệm xác thực dữ liệu đầu vào của Khách hàng trước khi lưu hoặc cập nhật.
 */
public class CustomerValidator {

    /**
     * Phương thức thực hiện kiểm tra tính hợp lệ của toàn bộ thông tin khách hàng nhập từ Form.
     *
     * @param id           Mã khách hàng cần kiểm tra
     * @param fullName     Họ và tên khách hàng
     * @param email        Địa chỉ email khách hàng
     * @param phone        Số điện thoại liên lạc
     * @param birthday     Ngày sinh
     * @param gender       Giới tính khách hàng
     * @param status       Trạng thái hoạt động
     * @param address      Địa chỉ mặc định chi tiết
     * @param customers    Danh sách khách hàng hiện có trong hệ thống (để kiểm tra trùng lặp)
     * @param isEdit       Trạng thái có phải là đang cập nhật khách hàng cũ hay không
     * @return Danh sách các chuỗi thông báo lỗi (ArrayList<String>). Rỗng nếu dữ liệu hợp lệ.
     */
    public static List<String> validate(
            String id,
            String fullName,
            String email,
            String phone,
            Date birthday,
            String gender,
            String status,
            String address,
            List<Customer> customers,
            boolean isEdit
    ) {

        List<String> errors = new ArrayList<>();

        // 1. Xác thực Mã khách hàng
        if (id == null || id.trim().isEmpty()) {
            errors.add("Mã khách hàng không được để trống.");
        } else {
            // Kiểm tra xem mã khách hàng nhập vào đã tồn tại trên tài khoản khác chưa
            if (customers != null) {
                for (Customer c : customers) {
                    // Nếu đang thêm mới (!isEdit) hoặc sửa đổi mã của chính họ nhưng bị trùng mã với người khác
                    if (!isEdit || !c.getId().equalsIgnoreCase(id)) {
                        if (c.getId().equalsIgnoreCase(id.trim())) {
                            errors.add("Mã khách hàng đã tồn tại.");
                            break;
                        }
                    }
                }
            }
        }

        // 2. Xác thực Họ tên khách hàng
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Họ tên không được để trống.");
        } else if (fullName.length() < 2 || fullName.length() > 50) {
            errors.add("Họ tên phải từ 2 đến 50 ký tự.");
        }

        // 3. Xác thực Email liên hệ
        if (email == null || email.trim().isEmpty()) {
            errors.add("Email không được để trống.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            errors.add("Email không đúng định dạng.");
        }

        // 4. Bỏ qua xác thực Mật khẩu đăng nhập vì không cần dùng nữa

        // 5. Xác thực Số điện thoại nhận hàng
        if (phone == null || phone.trim().isEmpty()) {
            errors.add("Số điện thoại không được để trống.");
        } else if (!phone.matches("^0\\d{9}$")) {
            errors.add("Số điện thoại phải gồm đúng 10 số.");
        }

        // 6. Xác thực Ngày tháng sinh nhật
        if (birthday == null) {
            errors.add("Ngày sinh không được để trống.");
        } else if (birthday.after(new Date())) {
            errors.add("Ngày sinh không hợp lệ.");
        }

        // 7. Xác thực các ô lựa chọn Giới tính
        if (gender == null || gender.trim().isEmpty()) {
            errors.add("Vui lòng chọn giới tính.");
        }


        // 9. Xác thực Trạng thái hoạt động
        if (status == null || status.trim().isEmpty()) {
            errors.add("Vui lòng chọn trạng thái.");
        }

        // 10. Xác thực Địa chỉ mặc định chi tiết
        if (address == null || address.trim().isEmpty()
                || address.trim().replaceAll("[,\\s]+", "").isEmpty()) {
            errors.add("Địa chỉ mặc định không được để trống hoặc không hợp lệ.");
        }

        // 11. Kiểm tra tính duy nhất (Không trùng lặp) của Email trong hệ thống
        if (customers != null) {
            for (Customer c : customers) {
                // Chỉ đối chiếu với các tài khoản khách hàng khác, loại trừ chính tài khoản đang sửa
                if (!isEdit || !c.getId().equals(id)) {
                    if (c.getEmail().equalsIgnoreCase(email)) {
                        errors.add("Email đã tồn tại.");
                        break;
                    }
                }
            }
        }

        // 12. Kiểm tra tính duy nhất (Không trùng lặp) của Số điện thoại trong hệ thống
        if (customers != null) {
            for (Customer c : customers) {
                // Chỉ đối chiếu với các tài khoản khách hàng khác, loại trừ chính tài khoản đang sửa
                if (!isEdit || !c.getId().equals(id)) {
                    if (c.getPhoneNumber().equals(phone)) {
                        errors.add("Số điện thoại đã tồn tại.");
                        break;
                    }
                }
            }
        }

        return errors;
    }
}