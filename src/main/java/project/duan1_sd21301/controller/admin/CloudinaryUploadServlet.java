package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import project.duan1_sd21301.util.CloudinaryUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

@WebServlet(name = "CloudinaryUploadServlet", value = "/admin/upload-cloudinary")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class CloudinaryUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Part filePart = request.getPart("file");
            if (filePart == null) {
                filePart = request.getPart("image");
            }

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().trim().isEmpty()) {
                try (InputStream is = filePart.getInputStream()) {
                    String uploadedUrl = CloudinaryUtil.uploadImage(is, "product_variants");
                    if (uploadedUrl != null && !uploadedUrl.trim().isEmpty()) {
                        out.print("{\"success\": true, \"url\": \"" + uploadedUrl + "\"}");
                        return;
                    }
                }
            }
            out.print("{\"success\": false, \"message\": \"Không tìm thấy file ảnh tải lên\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"" + (e.getMessage() != null ? e.getMessage().replace("\"", "'") : "Lỗi upload") + "\"}");
        }
    }
}
