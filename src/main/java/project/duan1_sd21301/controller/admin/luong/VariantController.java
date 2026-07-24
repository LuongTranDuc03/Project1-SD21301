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
import java.util.List;

@WebServlet(name = "VariantController", value = "/admin/variants")
@jakarta.servlet.annotation.MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class VariantController extends HttpServlet {

    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> products = productService.getAllProducts();
        String filterProductCode = request.getParameter("productCode");

        List<ProductDetail> allVariants = new ArrayList<>();
        for (Product product : products) {
            if (filterProductCode != null && !filterProductCode.trim().isEmpty()) {
                if (!product.getCode().equalsIgnoreCase(filterProductCode.trim())) {
                    continue;
                }
            }
            if (product.getDetails() != null) {
                for (ProductDetail pd : product.getDetails()) {
                    pd.setProduct(product);
                    allVariants.add(pd);
                }
            }
        }
        String action = request.getParameter("action");
        if ("exportExcel".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"DanhSachBienThe.csv\"");
            try (java.io.PrintWriter writer = response.getWriter()) {
                writer.write("\ufeff"); // UTF-8 BOM cho Excel
                writer.write("STT,Mã Sản Phẩm,Màu Sắc,Kích Cỡ,Kiểu Dáng,Giá Nhập,Đơn Giá,Số Lượng,Trạng Thái\n");
                int stt = 1;
                for (ProductDetail v : allVariants) {
                    Integer pStatus = v.getStatus();
                    String statusLabel = (pStatus != null && pStatus == 1) ? "Còn hàng" : "Hết hàng";
                    writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%.0f,%.0f,%d,\"%s\"\n",
                            stt++,
                            (v.getProduct() != null && v.getProduct().getCode() != null) ? v.getProduct().getCode() : "",
                            v.getColor() != null ? v.getColor() : "",
                            v.getSize() != null ? v.getSize() : "",
                            v.getStyle() != null ? v.getStyle() : "",
                            v.getImportPrice(),
                            v.getPrice(),
                            v.getStock(),
                            statusLabel);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        jakarta.servlet.http.HttpSession session = request.getSession();
        String toastMessage = (String) session.getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", session.getAttribute("toastType"));
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        request.setAttribute("variants", allVariants);
        request.setAttribute("filterProductCode", filterProductCode);
        request.getRequestDispatcher("/WEB-INF/views/admin/luong/variant-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String productCode = request.getParameter("productCode");
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String style = request.getParameter("style");
            String importPriceStr = request.getParameter("importPrice");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String weightStr = request.getParameter("weight");
            String lengthStr = request.getParameter("length");
            String widthStr = request.getParameter("width");
            String thicknessStr = request.getParameter("thickness");

            Product product = productService.getProductByCode(productCode);
            if (product != null) {
                ProductDetail detail = new ProductDetail();
                detail.setProduct(product);
                detail.setColor(color);
                detail.setSize(size);
                detail.setStyle(style);
                try {
                    if (importPriceStr != null && !importPriceStr.isEmpty()) detail.setImportPrice(Double.parseDouble(importPriceStr.replace(",", "")));
                    if (priceStr != null && !priceStr.isEmpty()) detail.setPrice(Double.parseDouble(priceStr.replace(",", "")));
                    if (stockStr != null && !stockStr.isEmpty()) detail.setStock(Integer.parseInt(stockStr.replace(",", "")));
                    if (weightStr != null && !weightStr.isEmpty()) detail.setWeight(Double.parseDouble(weightStr.replace(",", "")));
                    if (lengthStr != null && !lengthStr.isEmpty()) detail.setLength(Double.parseDouble(lengthStr.replace(",", "")));
                    if (widthStr != null && !widthStr.isEmpty()) detail.setWidth(Double.parseDouble(widthStr.replace(",", "")));
                    if (thicknessStr != null && !thicknessStr.isEmpty()) detail.setThickness(Double.parseDouble(thicknessStr.replace(",", "")));
                } catch (Exception ignored) {}

                try {
                    jakarta.servlet.http.Part filePart = request.getPart("variantImage");
                    if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                        try (java.io.InputStream is = filePart.getInputStream()) {
                            String uploadedUrl = project.duan1_sd21301.util.CloudinaryUtil.uploadImage(is, "product_variants");
                            if (uploadedUrl != null && !uploadedUrl.trim().isEmpty()) {
                                List<String> images = new ArrayList<>();
                                images.add(uploadedUrl);
                                detail.setImages(images);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("⚠️ Variant image upload error: " + e.getMessage());
                }

                boolean success = productService.addProductDetail(detail);
                jakarta.servlet.http.HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("toastMessage", "Thêm biến thể thành công!");
                    session.setAttribute("toastType", "success");
                } else {
                    session.setAttribute("toastMessage", "Thêm thất bại! Biến thể này có thể đã tồn tại.");
                    session.setAttribute("toastType", "error");
                }
            }
        } else if ("edit".equals(action)) {
            String variantIdStr = request.getParameter("variantId");
            String productCode = request.getParameter("productCode");
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String style = request.getParameter("style");
            String importPriceStr = request.getParameter("importPrice");
            String priceStr = request.getParameter("price");

            String stockStr = request.getParameter("stock");
            String weightStr = request.getParameter("weight");
            String lengthStr = request.getParameter("length");
            String widthStr = request.getParameter("width");
            String thicknessStr = request.getParameter("thickness");

            ProductDetail detail = null;
            if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                try {
                    detail = productService.getDetailById(Integer.parseInt(variantIdStr));
                } catch (Exception ignored) {}
            }

            if (detail == null && productCode != null) {
                Product p = productService.getProductByCode(productCode);
                if (p != null && p.getDetails() != null) {
                    for (ProductDetail d : p.getDetails()) {
                        if (color != null && color.equals(d.getColor()) && size != null && size.equals(d.getSize())) {
                            detail = d;
                            break;
                        }
                    }
                }
            }

            if (detail != null) {
                if (color != null) detail.setColor(color);
                if (size != null) detail.setSize(size);
                if (style != null) detail.setStyle(style);
                try {
                    if (importPriceStr != null && !importPriceStr.isEmpty())
                        detail.setImportPrice(Double.parseDouble(importPriceStr.replace(",", "")));
                    if (priceStr != null && !priceStr.isEmpty())
                        detail.setPrice(Double.parseDouble(priceStr.replace(",", "")));
                    if (stockStr != null && !stockStr.isEmpty())
                        detail.setStock(Integer.parseInt(stockStr.replace(",", "")));
                    if (weightStr != null && !weightStr.isEmpty())
                        detail.setWeight(Double.parseDouble(weightStr.replace(",", "")));
                    if (lengthStr != null && !lengthStr.isEmpty())
                        detail.setLength(Double.parseDouble(lengthStr.replace(",", "")));
                    if (widthStr != null && !widthStr.isEmpty())
                        detail.setWidth(Double.parseDouble(widthStr.replace(",", "")));
                    if (thicknessStr != null && !thicknessStr.isEmpty())
                        detail.setThickness(Double.parseDouble(thicknessStr.replace(",", "")));
                } catch (NumberFormatException ignored) {}

                try {
                    jakarta.servlet.http.Part filePart = request.getPart("variantImage");
                    if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                        try (java.io.InputStream is = filePart.getInputStream()) {
                            String uploadedUrl = project.duan1_sd21301.util.CloudinaryUtil.uploadImage(is, "product_variants");
                            if (uploadedUrl != null && !uploadedUrl.trim().isEmpty()) {
                                List<String> images = new ArrayList<>();
                                images.add(uploadedUrl);
                                detail.setImages(images);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("⚠️ Variant image upload error: " + e.getMessage());
                }

                boolean success = productService.updateProductDetail(detail);

                jakarta.servlet.http.HttpSession session = request.getSession();
                if (success) {
                    session.setAttribute("toastMessage", "Cập nhật biến thể thành công!");
                    session.setAttribute("toastType", "success");
                } else {
                    session.setAttribute("toastMessage", "Cập nhật thất bại! Biến thể trùng lặp hoặc lỗi hệ thống.");
                    session.setAttribute("toastType", "error");
                }
            }
        } else if ("toggleStatus".equals(action)) {
            String variantIdStr = request.getParameter("variantId");
            String status = request.getParameter("status");
            String productCode = request.getParameter("productCode");
            String color = request.getParameter("color");
            String size = request.getParameter("size");

            ProductDetail detail = null;
            if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                try {
                    detail = productService.getDetailById(Integer.parseInt(variantIdStr.trim()));
                } catch (Exception ignored) {}
            }

            if (detail == null && productCode != null && !productCode.trim().isEmpty()) {
                Product p = productService.getProductByCode(productCode.trim());
                if (p != null && p.getDetails() != null) {
                    for (ProductDetail d : p.getDetails()) {
                        boolean matchColor = (color == null || color.trim().isEmpty() || color.trim().equalsIgnoreCase(d.getColor()));
                        boolean matchSize = (size == null || size.trim().isEmpty() || size.trim().equalsIgnoreCase(d.getSize()));
                        if (matchColor && matchSize) {
                            detail = d;
                            break;
                        }
                    }
                }
            }

            if (detail != null) {
                Integer newDbStatus = 1;
                if ("OUT_OF_STOCK".equalsIgnoreCase(status) || "Hết hàng".equalsIgnoreCase(status) || "Ngừng hoạt động".equalsIgnoreCase(status) || "0".equals(status)) {
                    newDbStatus = 0;
                } else if ("AVAILABLE".equalsIgnoreCase(status) || "Còn hàng".equalsIgnoreCase(status) || "Hoạt động".equalsIgnoreCase(status) || "1".equals(status)) {
                    newDbStatus = 1;
                }
                detail.setStatus(newDbStatus);
                boolean updated = productService.updateProductDetail(detail);
                if (updated) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    return;
                }
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/variants");
    }
}
