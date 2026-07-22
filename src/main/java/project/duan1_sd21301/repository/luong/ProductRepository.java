package project.duan1_sd21301.repository.luong;

import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;

import java.util.List;

public interface ProductRepository {
    List<Product> findAll();
    Product findById(int id);
    Product findByCode(String code);
    boolean insert(Product product);
    boolean update(Product product);
    boolean delete(int id);

    List<ProductDetail> findDetailsByProductId(int productId);
    ProductDetail findDetailById(int detailId);
    boolean insertDetail(ProductDetail detail);
    boolean updateDetail(ProductDetail detail);
    boolean deleteDetail(int detailId);

    List<String> findAllCategories();
    List<String> findAllBrands();
    List<String> findAllColors();
    List<String> findAllSizes();
    List<String> findAllStyles();
}
