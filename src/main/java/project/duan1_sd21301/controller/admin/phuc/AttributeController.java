package project.duan1_sd21301.controller.admin.phuc;

import project.duan1_sd21301.dto.phuc.AttributeDTO;
import project.duan1_sd21301.service.phuc.AttributeService;
import project.duan1_sd21301.service.phuc.AttributeServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.text.SimpleDateFormat;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "AttributeController", urlPatterns = {
        "/admin/attributes",
        "/admin/attributes/save",
        "/admin/attributes/toggle-status",
        "/admin/attributes/export"
})
public class AttributeController extends HttpServlet {

    private AttributeService attributeService;

    @Override
    public void init() throws ServletException {
        attributeService = new AttributeServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/admin/attributes")) {
            showAttributeList(request, response);
        } else if (uri.endsWith("/admin/attributes/export")) {
            exportExcel(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.endsWith("/admin/attributes/save")) {
            saveAttribute(request, response);
        } else if (uri.endsWith("/admin/attributes/toggle-status")) {
            toggleStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showAttributeList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "category"; // default tab
        }
        
        String pageStr = request.getParameter("page");
        int page = 0;
        int size = 10;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 0) page = 0;
            } catch (NumberFormatException e) {
                page = 0;
            }
        }
        
        List<AttributeDTO> list = attributeService.findAll(type, page, size);
        long totalItems = attributeService.countAll(type);
        int totalPages = (int) Math.ceil((double) totalItems / size);

        request.setAttribute("attributeList", list);
        request.setAttribute("currentType", type.toLowerCase());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("nextCode", attributeService.generateNextCode(type));

        request.getRequestDispatcher("/WEB-INF/views/admin/phuc/attribute-list.jsp").forward(request, response);
    }

    private void saveAttribute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "category";
        }

        String idStr = request.getParameter("id");
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String statusStr = request.getParameter("status");

        AttributeDTO dto = new AttributeDTO();
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                dto.setId(Integer.parseInt(idStr));
            } catch (NumberFormatException ignored) {}
        }
        dto.setCode(code);
        dto.setName(name);
        try {
            if (statusStr != null) {
                dto.setStatus(Integer.parseInt(statusStr));
            } else {
                dto.setStatus(1);
            }
        } catch (NumberFormatException e) {
            dto.setStatus(1);
        }

        boolean success = attributeService.save(type, dto);

        if (success) {
            request.getSession().setAttribute("message", "Lưu thuộc tính thành công!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Lưu thuộc tính thất bại!");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/attributes?type=" + type);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        String idStr = request.getParameter("id");
        if (type != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                attributeService.toggleStatus(type, id);
                request.getSession().setAttribute("message", "Cập nhật trạng thái thành công!");
                request.getSession().setAttribute("messageType", "success");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("message", "ID không hợp lệ!");
                request.getSession().setAttribute("messageType", "error");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/attributes?type=" + (type != null ? type : "category"));
    }

    private void exportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "category";
        }
        
        List<AttributeDTO> list = attributeService.findAll(type);
        
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Attributes");
            
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("STT");
            headerRow.createCell(1).setCellValue("Mã thuộc tính");
            headerRow.createCell(2).setCellValue("Tên thuộc tính");
            headerRow.createCell(3).setCellValue("Trạng thái");
            headerRow.createCell(4).setCellValue("Ngày tạo");
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            int rowNum = 1;
            for (AttributeDTO dto : list) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(rowNum - 1);
                row.createCell(1).setCellValue(dto.getCode() != null ? dto.getCode() : "");
                row.createCell(2).setCellValue(dto.getName() != null ? dto.getName() : "");
                
                String statusStr = (dto.getStatus() != null && dto.getStatus() == 1) ? "Hoạt động" : "Ngừng hoạt động";
                row.createCell(3).setCellValue(statusStr);
                
                String dateStr = dto.getCreatedAt() != null ? sdf.format(dto.getCreatedAt()) : "";
                row.createCell(4).setCellValue(dateStr);
            }
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=Attributes_" + type + ".xlsx");
            
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
                out.flush();
            }
        }
    }
}
