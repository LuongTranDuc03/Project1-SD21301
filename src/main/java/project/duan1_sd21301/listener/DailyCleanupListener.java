package project.duan1_sd21301.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import project.duan1_sd21301.service.pos.PosDraftService;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class DailyCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private final PosDraftService draftService = new PosDraftService();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        
        // Chạy ngay khi start server để dọn dẹp các đơn cũ
        draftService.cleanupOldDrafts();

        // Tính thời gian từ hiện tại đến nửa đêm
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime nextMidnight = now.toLocalDate().plusDays(1).atStartOfDay();
        ZonedDateTime zonedNow = now.atZone(ZoneId.systemDefault());
        ZonedDateTime zonedNextMidnight = nextMidnight.atZone(ZoneId.systemDefault());
        
        long initialDelay = Duration.between(zonedNow, zonedNextMidnight).getSeconds();
        
        // Lập lịch chạy mỗi ngày một lần (86400 giây)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("Running daily POS draft cleanup...");
                draftService.cleanupOldDrafts();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, initialDelay, 24 * 60 * 60, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
