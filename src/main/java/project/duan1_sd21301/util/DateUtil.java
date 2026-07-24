package project.duan1_sd21301.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateUtil {
    public static String getCurrentDateString() {
        LocalDate today = LocalDate.now();
        int dayOfWeek = today.getDayOfWeek().getValue();
        String thu;
        if (dayOfWeek == 7) {
            thu = "Chủ Nhật";
        } else {
            thu = "Thứ " + (dayOfWeek + 1);
        }
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy", new Locale("vi", "VN"));
        return thu + ", " + today.format(formatter);
    }
}
