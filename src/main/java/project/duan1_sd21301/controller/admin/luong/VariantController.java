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
                writer.write("STT,Mã Sản Phẩm,Màu Sắc,Kích Cỡ,Kiểu Dáng,Đơn Giá,Số Lượng,Trạng Thái\n");
                int stt = 1;
                for (ProductDetail v : allVariants) {
                    String pStatus = v.getStatus();
                    if (pStatus == null || pStatus.trim().isEmpty() || pStatus.equals("Hoạt động")) {
                        pStatus = v.getStock() > 0 ? "Còn hàng" : "Hết hàng";
                    }
                    String statusLabel = pStatus.equals("Còn hàng") || pStatus.equals("AVAILABLE") ? "Còn hàng"
                            : "Hết hàng";
                    writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%.0f,%d,\"%s\"\n",
                            stt++,
                            (v.getProduct() != null && v.getProduct().getCode() != null) ? v.getProduct().getCode() : "",
                            v.getColor() != null ? v.getColor() : "",
                            v.getSize() != null ? v.getSize() : "",
                            v.getStyle() != null ? v.getStyle() : "",
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
        if ("edit".equals(action)) {
            String variantIdStr = request.getParameter("variantId");
            String productCode = request.getParameter("productCode");
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String style = request.getParameter("style");
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

                productService.updateProductDetail(detail);

                jakarta.servlet.http.HttpSession session = request.getSession();
                session.setAttribute("toastMessage", "Cập nhật biến thể thành công!");
                session.setAttribute("toastType", "success");
            }
        } else if ("toggleStatus".equals(action)) {
            String variantIdStr = request.getParameter("variantId");
            String status = request.getParameter("status");

            if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                try {
                    ProductDetail detail = productService.getDetailById(Integer.parseInt(variantIdStr));
                    if (detail != null) {
                        detail.setStatus(status);
                        productService.updateProductDetail(detail);
                    }
                } catch (Exception ignored) {}
            }
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/variants");
    }
}
