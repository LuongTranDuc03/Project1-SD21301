package project.duan1_sd21301.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import project.duan1_sd21301.repository.DashboardRepository;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardController", value = "/admin/dashboard")
public class DashboardController extends HttpServlet {

    private DashboardRepository repo = new DashboardRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy dữ liệu 4 khung thời gian
        Map<String, Map<String, Object>> timeframes = new HashMap<>();
        timeframes.put("today", repo.getStatsForPeriod("today"));
        timeframes.put("week", repo.getStatsForPeriod("week"));
        timeframes.put("month", repo.getStatsForPeriod("month"));
        timeframes.put("year", repo.getStatsForPeriod("year"));
        request.setAttribute("timeframes", timeframes);

        // 2. Lấy dữ liệu biểu đồ
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        
        String monthParam = request.getParameter("chartMonth");
        int month = now.getMonthValue();
        if (monthParam != null && !monthParam.trim().isEmpty()) {
            try {
                month = Integer.parseInt(monthParam);
            } catch (Exception e) {}
        }
        
        Map<Integer, Double> dailyData = repo.getMonthlyChartData(year, month);
        
        int daysInMonth = YearMonth.of(year, month).lengthOfMonth();
        List<Integer> labels = new ArrayList<>();
        List<Double> dataVals = new ArrayList<>();
        double totalMonthlyRevenue = 0.0;
        
        for (int i = 1; i <= daysInMonth; i++) {
            labels.add(i);
            double rev = dailyData.getOrDefault(i, 0.0);
            dataVals.add(rev);
            totalMonthlyRevenue += rev;
        }
        
        request.setAttribute("chartLabels", labels.toString()); // format like [1, 2, 3...]
        request.setAttribute("chartData", dataVals.toString());
        request.setAttribute("totalMonthlyRevenue", totalMonthlyRevenue);
        request.setAttribute("currentMonthYear", "Tháng " + month + "/" + year);
        request.setAttribute("selectedMonth", month);

        // 3. Lấy Top sản phẩm và khách hàng
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        request.setAttribute("topProducts", repo.getTopProducts(5, fromDate, toDate));
        request.setAttribute("topCustomers", repo.getTopCustomers(5, fromDate, toDate));
        
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

        request.setAttribute("pageTitle", "Thống kê doanh thu");
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

