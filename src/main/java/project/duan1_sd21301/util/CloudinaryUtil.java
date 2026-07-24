package project.duan1_sd21301.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {

    // Cấu hình Cloudinary Credentials
    // Lưu ý: Thay "d_cloud_name" bằng Cloud Name cụ thể trên tài khoản Cloudinary của bạn (ví dụ: dx123456)
    private static String cloudName = System.getenv("CLOUDINARY_CLOUD_NAME") != null 
            ? System.getenv("CLOUDINARY_CLOUD_NAME") : "hpjixeta";

    private static final String API_KEY = "535945819386347";
    private static final String API_SECRET = "rml76RNfRfB_dn2NZUqyT-mB7w8";

    private static Cloudinary cloudinary;

    static {
        initCloudinary();
    }

    private static void initCloudinary() {
        try {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", cloudName,
                    "api_key", API_KEY,
                    "api_secret", API_SECRET,
                    "secure", true
            ));
        } catch (Exception e) {
            System.err.println("❌ Khởi tạo Cloudinary thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void setCloudName(String newCloudName) {
        if (newCloudName != null && !newCloudName.trim().isEmpty()) {
            cloudName = newCloudName.trim();
            initCloudinary();
        }
    }

    public static String getCloudName() {
        return cloudName;
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }

    /**
     * Upload InputStream file ảnh lên Cloudinary và trả về HTTPS URL công khai.
     *
     * @param inputStream dữ liệu luồng ảnh từ request HTTP
     * @param folderName  tên thư mục lưu trữ trên Cloudinary (ví dụ: "product_variants")
     * @return Đường dẫn HTTPS (secure_url) của ảnh trên Cloudinary
     */
    public static String uploadImage(InputStream inputStream, String folderName) throws Exception {
        if (inputStream == null) {
            return null;
        }
        byte[] fileBytes = inputStream.readAllBytes();
        if (fileBytes.length == 0) {
            return null;
        }
        return uploadImageBytes(fileBytes, folderName);
    }

    /**
     * Upload byte array dữ liệu ảnh trực tiếp lên Cloudinary.
     *
     * @param bytes      dữ liệu byte của ảnh
     * @param folderName tên thư mục trên Cloudinary
     * @return Đường dẫn HTTPS (secure_url)
     */
    public static String uploadImageBytes(byte[] bytes, String folderName) throws Exception {
        if (bytes == null || bytes.length == 0) {
            return null;
        }
        Map params = ObjectUtils.asMap(
                "folder", folderName != null ? folderName : "product_variants",
                "resource_type", "image"
        );
        Map uploadResult = cloudinary.uploader().upload(bytes, params);
        if (uploadResult != null && uploadResult.containsKey("secure_url")) {
            return (String) uploadResult.get("secure_url");
        }
        return null;
    }
}
