package project.duan1_sd21301.controller.admin.luong;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "VariantController", value = "/admin/variants")
public class VariantController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Product> products = (List<Product>) session.getAttribute("products");

        if (products == null) {
            // Redirect to products to initialize the data first
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        String filterProductId = request.getParameter("productId");

        List<ProductDetail> allVariants = new ArrayList<>();
        for (Product product : products) {
            if (filterProductId != null && !filterProductId.trim().isEmpty()) {
                if (!product.getId().equals(filterProductId)) {
                    continue;
                }
            }
            if (product.getDetails() != null) {
                for (ProductDetail pd : product.getDetails()) {
                    pd.setProductId(product.getId());
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
                            v.getProductId() != null ? v.getProductId() : "",
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

        String toastMessage = (String) session.getAttribute("toastMessage");
        if (toastMessage != null) {
            request.setAttribute("toastMessage", toastMessage);
            request.setAttribute("toastType", session.getAttribute("toastType"));
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        request.setAttribute("variants", allVariants);
        request.setAttribute("filterProductId", filterProductId);
        request.getRequestDispatcher("/WEB-INF/views/admin/luong/variant-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String productId = request.getParameter("productId");
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String style = request.getParameter("style");
            String priceStr = request.getParameter("price");

            String stockStr = request.getParameter("stock");
            String weightStr = request.getParameter("weight");
            String lengthStr = request.getParameter("length");
            String widthStr = request.getParameter("width");
            String thicknessStr = request.getParameter("thickness");

            jakarta.servlet.http.HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<Product> products = (List<Product>) session.getAttribute("products");

            if (products != null && productId != null && color != null && size != null) {
                for (Product p : products) {
                    if (productId.equals(p.getId()) && p.getDetails() != null) {
                        for (ProductDetail d : p.getDetails()) {
                            if (color.equals(d.getColor()) && size.equals(d.getSize())) {
                                d.setStyle(style);
                                try {
                                    if (priceStr != null && !priceStr.isEmpty())
                                        d.setPrice(Double.parseDouble(priceStr.replace(",", "")));
                                    if (stockStr != null && !stockStr.isEmpty())
                                        d.setStock(Integer.parseInt(stockStr.replace(",", "")));
                                    if (weightStr != null && !weightStr.isEmpty())
                                        d.setWeight(Double.parseDouble(weightStr.replace(",", "")));
                                    if (lengthStr != null && !lengthStr.isEmpty())
                                        d.setLength(Double.parseDouble(lengthStr.replace(",", "")));
                                    if (widthStr != null && !widthStr.isEmpty())
                                        d.setWidth(Double.parseDouble(widthStr.replace(",", "")));
                                    if (thicknessStr != null && !thicknessStr.isEmpty())
                                        d.setThickness(Double.parseDouble(thicknessStr.replace(",", "")));
                                } catch (NumberFormatException ignored) {
                                }

                                // Cập nhật trạng thái sản phẩm cha dựa trên stock tính từ biến thể
                                p.setStatus(p.getStock() > 0 ? "AVAILABLE" : "OUT_OF_STOCK");
                                session.setAttribute("toastMessage", "Cập nhật biến thể thành công!");
                                session.setAttribute("toastType", "success");

                                break;
                            }
                        }
                        break;
                    }
                }
            }
        } else if ("toggleStatus".equals(action)) {
            String productId = request.getParameter("productId");
            String color = request.getParameter("color");
            String size = request.getParameter("size");
            String status = request.getParameter("status");

            jakarta.servlet.http.HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<Product> products = (List<Product>) session.getAttribute("products");

            if (products != null && productId != null && color != null && size != null && status != null) {
                for (Product p : products) {
                    if (productId.equals(p.getId()) && p.getDetails() != null) {
                        for (ProductDetail d : p.getDetails()) {
                            if (color.equals(d.getColor()) && size.equals(d.getSize())) {
                                d.setStatus(status);
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/admin/variants");
    }
}
