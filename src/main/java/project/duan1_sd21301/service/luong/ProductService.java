package project.duan1_sd21301.service.luong;

import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;

import java.util.List;

public interface ProductService {
    List<Product> getAllProducts();
    Product getProductById(int id);
    Product getProductByCode(String code);
    boolean addProduct(Product product);
    boolean updateProduct(Product product);
    boolean deleteProduct(int id);

    List<ProductDetail> getDetailsByProductId(int productId);
    ProductDetail getDetailById(int detailId);
    boolean addProductDetail(ProductDetail detail);
    boolean updateProductDetail(ProductDetail detail);
    boolean deleteProductDetail(int detailId);

    List<String> getAllCategories();
    List<String> getAllBrands();
    List<String> getAllColors();
    List<String> getAllSizes();
    List<String> getAllStyles();
}
