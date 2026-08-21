package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.FieldDefaults;
import java.time.LocalDateTime;

@Entity
@Table(name = "thuong_hieu")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Brand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "thuong_hieu_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_thuong_hieu", length = 100, nullable = false, columnDefinition = "NVARCHAR(100)")
    String name;

    @Column(name = "logo", length = 500, columnDefinition = "NVARCHAR(500)")
    String logo;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}

