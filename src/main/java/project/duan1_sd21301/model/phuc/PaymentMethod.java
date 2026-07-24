package project.duan1_sd21301.model.phuc;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.FieldDefaults;
import java.time.LocalDateTime;

import java.util.List;

@Entity
@Table(name = "phuong_thuc_thanh_toan")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PaymentMethod {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "phuong_thuc_thanh_toan_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_phuong_thuc", nullable = false, length = 100)
    String name;

    @Column(name = "mo_ta", columnDefinition = "NVARCHAR(MAX)")
    String description;

    @Column(name = "logo", length = 500)
    String logo;

    @Column(name = "phi_thanh_toan")
    Double fee;

    @Column(name = "trang_thai")
    int status; // 1: Hoạt động, 0: Không hoạt động

    // Quan hệ 1-N với HoaDon 
    @OneToMany(mappedBy = "paymentMethod", fetch = FetchType.EAGER)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    List<Invoice> invoiceList;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}

