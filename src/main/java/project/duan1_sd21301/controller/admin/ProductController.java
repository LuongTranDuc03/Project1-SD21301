package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Product;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ProductController", value = "/admin/products")
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> products = new ArrayList<>();
        
        products.add(new Product("SP001", "Áo khoác da", "Áo khoác da nam Premium", "Leather Jacket", 1850000.0, 2100000.0, -12, 48, 324, 4.8, "AVAILABLE", "#EC4899", Arrays.asList("#000000", "#8B4513", "#3D2314")));
        products.add(new Product("SP002", "Áo bomber", "Bomber jacket oversize unisex", "Bomber Jacket", 1290000.0, 0.0, 0, 32, 287, 4.7, "AVAILABLE", "#3B82F6", Arrays.asList("#1E3A1E", "#4A5D4E", "#800000")));
        products.add(new Product("SP003", "Áo denim", "Áo denim wash nữ vintage", "Denim Jacket", 890000.0, 1100000.0, -19, 15, 241, 4.5, "LOW_STOCK", "#60A5FA", Arrays.asList("#ADD8E6", "#000080", "#E0FFFF")));
        products.add(new Product("SP004", "Áo phao", "Áo phao siêu nhẹ unisex", "Puffer Jacket", 2100000.0, 0.0, 0, 61, 198, 4.9, "AVAILABLE", "#10B981", Arrays.asList("#000000", "#FFB6C1", "#0000FF", "#008000")));
        products.add(new Product("SP005", "Áo gió", "Khoác gió windbreaker nam", "Windbreaker", 1150000.0, 1350000.0, -15, 8, 156, 4.6, "LOW_STOCK", "#F59E0B", Arrays.asList("#FFA500", "#000080", "#008080")));
        products.add(new Product("SP006", "Áo khoác da", "Áo khoác da nữ Premium", "Women Leather", 1750000.0, 2200000.0, -20, 0, 412, 4.9, "OUT_OF_STOCK", "#F43F5E", Arrays.asList("#000000", "#8B4513")));
        products.add(new Product("SP007", "Áo bomber", "Bomber jacket slim fit nam", "Slim Bomber", 1190000.0, 0.0, 0, 45, 203, 4.7, "AVAILABLE", "#7F1D1D", Arrays.asList("#000000", "#4B5320", "#8B4513")));
        products.add(new Product("SP008", "Áo len", "Áo khoác len nữ thu đông", "Wool Coat", 990000.0, 1200000.0, -18, 28, 167, 4.8, "AVAILABLE", "#6D28D9", Arrays.asList("#D2691E", "#808080", "#FFFDD0", "#FFB6C1")));

        request.setAttribute("pageTitle", "Quản lý sản phẩm");
        request.setAttribute("products", products);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(request, response);
    }
}
