package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class HoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    // ===== Quan hệ khóa ngoại =====
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_khach_hang")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    KhachHang khachHang;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_nhan_vien")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    NhanVien nhanVien;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_dia_chi")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    DiaChi diaChi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_phuong_thuc_thanh_toan")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    PhuongThucThanhToan phuongThucThanhToan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ma_giam_gia")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    PhieuGiamGia phieuGiamGia;

    // ===== Thông tin đơn hàng =====
    @Column(name = "ngay_dat_hang")
    LocalDateTime ngayDatHang;

    @Column(name = "ngay_xac_nhan")
    LocalDateTime ngayXacNhan;

    @Column(name = "ten_khach_hang", length = 150)
    String tenKhachHang;

    @Column(name = "sdt_khach_hang", length = 20)
    String sdtKhachHang;

    @Column(name = "email_khach_hang", length = 200)
    String emailKhachHang;

    @Column(name = "dia_chi_khach_hang", columnDefinition = "NVARCHAR(500)")
    String diaChiKhachHang;

    // ===== Thông tin tiền =====
    @Column(name = "tong_so_luong")
    Integer tongSoLuong;

    @Column(name = "tam_tinh")
    Double tamTinh;

    @Column(name = "tien_giam_hoa_don")
    Double tienGiamHoaDon;

    @Column(name = "tong_thanh_toan")
    Double tongThanhToan;

    @Column(name = "da_thanh_toan")
    Double daThanhToan;

    @Column(name = "lien_hoan")
    Double lienHoan;

    // ===== Trạng thái =====
    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String ghiChu;

    @Column(name = "trang_thai_thanh_toan")
    Integer trangThaiThanhToan; // 0: Chưa thanh toán, 1: Đã thanh toán

    @Column(name = "trang_thai_don_hang")
    Integer trangThaiDonHang; // 0: Chờ xử lý, 1: Đang giao, 2: Đã giao, 3: Huỷ

    @Column(name = "trang_thai")
    Integer trangThai; // 1: Active, 0: Inactive

    // ===== Quan hệ 1-N =====
    @OneToMany(mappedBy = "hoaDon", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<ChiTietHoaDon> chiTietHoaDonList;

    @OneToMany(mappedBy = "hoaDon", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<LichSuThanhToan> lichSuThanhToanList;

    @OneToMany(mappedBy = "hoaDon", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<LichSuHoaDon> lichSuHoaDonList;
}
