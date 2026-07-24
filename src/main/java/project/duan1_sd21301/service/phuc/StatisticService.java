package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.repository.phuc.StatisticRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.DayOfWeek;
import java.time.temporal.TemporalAdjusters;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class StatisticService {

    private final StatisticRepository statisticRepository = new StatisticRepository();

    // Lấy 4 mốc thời gian: Hôm nay, Tuần này, Tháng này, Năm nay
    public Map<String, Map<String, Object>> getFourTimeframesStats() {
        Map<String, Map<String, Object>> result = new LinkedHashMap<>();
        LocalDate now = LocalDate.now();

        // 1. Hôm nay
        LocalDateTime startToday = now.atStartOfDay();
        LocalDateTime endToday = now.atTime(LocalTime.MAX);
        result.put("today", statisticRepository.getOverviewStats(startToday, endToday));

        // 2. Tuần này
        LocalDate startOfWeek = now.with(DayOfWeek.MONDAY);
        LocalDate endOfWeek = now.with(DayOfWeek.SUNDAY);
        result.put("week", statisticRepository.getOverviewStats(startOfWeek.atStartOfDay(), endOfWeek.atTime(LocalTime.MAX)));

        // 3. Tháng này
        LocalDate startOfMonth = now.with(TemporalAdjusters.firstDayOfMonth());
        LocalDate endOfMonth = now.with(TemporalAdjusters.lastDayOfMonth());
        result.put("month", statisticRepository.getOverviewStats(startOfMonth.atStartOfDay(), endOfMonth.atTime(LocalTime.MAX)));

        // 4. Năm nay
        LocalDate startOfYear = now.with(TemporalAdjusters.firstDayOfYear());
        LocalDate endOfYear = now.with(TemporalAdjusters.lastDayOfYear());
        result.put("year", statisticRepository.getOverviewStats(startOfYear.atStartOfDay(), endOfYear.atTime(LocalTime.MAX)));

        return result;
    }

    // Lấy dữ liệu biểu đồ doanh thu theo tháng hiện tại
    public Map<String, Object> getMonthlyRevenueChartData() {
        LocalDate now = LocalDate.now();
        LocalDate startOfMonth = now.with(TemporalAdjusters.firstDayOfMonth());
        LocalDate endOfMonth = now.with(TemporalAdjusters.lastDayOfMonth());
        
        List<Object[]> rawData = statisticRepository.getRevenueByDate(startOfMonth.atStartOfDay(), endOfMonth.atTime(LocalTime.MAX));
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd");

        // Prepare all days of the month to ensure no missing dates
        Map<LocalDate, Double> dateMap = new LinkedHashMap<>();
        for (LocalDate date = startOfMonth; !date.isAfter(endOfMonth); date = date.plusDays(1)) {
            dateMap.put(date, 0.0);
        }

        // Fill with actual data
        for (Object[] row : rawData) {
            if (row[0] != null && row[1] != null) {
                LocalDate date = ((java.sql.Date) row[0]).toLocalDate();
                Double revenue = ((Number) row[1]).doubleValue();
                if (dateMap.containsKey(date)) {
                    dateMap.put(date, revenue);
                }
            }
        }

        for (Map.Entry<LocalDate, Double> entry : dateMap.entrySet()) {
            labels.add(entry.getKey().format(dtf));
            data.add(entry.getValue());
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("labels", labels);
        result.put("data", data);
        return result;
    }

    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Object[]> rawData = statisticRepository.getTopSellingProducts(limit);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : rawData) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("name", row[0]);
            item.put("quantity", row[1]);
            item.put("stock", row[2]);
            result.add(item);
        }
        return result;
    }

    public List<Map<String, Object>> getTopCustomers(int limit) {
        List<Object[]> rawData = statisticRepository.getTopCustomers(limit);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : rawData) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("name", row[0]);
            item.put("orders", row[1]);
            item.put("spent", row[2]);
            result.add(item);
        }
        return result;
    }
}
