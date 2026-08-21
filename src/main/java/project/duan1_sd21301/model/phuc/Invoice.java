package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import project.duan1_sd21301.model.Address;
import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;
import project.duan1_sd21301.model.huy.Employee;

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

    @Column(name = "hoa_don_code", length = 50, nullable = false, unique = true)
    String code;

    // ===== Quan hệ khóa ngoại =====
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_khach_hang")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Customer customer;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_nhan_vien")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Employee employee;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_dia_chi")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Address address;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_phuong_thuc_thanh_toan")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    PaymentMethod paymentMethod;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_ma_giam_gia")
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    Coupon coupon;

    // ===== Thông tin đơn hàng =====
    @Column(name = "ngay_dat_hang")
    LocalDateTime orderDate;

    @Column(name = "ngay_xac_nhan")
    LocalDateTime confirmDate;

    @Column(name = "ngay_giao_du_kien")
    LocalDateTime expectedDeliveryDate;

    @Column(name = "ngay_hoan_thanh")
    LocalDateTime completionDate;

    @Column(name = "dia_chi_snapshot", columnDefinition = "NVARCHAR(MAX)")
    String addressSnapshot;

    @Column(name = "ten_khach_nhan", length = 150)
    String receiverName;

    @Column(name = "sdt_khach_nhan", length = 20)
    String receiverPhone;

    @Column(name = "dia_chi_khach_nhan", columnDefinition = "NVARCHAR(500)")
    String receiverAddress;

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

    @Column(name = "phi_van_chuyen")
    Double shippingFee;

    // ===== Trạng thái =====
    @Column(name = "loai_hoa_don")
    Integer orderType;

    @Column(name = "ghi_chu", columnDefinition = "NVARCHAR(MAX)")
    String note;

    @Column(name = "trang_thai_thanh_toan")
    Integer paymentStatus; // 0: Chưa thanh toán, 1: Đã thanh toán

    @Column(name = "trang_thai_don_hang")
    Integer orderStatus; // POS: 0: Chờ thanh toán, 1: Chờ giao hàng, 3: Hoàn thành, 4: Đã huỷ | Online: 0: Chờ xác nhận, 1: Đã xác nhận, 2: Đang giao, 3: Hoàn thành, 4: Đã huỷ, 5: Đã hoàn tiền

    @Column(name = "trang_thai")
    Integer status;

    @Column(name = "updated_at")
    @Builder.Default
    LocalDateTime updatedAt = LocalDateTime.now();

    // ===== Quan hệ =====
    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<InvoiceDetail> invoiceDetailList;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<PaymentHistory> paymentHistoryList;

    @OneToMany(mappedBy = "invoice", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<InvoiceHistory> invoiceHistoryList;

    @Transient
    public String getCustomerName() {
        if (customer != null && customer.getFullName() != null)
            return customer.getFullName();
        return receiverName;
    }

    @Transient
    public String getCustomerPhone() {
        if (customer != null && customer.getPhoneNumber() != null)
            return customer.getPhoneNumber();
        return receiverPhone;
    }

    @Transient
    public String getCustomerEmail() {
        if (customer != null && customer.getEmail() != null)
            return customer.getEmail();
        return "";
    }

    @Transient
    public String getCustomerAddress() {
        if (address != null && address.getFormattedAddress() != null)
            return address.getFormattedAddress();
        return receiverAddress != null ? receiverAddress : "";
    }
}
