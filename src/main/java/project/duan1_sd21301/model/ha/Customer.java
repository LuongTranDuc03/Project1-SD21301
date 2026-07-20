package project.duan1_sd21301.model.ha;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

/**
 * Lớp đại diện cho thông tin tài khoản Khách hàng.
 * Tích hợp đầy đủ các thuộc tính thông tin cá nhân và quản lý sổ địa chỉ.
 */
public class Customer {
    // Mã duy nhất định danh khách hàng (Ví dụ: KH001, KH002)
    private String id;
    
    // Họ và tên đầy đủ của khách hàng
    private String fullName;
    
    // Email đăng nhập và nhận thông báo của khách hàng
    private String email;
    
    // Mật khẩu đăng nhập tài khoản khách hàng
    private String password;
    
    // Số điện thoại liên lạc
    private String phoneNumber;
    
    // Ngày tháng năm sinh
    private Date dateOfBirth;
    
    // Giới tính (Nam, Nữ, Khác)
    private String gender;
    

    // Đường dẫn ảnh đại diện của khách hàng (URL ảnh hoặc file uploads)
    private String avatar;
    
    // Trạng thái tài khoản (Hoạt động, Khóa)
    private String status;
    
    // Địa chỉ giao nhận mặc định của khách hàng
    private Address defaultAddress;
    
    // Danh sách các địa chỉ phụ khác của khách hàng
    private List<Address> otherAddresses;

    /**
     * Constructor mặc định không tham số.
     * Tự động khởi tạo danh sách địa chỉ phụ rỗng để tránh NullPointerException.
     */
    public Customer() {
        this.otherAddresses = new ArrayList<>();
    }

    /**
     * Constructor đầy đủ tham số để tạo nhanh một đối tượng khách hàng.
     */
    public Customer(String id, String fullName, String email, String password, String phoneNumber,
                    Date dateOfBirth, String gender, 
                    String avatar, String status, Address defaultAddress, List<Address> otherAddresses) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        
        
        this.avatar = avatar;
        this.status = status;
        this.defaultAddress = defaultAddress;
        this.otherAddresses = otherAddresses != null ? otherAddresses : new ArrayList<>();
    }

    // --- GETTERS & SETTERS (Các phương thức đọc/ghi dữ liệu cho thuộc tính) ---
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }



    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Address getDefaultAddress() {
        return defaultAddress;
    }

    public void setDefaultAddress(Address defaultAddress) {
        this.defaultAddress = defaultAddress;
    }

    public List<Address> getOtherAddresses() {
        return otherAddresses;
    }

    public void setOtherAddresses(List<Address> otherAddresses) {
        this.otherAddresses = otherAddresses != null ? otherAddresses : new ArrayList<>();
    }

    // --- BUILDER PATTERN (Hỗ trợ cú pháp tạo chuỗi khởi tạo đối tượng sạch hơn) ---
    public static CustomerBuilder builder() {
        return new CustomerBuilder();
    }

    /**
     * Lớp tĩnh phụ trợ thực thi Builder Pattern cho Customer.
     */
    public static class CustomerBuilder {
        private String id;
        private String fullName;
        private String email;
        private String password;
        private String phoneNumber;
        private Date dateOfBirth;
        private String gender;
        
        
        private String avatar;
        private String status;
        private Address defaultAddress;
        private List<Address> otherAddresses;

        public CustomerBuilder id(String id) {
            this.id = id;
            return this;
        }

        public CustomerBuilder fullName(String fullName) {
            this.fullName = fullName;
            return this;
        }

        public CustomerBuilder email(String email) {
            this.email = email;
            return this;
        }

        public CustomerBuilder password(String password) {
            this.password = password;
            return this;
        }

        public CustomerBuilder phoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber;
            return this;
        }

        public CustomerBuilder dateOfBirth(Date dateOfBirth) {
            this.dateOfBirth = dateOfBirth;
            return this;
        }

        public CustomerBuilder gender(String gender) {
            this.gender = gender;
            return this;
        }



        public CustomerBuilder avatar(String avatar) {
            this.avatar = avatar;
            return this;
        }

        public CustomerBuilder status(String status) {
            this.status = status;
            return this;
        }

        public CustomerBuilder defaultAddress(Address defaultAddress) {
            this.defaultAddress = defaultAddress;
            return this;
        }

        public CustomerBuilder otherAddresses(List<Address> otherAddresses) {
            this.otherAddresses = otherAddresses;
            return this;
        }

        /**
         * Xây dựng và trả về đối tượng Customer hoàn chỉnh dựa trên các thuộc tính đã gán.
         */
        public Customer build() {
            return new Customer(id, fullName, email, password, phoneNumber, dateOfBirth,
                    gender, avatar,
                    status, defaultAddress, otherAddresses);
        }
    }
}
