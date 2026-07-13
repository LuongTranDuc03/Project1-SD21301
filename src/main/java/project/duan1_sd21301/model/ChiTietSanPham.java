package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "chi_tiet_san_pham")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ChiTietSanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    // ===== Quan hệ N-1 với SanPham =====
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_san_pham")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    SanPham sanPham;

    @Column(name = "mau_sac", length = 100, columnDefinition = "NVARCHAR(100)")
    String mauSac;

    @Column(name = "kich_thuoc", length = 20)
    String kichThuoc; // S, M, L, XL, XXL

    @Column(name = "kieu_dang", length = 100, columnDefinition = "NVARCHAR(100)")
    String kieuDang; // Slim-fit, Oversize, Classic, ...

    @Column(name = "gia_nhap")
    Double giaNhap;

    @Column(name = "gia_ban")
    Double giaBan;

    @Column(name = "gia_khuyen_mai")
    Double giaKhuyenMai;

    @Column(name = "so_luong_ton")
    Integer soLuongTon;

    @Column(name = "trong_luong")
    Double trongLuong;

    @Column(name = "chieu_dai")
    Double chieuDai;

    @Column(name = "chieu_rong")
    Double chieuRong;

    @Column(name = "do_day")
    Double doDai;

    @Column(name = "trang_thai")
    Integer trangThai; // 1: Đang bán, 0: Ngừng bán

    // ===== Quan hệ 1-N với ChiTietHoaDon =====
    @OneToMany(mappedBy = "chiTietSanPham", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<ChiTietHoaDon> chiTietHoaDonList;
}
