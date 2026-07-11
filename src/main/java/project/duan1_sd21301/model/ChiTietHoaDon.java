package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "chi_tiet_hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ChiTietHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_hoa_don", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    HoaDon hoaDon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_chi_tiet_san_pham")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    ChiTietSanPham chiTietSanPham;

    @Column(name = "don_gia")
    Double donGia;

    @Column(name = "gia_giam")
    Double giaGiam;

    @Column(name = "so_luong")
    Integer soLuong;

    @Column(name = "thanh_tien")
    Double thanhTien;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String ghiChu;
}
