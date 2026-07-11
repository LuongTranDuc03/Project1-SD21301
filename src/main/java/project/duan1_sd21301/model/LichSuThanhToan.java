package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Entity
@Table(name = "lich_su_thanh_toan")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class LichSuThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_hoa_don", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    HoaDon hoaDon;

    @Column(name = "ma_giao_dich_cong", length = 200)
    String maGiaoDichCong;

    @Column(name = "so_tien")
    Double soTien;

    @Column(name = "noi_dung", columnDefinition = "NVARCHAR(MAX)")
    String noiDung;

    @Column(name = "trang_thai")
    Integer trangThai; // 0: Thất bại, 1: Thành công

    @Column(name = "thoi_gian_giao_dich")
    LocalDateTime thoiGianGiaoDich;
}
