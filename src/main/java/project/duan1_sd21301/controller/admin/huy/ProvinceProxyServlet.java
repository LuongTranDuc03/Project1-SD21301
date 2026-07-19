package project.duan1_sd21301.controller.admin.huy;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.util.phuc.ProvinceApiClient;

import java.io.IOException;

/**
 * Proxy Servlet cho API tỉnh thành Việt Nam (provinces.open-api.vn/api/v2).
 *
 * Endpoints:
 *   GET /api/provinces                    → lấy danh sách 34 tỉnh/thành
 *   GET /api/provinces?provinceCode={code} → lấy 1 tỉnh kèm xã/phường (depth=2)
 */
@WebServlet(name = "ProvinceProxyServlet", urlPatterns = "/api/provinces")
public class ProvinceProxyServlet extends HttpServlet {

    private final ProvinceApiClient apiClient = new ProvinceApiClient();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "public, max-age=3600");

        String provinceCodeParam = request.getParameter("provinceCode");
        String json;

        try {
            if (provinceCodeParam == null || provinceCodeParam.isEmpty()) {
                // Không có provinceCode → lấy tất cả tỉnh
                json = apiClient.getAllProvinces();
            } else {
                // Có provinceCode → lấy chi tiết tỉnh đó + wards (depth=2)
                int provinceCode = Integer.parseInt(provinceCodeParam);
                json = apiClient.getProvinceWithWards(provinceCode);
            }

            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Mã tỉnh không hợp lệ\"}");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Lỗi kết nối API (Bị ngắt)\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
