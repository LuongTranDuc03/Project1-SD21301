package project.duan1_sd21301.controller.admin.luong;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.service.luong.ProductService;
import project.duan1_sd21301.service.luong.ProductServiceImpl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "ProductController", value = "/admin/products")
public class ProductController extends HttpServlet {

    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = productService.getAllProducts();

        String action = request.getParameter("action");
        if ("exportExcel".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh_sach_san_pham.csv\"");
            try (java.io.PrintWriter writer = response.getWriter()) {
                writer.write('\ufeff');
                writer.println("STT,Mã sản phẩm,Tên sản phẩm,Danh mục,Thương hiệu,Khoảng giá,Tổng số lượng,Trạng thái");
                int stt = 1;
                for (Product prod : products) {
                    String name = prod.getName() != null ? prod.getName().replace("\"", "\"\"") : "";
                    String brand = prod.getBrand() != null ? prod.getBrand().replace("\"", "\"\"") : "N/A";
                    String category = prod.getCategory() != null ? prod.getCategory().replace("\"", "\"\"") : "";
                    String priceRange = prod.getPriceRangeFormatted().replace("\"", "\"\"");

                    String statusLabel = "";
                    if ("AVAILABLE".equals(prod.getStatus()))
                        statusLabel = "Còn hàng";
                    else if ("OUT_OF_STOCK".equals(prod.getStatus()))
                        statusLabel = "Hết hàng";
                    else
                        statusLabel = prod.getStatus() != null ? prod.getStatus() : "";

                    writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\"\n",
                            stt++, prod.getCode(), name, category, brand, priceRange,
                            prod.getStock(), statusLabel);
                }
            }
            return;
        }

        if ("add".equals(action)) {
            request.setAttribute("pageTitle", "Thêm sản phẩm mới");
            request.setAttribute("categories", productService.getAllCategories());
            request.setAttribute("brands", productService.getAllBrands());
            request.setAttribute("colors", productService.getAllColors());
            request.setAttribute("sizes", productService.getAllSizes());
            request.setAttribute("styles", productService.getAllStyles());
            request.setAttribute("origins", productService.getAllOrigins());
            request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-add.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            String productCode = request.getParameter("code");
            if (productCode != null) {
                Product targetProduct = productService.getProductByCode(productCode);
                if (targetProduct != null) {
                    request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm " + productCode);
                    request.setAttribute("product", targetProduct);
                    request.setAttribute("categories", productService.getAllCategories());
                    request.setAttribute("brands", productService.getAllBrands());
                    request.setAttribute("colors", productService.getAllColors());
                    request.setAttribute("sizes", productService.getAllSizes());
                    request.setAttribute("styles", productService.getAllStyles());
                    request.setAttribute("origins", productService.getAllOrigins());
                    request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-add.jsp").forward(request,
                            response);
                    return;
                }
            }
        }

        String productCode = request.getParameter("code");
        if (productCode != null) {
            Product targetProduct = productService.getProductByCode(productCode);
            if (targetProduct != null) {
                request.setAttribute("pageTitle", "Chi tiết sản phẩm " + productCode);
                request.setAttribute("product", targetProduct);
                request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-detail.jsp").forward(request,
                        response);
                return;
            }
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        String toastMessage = (String) session.getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", session.getAttribute("toastType"));
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        request.setAttribute("pageTitle", "Quản lý sản phẩm");
        request.setAttribute("products", products);
        request.setAttribute("categories", productService.getAllCategories());
        request.setAttribute("brands", productService.getAllBrands());
        request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("toggleStatus".equals(action)) {
            String productCode = request.getParameter("code");
            if (productCode == null || productCode.trim().isEmpty()) {
                productCode = request.getParameter("id");
            }
            if (productCode != null && !productCode.trim().isEmpty()) {
                Product p = productService.getProductByCode(productCode.trim());
                if (p != null) {
                    String currentEff = p.getEffectiveStatus();
                    String newStatus = ("OUT_OF_STOCK".equalsIgnoreCase(currentEff) || "OUT_OF_STOCK".equalsIgnoreCase(p.getStatus())) ? "AVAILABLE" : "OUT_OF_STOCK";
                    p.setStatus(newStatus);
                    boolean ok = productService.updateProduct(p);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\":" + ok + ", \"newStatus\":\"" + newStatus + "\"}");
                    return;
                }
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":false}");
            return;
        }

        if ("updateVariant".equals(action)) {
            String productCode = request.getParameter("productCode");
            String variantIdStr = request.getParameter("variantId");
            if (productCode != null && variantIdStr != null) {
                try {
                    int variantId = Integer.parseInt(variantIdStr);
                    ProductDetail detail = productService.getDetailById(variantId);
                    if (detail != null) {
                        detail.setColor(request.getParameter("color"));
                        detail.setSize(request.getParameter("size"));
                        detail.setStyle(request.getParameter("style"));

                        try {
                            detail.setPrice(Double.parseDouble(request.getParameter("price")));
                        } catch (Exception ignored) {
                        }
                        try {
                            detail.setStock(Integer.parseInt(request.getParameter("stock")));
                        } catch (Exception ignored) {
                        }
                        try {
                            detail.setWeight(Double.parseDouble(request.getParameter("weight")));
                        } catch (Exception ignored) {
                        }
                        try {
                            detail.setLength(Double.parseDouble(request.getParameter("length")));
                        } catch (Exception ignored) {
                        }
                        try {
                            detail.setWidth(Double.parseDouble(request.getParameter("width")));
                        } catch (Exception ignored) {
                        }
                        try {
                            detail.setThickness(Double.parseDouble(request.getParameter("thickness")));
                        } catch (Exception ignored) {
                        }
                        detail.setStatus(request.getParameter("status"));

                        String imagesParam = request.getParameter("images");
                        if (imagesParam != null) {
                            if (imagesParam.trim().isEmpty()) {
                                detail.setImages(new ArrayList<>());
                            } else {
                                detail.setImages(new ArrayList<>(Arrays.asList(imagesParam.split(","))));
                            }
                        }
                        productService.updateProductDetail(detail);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&code=" + productCode);
            return;
        }

        if ("deleteVariant".equals(action)) {
            String productCode = request.getParameter("productCode");
            String variantIdStr = request.getParameter("variantId");
            if (productCode != null && variantIdStr != null) {
                try {
                    int variantId = Integer.parseInt(variantIdStr);
                    productService.deleteProductDetail(variantId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&code=" + productCode);
            return;
        }

        if ("addVariant".equals(action)) {
            String productCode = request.getParameter("productCode");
            if (productCode != null) {
                Product targetProduct = productService.getProductByCode(productCode);
                if (targetProduct != null) {
                    ProductDetail detail = ProductDetail.builder()
                            .product(targetProduct)
                            .color(request.getParameter("color"))
                            .size(request.getParameter("size"))
                            .style(request.getParameter("style"))
                            .status(request.getParameter("status"))
                            .build();

                    try {
                        detail.setPrice(Double.parseDouble(request.getParameter("price")));
                    } catch (Exception ignored) {
                    }
                    try {
                        detail.setStock(Integer.parseInt(request.getParameter("stock")));
                    } catch (Exception ignored) {
                    }
                    try {
                        detail.setWeight(Double.parseDouble(request.getParameter("weight")));
                    } catch (Exception ignored) {
                    }
                    try {
                        detail.setLength(Double.parseDouble(request.getParameter("length")));
                    } catch (Exception ignored) {
                    }
                    try {
                        detail.setWidth(Double.parseDouble(request.getParameter("width")));
                    } catch (Exception ignored) {
                    }
                    try {
                        detail.setThickness(Double.parseDouble(request.getParameter("thickness")));
                    } catch (Exception ignored) {
                    }

                    String imagesParam = request.getParameter("images");
                    if (imagesParam != null && !imagesParam.trim().isEmpty()) {
                        detail.setImages(new ArrayList<>(Arrays.asList(imagesParam.split(","))));
                    } else {
                        detail.setImages(new ArrayList<>(Arrays.asList("anh-default.png")));
                    }

                    productService.addProductDetail(detail);
                }
            }
            request.getSession().setAttribute("toastMessage", "Thêm biến thể thành công!");
            request.getSession().setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&code=" + productCode);
            return;
        }

        if ("deleteProduct".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    productService.deleteProduct(id);
                    request.getSession().setAttribute("toastMessage", "Xóa sản phẩm thành công!");
                    request.getSession().setAttribute("toastType", "success");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        String code = request.getParameter("code");
        boolean isEdit = "true".equals(request.getParameter("isEdit"));

        if (code != null) {
            code = code.trim();
        }
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String origin = request.getParameter("origin");

        String careInstructions = request.getParameter("careInstructions");
        String description = request.getParameter("description");

        String[] sizes = request.getParameterValues("variantSize");
        String[] colors = request.getParameterValues("variantColor");
        String[] styles = request.getParameterValues("variantStyle");
        String[] importPrices = request.getParameterValues("variantImportPrice");
        String[] prices = request.getParameterValues("variantPrice");
        String[] stocks = request.getParameterValues("variantStock");
        String[] weights = request.getParameterValues("variantWeight");
        String[] lengths = request.getParameterValues("variantLength");
        String[] widths = request.getParameterValues("variantWidth");
        String[] thicknesses = request.getParameterValues("variantThickness");
        String[] variantImages = request.getParameterValues("variantImage");

        List<ProductDetail> details = new ArrayList<>();
        double minPrice = Double.MAX_VALUE;

        if (sizes != null) {
            for (int i = 0; i < sizes.length; i++) {
                double ip = 0.0;
                double p = 0.0;
                int st = 0;
                double w = 0.0;
                double l = 0.0;
                double wd = 0.0;
                double th = 0.0;

                try {
                    if (importPrices != null && importPrices.length > i && importPrices[i] != null && !importPrices[i].trim().isEmpty())
                        ip = Double.parseDouble(importPrices[i].replaceAll("[^0-9.]", ""));
                } catch (Exception ignored) {
                }
                try {
                    if (prices != null && prices[i] != null && !prices[i].trim().isEmpty())
                        p = Double.parseDouble(prices[i].replaceAll("[^0-9.]", ""));
                } catch (Exception ignored) {
                }
                try {
                    if (stocks != null && stocks[i] != null && !stocks[i].trim().isEmpty())
                        st = Integer.parseInt(stocks[i].replaceAll("[^0-9]", ""));
                } catch (Exception ignored) {
                }
                try {
                    if (weights != null && weights[i] != null)
                        w = Double.parseDouble(weights[i]);
                } catch (Exception ignored) {
                }
                try {
                    if (lengths != null && lengths[i] != null)
                        l = Double.parseDouble(lengths[i]);
                } catch (Exception ignored) {
                }
                try {
                    if (widths != null && widths[i] != null)
                        wd = Double.parseDouble(widths[i]);
                } catch (Exception ignored) {
                }
                try {
                    if (thicknesses != null && thicknesses[i] != null)
                        th = Double.parseDouble(thicknesses[i]);
                } catch (Exception ignored) {
                }

                if (p < minPrice)
                    minPrice = p;

                String imgStr = (variantImages != null && variantImages.length > i) ? variantImages[i]
                        : "anh-default.png";
                List<String> imgList = new ArrayList<>();
                if (imgStr != null && !imgStr.trim().isEmpty()) {
                    for (String s : imgStr.split(",")) {
                        if (!s.trim().isEmpty())
                            imgList.add(s.trim());
                    }
                }
                if (imgList.isEmpty())
                    imgList.add("anh-default.png");

                ProductDetail detail = ProductDetail.builder()
                        .size(sizes[i])
                        .color(colors[i])
                        .style(styles[i])
                        .importPrice(ip)
                        .price(p)
                        .stock(st)
                        .weight(w)
                        .length(l)
                        .width(wd)
                        .thickness(th)
                        .status(st == 0 ? "OUT_OF_STOCK" : "AVAILABLE")
                        .images(imgList)
                        .build();
                details.add(detail);
            }
        }

        if (minPrice == Double.MAX_VALUE)
            minPrice = 0.0;
        String computedStatus = details.isEmpty() || details.stream().allMatch(d -> d.getStock() == 0) ? "OUT_OF_STOCK"
                : "AVAILABLE";

        if (isEdit) {
            Product existingProduct = productService.getProductByCode(code);
            if (existingProduct != null) {
                existingProduct.setName(name);
                existingProduct.setCategory(category);
                existingProduct.setBrand(brand);
                existingProduct.setOrigin(origin);
                existingProduct.setCareInstructions(careInstructions);
                existingProduct.setDescription(description);
                existingProduct.setPrice(minPrice);
                existingProduct.setStatus(computedStatus);

                productService.updateProduct(existingProduct);
                request.getSession().setAttribute("toastMessage", "Cập nhật sản phẩm thành công!");
                request.getSession().setAttribute("toastType", "success");
            }
        } else {
            // Check code duplicate in DB
            if (code != null && productService.getProductByCode(code) != null) {
                request.setAttribute("errorMessage", "Mã sản phẩm '" + code + "' đã tồn tại! Vui lòng chọn mã khác.");
                Product temp = Product.builder()
                        .code(code)
                        .name(name)
                        .category(category)
                        .brand(brand)
                        .origin(origin)
                        .careInstructions(careInstructions)
                        .description(description)
                        .details(details)
                        .build();
                request.setAttribute("product", temp);
                request.setAttribute("categories", productService.getAllCategories());
                request.setAttribute("brands", productService.getAllBrands());
                request.setAttribute("colors", productService.getAllColors());
                request.setAttribute("sizes", productService.getAllSizes());
                request.setAttribute("styles", productService.getAllStyles());
                request.setAttribute("origins", productService.getAllOrigins());
                request.setAttribute("isValidationAddError", "true");
                request.setAttribute("pageTitle", "Thêm sản phẩm mới");
                request.getRequestDispatcher("/WEB-INF/views/admin/luong/product-add.jsp").forward(request, response);
                return;
            }

            Product newProduct = Product.builder()
                    .code(code)
                    .name(name)
                    .category(category)
                    .brand(brand)
                    .origin(origin)
                    .careInstructions(careInstructions)
                    .description(description)
                    .price(minPrice)
                    .status(computedStatus)
                    .details(details)
                    .build();

            boolean success = productService.addProduct(newProduct);
            if (success) {
                request.getSession().setAttribute("toastMessage", "Thêm sản phẩm thành công!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Thêm sản phẩm thất bại! Vui lòng kiểm tra lại kết nối CSDL hoặc dữ liệu.");
                request.getSession().setAttribute("toastType", "error");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
