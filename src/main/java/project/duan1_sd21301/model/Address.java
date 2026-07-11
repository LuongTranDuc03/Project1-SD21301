package project.duan1_sd21301.model;

public class Address {
    private String tenNguoiNhan;
    private String sdtNguoiNhan;
    private String chiTietDiaChi;

    // Constructor mặc định
    public Address() {}

    // Constructor đầy đủ tham số
    public Address(String tenNguoiNhan, String sdtNguoiNhan, String chiTietDiaChi) {
        this.tenNguoiNhan = tenNguoiNhan;
        this.sdtNguoiNhan = sdtNguoiNhan;
        this.chiTietDiaChi = chiTietDiaChi;
    }

    // --- GETTERS & SETTERS ---
    public String getTenNguoiNhan() {
        return tenNguoiNhan;
    }

    public void setTenNguoiNhan(String tenNguoiNhan) {
        this.tenNguoiNhan = tenNguoiNhan;
    }

    public String getSdtNguoiNhan() {
        return sdtNguoiNhan;
    }

    public void setSdtNguoiNhan(String sdtNguoiNhan) {
        this.sdtNguoiNhan = sdtNguoiNhan;
    }

    public String getChiTietDiaChi() {
        return chiTietDiaChi;
    }

    public void setChiTietDiaChi(String chiTietDiaChi) {
        this.chiTietDiaChi = chiTietDiaChi;
    }
}
