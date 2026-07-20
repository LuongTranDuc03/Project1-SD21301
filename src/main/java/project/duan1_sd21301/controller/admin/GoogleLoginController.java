package project.duan1_sd21301.controller.admin;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.repository.huy.EmployeeRepository;
import project.duan1_sd21301.repository.huy.EmployeeRepositoryImpl;
import project.duan1_sd21301.util.huy.EmployeeMockData;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;

/**
 * GoogleLoginController – xác thực Google ID Token thật sự.
 *
 * CÁCH DÙNG:
 *  1. Vào https://console.cloud.google.com → Credentials → Create OAuth 2.0 Client ID
 *  2. Chọn "Web application", thêm Authorized JavaScript origins: http://localhost:8080
 *  3. Copy Client ID (dạng xxxxx.apps.googleusercontent.com)
 *  4. Thay giá trị GOOGLE_CLIENT_ID bên dưới + trong login.jsp
 */
@WebServlet(name = "GoogleLoginController", value = "/login-google")
public class GoogleLoginController extends HttpServlet {

    /**
     * TODO: Thay bằng Client ID thật của bạn từ Google Cloud Console
     * Ví dụ: "123456789-abcdefg.apps.googleusercontent.com"
     */
    private static final String GOOGLE_CLIENT_ID = "35800930005-are3qqcamf2hb4tsuslmtdir1okmloaf.apps.googleusercontent.com";

    private EmployeeRepository employeeRepository;

    @Override
    public void init() throws ServletException {
        employeeRepository = new EmployeeRepositoryImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String credential = request.getParameter("credential");

        if (credential == null || credential.trim().isEmpty()) {
            request.setAttribute("error", "Token Google không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        String email = null;

        // === Nếu Client ID đã được cấu hình thật → verify với Google ===
        if (!GOOGLE_CLIENT_ID.equals("YOUR_GOOGLE_CLIENT_ID")) {
            try {
                GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                        new NetHttpTransport(),
                        GsonFactory.getDefaultInstance())
                        .setAudience(Collections.singletonList(GOOGLE_CLIENT_ID))
                        .build();

                GoogleIdToken idToken = verifier.verify(credential);
                if (idToken == null) {
                    request.setAttribute("error", "Token Google không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                    request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
                    return;
                }

                Payload payload = idToken.getPayload();
                email = payload.getEmail();

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi xác thực với Google: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
                return;
            }
        } else {
            // === Chưa có Client ID thật → giải mã Base64 để lấy email (chỉ cho dev/demo) ===
            email = extractEmailFromJwt(credential);
        }

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Không thể đọc thông tin email từ Google. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        // Tìm nhân viên theo email trong DB
        Employee employee = employeeRepository.findByEmail(email);

        // Fallback sang mock data
        if (employee == null) {
            for (Employee e : EmployeeMockData.loadAll()) {
                if (email.equalsIgnoreCase(e.getEmail())) {
                    employee = e;
                    break;
                }
            }
        }

        if (employee == null) {
            request.setAttribute("error",
                "Tài khoản Google <b>" + escapeHtml(email) + "</b> chưa được cấp quyền truy cập hệ thống.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        if (employee.getStatus() != 1) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp").forward(request, response);
            return;
        }

        // Đăng nhập thành công
        HttpSession session = request.getSession();
        session.setAttribute("loggedInUser", employee);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    /** Giải mã Base64 JWT payload để lấy email (fallback khi không có Client ID thật) */
    private String extractEmailFromJwt(String jwt) {
        try {
            String[] parts = jwt.split("\\.");
            if (parts.length < 2) return null;
            String payload = parts[1].replace('-', '+').replace('_', '/');
            int pad = 4 - payload.length() % 4;
            if (pad != 4) payload += "=".repeat(pad);
            String decoded = new String(java.util.Base64.getDecoder().decode(payload));
            int idx = decoded.indexOf("\"email\"");
            if (idx == -1) return null;
            int s = decoded.indexOf('"', decoded.indexOf(':', idx) + 1) + 1;
            int e = decoded.indexOf('"', s);
            return decoded.substring(s, e);
        } catch (Exception ex) {
            return null;
        }
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
