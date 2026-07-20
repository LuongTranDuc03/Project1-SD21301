package project.duan1_sd21301.controller.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.nio.charset.StandardCharsets;

/**
 * API Servlet làm cổng Proxy truy vấn dữ liệu Tỉnh/Thành, Quận/Huyện, Phường/Xã
 * từ dịch vụ https://provinces.open-api.vn/api/v1/
 * Tích hợp bộ nhớ đệm Cache trong bộ nhớ RAM để đảm bảo tốc độ phản hồi cực
 * nhanh (dưới 10ms)
 * và giảm tải/tránh lỗi nghẽn khi gọi API ngoài.
 */
@WebServlet(name = "ProvincesApiServlet", urlPatterns = {
        "/api/v1/p", "/api/v1/p/*",
        "/api/v1/d", "/api/v1/d/*",
        "/api/v1/w", "/api/v1/w/*",
        "/api/v2/p", "/api/v2/p/*",
        "/api/v2/w", "/api/v2/w/*"
})
public class ProvincesApiServlet extends HttpServlet {

    // Bộ nhớ đệm lưu trữ các phản hồi JSON
    private static final Map<String, String> cache = new ConcurrentHashMap<>();

    // Sử dụng HttpClient của Java 11+
    private final HttpClient httpClient = HttpClient.newBuilder()
            .followRedirects(HttpClient.Redirect.NORMAL)
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập mã hóa UTF-8 và kiểu phản hồi JSON
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Xây dựng URL đích để gọi tới api ngoài
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        // Ví dụ: /api/v1/p hoặc /api/v1/p/35
        String pathInApi = uri.substring(contextPath.length());
        
        // Loại bỏ /v1 vì API thực tế của provinces.open-api.vn không có /v1
        String realApiPath = pathInApi.replace("/v1", "");

        String queryString = request.getQueryString();
        String targetUrl = "https://provinces.open-api.vn" + realApiPath;
        if (queryString != null && !queryString.isEmpty()) {
            targetUrl += "?" + queryString;
        }

        System.out.println("[ProvincesApiProxy] Target URL: " + targetUrl);

        // Kiểm tra xem phản hồi đã có trong cache chưa
        String cacheKey = targetUrl;
        if (cache.containsKey(cacheKey)) {
            System.out.println("[ProvincesApiProxy] Serve from Cache: " + targetUrl);
            response.getWriter().write(cache.get(cacheKey));
            return;
        }

        try {
            // Khởi tạo Request gọi API ngoài
            HttpRequest apiRequest = HttpRequest.newBuilder()
                    .uri(URI.create(targetUrl))
                    .header("User-Agent",
                            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
                    .timeout(Duration.ofSeconds(60))
                    .GET()
                    .build();

            // Gửi request đồng bộ
            HttpResponse<String> apiResponse = httpClient.send(apiRequest,
                    HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (apiResponse.statusCode() == 200) {
                String jsonBody = apiResponse.body();
                // Lưu vào cache
                cache.put(cacheKey, jsonBody);
                // Trả về kết quả
                response.getWriter().write(jsonBody);
            } else {
                System.err.println("[ProvincesApiProxy] Remote returned status: " + apiResponse.statusCode());
                response.setStatus(apiResponse.statusCode());
                response.getWriter().write("{\"error\": \"Failed to fetch data from provinces api. Status: "
                        + apiResponse.statusCode() + "\"}");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Request was interrupted: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.err.println("[ProvincesApiProxy] Exception occurred fetching " + targetUrl);
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error fetching data: " + e.getMessage() + "\"}");
        }
    }

    // Endpoint POST để xóa toàn bộ cache (dùng khi debug)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cache.clear();
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"message\": \"Cache cleared\", \"size\": 0}");
        System.out.println("[ProvincesApiProxy] Cache cleared by POST request.");
    }
}
