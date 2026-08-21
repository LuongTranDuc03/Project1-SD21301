package project.duan1_sd21301.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.service.pos.PosDraftService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PosDraftController", urlPatterns = {
        "/admin/pos/api/create-order",
        "/admin/pos/api/add-item",
        "/admin/pos/api/update-item",
        "/admin/pos/api/remove-item",
        "/admin/pos/api/delete-order",
        "/admin/pos/api/get-drafts",
        "/admin/pos/api/update-draft-info"
})
public class PosDraftController extends HttpServlet {

    private final PosDraftService draftService = new PosDraftService();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (uri.endsWith("/get-drafts")) {
            Employee loggedInUser = (Employee) request.getSession().getAttribute("loggedInUser");
            int employeeId = loggedInUser != null ? loggedInUser.getId() : -1;
            List<Map<String, Object>> drafts = draftService.getPendingDrafts(employeeId);
            mapper.writeValue(response.getWriter(), drafts);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Employee loggedInUser = (Employee) request.getSession().getAttribute("loggedInUser");

        try {
            Map<String, Object> result = new HashMap<>();

            if (uri.endsWith("/create-order")) {
                result = draftService.createDraftOrder(loggedInUser);

            } else if (uri.endsWith("/add-item") || uri.endsWith("/update-item")) {
                int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
                String variantCode = request.getParameter("variantCode");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String variantName = request.getParameter("variantName");
                double price = Double.parseDouble(request.getParameter("price"));
                String colorSize = request.getParameter("colorSize");

                result = draftService.addOrUpdateItem(invoiceId, variantCode, quantity, variantName, price, colorSize);

            } else if (uri.endsWith("/remove-item")) {
                int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
                String variantCode = request.getParameter("variantCode");

                result = draftService.removeItem(invoiceId, variantCode);

            } else if (uri.endsWith("/delete-order")) {
                int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

                result = draftService.deleteDraftOrder(invoiceId);
            } else if (uri.endsWith("/update-draft-info")) {
                project.duan1_sd21301.dto.pos.PosOrderRequestDTO orderDTO = mapper.readValue(request.getReader(), project.duan1_sd21301.dto.pos.PosOrderRequestDTO.class);
                result = draftService.updateDraftInfo(orderDTO);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            mapper.writeValue(response.getWriter(), result);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            mapper.writeValue(response.getWriter(), error);
        }
    }
}
