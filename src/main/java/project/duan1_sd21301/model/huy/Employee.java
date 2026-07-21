package project.duan1_sd21301.model.huy;

import java.util.Date;

public class Employee {
    private int id;
    private String maNhanVien;  // ma_nhan_vien: mã hiển thị (NV001...)
    private String fullName;    // ho_ten
    private String email;
    private String password;    // mat_khau
    private String phoneNumber; // so_dien_thoai
    private Date birthday;      // ngay_sinh
    private Boolean gender;     // gioi_tinh: true=Nam, false=Nữ
    private String avatar;      // anh_dai_dien
    private int status;         // trang_thai: 1=Đang làm, 0=Nghỉ việc
    private String address;     // dia_chi tong hop
    private String cccd;        // can_cuoc_cong_dan

    /**
     * Đối tượng vai trò (quan hệ 1-1 với bảng vai_tro).
     * Được populate sau khi JOIN trong Repository.
     */
    private Role role;

    public Employee() {}

    public Employee(int id, String maNhanVien, String fullName, String email, String password,
                    String phoneNumber, Date birthday, Boolean gender,
                    String avatar, int status, String address, String cccd, Role role) {
        this.id = id;
        this.maNhanVien = maNhanVien;
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

    public String getMaNhanVien() { return maNhanVien; }
    public void setMaNhanVien(String maNhanVien) { this.maNhanVien = maNhanVien; }

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

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCccd() { return cccd; }
    public void setCccd(String cccd) { this.cccd = cccd; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    // ---- Convenience helpers (tránh NullPointerException khi role chưa được load) ----

    /**
     * Trả về id của vai trò. Trả về 0 nếu chưa có vai trò.
     */
    public int getRoleId() {
        return (role != null) ? role.getId() : 0;
    }

    /**
     * Trả về tên vai trò. Trả về chuỗi rỗng nếu chưa có vai trò.
     */
    public String getRoleName() {
        return (role != null && role.getRoleName() != null) ? role.getRoleName() : "";
    }
}
