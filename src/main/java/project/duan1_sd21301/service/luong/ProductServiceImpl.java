package project.duan1_sd21301.service.luong;

import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.repository.luong.ProductRepository;
import project.duan1_sd21301.repository.luong.ProductRepositoryImpl;

import java.util.List;

public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepo = new ProductRepositoryImpl();

    @Override
    public List<Product> getAllProducts() {
        return productRepo.findAll();
    }

    @Override
    public Product getProductById(int id) {
        return productRepo.findById(id);
    }

    @Override
    public Product getProductByCode(String code) {
        return productRepo.findByCode(code);
    }

    @Override
    public boolean addProduct(Product product) {
        return productRepo.insert(product);
    }

    @Override
    public boolean updateProduct(Product product) {
        return productRepo.update(product);
    }

    @Override
    public boolean deleteProduct(int id) {
        return productRepo.delete(id);
    }

    @Override
    public List<ProductDetail> getDetailsByProductId(int productId) {
        return productRepo.findDetailsByProductId(productId);
    }

    @Override
    public ProductDetail getDetailById(int detailId) {
        return productRepo.findDetailById(detailId);
    }

    @Override
    public boolean addProductDetail(ProductDetail detail) {
        return productRepo.insertDetail(detail);
    }

    @Override
    public boolean updateProductDetail(ProductDetail detail) {
        return productRepo.updateDetail(detail);
    }

    @Override
    public boolean deleteProductDetail(int detailId) {
        return productRepo.deleteDetail(detailId);
    }

    @Override
    public List<String> getAllCategories() {
        return productRepo.findAllCategories();
    }

    @Override
    public List<String> getAllBrands() {
        return productRepo.findAllBrands();
    }

    @Override
    public List<String> getAllColors() {
        return productRepo.findAllColors();
    }

    @Override
    public List<String> getAllSizes() {
        return productRepo.findAllSizes();
    }

    @Override
    public List<String> getAllStyles() {
        return productRepo.findAllStyles();
    }

    @Override
    public List<String> getAllOrigins() {
        return productRepo.findAllOrigins();
    }
}
