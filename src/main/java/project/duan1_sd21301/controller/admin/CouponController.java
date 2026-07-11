package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Coupon;
import project.duan1_sd21301.util.MockData;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CouponController", value = "/admin/coupons")
public class CouponController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        List<Coupon> coupons = MockData.getCoupons();
        request.setAttribute("pageTitle", "Quản lý phiếu giảm giá");
        request.setAttribute("coupons", coupons);

        // Nếu có thông báo (thêm/sửa/xóa thành công)
        String successMsg = request.getParameter("success");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/coupon-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            // --- XÓA PHIẾU GIẢM GIÁ ---
            int id = Integer.parseInt(request.getParameter("id"));
            MockData.deleteCoupon(id);
            response.sendRedirect(request.getContextPath() + "/admin/coupons?success=deleted");

        } else if ("create".equals(action)) {
            // --- TẠO MỚI PHIẾU GIẢM GIÁ ---
            Coupon newCoupon = buildCouponFromRequest(request, null);
            if (newCoupon != null) {
                MockData.addCoupon(newCoupon);
            }
            response.sendRedirect(request.getContextPath() + "/admin/coupons?success=created");

        } else if ("update".equals(action)) {
            // --- CẬP NHẬT PHIẾU GIẢM GIÁ ---
            int id = Integer.parseInt(request.getParameter("id"));
            Coupon existing = MockData.getCouponById(id);
            Coupon updated = buildCouponFromRequest(request, existing);
            if (updated != null) {
                updated.setId(id);
                // Giữ nguyên code (fix cứng, không cho đổi)
                if (existing != null) {
                    updated.setCode(existing.getCode());
                }
                MockData.updateCoupon(updated);
            }
            response.sendRedirect(request.getContextPath() + "/admin/coupons?success=updated");

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/coupons");
        }
    }

    /**
     * Hàm xây dựng đối tượng Coupon từ dữ liệu form
     */
    private Coupon buildCouponFromRequest(HttpServletRequest request, Coupon existing) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            String code = request.getParameter("code");
            String tenChuongTrinh = request.getParameter("tenChuongTrinh");
            String loaiGiam = request.getParameter("loaiGiam");
            double giaTriGiam = Double.parseDouble(request.getParameter("giaTriGiam"));
            double giaTriDonHangToiThieu = Double.parseDouble(request.getParameter("giaTriDonHangToiThieu"));
            double giamToiDa = Double.parseDouble(request.getParameter("giamToiDa") != null && !request.getParameter("giamToiDa").isEmpty() ? request.getParameter("giamToiDa") : "0");
            int soLuong = Integer.parseInt(request.getParameter("soLuong") != null && !request.getParameter("soLuong").isEmpty() ? request.getParameter("soLuong") : "0");
            int daSuDung = existing != null ? existing.getDaSuDung() : 0;
            Date ngayBatDau = sdf.parse(request.getParameter("ngayBatDau"));
            Date ngayKetThuc = sdf.parse(request.getParameter("ngayKetThuc"));
            String moTa = request.getParameter("moTa") != null ? request.getParameter("moTa") : "";
            int trangThai = Integer.parseInt(request.getParameter("trangThai") != null ? request.getParameter("trangThai") : "1");

            Coupon coupon = new Coupon(null, code, tenChuongTrinh, loaiGiam, giaTriGiam,
                    giaTriDonHangToiThieu, giamToiDa, soLuong, daSuDung,
                    ngayBatDau, ngayKetThuc, moTa, trangThai);
            return coupon;

        } catch (ParseException | NumberFormatException e) {
            e.printStackTrace();
            return null;
        }
    }
}
