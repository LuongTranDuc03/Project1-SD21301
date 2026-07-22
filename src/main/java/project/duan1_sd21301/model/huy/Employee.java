package project.duan1_sd21301.model.huy;

import project.duan1_sd21301.model.Address;
import java.util.Date;

public class Employee {
    private int id;
    private String code;        // code: mã hiển thị (NV001...)
    private String fullName;    // ho_ten
    private String email;
    private String password;    // mat_khau
    private String phoneNumber; // so_dien_thoai
    private Date birthday;      // ngay_sinh
    private Boolean gender;     // gioi_tinh: true=Nam, false=Nữ
    private String avatar;      // anh_dai_dien
    private int status;         // trang_thai: 1=Đang làm, 0=Nghỉ việc
    private Address addressObj; // Đối tượng DiaChi (bảng dia_chi 3NF)
    private String address;     // chuỗi địa chỉ tổng hợp
    private String cccd;        // can_cuoc_cong_dan
    private Role role;

    public Employee() {}

    public Employee(int id, String code, String fullName, String email, String password,
                    String phoneNumber, Date birthday, Boolean gender,
                    String avatar, int status, Address addressObj, String cccd, Role role) {
        this.id = id;
        this.code = code;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.birthday = birthday;
        this.gender = gender;
        this.avatar = avatar;
        this.status = status;
        this.addressObj = addressObj;
        this.cccd = cccd;
        this.role = role;
        if (addressObj != null) {
            this.address = addressObj.getFormattedAddress();
        }
    }

    public Employee(int id, String code, String fullName, String email, String password,
                    String phoneNumber, Date birthday, Boolean gender,
                    String avatar, int status, String address, String cccd, Role role) {
        this.id = id;
        this.code = code;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.birthday = birthday;
        this.gender = gender;
        this.avatar = avatar;
        this.status = status;
        this.address = address;
        this.cccd = cccd;
        this.role = role;
    }

    // ---- Getters & Setters ----

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

    public Date getBirthday() { return birthday; }
    public void setBirthday(Date birthday) { this.birthday = birthday; }

    public Boolean getGender() { return gender; }
    public void setGender(Boolean gender) { this.gender = gender; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Address getAddressObj() { return addressObj; }
    public void setAddressObj(Address addressObj) {
        this.addressObj = addressObj;
        if (addressObj != null) {
            this.address = addressObj.getFormattedAddress();
        }
    }

    public String getAddress() {
        if (addressObj != null) {
            return addressObj.getFormattedAddress();
        }
        return address;
    }
    public void setAddress(String address) { this.address = address; }

    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public int getRoleId() {
        return (role != null) ? role.getId() : 0;
    }

    public String getRoleName() {
        return (role != null && role.getRoleName() != null) ? role.getRoleName() : "";
    }
}
