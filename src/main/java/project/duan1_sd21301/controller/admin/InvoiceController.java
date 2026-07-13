package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.Invoice;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "InvoiceController", value = "/admin/invoices")
public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Tạo dữ liệu giả lập (Mock Data) cho Hóa đơn
        List<Invoice> invoices = new ArrayList<>();
        
        // Sử dụng thời gian lùi lại tương đối
        long now = System.currentTimeMillis();
        invoices.add(new Invoice("HD-2401", "Nguyễn Văn A", "0987654321", "Áo khoác da nam Premium", 1, new Date(now - 2 * 60 * 1000), 1850000.0, "Chuyển khoản", "SUCCESS"));
        invoices.add(new Invoice("HD-2400", "Trần Thị B", "0912345678", "Bomber jacket oversize", 2, new Date(now - 15 * 60 * 1000), 1290000.0, "Tiền mặt", "SHIPPING"));
        invoices.add(new Invoice("HD-2399", "Lê Minh C", "0909090909", "Áo denim wash nữ", 1, new Date(now - 60 * 60 * 1000), 890000.0, "Chuyển khoản", "PENDING"));
        invoices.add(new Invoice("HD-2398", "Phạm Lan D", "0977777777", "Áo phao siêu nhẹ", 3, new Date(now - 120 * 60 * 1000), 2100000.0, "Chuyển khoản", "SUCCESS"));
        invoices.add(new Invoice("HD-2397", "Hoàng Văn E", "0966666666", "Khoác gió windbreaker", 2, new Date(now - 24 * 60 * 60 * 1000), 3400000.0, "Thẻ tín dụng", "CANCELLED"));
        invoices.add(new Invoice("HD-2396", "Đỗ Thị F", "0955555555", "Áo khoác da nam Premium", 1, new Date(now - 30 * 60 * 60 * 1000), 990000.0, "Tiền mặt", "SUCCESS"));
        
        // Thiết lập các thuộc tính gửi sang JSP
        request.setAttribute("pageTitle", "Quản lý hoá đơn");
        request.setAttribute("invoices", invoices);
        
        // Gửi sang trang invoice-list.jsp
        request.getRequestDispatcher("/WEB-INF/views/admin/invoice-list.jsp").forward(request, response);
    }
}
