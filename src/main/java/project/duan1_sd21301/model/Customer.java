package project.duan1_sd21301.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Customer {
    private String id;                 // Khóa chính: id (Mã khách hàng)
    private String hoTen;              // ho_ten (Họ và tên)
    private String email;              // email (Địa chỉ email)
    private String matKhau;            // mat_khau (Mật khẩu)
    private String soDienThoai;        // so_dien_thoai (Số điện thoại)
    private Date ngaySinh;             // ngay_sinh (Ngày sinh)
    private String gioiTinh;           // gioi_tinh (Giới tính: "Nam", "Nữ", "Khác")
    private Integer diemTichLuy;       // diem_tich_luy (Điểm tích lũy)
    private String hangThanhVien;      // hang_thanh_vien (Hạng thành viên)
    private String anhDaiDien;         // anh_dai_dien (Đường dẫn ảnh đại diện)
    private String trangThai;          // trang_thai (Trạng thái)
    private Address diaChiMacDinh;     // Đối tượng Địa chỉ mặc định
    private List<Address> diaChiKhac;  // Danh sách đối tượng địa chỉ khác

    // Constructor mặc định (No-Args Constructor)
    public Customer() {
        this.diaChiKhac = new ArrayList<>();
    }

    // Constructor đầy đủ tham số (All-Args Constructor)
    public Customer(String id, String hoTen, String email, String matKhau, String soDienThoai, 
                    Date ngaySinh, String gioiTinh, Integer diemTichLuy, String hangThanhVien, 
                    String anhDaiDien, String trangThai, Address diaChiMacDinh, List<Address> diaChiKhac) {
        this.id = id;
        this.hoTen = hoTen;
        this.email = email;
        this.matKhau = matKhau;
        this.soDienThoai = soDienThoai;
        this.ngaySinh = ngaySinh;
        this.gioiTinh = gioiTinh;
        this.diemTichLuy = diemTichLuy;
        this.hangThanhVien = hangThanhVien;
        this.anhDaiDien = anhDaiDien;
        this.trangThai = trangThai;
        this.diaChiMacDinh = diaChiMacDinh;
        this.diaChiKhac = diaChiKhac != null ? diaChiKhac : new ArrayList<>();
    }

    // --- GETTERS & SETTERS ---
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public Date getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(Date ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(String gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public Integer getDiemTichLuy() {
        return diemTichLuy;
    }

    public void setDiemTichLuy(Integer diemTichLuy) {
        this.diemTichLuy = diemTichLuy;
    }

    public String getHangThanhVien() {
        return hangThanhVien;
    }

    public void setHangThanhVien(String hangThanhVien) {
        this.hangThanhVien = hangThanhVien;
    }

    public String getAnhDaiDien() {
        return anhDaiDien;
    }

    public void setAnhDaiDien(String anhDaiDien) {
        this.anhDaiDien = anhDaiDien;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Address getDiaChiMacDinh() {
        return diaChiMacDinh;
    }

    public void setDiaChiMacDinh(Address diaChiMacDinh) {
        this.diaChiMacDinh = diaChiMacDinh;
    }

    public List<Address> getDiaChiKhac() {
        return diaChiKhac;
    }

    public void setDiaChiKhac(List<Address> diaChiKhac) {
        this.diaChiKhac = diaChiKhac != null ? diaChiKhac : new ArrayList<>();
    }

    // --- CUSTOM BUILDER PATTERN TO KEEP CONTROLLER CODE COMPATIBLE ---
    public static CustomerBuilder builder() {
        return new CustomerBuilder();
    }

    public static class CustomerBuilder {
        private String id;
        private String hoTen;
        private String email;
        private String matKhau;
        private String soDienThoai;
        private Date ngaySinh;
        private String gioiTinh;
        private Integer diemTichLuy;
        private String hangThanhVien;
        private String anhDaiDien;
        private String trangThai;
        private Address diaChiMacDinh;
        private List<Address> diaChiKhac;

        public CustomerBuilder id(String id) {
            this.id = id;
            return this;
        }

        public CustomerBuilder hoTen(String hoTen) {
            this.hoTen = hoTen;
            return this;
        }

        public CustomerBuilder email(String email) {
            this.email = email;
            return this;
        }

        public CustomerBuilder matKhau(String matKhau) {
            this.matKhau = matKhau;
            return this;
        }

        public CustomerBuilder soDienThoai(String soDienThoai) {
            this.soDienThoai = soDienThoai;
            return this;
        }

        public CustomerBuilder ngaySinh(Date ngaySinh) {
            this.ngaySinh = ngaySinh;
            return this;
        }

        public CustomerBuilder gioiTinh(String gioiTinh) {
            this.gioiTinh = gioiTinh;
            return this;
        }

        public CustomerBuilder diemTichLuy(Integer diemTichLuy) {
            this.diemTichLuy = diemTichLuy;
            return this;
        }

        public CustomerBuilder hangThanhVien(String hangThanhVien) {
            this.hangThanhVien = hangThanhVien;
            return this;
        }

        public CustomerBuilder anhDaiDien(String anhDaiDien) {
            this.anhDaiDien = anhDaiDien;
            return this;
        }

        public CustomerBuilder trangThai(String trangThai) {
            this.trangThai = trangThai;
            return this;
        }

        public CustomerBuilder diaChiMacDinh(Address diaChiMacDinh) {
            this.diaChiMacDinh = diaChiMacDinh;
            return this;
        }

        public CustomerBuilder diaChiKhac(List<Address> diaChiKhac) {
            this.diaChiKhac = diaChiKhac;
            return this;
        }

        public Customer build() {
            return new Customer(id, hoTen, email, matKhau, soDienThoai, ngaySinh, 
                                gioiTinh, diemTichLuy, hangThanhVien, anhDaiDien, 
                                trangThai, diaChiMacDinh, diaChiKhac);
        }
    }
}
