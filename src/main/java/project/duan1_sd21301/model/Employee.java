package project.duan1_sd21301.model;

import java.util.Date;


public class Employee {
    // ---- 13 cột DB ----
    private String  id;
    private int     roleId;       // id_vai_tro
    private String  fullName;     // ho_ten
    private String  email;
    private String  password;     // mat_khau
    private String  phoneNumber;  // so_dien_thoai
    private Date    birthday;     // ngay_sinh
    private Boolean gender;       // gioi_tinh: true=Nam, false=Nữ
    private String  cccd;
    private double  salary;       // luong
    private Date    hireDate;     // ngay_vao_lam
    private String  avatar;       // anh_dai_dien
    private int     status;       // trang_thai: 1=Đang làm, 0=Nghỉ việc

    private String  address;      // dia_chi

    // ---- Helper (lấy từ JOIN vai_tro, không lưu DB) ----
    private String roleName;      // vai_tro.ten_vai_tro

    public Employee() {}

    public Employee(String id, int roleId, String fullName, String email, String password,
                    String phoneNumber, Date birthday, Boolean gender, String cccd,
                    double salary, Date hireDate, String avatar, int status, String address) {
        this.id          = id;
        this.roleId      = roleId;
        this.fullName    = fullName;
        this.email       = email;
        this.password    = password;
        this.phoneNumber = phoneNumber;
        this.birthday    = birthday;
        this.gender      = gender;
        this.cccd        = cccd;
        this.salary      = salary;
        this.hireDate    = hireDate;
        this.avatar      = avatar;
        this.status      = status;
        this.address     = address;
    }

    // ---- Getters & Setters ----
    public String getId()                  { return id; }
    public void   setId(String id)         { this.id = id; }

    public int  getRoleId()                { return roleId; }
    public void setRoleId(int roleId)      { this.roleId = roleId; }

    public String getFullName()            { return fullName; }
    public void   setFullName(String v)    { this.fullName = v; }

    public String getEmail()               { return email; }
    public void   setEmail(String v)       { this.email = v; }

    public String getPassword()            { return password; }
    public void   setPassword(String v)    { this.password = v; }

    public String getPhoneNumber()         { return phoneNumber; }
    public void   setPhoneNumber(String v) { this.phoneNumber = v; }

    public Date getBirthday()              { return birthday; }
    public void setBirthday(Date v)        { this.birthday = v; }

    public Boolean getGender()             { return gender; }
    public void    setGender(Boolean v)    { this.gender = v; }

    public String getCccd()               { return cccd; }
    public void   setCccd(String v)       { this.cccd = v; }

    public double getSalary()              { return salary; }
    public void   setSalary(double v)      { this.salary = v; }

    public Date getHireDate()              { return hireDate; }
    public void setHireDate(Date v)        { this.hireDate = v; }

    public String getAvatar()              { return avatar; }
    public void   setAvatar(String v)      { this.avatar = v; }

    public int  getStatus()                { return status; }
    public void setStatus(int v)           { this.status = v; }

    public String getAddress()             { return address; }
    public void   setAddress(String v)     { this.address = v; }

    public String getRoleName()            { return roleName; }
    public void   setRoleName(String v)    { this.roleName = v; }
}
