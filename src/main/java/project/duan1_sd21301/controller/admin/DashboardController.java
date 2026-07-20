package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import project.duan1_sd21301.service.phuc.StatisticService;

import java.io.IOException;
import java.util.Map;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "DashboardController", value = "/admin/dashboard")
public class DashboardController extends HttpServlet {

    private final StatisticService statisticService = new StatisticService();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("pageTitle", "Thống kê");
        
        // 1. Lấy 4 mốc thời gian: Hôm nay, Tuần này, Tháng này, Năm nay
        Map<String, Map<String, Object>> timeframes = statisticService.getFourTimeframesStats();
        request.setAttribute("timeframes", timeframes);
        
        // 2. Chart Data (Tháng hiện tại)
        Map<String, Object> chartData = statisticService.getMonthlyRevenueChartData();
        request.setAttribute("chartLabels", mapper.writeValueAsString(chartData.get("labels")));
        request.setAttribute("chartData", mapper.writeValueAsString(chartData.get("data")));
        
        // Calculate total revenue for chart label
        Double totalMonthlyRevenue = 0.0;
        try {
            java.util.List<Double> dataList = (java.util.List<Double>) chartData.get("data");
            for (Double v : dataList) {
                totalMonthlyRevenue += v;
            }
        } catch (Exception ignored) {}
        request.setAttribute("totalMonthlyRevenue", totalMonthlyRevenue);

        // Format Date month/year
        LocalDate now = LocalDate.now();
        request.setAttribute("currentMonthYear", now.format(DateTimeFormatter.ofPattern("MMMM yyyy")));
        
        // 3. Top Products
        request.setAttribute("topProducts", statisticService.getTopSellingProducts(5));
        
        // 4. Top Customers
        request.setAttribute("topCustomers", statisticService.getTopCustomers(5));

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
