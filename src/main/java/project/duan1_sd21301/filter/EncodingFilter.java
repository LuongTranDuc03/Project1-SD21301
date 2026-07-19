package project.duan1_sd21301.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Filter cấu hình Encoding toàn cục cho toàn bộ ứng dụng (/*).
 * Đảm bảo dữ liệu từ client gửi lên và server trả về luôn là UTF-8,
 * tránh tình trạng lỗi font tiếng Việt khi thao tác với CSDL.
 */
@WebFilter(filterName = "EncodingFilter", urlPatterns = "/*")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Có thể cấu hình thêm tham số ở đây nếu cần thiết
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // Thiết lập UTF-8 cho Request (dữ liệu gửi lên từ form)
        request.setCharacterEncoding("UTF-8");
        
        // Thiết lập UTF-8 cho Response (dữ liệu trả về cho trình duyệt)
        response.setCharacterEncoding("UTF-8");

        // Tiếp tục chuyển tiếp request cho các Servlet/JSP xử lý
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Dọn dẹp tài nguyên nếu cần
    }
}
