package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.FieldDefaults;
import java.time.LocalDateTime;

@Entity
@Table(name = "hinh_anh")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "hinh_anh_code", length = 50, nullable = false, unique = true)
    String code;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_chi_tiet_san_pham", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    ProductDetail productDetail;

    @Column(name = "duong_dan", length = 500, columnDefinition = "NVARCHAR(500)")
    String url;

    @Column(name = "anh_chinh")
    @Builder.Default
    boolean isMain = false;

    @Column(name = "thu_tu")
    @Builder.Default
    int displayOrder = 1;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}

