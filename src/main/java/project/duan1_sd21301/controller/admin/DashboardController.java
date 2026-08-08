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

    private boolean isDefaultPeriod(String fromDate, String toDate) {
        if (fromDate == null || fromDate.trim().isEmpty() || toDate == null || toDate.trim().isEmpty()) return false;
        try {
            LocalDate from = LocalDate.parse(fromDate);
            LocalDate to = LocalDate.parse(toDate);
            LocalDate now = LocalDate.now();
            
            if (from.equals(now) && to.equals(now)) return true;
            
            LocalDate startOfWeek = now.with(java.time.temporal.TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
            LocalDate endOfWeek = now.with(java.time.temporal.TemporalAdjusters.nextOrSame(java.time.DayOfWeek.SUNDAY));
            if (from.equals(startOfWeek) && (to.equals(endOfWeek) || to.equals(now))) return true;
            
            LocalDate startOfMonth = now.withDayOfMonth(1);
            LocalDate endOfMonth = now.withDayOfMonth(now.lengthOfMonth());
            if (from.equals(startOfMonth) && (to.equals(endOfMonth) || to.equals(now))) return true;
            
            LocalDate startOfYear = now.withDayOfYear(1);
            LocalDate endOfYear = now.withDayOfYear(now.lengthOfYear());
            if (from.equals(startOfYear) && (to.equals(endOfYear) || to.equals(now))) return true;
        } catch (Exception e) {}
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        boolean isCustomFilter = (fromDate != null && !fromDate.trim().isEmpty()) || (toDate != null && !toDate.trim().isEmpty());
        boolean isCustomKPI = isCustomFilter && !isDefaultPeriod(fromDate, toDate);

        // 1. Lấy dữ liệu 4 khung thời gian hoặc dữ liệu tùy chỉnh
        Map<String, Map<String, Object>> timeframes = new HashMap<>();
        String refDate = null;
        if (isCustomKPI) {
            refDate = (toDate != null && !toDate.trim().isEmpty()) ? toDate : fromDate;
            timeframes.put("today", repo.getStatsForCustomPeriod(fromDate, toDate));
            request.setAttribute("kpi1Title", "Theo bộ lọc");
        } else {
            timeframes.put("today", repo.getStatsForPeriod("today", null));
            request.setAttribute("kpi1Title", "Hôm nay");
        }
        timeframes.put("week", repo.getStatsForPeriod("week", refDate));
        timeframes.put("month", repo.getStatsForPeriod("month", refDate));
        timeframes.put("year", repo.getStatsForPeriod("year", refDate));

        request.setAttribute("timeframes", timeframes);
        request.setAttribute("isCustomFilter", isCustomFilter);

        // 2. Lấy dữ liệu biểu đồ
        List<String> labels = new ArrayList<>();
        List<Double> dataVals = new ArrayList<>();
        double totalMonthlyRevenue = 0.0;

        if (fromDate != null && !fromDate.trim().isEmpty() || toDate != null && !toDate.trim().isEmpty()) {
            Map<String, Double> customData = repo.getCustomChartData(fromDate, toDate);
            // sort keys
            List<String> sortedDates = new ArrayList<>(customData.keySet());
            sortedDates.sort(String::compareTo);
            for (String dateStr : sortedDates) {
                labels.add("'" + dateStr + "'");
                double rev = customData.get(dateStr);
                dataVals.add(rev);
                totalMonthlyRevenue += rev;
            }
            request.setAttribute("currentMonthYear", "Theo bộ lọc");
            request.setAttribute("selectedMonth", 0);
        } else {
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
            for (int i = 1; i <= daysInMonth; i++) {
                labels.add(String.valueOf(i));
                double rev = dailyData.getOrDefault(i, 0.0);
                dataVals.add(rev);
                totalMonthlyRevenue += rev;
            }
            request.setAttribute("currentMonthYear", "Tháng " + month + "/" + year);
            request.setAttribute("selectedMonth", month);
        }
        
        request.setAttribute("chartLabels", labels.toString()); // format like [1, 2, 3...]
        request.setAttribute("chartData", dataVals.toString());
        request.setAttribute("totalMonthlyRevenue", totalMonthlyRevenue);

        // 3. Lấy Top sản phẩm và khách hàng
        request.setAttribute("topProducts", repo.getTopProducts(5, fromDate, toDate));
        request.setAttribute("topCustomers", repo.getTopCustomers(5, fromDate, toDate));
        
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

        request.setAttribute("pageTitle", "Thống kê doanh thu");
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

