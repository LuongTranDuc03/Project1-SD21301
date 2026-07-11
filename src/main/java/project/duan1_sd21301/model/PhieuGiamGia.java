package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "phieu_giam_gia")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PhieuGiamGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    @Column(name = "ten_chuong_trinh", nullable = false, length = 200, columnDefinition = "NVARCHAR(200)")
    String tenChuongTrinh;

    @Column(name = "loai_giam", length = 50)
    String loaiGiam; // PHAN_TRAM, SO_TIEN_CO_DINH

    @Column(name = "gia_tri_giam")
    Double giaTriGiam;

    @Column(name = "gia_tri_don_hang_toi_thieu")
    Double giaTriDonHangToiThieu;

    @Column(name = "giam_toi_da")
    Double giamToiDa;

    @Column(name = "so_luong")
    Integer soLuong;

    @Column(name = "da_su_dung")
    Integer daSuDung;

    @Column(name = "ngay_bat_dau")
    LocalDateTime ngayBatDau;

    @Column(name = "ngay_ket_thuc")
    LocalDateTime ngayKetThuc;

    @Column(name = "mo_ta", columnDefinition = "NVARCHAR(MAX)")
    String moTa;

    @Column(name = "trang_thai")
    Integer trangThai; // 1: Còn hiệu lực, 0: Hết hạn

    // ===== Quan hệ 1-N =====
    @OneToMany(mappedBy = "phieuGiamGia", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<HoaDon> hoaDonList;
}
