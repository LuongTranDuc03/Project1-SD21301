package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import project.duan1_sd21301.service.luong.ProductService;
import project.duan1_sd21301.service.luong.ProductServiceImpl;
import project.duan1_sd21301.repository.phuc.InvoiceRepository;

@WebServlet(name = "PosController", value = "/admin/pos")
public class PosController extends HttpServlet {

    private final ProductService productService = new ProductServiceImpl();
    private final InvoiceRepository invoiceRepository = new InvoiceRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Bán hàng tại quầy");
        
        // Pass data for modal
        request.setAttribute("products", productService.getAllProducts());
        request.setAttribute("colors", productService.getAllColors());
        request.setAttribute("sizes", productService.getAllSizes());
        
        long totalInvoices = invoiceRepository.countAll(null, null, null, null, null);
        request.setAttribute("nextOrderIndex", totalInvoices + 1);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/pos.jsp").forward(request, response);
    }
}

