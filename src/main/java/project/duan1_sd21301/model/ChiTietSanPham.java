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

    // FK tới san_pham - dùng column thô để tránh phụ thuộc entity chưa có
    @Column(name = "id_san_pham")
    Integer idSanPham;

    @Column(name = "id_kich_thuoc")
    Integer idKichThuoc;

    @Column(name = "id_mau_sac")
    Integer idMauSac;

    @Column(name = "id_kieu_dang")
    Integer idKieuDang;

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

    // ===== Quan hệ 1-N =====
    @OneToMany(mappedBy = "chiTietSanPham", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<ChiTietHoaDon> chiTietHoaDonList;
}
