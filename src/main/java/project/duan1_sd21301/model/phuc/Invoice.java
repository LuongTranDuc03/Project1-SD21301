package project.duan1_sd21301.model.phuc;

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
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

//    // ===== Quan hệ khóa ngoại =====
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "id_khach_hang")
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    KhachHang khachHang;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "id_nhan_vien")
//    @ToString.Exclude
//    @EqualsAndHashCode.Exclude
//    NhanVien nhanVien;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_dia_chi")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Address address;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_phuong_thuc_thanh_toan")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    PaymentMethod paymentMethod;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ma_giam_gia")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Coupon coupon;

    // ===== Thông tin đơn hàng =====
    @Column(name = "ngay_dat_hang")
    LocalDateTime orderDate;

    @Column(name = "ngay_xac_nhan")
    LocalDateTime confirmDate;

    @Column(name = "ten_khach_hang", length = 150)
    String customerName;

    @Column(name = "sdt_khach_hang", length = 20)
    String customerPhone;

    @Column(name = "email_khach_hang", length = 200)
    String customerEmail;

    @Column(name = "dia_chi_khach_hang", columnDefinition = "NVARCHAR(500)")
    String customerAddress;

    // ===== Thông tin tiền =====
    @Column(name = "tong_so_luong")
    int totalQuantity;

    @Column(name = "tam_tinh")
    Double subtotal;

    @Column(name = "tien_giam_hoa_don")
    Double discountAmount;

    @Column(name = "tong_thanh_toan")
    Double totalAmount;

    @Column(name = "da_thanh_toan")
    Double paidAmount;

    @Column(name = "lien_hoan")
    Double refundAmount;

    // ===== Trạng thái =====
    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    @Column(name = "trang_thai_thanh_toan")
    Integer paymentStatus; // 0: Chưa thanh toán, 1: Đã thanh toán

    @Column(name = "trang_thai_don_hang")
    Integer orderStatus; // 0: Chờ xác nhận, 1: Đã xác nhận, 2: Hoàn thành, 3: Đã huỷ, 4: Đã hoàn tiền

    @Column(name = "trang_thai")
    Integer status;

    // ===== Quan hệ =====
    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<InvoiceDetail> invoiceDetailList;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<PaymentHistory> paymentHistoryList;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<InvoiceHistory> invoiceHistoryList;
}
