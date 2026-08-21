package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import project.duan1_sd21301.repository.DashboardRepository;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "InventoryDashboardController", urlPatterns = {"/admin/inventory-dashboard", "/admin/inventory-dashboard/export-excel"})
public class InventoryDashboardController extends HttpServlet {

    private DashboardRepository repo = new DashboardRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/export-excel")) {
            handleExportExcel(request, response);
        } else {
            handleDashboard(request, response);
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("invPage");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (Exception e) {}
        }
        
        Integer invMonth = parseIntegerParam(request.getParameter("invMonth"));
        Integer invBrandId = parseIntegerParam(request.getParameter("invBrand"));
        Integer invStatus = parseIntegerParam(request.getParameter("invStatus"));
        
        String searchQuery = request.getParameter("searchQuery");
        if (searchQuery != null) searchQuery = searchQuery.trim();
        
        List<Map<String, Object>> inventoryStats = repo.getInventoryStats(page, pageSize, invMonth, invBrandId, invStatus, searchQuery);
        int totalInvItems = repo.countInventoryStats(invMonth, invBrandId, invStatus, searchQuery);
        int invTotalPages = (int) Math.ceil((double) totalInvItems / pageSize);
        if (invTotalPages == 0) invTotalPages = 1;
        
        Map<String, Object> kpis = repo.getInventoryKPIs(invMonth);
        request.setAttribute("kpis", kpis);
        
        request.setAttribute("inventoryStats", inventoryStats);
        request.setAttribute("invPage", page);
        request.setAttribute("invTotalPages", invTotalPages);
        request.setAttribute("invTotalItems", totalInvItems);
        request.setAttribute("invPageSize", pageSize);
        request.setAttribute("invMonth", invMonth);
        request.setAttribute("invBrandId", invBrandId);
        request.setAttribute("invStatus", invStatus);
        request.setAttribute("brands", repo.getBrands());

        request.setAttribute("pageTitle", "Thống kê tồn kho");
        request.getRequestDispatcher("/WEB-INF/views/admin/inventory-dashboard.jsp").forward(request, response);
    }
    
    private void handleExportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer invMonth = parseIntegerParam(request.getParameter("invMonth"));
        Integer invBrandId = parseIntegerParam(request.getParameter("invBrand"));
        Integer invStatus = parseIntegerParam(request.getParameter("invStatus"));
        
        String searchQuery = request.getParameter("searchQuery");
        if (searchQuery != null) searchQuery = searchQuery.trim();

        // Get all stats for export
        List<Map<String, Object>> allStats = repo.getInventoryStats(1, Integer.MAX_VALUE, invMonth, invBrandId, invStatus, searchQuery);

        try (XSSFWorkbook wb = new XSSFWorkbook()) {
            Sheet sheet = wb.createSheet("Ton kho");

            // Styles
            CellStyle headerStyle = wb.createCellStyle();
            Font headerFont = wb.createFont();
            headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 11);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            CellStyle titleStyle = wb.createCellStyle();
            Font titleFont = wb.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);
            titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            CellStyle dataStyle = wb.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            CellStyle numStyle = wb.createCellStyle();
            numStyle.cloneStyleFrom(dataStyle);
            DataFormat fmt = wb.createDataFormat();
            numStyle.setDataFormat(fmt.getFormat("#,##0"));
            numStyle.setAlignment(HorizontalAlignment.RIGHT);

            CellStyle centerStyle = wb.createCellStyle();
            centerStyle.cloneStyleFrom(dataStyle);
            centerStyle.setAlignment(HorizontalAlignment.CENTER);

            // Title
            Row titleRow = sheet.createRow(0);
            titleRow.setHeightInPoints(28);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("THONG KE TON KHO - FAMICOATS");
            titleCell.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));

            Row subRow = sheet.createRow(1);
            Cell subCell = subRow.createCell(0);
            subCell.setCellValue("Xuat ngay: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 7));

            // Headers
            String[] headers = { "STT", "Ma san pham", "Ma bien the", "Ten san pham", "Thuoc tinh", "So luong ton", "Da ban", "Trang thai" };
            Row headerRow = sheet.createRow(3);
            headerRow.setHeightInPoints(20);
            for (int i = 0; i < headers.length; i++) {
                Cell c = headerRow.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(headerStyle);
            }

            // Data rows
            int rowIdx = 4;
            int stt = 1;
            for (Map<String, Object> stat : allStats) {
                Row row = sheet.createRow(rowIdx++);
                row.setHeightInPoints(18);

                Cell c0 = row.createCell(0);
                c0.setCellValue(stt++);
                c0.setCellStyle(centerStyle);

                Cell c1 = row.createCell(1);
                c1.setCellValue(stat.get("productCode") != null ? stat.get("productCode").toString() : "");
                c1.setCellStyle(centerStyle);

                Cell c2 = row.createCell(2);
                c2.setCellValue(stat.get("variantCode") != null ? stat.get("variantCode").toString() : "");
                c2.setCellStyle(centerStyle);

                Cell c3 = row.createCell(3);
                c3.setCellValue(stat.get("productName") != null ? stat.get("productName").toString() : "");
                c3.setCellStyle(dataStyle);

                Cell c4 = row.createCell(4);
                c4.setCellValue(stat.get("attributes") != null ? stat.get("attributes").toString() : "");
                c4.setCellStyle(dataStyle);

                int stock = stat.get("stock") != null ? (Integer) stat.get("stock") : 0;
                Cell c5 = row.createCell(5);
                c5.setCellValue(stock);
                c5.setCellStyle(numStyle);

                int sold = stat.get("totalSold") != null ? (Integer) stat.get("totalSold") : 0;
                Cell c6 = row.createCell(6);
                c6.setCellValue(sold);
                c6.setCellStyle(numStyle);

                String status = "";
                if (stock == 0) status = "Het hang";
                else if (stock < 10) status = "Sap het";
                else status = "Con hang";
                
                Cell c7 = row.createCell(7);
                c7.setCellValue(status);
                c7.setCellStyle(centerStyle);
            }

            for (int i = 0; i < headers.length; i++) {
                if (i == 3 || i == 4) sheet.setColumnWidth(i, 8000);
                else sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"ThongKeTonKho_" + System.currentTimeMillis() + ".xlsx\"");
            wb.write(response.getOutputStream());
        }
    }
    
    private Integer parseIntegerParam(String param) {
        if (param != null && !param.trim().isEmpty() && !param.equals("all")) {
            try {
                return Integer.parseInt(param);
            } catch (Exception e) {}
        }
        return null;
    }
}
