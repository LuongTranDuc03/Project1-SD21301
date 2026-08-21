package project.duan1_sd21301.model.luong;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import lombok.experimental.FieldDefaults;
import java.time.LocalDateTime;

@Entity
@Table(name = "mau_sac")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Color {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "mau_sac_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_mau", length = 100, nullable = false, columnDefinition = "NVARCHAR(100)")
    String name;

    @Column(name = "ma_hex", length = 20)
    String hexCode;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "created_at")
    @Builder.Default
    LocalDateTime createdAt = LocalDateTime.now();
}

