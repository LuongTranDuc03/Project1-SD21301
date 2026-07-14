package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.service.HoaDonService;
import project.duan1_sd21301.service.impl.HoaDonServiceImpl;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servlet xuất danh sách hóa đơn ra file Excel (.xlsx).
 * URL: GET /admin/orders/export-excel
 *
 * Tham số nhận (giống invoice-list):
 *   trangThai  — lọc theo trạng thái (null = tất cả)
 *   q          — từ khóa tìm kiếm (tên KH hoặc mã HD)
 */
@WebServlet("/admin/orders/export-excel")
public class ExcelServlet extends HttpServlet {

    private final HoaDonService hoaDonService = new HoaDonServiceImpl();

    private static final String[] HEADERS = {
        "STT", "Mã HD", "Tên khách hàng", "Số điện thoại",
        "Tổng tiền (đ)", "Ngày đặt", "Thanh toán", "Trạng thái"
    };

    private static final String[] TRANG_THAI_LABELS = {
        "Chờ xác nhận", "Đã xác nhận", "Đang giao hàng", "Thành công", "Đã huỷ"
    };

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // Lấy tham số lọc giống trang danh sách
        Integer trangThai = null;
        String trangThaiParam = req.getParameter("trangThai");
        if (trangThaiParam != null && !trangThaiParam.isBlank()) {
            try { trangThai = Integer.parseInt(trangThaiParam); } catch (NumberFormatException ignored) {}
        }
        String keyword = req.getParameter("q");

        // Lấy TOÀN BỘ dữ liệu (không phân trang) theo bộ lọc hiện tại
        long total = hoaDonService.countHoaDons(trangThai, keyword);
        List<HoaDon> hoaDons = hoaDonService.getHoaDons(trangThai, keyword, 0, (int) Math.max(total, 1));

        // Tạo workbook Excel
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh sach hoa don");

            // ===== Style: tiêu đề bảng (dòng 0) =====
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);
            titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // ===== Style: header cột (dòng 1) =====
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_RED.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // ===== Style: dữ liệu =====
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // ===== Style: dữ liệu xen kẽ (màu nền nhạt) =====
            CellStyle dataAltStyle = workbook.createCellStyle();
            dataAltStyle.cloneStyleFrom(dataStyle);
            dataAltStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
            dataAltStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // ===== Style: số tiền (căn phải) =====
            CellStyle moneyStyle = workbook.createCellStyle();
            moneyStyle.cloneStyleFrom(dataStyle);
            moneyStyle.setAlignment(HorizontalAlignment.RIGHT);
            DataFormat format = workbook.createDataFormat();
            moneyStyle.setDataFormat(format.getFormat("#,##0"));

            CellStyle moneyAltStyle = workbook.createCellStyle();
            moneyAltStyle.cloneStyleFrom(dataAltStyle);
            moneyAltStyle.setAlignment(HorizontalAlignment.RIGHT);
            moneyAltStyle.setDataFormat(format.getFormat("#,##0"));

            // ===== Dòng 0: Tiêu đề lớn =====
            Row titleRow = sheet.createRow(0);
            titleRow.setHeightInPoints(28);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("DANH SÁCH HÓA ĐƠN - FAMICOATS");
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, HEADERS.length - 1));

            // ===== Dòng 1: Header cột =====
            Row headerRow = sheet.createRow(1);
            headerRow.setHeightInPoints(22);
            for (int i = 0; i < HEADERS.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(HEADERS[i]);
                cell.setCellStyle(headerStyle);
            }

            // ===== Dòng 2+: Dữ liệu =====
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            int rowIdx = 2;
            int sttIndex = 1;
            for (HoaDon hd : hoaDons) {
                Row row = sheet.createRow(rowIdx);
                row.setHeightInPoints(18);

                boolean isAlt = (rowIdx % 2 == 0);
                CellStyle cs      = isAlt ? dataAltStyle  : dataStyle;
                CellStyle csMoney = isAlt ? moneyAltStyle : moneyStyle;

                // STT
                Cell cStt = row.createCell(0);
                cStt.setCellValue(sttIndex++);
                cStt.setCellStyle(cs);

                // Mã HD
                Cell c0 = row.createCell(1);
                c0.setCellValue("HD" + hd.getId());
                c0.setCellStyle(cs);

                // Tên khách hàng
                Cell c1 = row.createCell(2);
                c1.setCellValue(hd.getTenKhachHang() != null ? hd.getTenKhachHang() : "");
                c1.setCellStyle(cs);

                // Số điện thoại
                Cell c2 = row.createCell(3);
                c2.setCellValue(hd.getSdtKhachHang() != null ? hd.getSdtKhachHang() : "");
                c2.setCellStyle(cs);

                // Tổng tiền
                Cell c3 = row.createCell(4);
                if (hd.getTongThanhToan() != null) {
                    c3.setCellValue(hd.getTongThanhToan());
                } else {
                    c3.setCellValue(0);
                }
                c3.setCellStyle(csMoney);

                // Ngày đặt
                Cell c4 = row.createCell(5);
                c4.setCellValue(hd.getNgayDatHang() != null ? hd.getNgayDatHang().format(dtf) : "");
                c4.setCellStyle(cs);

                // Phương thức thanh toán
                Cell c5 = row.createCell(6);
                c5.setCellValue(hd.getPhuongThucThanhToan() != null
                        ? hd.getPhuongThucThanhToan().getTenPhuongThuc() : "—");
                c5.setCellStyle(cs);

                // Trạng thái
                Cell c6 = row.createCell(7);
                int tt = hd.getTrangThaiDonHang() != null ? hd.getTrangThaiDonHang() : 0;
                c6.setCellValue(tt >= 0 && tt < TRANG_THAI_LABELS.length ? TRANG_THAI_LABELS[tt] : "?");
                c6.setCellStyle(cs);

                rowIdx++;
            }

            // ===== Dòng tổng kết =====
            Row sumRow = sheet.createRow(rowIdx + 1);
            CellStyle sumStyle = workbook.createCellStyle();
            Font sumFont = workbook.createFont();
            sumFont.setBold(true);
            sumStyle.setFont(sumFont);
            sumStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            sumStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            sumStyle.setBorderBottom(BorderStyle.THIN);
            sumStyle.setBorderTop(BorderStyle.THIN);
            sumStyle.setBorderLeft(BorderStyle.THIN);
            sumStyle.setBorderRight(BorderStyle.THIN);

            Cell sumLabel = sumRow.createCell(0);
            sumLabel.setCellValue("Tổng cộng: " + hoaDons.size() + " hóa đơn");
            sumLabel.setCellStyle(sumStyle);
            sheet.addMergedRegion(new CellRangeAddress(rowIdx + 1, rowIdx + 1, 0, HEADERS.length - 1));

            // ===== Tự động điều chỉnh độ rộng cột =====
            for (int i = 0; i < HEADERS.length; i++) {
                sheet.autoSizeColumn(i);
                // Thêm padding nhỏ
                sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 512);
            }

            // ===== Xuất file ra response =====
            String filename = "HoaDon_FamiCoats.xlsx";
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            resp.setCharacterEncoding("UTF-8");

            workbook.write(resp.getOutputStream());
            resp.getOutputStream().flush();
        }
    }
}
