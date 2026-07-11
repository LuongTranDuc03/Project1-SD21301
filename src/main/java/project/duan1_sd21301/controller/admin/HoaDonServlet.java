package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.service.HoaDonService;
import project.duan1_sd21301.service.impl.HoaDonServiceImpl;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet xử lý tất cả chức năng liên quan đến hóa đơn.
 * <p>
 * URL mapping:
 *   GET  /admin/orders              — Danh sách hóa đơn (phân trang, lọc)
 *   GET  /admin/orders/detail?id=  — Chi tiết hóa đơn
 *   POST /admin/orders/update-status — Cập nhật trạng thái đơn hàng
 *   POST /admin/orders/cancel       — Hủy hóa đơn
 * </p>
 */
@WebServlet(urlPatterns = {
    "/admin/orders",
    "/admin/orders/detail",
    "/admin/orders/print",
    "/admin/orders/update-status",
    "/admin/orders/cancel"
})
public class HoaDonServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    private final HoaDonService hoaDonService = new HoaDonServiceImpl();

    // =================================================================
    //  GET
    // =================================================================

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length()); // bỏ context path

        if (path.equals("/admin/orders/detail")) {
            handleDetail(req, resp);
        } else if (path.equals("/admin/orders/print")) {
            handlePrint(req, resp);
        } else {
            handleList(req, resp);
        }
    }

    /**
     * Hiển thị danh sách hóa đơn.
     */
    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy tham số phân trang
        int page = parseIntOrDefault(req.getParameter("page"), 0);
        int size = parseIntOrDefault(req.getParameter("size"), DEFAULT_PAGE_SIZE);

        // Lấy tham số lọc trạng thái
        Integer trangThai = null;
        String trangThaiParam = req.getParameter("trangThai");
        if (trangThaiParam != null && !trangThaiParam.isBlank()) {
            try { trangThai = Integer.parseInt(trangThaiParam); } catch (NumberFormatException ignored) {}
        }

        // Từ khóa tìm kiếm
        String keyword = req.getParameter("q");

        // Lấy dữ liệu
        List<HoaDon> hoaDons = hoaDonService.getHoaDons(trangThai, keyword, page, size);
        long total = hoaDonService.countHoaDons(trangThai, keyword);
        int totalPages = (int) Math.ceil((double) total / size);

        // Nhãn trạng thái để hiển thị
        Map<Integer, String> trangThaiLabels = new HashMap<>();
        trangThaiLabels.put(0, "Chờ xác nhận");
        trangThaiLabels.put(1, "Đã xác nhận");
        trangThaiLabels.put(2, "Đang giao hàng");
        trangThaiLabels.put(3, "Thành công");
        trangThaiLabels.put(4, "Đã huỷ");

        // Truyền sang JSP
        req.setAttribute("hoaDons", hoaDons);
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("size", size);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentTrangThai", trangThai);
        req.setAttribute("keyword", keyword);
        req.setAttribute("trangThaiLabels", trangThaiLabels);
        req.setAttribute("pageTitle", "Quản lý Hóa đơn");

        req.getRequestDispatcher("/WEB-INF/views/admin/invoice-list.jsp").forward(req, resp);
    }

    /**
     * Hiển thị chi tiết một hóa đơn.
     */
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            hoaDonService.getChiTiet(id).ifPresentOrElse(
                hoaDon -> {
                    try {
                        req.setAttribute("hoaDon", hoaDon);
                        req.setAttribute("chiTietList", hoaDonService.getChiTietSanPhams(id));
                        req.setAttribute("lichSuList", hoaDonService.getLichSuTrangThai(id));
                        req.setAttribute("pageTitle", "Chi tiết Hóa đơn #" + id);

                        Map<Integer, String> trangThaiLabels = new HashMap<>();
                        trangThaiLabels.put(0, "Chờ xác nhận");
                        trangThaiLabels.put(1, "Đã xác nhận");
                        trangThaiLabels.put(2, "Đang giao hàng");
                        trangThaiLabels.put(3, "Thành công");
                        trangThaiLabels.put(4, "Đã huỷ");
                        req.setAttribute("trangThaiLabels", trangThaiLabels);

                        req.getRequestDispatcher("/WEB-INF/views/admin/invoice-detail.jsp")
                           .forward(req, resp);
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                },
                () -> {
                    try {
                        resp.sendRedirect(req.getContextPath() + "/admin/orders?error=notfound");
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            );
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }

    // =================================================================
    //  POST
    // =================================================================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if (path.equals("/admin/orders/cancel")) {
            handleCancel(req, resp);
        } else if (path.equals("/admin/orders/update-status")) {
            handleUpdateStatus(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }

    /**
     * Hiển thị trang in hóa đơn.
     */
    private void handlePrint(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            hoaDonService.getChiTiet(id).ifPresentOrElse(
                hoaDon -> {
                    try {
                        req.setAttribute("hoaDon", hoaDon);
                        req.setAttribute("chiTietList", hoaDonService.getChiTietSanPhams(id));

                        java.util.Map<Integer, String> labels = new java.util.HashMap<>();
                        labels.put(0, "Chờ xác nhận"); labels.put(1, "Đã xác nhận");
                        labels.put(2, "Đang giao hàng"); labels.put(3, "Thành công");
                        labels.put(4, "Đã huỷ");
                        req.setAttribute("trangThaiLabels", labels);

                        req.getRequestDispatcher("/WEB-INF/views/admin/invoice-print.jsp")
                           .forward(req, resp);
                    } catch (Exception e) { throw new RuntimeException(e); }
                },
                () -> {
                    try { resp.sendRedirect(req.getContextPath() + "/admin/orders"); }
                    catch (IOException e) { throw new RuntimeException(e); }
                }
            );
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }

    /**
     * Xử lý cập nhật trạng thái đơn hàng.
     */
    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int hoaDonId       = Integer.parseInt(req.getParameter("hoaDonId"));
            int trangThaiMoi   = Integer.parseInt(req.getParameter("trangThaiMoi"));
            String ghiChu      = req.getParameter("ghiChu");
            Integer nhanVienId = parseIntOrNull(req.getParameter("nhanVienId"));

            hoaDonService.capNhatTrangThai(hoaDonId, trangThaiMoi, nhanVienId, null, ghiChu);
            resp.sendRedirect(req.getContextPath() + "/admin/orders/detail?id=" + hoaDonId + "&msg=updated");

        } catch (IllegalStateException | IllegalArgumentException ex) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=" + encodeURL(ex.getMessage()));
        } catch (Exception ex) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=server_error");
        }
    }

    /**
     * Xử lý hủy hóa đơn.
     */
    private void handleCancel(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            int hoaDonId        = Integer.parseInt(req.getParameter("hoaDonId"));
            String lyDo         = req.getParameter("lyDo");
            Integer nhanVienId  = parseIntOrNull(req.getParameter("nhanVienId"));
            Integer khachHangId = parseIntOrNull(req.getParameter("khachHangId"));

            hoaDonService.huyHoaDon(hoaDonId, nhanVienId, khachHangId, lyDo);
            resp.sendRedirect(req.getContextPath() + "/admin/orders/detail?id=" + hoaDonId + "&msg=cancelled");

        } catch (IllegalStateException | IllegalArgumentException ex) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=" + encodeURL(ex.getMessage()));
        } catch (Exception ex) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders?error=server_error");
        }
    }

    // =================================================================
    //  UTILS
    // =================================================================

    private int parseIntOrDefault(String value, int defaultVal) {
        if (value == null || value.isBlank()) return defaultVal;
        try { return Integer.parseInt(value.trim()); } catch (NumberFormatException e) { return defaultVal; }
    }

    private Integer parseIntOrNull(String value) {
        if (value == null || value.isBlank()) return null;
        try { return Integer.parseInt(value.trim()); } catch (NumberFormatException e) { return null; }
    }

    private String encodeURL(String msg) {
        if (msg == null) return "";
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
