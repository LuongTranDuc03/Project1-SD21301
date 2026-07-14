package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "khach_hang")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class KhachHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;

    @Column(name = "ho_ten", nullable = false, length = 200, columnDefinition = "NVARCHAR(200)")
    String hoTen;

    @Column(name = "email", unique = true, length = 200)
    String email;

    @Column(name = "mat_khau", length = 500)
    String matKhau;

    @Column(name = "so_dien_thoai", length = 20)
    String soDienThoai;

    @Column(name = "ngay_sinh")
    LocalDate ngaySinh;

    @Column(name = "gioi_tinh")
    Boolean gioiTinh; // true: Nam, false: Nữ

    @Column(name = "anh_dai_dien", length = 500)
    String anhDaiDien;

    @Column(name = "trang_thai")
    Integer trangThai; // 1: Hoạt động, 0: Bị khóa

    // ===== Quan hệ 1-N =====
    @OneToMany(mappedBy = "khachHang", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<DiaChi> diaChiList;

    @OneToMany(mappedBy = "khachHang", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<HoaDon> hoaDonList;
}
