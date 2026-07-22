package project.duan1_sd21301.model.ha;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Customer {
    private int id;
    private String code;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private Date dateOfBirth;
    private String gender;
    private String avatar;
    private String status;

    // Danh sách tất cả địa chỉ của khách hàng (bảng trung gian khach_hang_dia_chi)
    private List<CustomerAddress> addresses;

    public Customer() {
        this.addresses = new ArrayList<>();
    }

    public Customer(int id, String code, String fullName, String email, String password,
                    String phoneNumber, Date dateOfBirth, String gender,
                    String avatar, String status, List<CustomerAddress> addresses) {
        this.id = id;
        this.code = code;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.avatar = avatar;
        this.status = status;
        this.addresses = addresses != null ? addresses : new ArrayList<>();
    }

    // Helper: lấy địa chỉ mặc định
    public CustomerAddress getDefaultAddress() {
        if (addresses == null) return null;
        for (CustomerAddress a : addresses) {
            if (a.isDefault()) return a;
        }
        return addresses.isEmpty() ? null : addresses.get(0);
    }

    // Helper: lấy danh sách địa chỉ phụ
    public List<CustomerAddress> getOtherAddresses() {
        List<CustomerAddress> others = new ArrayList<>();
        if (addresses == null) return others;
        CustomerAddress def = getDefaultAddress();
        for (CustomerAddress a : addresses) {
            if (a != def) others.add(a);
        }
        return others;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<CustomerAddress> getAddresses() { return addresses; }
    public void setAddresses(List<CustomerAddress> addresses) {
        this.addresses = addresses != null ? addresses : new ArrayList<>();
    }

    // Builder Pattern
    public static CustomerBuilder builder() {
        return new CustomerBuilder();
    }

    public static class CustomerBuilder {
        private int id;
        private String code;
        private String fullName;
        private String email;
        private String password;
        private String phoneNumber;
        private Date dateOfBirth;
        private String gender;
        private String avatar;
        private String status;
        private List<CustomerAddress> addresses;

        public CustomerBuilder id(int id) { this.id = id; return this; }
        public CustomerBuilder code(String code) { this.code = code; return this; }
        public CustomerBuilder fullName(String fullName) { this.fullName = fullName; return this; }
        public CustomerBuilder email(String email) { this.email = email; return this; }
        public CustomerBuilder password(String password) { this.password = password; return this; }
        public CustomerBuilder phoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; return this; }
        public CustomerBuilder dateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; return this; }
        public CustomerBuilder gender(String gender) { this.gender = gender; return this; }
        public CustomerBuilder avatar(String avatar) { this.avatar = avatar; return this; }
        public CustomerBuilder status(String status) { this.status = status; return this; }
        public CustomerBuilder addresses(List<CustomerAddress> addresses) { this.addresses = addresses; return this; }

        public Customer build() {
            return new Customer(id, code, fullName, email, password, phoneNumber,
                    dateOfBirth, gender, avatar, status, addresses);
        }
    }
}
