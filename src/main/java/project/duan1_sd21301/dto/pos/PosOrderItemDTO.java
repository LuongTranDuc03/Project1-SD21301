package project.duan1_sd21301.dto.pos;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class PosOrderItemDTO {
    private String code; // ChiTietSanPham code
    private String name;
    private String color;
    private String size;
    private Double price;
    private Integer quantity;
}
