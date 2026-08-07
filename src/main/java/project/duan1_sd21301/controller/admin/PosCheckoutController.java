package project.duan1_sd21301.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.dto.pos.PosOrderRequestDTO;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.service.pos.PosCheckoutService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "PosCheckoutController", value = "/admin/pos/checkout")
public class PosCheckoutController extends HttpServlet {

    private final PosCheckoutService checkoutService = new PosCheckoutService();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        Employee loggedInUser = (Employee) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }

        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        try {
            PosOrderRequestDTO orderDTO = mapper.readValue(sb.toString(), PosOrderRequestDTO.class);
            
            String result = checkoutService.processCheckout(orderDTO, loggedInUser);
            if (result != null) {
                // result có dạng "invoiceId|invoiceCode"
                String[] parts = result.split("\\|", 2);
                String invoiceId = parts.length > 0 ? parts[0] : "";
                String invoiceCode = parts.length > 1 ? parts[1] : result;
                out.print("{\"success\": true, \"message\": \"Checkout successful\", " +
                        "\"invoiceCode\": \"" + invoiceCode + "\", " +
                        "\"invoiceId\": " + invoiceId + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"Checkout failed. Please check logs.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            String msg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Lỗi hệ thống";
            out.print("{\"success\": false, \"message\": \"" + msg + "\"}");
        }
    }
}
