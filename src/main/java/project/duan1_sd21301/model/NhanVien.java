package project.duan1_sd21301.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "nhan_vien")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class NhanVien {

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

    @Column(name = "ccod", length = 20) // CCCD / Căn cước
    String ccod;

    @Column(name = "luong")
    Double luong;

    @Column(name = "ngay_vao_lam")
    LocalDate ngayVaoLam;

    @Column(name = "anh_dai_dien", length = 500)
    String anhDaiDien;

    @Column(name = "vai_tro", length = 50, columnDefinition = "NVARCHAR(50)")
    String vaiTro; // ADMIN, NHAN_VIEN, QUAN_LY

    @Column(name = "trang_thai")
    Integer trangThai; // 1: Hoạt động, 0: Nghỉ việc

    // ===== Quan hệ 1-N =====
    @OneToMany(mappedBy = "nhanVien", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<HoaDon> hoaDonList;

    @OneToMany(mappedBy = "nguoiThucHien", fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<LichSuHoaDon> lichSuHoaDonList;
}
