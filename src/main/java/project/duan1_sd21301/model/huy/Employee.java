package project.duan1_sd21301.model.huy;

import java.util.Date;

public class Employee {
    // ---- 14 cột DB ----
    private int id;
    private String maNhanVien; // ma_nhan_vien: số thứ tự tự sinh, khác id
    private int roleId; // id_vai_tro
    private String fullName; // ho_ten
    private String email;
    private String password; // mat_khau
    private String phoneNumber; // so_dien_thoai
    private Date birthday; // ngay_sinh
    private Boolean gender; // gioi_tinh: true=Nam, false=Nữ
    private String avatar; // anh_dai_dien
    private int status; // trang_thai: 1=Đang làm, 0=Nghỉ việc

    private String address; // dia_chi tong hop
    private String cccd; // can_cuoc_cong_dan

    // ---- Helper (lấy từ JOIN vai_tro, không lưu DB) ----
    private String roleName; // vai_tro.ten_vai_tro

    public Employee() {
    }

    public Employee(int id, int roleId, String fullName, String email, String password,
                    String phoneNumber, Date birthday, Boolean gender,
                    String avatar, int status, String address, String cccd) {
        this.id = id;
        this.roleId = roleId;
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
    }

    // ---- Getters & Setters ----
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMaNhanVien() {
        return maNhanVien;
    }

    public void setMaNhanVien(String maNhanVien) {
        this.maNhanVien = maNhanVien;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String v) {
        this.fullName = v;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String v) {
        this.email = v;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String v) {
        this.password = v;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String v) {
        this.phoneNumber = v;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date v) {
        this.birthday = v;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean v) {
        this.gender = v;
    }
    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String v) {
        this.avatar = v;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int v) {
        this.status = v;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String v) {
        this.address = v;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String v) {
        this.roleName = v;
    }
}
