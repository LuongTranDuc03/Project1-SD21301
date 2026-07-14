package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Product;
<<<<<<< HEAD
=======
import project.duan1_sd21301.model.ProductDetail;
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ProductController", value = "/admin/products")
public class ProductController extends HttpServlet {

<<<<<<< HEAD
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
=======
        @SuppressWarnings("unchecked")
        private List<Product> getProductsList(HttpServletRequest request) {
                jakarta.servlet.http.HttpSession session = request.getSession();
                List<Product> products = (List<Product>) session.getAttribute("products");
                if (products == null) {
                        products = new ArrayList<>();

                        // SP001
                        List<ProductDetail> details1 = new ArrayList<>();
                        details1.add(ProductDetail.builder()
                                        .id(1).productId("SP001").size("M").color("Đen").style("Slim-fit")
                                        .importPrice(500000.0).price(950000.0).promoPrice(850000.0).stock(20)
                                        .weight(0.8).length(95.0).width(48.0).thickness(2.5)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh1.png", "anh2.png")).build());
                        details1.add(ProductDetail.builder()
                                        .id(2).productId("SP001").size("L").color("Be").style("Oversize")
                                        .importPrice(500000.0).price(950000.0).promoPrice(850000.0).stock(28)
                                        .weight(0.85).length(98.0).width(50.0).thickness(2.5)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh3.png")).build());

                        products.add(Product.builder()
                                        .id("SP001").category("Áo khoác da").name("Áo khoác da nam Premium")
                                        .englishName("Leather Jacket")
                                        .price(1850000.0).oldPrice(2100000.0).discountPercent(-12).stock(48).sold(324)
                                        .rating(4.8)
                                        .brand("FamiCoats").origin("Việt Nam").warranty("12 tháng")
                                        .careInstructions(
                                                        "Chỉ giặt khô, không giặt máy. Tránh ánh nắng trực tiếp, bảo quản nơi khô ráo, thoáng mát.")
                                        .description("Áo khoác da nam chất liệu da cừu tự nhiên cao cấp, bề mặt da mềm mịn, có khả năng chắn gió và giữ ấm cực tốt. Thiết kế slim-fit hiện đại, tôn dáng người mặc.")
                                        .status("AVAILABLE").bgColor("#EC4899")
                                        .colorCircles(Arrays.asList("#000000", "#8B4513", "#3D2314"))
                                        .details(details1).build());

                        // SP002
                        List<ProductDetail> details2 = new ArrayList<>();
                        details2.add(ProductDetail.builder()
                                        .id(3).productId("SP002").size("L").color("Navy").style("Classic")
                                        .importPrice(400000.0).price(799000.0).promoPrice(699000.0).stock(18)
                                        .weight(1.1).length(75.0).width(60.0).thickness(5.0)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh4.png")).build());
                        details2.add(ProductDetail.builder()
                                        .id(4).productId("SP002").size("XL").color("Đen").style("Classic")
                                        .importPrice(400000.0).price(799000.0).promoPrice(749000.0).stock(14)
                                        .weight(1.2).length(78.0).width(62.0).thickness(5.0)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh5.png")).build());

                        products.add(Product.builder()
                                        .id("SP002").category("Áo bomber").name("Bomber jacket oversize unisex")
                                        .englishName("Bomber Jacket")
                                        .price(1290000.0).oldPrice(0.0).discountPercent(0).stock(32).sold(287)
                                        .rating(4.7)
                                        .brand("Zara").origin("Nhập khẩu").warranty("6 tháng")
                                        .careInstructions(
                                                        "Giặt máy chế độ nhẹ với nước ấm, dùng túi giặt. Không tẩy trắng, phơi nơi râm mát.")
                                        .description("Áo bomber form rộng thời trang unisex thích hợp cho cả nam và nữ. Lớp lót gió dày dặn, bo chun cổ tay và gấu áo chắc chắn, chống gió hiệu quả trong mùa lạnh.")
                                        .status("AVAILABLE").bgColor("#3B82F6")
                                        .colorCircles(Arrays.asList("#1E3A1E", "#4A5D4E", "#800000"))
                                        .details(details2).build());

                        // SP003
                        List<ProductDetail> details3 = new ArrayList<>();
                        details3.add(ProductDetail.builder()
                                        .id(5).productId("SP003").size("M").color("Đen").style("Vintage")
                                        .importPrice(600000.0).price(1200000.0).promoPrice(1050000.0).stock(10)
                                        .weight(0.9).length(100.0).width(52.0).thickness(1.8)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh6.png")).build());
                        details3.add(ProductDetail.builder()
                                        .id(6).productId("SP003").size("L").color("Navy").style("Vintage")
                                        .importPrice(600000.0).price(1200000.0).promoPrice(0.0).stock(5)
                                        .weight(0.95).length(103.0).width(54.0).thickness(1.8)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh7.png")).build());

                        products.add(Product.builder()
                                        .id("SP003").category("Áo denim").name("Áo denim wash nữ vintage")
                                        .englishName("Denim Jacket")
                                        .price(890000.0).oldPrice(1100000.0).discountPercent(-19).stock(15).sold(241)
                                        .rating(4.5)
                                        .brand("Levi's").origin("Việt Nam").warranty("3 tháng")
                                        .careInstructions(
                                                        "Giặt riêng bằng tay hoặc máy chế độ thường, lộn trái khi giặt và phơi để giữ màu wash.")
                                        .description("Áo khoác bò denim dáng lửng phong cách retro vintage cho nữ. Chất bò dày dặn, wash màu tự nhiên cá tính, bền màu sau nhiều lần giặt.")
                                        .status("LOW_STOCK").bgColor("#60A5FA")
                                        .colorCircles(Arrays.asList("#ADD8E6", "#000080", "#E0FFFF"))
                                        .details(details3).build());

                        // SP004
                        List<ProductDetail> details4 = new ArrayList<>();
                        details4.add(ProductDetail.builder()
                                        .id(7).productId("SP004").size("S").color("Đỏ đô").style("Blocktech")
                                        .importPrice(250000.0).price(499000.0).promoPrice(0.0).stock(30)
                                        .weight(0.3).length(65.0).width(45.0).thickness(0.8)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh8.png")).build());
                        details4.add(ProductDetail.builder()
                                        .id(8).productId("SP004").size("M").color("Navy").style("Blocktech")
                                        .importPrice(250000.0).price(499000.0).promoPrice(449000.0).stock(31)
                                        .weight(0.32).length(68.0).width(47.0).thickness(0.8)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh9.png")).build());

                        products.add(Product.builder()
                                        .id("SP004").category("Áo phao").name("Áo phao siêu nhẹ unisex")
                                        .englishName("Puffer Jacket")
                                        .price(2100000.0).oldPrice(0.0).discountPercent(0).stock(61).sold(198)
                                        .rating(4.9)
                                        .brand("Uniqlo").origin("Nhật Bản").warranty("6 tháng")
                                        .careInstructions(
                                                        "Giặt tay nhẹ nhàng bằng nước lạnh với dầu gội đầu. Tránh giặt khô hoặc vắt xoắn mạnh.")
                                        .description("Áo phao lông vũ siêu nhẹ, cản gió cản nước nhẹ vượt trội. Thiết kế gấp gọn tiện lợi mang đi du lịch hoặc di chuyển hàng ngày.")
                                        .status("AVAILABLE").bgColor("#10B981")
                                        .colorCircles(Arrays.asList("#000000", "#FFB6C1", "#0000FF", "#008000"))
                                        .details(details4).build());

                        // SP005
                        List<ProductDetail> details5 = new ArrayList<>();
                        details5.add(ProductDetail.builder()
                                        .id(9).productId("SP005").size("M").color("Đen").style("Casual")
                                        .importPrice(300000.0).price(599000.0).promoPrice(0.0).stock(3)
                                        .weight(0.6).length(72.0).width(50.0).thickness(1.2)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh10.png")).build());
                        details5.add(ProductDetail.builder()
                                        .id(10).productId("SP005").size("L").color("Be").style("Casual")
                                        .importPrice(300000.0).price(599000.0).promoPrice(529000.0).stock(5)
                                        .weight(0.63).length(74.0).width(52.0).thickness(1.2)
                                        .status("Hoạt động")
                                        .images(Arrays.asList("anh10.png")).build());

                        products.add(Product.builder()
                                        .id("SP005").category("Áo gió").name("Khoác gió windbreaker nam")
                                        .englishName("Windbreaker")
                                        .price(1150000.0).oldPrice(1350000.0).discountPercent(-15).stock(8).sold(156)
                                        .rating(4.6)
                                        .brand("The North Face").origin("Việt Nam").warranty("12 tháng")
                                        .careInstructions(
                                                        "Giặt máy bằng nước lạnh với bột giặt nhẹ. Không ủi ở nhiệt độ cao.")
                                        .description("Áo gió thể thao nam chống nước nhẹ, cản gió 100%. Lớp lót lưới thoáng khí hạn chế bí mồ hôi khi hoạt động ngoài trời.")
                                        .status("LOW_STOCK").bgColor("#F59E0B")
                                        .colorCircles(Arrays.asList("#FFA500", "#000080", "#008080"))
                                        .details(details5).build());

                        // SP006
                        products.add(Product.builder()
                                        .id("SP006").category("Áo khoác da").name("Áo khoác da nữ Premium")
                                        .englishName("Women Leather")
                                        .price(1750000.0).oldPrice(2200000.0).discountPercent(-20).stock(0).sold(412)
                                        .rating(4.9)
                                        .brand("FamiCoats").origin("Việt Nam").warranty("12 tháng")
                                        .careInstructions(
                                                        "Chỉ giặt khô chuyên nghiệp. Dùng khăn mềm ẩm để lau các vết bẩn nhẹ trên bề mặt da.")
                                        .description("Phiên bản áo da cừu cao cấp dành riêng cho nữ, kiểu dáng biker cá tính, khóa kéo kim loại không gỉ sang trọng.")
                                        .status("OUT_OF_STOCK").bgColor("#F43F5E")
                                        .colorCircles(Arrays.asList("#000000", "#8B4513"))
                                        .details(new ArrayList<>()).build());

                        // SP007
                        products.add(Product.builder()
                                        .id("SP007").category("Áo bomber").name("Bomber jacket slim fit nam")
                                        .englishName("Slim Bomber")
                                        .price(1190000.0).oldPrice(0.0).discountPercent(0).stock(45).sold(203)
                                        .rating(4.7)
                                        .brand("H&M").origin("Việt Nam").warranty("6 tháng")
                                        .careInstructions(
                                                        "Giặt máy ở nhiệt độ bình thường, lộn trái áo khi phơi để giữ độ bền cho bo chun cổ tay.")
                                        .description("Áo khoác bomber dáng ôm nam tính lịch lãm, dễ dàng phối cùng áo phông và quần jeans đơn giản.")
                                        .status("AVAILABLE").bgColor("#7F1D1D")
                                        .colorCircles(Arrays.asList("#000000", "#4B5320", "#8B4513"))
                                        .details(new ArrayList<>()).build());

                        // SP008
                        products.add(Product.builder()
                                        .id("SP008").category("Áo len").name("Áo khoác len nữ thu đông")
                                        .englishName("Wool Coat")
                                        .price(990000.0).oldPrice(1200000.0).discountPercent(-18).stock(28).sold(167)
                                        .rating(4.8)
                                        .brand("Cardina").origin("Việt Nam").warranty("3 tháng")
                                        .careInstructions(
                                                        "Giặt tay nhẹ nhàng bằng dầu gội hoặc nước giặt chuyên dụng cho đồ len. Phơi nằm ngang.")
                                        .description("Chất liệu len dệt sợi cao cấp mềm mại, co giãn tốt, không xù lông. Giữ ấm cơ thể hiệu quả trong thời tiết se lạnh đầu đông.")
                                        .status("AVAILABLE").bgColor("#6D28D9")
                                        .colorCircles(Arrays.asList("#D2691E", "#808080", "#FFFDD0", "#FFB6C1"))
                                        .details(new ArrayList<>()).build());

                        session.setAttribute("products", products);
                }
                return products;
        }

        private int getNextDetailId(List<Product> products) {
                int maxId = 0;
                for (Product p : products) {
                        if (p.getDetails() != null) {
                                for (ProductDetail d : p.getDetails()) {
                                        if (d.getId() > maxId) {
                                                maxId = d.getId();
                                        }
                                }
                        }
                }
                return maxId + 1;
        }

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

                List<Product> products = getProductsList(request);

                String action = request.getParameter("action");
                if ("add".equals(action)) {
                        request.setAttribute("pageTitle", "Thêm sản phẩm mới");
                        request.getRequestDispatcher("/WEB-INF/views/admin/product-add.jsp").forward(request, response);
                        return;
                } else if ("edit".equals(action)) {
                        String productId = request.getParameter("id");
                        if (productId != null) {
                                Product targetProduct = null;
                                for (Product p : products) {
                                        if (p.getId().equals(productId)) {
                                                targetProduct = p;
                                                break;
                                        }
                                }
                                if (targetProduct != null) {
                                        request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm " + productId);
                                        request.setAttribute("product", targetProduct);
                                        request.getRequestDispatcher("/WEB-INF/views/admin/product-add.jsp").forward(request, response);
                                        return;
                                }
                        }
                }

                String productId = request.getParameter("id");
                if (productId != null) {
                        Product targetProduct = null;
                        for (Product p : products) {
                                if (p.getId().equals(productId)) {
                                        targetProduct = p;
                                        break;
                                }
                        }
                        if (targetProduct != null) {
                                request.setAttribute("pageTitle", "Chi tiết sản phẩm " + productId);
                                request.setAttribute("product", targetProduct);
                                request.getRequestDispatcher("/WEB-INF/views/admin/product-detail.jsp").forward(request,
                                                response);
                                return;
                        }
                }

                request.setAttribute("pageTitle", "Quản lý sản phẩm");
                request.setAttribute("products", products);

                request.getRequestDispatcher("/WEB-INF/views/admin/product-list.jsp").forward(request, response);
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {
                request.setCharacterEncoding("UTF-8");
                List<Product> products = getProductsList(request);

                String action = request.getParameter("action");
                if ("updateVariant".equals(action)) {
                        String productId = request.getParameter("productId");
                        String variantIdStr = request.getParameter("variantId");
                        if (productId != null && variantIdStr != null) {
                                try {
                                        int variantId = Integer.parseInt(variantIdStr);
                                        Product targetProduct = null;
                                        for (Product p : products) {
                                                if (p.getId().equals(productId)) {
                                                        targetProduct = p;
                                                        break;
                                                }
                                        }
                                        if (targetProduct != null && targetProduct.getDetails() != null) {
                                                for (ProductDetail detail : targetProduct.getDetails()) {
                                                        if (detail.getId() == variantId) {
                                                                detail.setColor(request.getParameter("color"));
                                                                detail.setSize(request.getParameter("size"));
                                                                detail.setStyle(request.getParameter("style"));
                                                                try {
                                                                        detail.setImportPrice(Double.parseDouble(request.getParameter("importPrice")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setPrice(Double.parseDouble(request.getParameter("price")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setPromoPrice(Double.parseDouble(request.getParameter("promoPrice")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setStock(Integer.parseInt(request.getParameter("stock")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setWeight(Double.parseDouble(request.getParameter("weight")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setLength(Double.parseDouble(request.getParameter("length")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setWidth(Double.parseDouble(request.getParameter("width")));
                                                                } catch (Exception e) {}
                                                                try {
                                                                        detail.setThickness(Double.parseDouble(request.getParameter("thickness")));
                                                                } catch (Exception e) {}
                                                                detail.setStatus(request.getParameter("status"));
                                                                String imagesParam = request.getParameter("images");
                                                                if (imagesParam != null) {
                                                                        if (imagesParam.trim().isEmpty()) {
                                                                                detail.setImages(new ArrayList<>());
                                                                        } else {
                                                                                detail.setImages(new ArrayList<>(Arrays.asList(imagesParam.split(","))));
                                                                        }
                                                                }
                                                                break;
                                                        }
                                                }
                                                // Recalculate product fields
                                                double minPrice = Double.MAX_VALUE;
                                                double maxPrice = 0.0;
                                                int totalStock = 0;
                                                for (ProductDetail detail : targetProduct.getDetails()) {
                                                        double p = detail.getPrice();
                                                        if (p < minPrice) minPrice = p;
                                                        if (p > maxPrice) maxPrice = p;
                                                        totalStock += detail.getStock();
                                                }
                                                if (targetProduct.getDetails().isEmpty()) {
                                                        minPrice = 0.0;
                                                        maxPrice = 0.0;
                                                }
                                                targetProduct.setPrice(minPrice);
                                                targetProduct.setOldPrice(maxPrice > minPrice ? maxPrice : 0.0);
                                                targetProduct.setStock(totalStock);
                                                targetProduct.setColorCircles(buildColorCircles(targetProduct.getDetails()));
                                        }
                                } catch (Exception e) {
                                        e.printStackTrace();
                                }
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/products?id=" + productId);
                        return;
                }

                String id = request.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                        id = "SP" + String.format("%03d", products.size() + 1);
                }
                String name = request.getParameter("name");
                String englishName = "";
                String category = request.getParameter("category");
                String brand = request.getParameter("brand");
                String origin = request.getParameter("origin");
                String warranty = request.getParameter("warranty");
                String careInstructions = request.getParameter("careInstructions");
                String description = request.getParameter("description");
                String status = request.getParameter("status");
                String bgColor = "#3B82F6";

                // Read variants
                String[] sizes = request.getParameterValues("variantSize");
                String[] colors = request.getParameterValues("variantColor");
                String[] styles = request.getParameterValues("variantStyle");
                String[] importPrices = request.getParameterValues("variantImportPrice");
                String[] prices = request.getParameterValues("variantPrice");
                String[] promoPrices = request.getParameterValues("variantPromoPrice");
                String[] stocks = request.getParameterValues("variantStock");
                String[] weights = request.getParameterValues("variantWeight");
                String[] lengths = request.getParameterValues("variantLength");
                String[] widths = request.getParameterValues("variantWidth");
                String[] thicknesses = request.getParameterValues("variantThickness");
                String[] variantStatuses = request.getParameterValues("variantStatus");
                String[] variantImages = request.getParameterValues("variantImage");

                List<ProductDetail> details = new ArrayList<>();
                int nextDetailId = getNextDetailId(products);

                double minPrice = Double.MAX_VALUE;
                double maxPrice = 0.0;
                int totalStock = 0;

                if (sizes != null) {
                        for (int i = 0; i < sizes.length; i++) {
                                double ip = 0.0;
                                double p = 0.0;
                                double pp = 0.0;
                                int st = 0;
                                double w = 0.0;
                                double l = 0.0;
                                double wd = 0.0;
                                double th = 0.0;

                                try {
                                        ip = Double.parseDouble(importPrices[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        p = Double.parseDouble(prices[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        if (promoPrices != null && promoPrices.length > i) {
                                                pp = Double.parseDouble(promoPrices[i]);
                                        }
                                } catch (Exception e) {
                                }
                                try {
                                        st = Integer.parseInt(stocks[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        w = Double.parseDouble(weights[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        l = Double.parseDouble(lengths[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        wd = Double.parseDouble(widths[i]);
                                } catch (Exception e) {
                                }
                                try {
                                        th = Double.parseDouble(thicknesses[i]);
                                } catch (Exception e) {
                                }

                                if (p < minPrice)
                                        minPrice = p;
                                if (p > maxPrice)
                                        maxPrice = p;
                                totalStock += st;

                                String imgStr = (variantImages != null && variantImages.length > i) ? variantImages[i]
                                                : "anh-default.png";
                                List<String> imgList = new ArrayList<>();
                                if (imgStr != null && !imgStr.trim().isEmpty()) {
                                        for (String s : imgStr.split(",")) {
                                                if (!s.trim().isEmpty()) {
                                                        imgList.add(s.trim());
                                                }
                                        }
                                }
                                if (imgList.isEmpty()) {
                                        imgList.add("anh-default.png");
                                }

                                ProductDetail detail = ProductDetail.builder()
                                                .id(nextDetailId++)
                                                .productId(id)
                                                .size(sizes[i])
                                                .color(colors[i])
                                                .style(styles[i])
                                                .importPrice(ip)
                                                .price(p)
                                                .promoPrice(pp)
                                                .stock(st)
                                                .weight(w)
                                                .length(l)
                                                .width(wd)
                                                .thickness(th)
                                                .status(variantStatuses != null && variantStatuses.length > i
                                                                ? variantStatuses[i]
                                                                : "Hoạt động")
                                                .images(imgList)
                                                .build();
                                details.add(detail);
                        }
                }

                if (details.isEmpty()) {
                        minPrice = 0.0;
                        maxPrice = 0.0;
                }

                boolean isEdit = "true".equals(request.getParameter("isEdit"));
                List<String> computedColors = buildColorCircles(details);

                if (isEdit) {
                        for (int i = 0; i < products.size(); i++) {
                                if (products.get(i).getId().equals(id)) {
                                        Product oldProduct = products.get(i);
                                        Product updatedProduct = Product.builder()
                                                        .id(id)
                                                        .category(category)
                                                        .name(name)
                                                        .englishName(oldProduct.getEnglishName() != null ? oldProduct.getEnglishName() : "")
                                                        .price(minPrice)
                                                        .oldPrice(maxPrice > minPrice ? maxPrice : 0.0)
                                                        .discountPercent(oldProduct.getDiscountPercent())
                                                        .stock(totalStock)
                                                        .sold(oldProduct.getSold())
                                                        .rating(oldProduct.getRating())
                                                        .brand(brand)
                                                        .origin(origin)
                                                        .warranty(warranty)
                                                        .careInstructions(careInstructions)
                                                        .description(description)
                                                        .status(status)
                                                        .bgColor(oldProduct.getBgColor() != null ? oldProduct.getBgColor() : "#3B82F6")
                                                        .colorCircles(computedColors)
                                                        .details(details)
                                                        .build();
                                        products.set(i, updatedProduct);
                                        break;
                                }
                        }
                } else {
                        Product newProduct = Product.builder()
                                        .id(id)
                                        .category(category)
                                        .name(name)
                                        .englishName(englishName)
                                        .price(minPrice)
                                        .oldPrice(maxPrice > minPrice ? maxPrice : 0.0)
                                        .discountPercent(0)
                                        .stock(totalStock)
                                        .sold(0)
                                        .rating(5.0)
                                        .brand(brand)
                                        .origin(origin)
                                        .warranty(warranty)
                                        .careInstructions(careInstructions)
                                        .description(description)
                                        .status(status)
                                        .bgColor(bgColor)
                                        .colorCircles(computedColors)
                                        .details(details)
                                        .build();
                        products.add(newProduct);
                }

                response.sendRedirect(request.getContextPath() + "/admin/products");
        }

        private List<String> buildColorCircles(List<ProductDetail> details) {
                List<String> circles = new ArrayList<>();
                if (details == null) return circles;
                for (ProductDetail detail : details) {
                        String colorName = detail.getColor();
                        if (colorName == null || colorName.trim().isEmpty()) continue;
                        colorName = colorName.trim();
                        String hex = getHexFromColorName(colorName);
                        if (!circles.contains(hex)) {
                                circles.add(hex);
                        }
                }
                return circles;
        }

        private String getHexFromColorName(String colorName) {
                if (colorName.startsWith("#")) {
                        return colorName;
                }
                String nameLower = colorName.toLowerCase();
                switch (nameLower) {
                        case "đen":
                        case "black":
                                return "#000000";
                        case "be":
                        case "beige":
                                return "#E6D7C3";
                        case "navy":
                        case "xanh navy":
                                return "#1B365D";
                        case "đỏ đô":
                        case "đỏ":
                        case "red":
                                return "#8B0000";
                        case "trắng":
                        case "white":
                                return "#FFFFFF";
                        case "xám":
                        case "gray":
                        case "grey":
                                return "#808080";
                        case "xanh dương":
                        case "blue":
                                return "#3B82F6";
                        case "xanh lá":
                        case "green":
                                return "#10B981";
                        case "vàng":
                        case "yellow":
                                return "#FBBF24";
                        case "hồng":
                        case "pink":
                                return "#EC4899";
                        case "cam":
                        case "orange":
                                return "#F97316";
                        case "tím":
                        case "purple":
                                return "#8B5CF6";
                        default:
                                int hash = colorName.hashCode();
                                int r = (hash & 0xFF0000) >> 16;
                                int g = (hash & 0x00FF00) >> 8;
                                int b = hash & 0x0000FF;
                                return String.format("#%02X%02X%02X", r, g, b);
                }
        }
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
}
