package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<< HEAD
import java.io.IOException;
=======
import project.duan1_sd21301.model.Coupon;
import project.duan1_sd21301.repository.CouponRepository;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed

@WebServlet(name = "CouponController", value = "/admin/coupons")
public class CouponController extends HttpServlet {

<<<<<<< HEAD
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Quản lý phiếu giảm giá");
        request.getRequestDispatcher("/WEB-INF/views/admin/under-construction.jsp").forward(request, response);
=======
    private final CouponRepository couponRepository = new CouponRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchQuery = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String success = request.getParameter("success");

        // Lấy toàn bộ danh sách phiếu giảm giá
        List<Coupon> allCoupons = couponRepository.findAll();
        List<Coupon> filteredCoupons = new ArrayList<>();

        // Lọc theo tìm kiếm và trạng thái
        for (Coupon c : allCoupons) {
            boolean matchesSearch = true;
            boolean matchesStatus = true;

            // Lọc theo mã hoặc tên chương trình
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String q = searchQuery.toLowerCase().trim();
                matchesSearch = c.getId().toLowerCase().contains(q) 
                             || (c.getTenChuongTrinh() != null && c.getTenChuongTrinh().toLowerCase().contains(q));
            }

            // Lọc theo trạng thái
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
                matchesStatus = c.getTrangThai().equalsIgnoreCase(statusFilter);
            }

            if (matchesSearch && matchesStatus) {
                filteredCoupons.add(c);
            }
        }

        // Đếm số lượng các trạng thái để hiển thị thống kê
        int totalCount = allCoupons.size();
        int activeCount = 0;
        int upcomingCount = 0;
        int expiredCount = 0;
        int inactiveCount = 0;

        for (Coupon c : allCoupons) {
            // Tự động kiểm tra cập nhật trạng thái theo ngày nếu không ở trạng thái tạm dừng (INACTIVE)
            if (!"INACTIVE".equalsIgnoreCase(c.getTrangThai())) {
                Date now = new Date();
                if (c.getNgayKetThuc() != null && now.after(c.getNgayKetThuc())) {
                    c.setTrangThai("EXPIRED");
                } else if (c.getNgayBatDau() != null && now.before(c.getNgayBatDau())) {
                    c.setTrangThai("UPCOMING");
                } else if (c.getSoLuong() <= c.getDaSuDung()) {
                    c.setTrangThai("EXPIRED"); // Hết lượt sử dụng cũng coi như hết hạn/hết hàng
                } else {
                    c.setTrangThai("ACTIVE");
                }
            }

            switch (c.getTrangThai().toUpperCase()) {
                case "ACTIVE":
                    activeCount++;
                    break;
                case "UPCOMING":
                    upcomingCount++;
                    break;
                case "EXPIRED":
                    expiredCount++;
                    break;
                case "INACTIVE":
                    inactiveCount++;
                    break;
            }
        }

        // Thiết lập thông báo thành công nếu có
        if (success != null) {
            switch (success) {
                case "add":
                    request.setAttribute("successMsg", "Thêm phiếu giảm giá thành công!");
                    break;
                case "edit":
                    request.setAttribute("successMsg", "Cập nhật phiếu giảm giá thành công!");
                    break;
                case "delete":
                    request.setAttribute("successMsg", "Xóa phiếu giảm giá thành công!");
                    break;
            }
        }

        // Thiết lập thuộc tính gửi sang JSP
        request.setAttribute("pageTitle", "Quản lý phiếu giảm giá");
        request.setAttribute("coupons", filteredCoupons);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("upcomingCount", upcomingCount);
        request.setAttribute("expiredCount", expiredCount);
        request.setAttribute("inactiveCount", inactiveCount);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("statusFilter", statusFilter);

        // Gửi sang trang coupon-list.jsp
        request.getRequestDispatcher("/WEB-INF/views/admin/coupon-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            String id = request.getParameter("id");
            couponRepository.delete(id);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?success=delete");
            return;
        }

        // Đọc thông tin từ form
        String id = request.getParameter("id");
        String tenChuongTrinh = request.getParameter("tenChuongTrinh");
        String loaiGiam = request.getParameter("loaiGiam");
        double giaTriGiam = getDoubleParam(request, "giaTriGiam");
        double giaTriDonHangToiThieu = getDoubleParam(request, "giaTriDonHangToiThieu");
        double giamToiDa = getDoubleParam(request, "giamToiDa");
        int soLuong = getIntParam(request, "soLuong");
        int daSuDung = getIntParam(request, "daSuDung");
        Date ngayBatDau = parseDateTime(request.getParameter("ngayBatDau"));
        Date ngayKetThuc = parseDateTime(request.getParameter("ngayKetThuc"));
        String moTa = request.getParameter("moTa");
        String trangThai = request.getParameter("trangThai");

        // Nếu ngày kết thúc trước ngày bắt đầu thì mặc định
        if (ngayKetThuc != null && ngayBatDau != null && ngayKetThuc.before(ngayBatDau)) {
            ngayKetThuc = new Date(ngayBatDau.getTime() + 7 * 24 * 60 * 60 * 1000L); // mặc định cộng 7 ngày
        }

        // Tự động kiểm tra trạng thái ban đầu nếu không phải INACTIVE
        if (!"INACTIVE".equalsIgnoreCase(trangThai)) {
            Date now = new Date();
            if (ngayKetThuc != null && now.after(ngayKetThuc)) {
                trangThai = "EXPIRED";
            } else if (ngayBatDau != null && now.before(ngayBatDau)) {
                trangThai = "UPCOMING";
            } else if (soLuong <= daSuDung) {
                trangThai = "EXPIRED";
            } else {
                trangThai = "ACTIVE";
            }
        }

        Coupon coupon = Coupon.builder()
                .id(id)
                .tenChuongTrinh(tenChuongTrinh)
                .loaiGiam(loaiGiam)
                .giaTriGiam(giaTriGiam)
                .giaTriDonHangToiThieu(giaTriDonHangToiThieu)
                .giamToiDa(giamToiDa)
                .soLuong(soLuong)
                .daSuDung(daSuDung)
                .ngayBatDau(ngayBatDau)
                .ngayKetThuc(ngayKetThuc)
                .moTa(moTa)
                .trangThai(trangThai)
                .build();

        if ("add".equalsIgnoreCase(action)) {
            boolean success = couponRepository.insert(coupon);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/coupons?success=add");
            } else {
                // Trùng mã hoặc lỗi
                request.setAttribute("errorMsg", "Mã phiếu giảm giá đã tồn tại!");
                doGet(request, response);
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            boolean success = couponRepository.update(coupon);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/coupons?success=edit");
            } else {
                request.setAttribute("errorMsg", "Không thể cập nhật phiếu giảm giá!");
                doGet(request, response);
            }
        }
    }

    private double getDoubleParam(HttpServletRequest request, String name) {
        try {
            return Double.parseDouble(request.getParameter(name).replace(",", ""));
        } catch (Exception e) {
            return 0.0;
        }
    }

    private int getIntParam(HttpServletRequest request, String name) {
        try {
            return Integer.parseInt(request.getParameter(name));
        } catch (Exception e) {
            return 0;
        }
    }

    private Date parseDateTime(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            if (dateStr.contains("T")) {
                return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(dateStr);
            }
            return new SimpleDateFormat("yyyy-MM-dd HH:mm").parse(dateStr);
        } catch (Exception e) {
            try {
                return new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
            } catch (Exception ex) {
                return new Date();
            }
        }
>>>>>>> 4ab1a6c62386556ffecbcd9edcc3018af0319fed
    }
}
