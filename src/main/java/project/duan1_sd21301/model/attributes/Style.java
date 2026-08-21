package project.duan1_sd21301.model.attributes;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import java.util.Date;

@Entity
@Table(name = "kieu_dang")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Style {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int id;

    @Column(name = "kieu_dang_code", length = 50, nullable = false, unique = true)
    String code;

    @Column(name = "ten_kieu_dang", length = 100, nullable = false)
    String name;

    @Column(name = "trang_thai")
    @Builder.Default
    Integer status = 1;

    @Column(name = "created_at", insertable = false, updatable = false)
    Date createdAt;
}

