package project.duan1_sd21301.model.luong;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductDetail {
    private int id;
    private String productId;
    private String size;
    private String color;
    private String style;
    private double importPrice;
    private double price;

    private int stock;
    private double weight;
    private double length;
    private double width;
    private double thickness;
    private String status;
    private List<String> images; // Danh sách hình ảnh nối với chi tiết sản phẩm này
}
