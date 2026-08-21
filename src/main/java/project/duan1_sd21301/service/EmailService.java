package project.duan1_sd21301.service;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.util.EmailUtil;

import java.util.concurrent.CompletableFuture;

public class EmailService {
    private static final String HOST = "smtp.gmail.com";
    private static final int PORT = 587;
    private static final String USERNAME = "pdhuy190107@gmail.com";
    private static final String PASSWORD = "jlqfokuwcylkfhqd";
    private static final String FROM = "pdhuy190107@gmail.com";

    private EmailUtil emailUtil;

    public EmailService() {
        this.emailUtil = new EmailUtil(HOST, PORT, USERNAME, PASSWORD, FROM);
    }

    public void sendLoginCredentialsAsync(Employee emp) {
        CompletableFuture.runAsync(() -> {
            try {
                String subject = "Thong tin dang nhap he thong FamiCoats";
                String html = "<!DOCTYPE html><html><body style='font-family:Inter,sans-serif;background:#f8fafc;margin:0;padding:20px;'>"
                        + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);'>"
                        + "<div style='background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:28px 32px;color:#fff;'>"
                        + "<h2 style='margin:0;font-size:20px;'>🔑 Thong tin dang nhap</h2>"
                        + "<p style='margin:6px 0 0;opacity:0.85;font-size:13px;'>He thong quan ly FamiCoats</p>"
                        + "</div>"
                        + "<div style='padding:28px 32px;'>"
                        + "<p style='margin:0 0 16px;color:#374151;'>Xin chao <strong>" + emp.getFullName()
                        + "</strong>,</p>"
                        + "<p style='margin:0 0 20px;color:#6b7280;font-size:14px;'>Duoi day la thong tin dang nhap he thong cua ban:</p>"
                        + "<div style='background:#f3f4f6;border-radius:10px;padding:16px 20px;border-left:4px solid #6366f1;'>"
                        + "<table style='border-collapse:collapse;width:100%;font-size:14px;'>"
                        + "<tr><td style='padding:6px 0;color:#6b7280;width:100px;'>📧 Email</td>"
                        + "<td style='padding:6px 0;font-weight:600;color:#1f2937;'>" + emp.getEmail() + "</td></tr>"
                        + "<tr><td style='padding:6px 0;color:#6b7280;'>🔑 Mat khau</td>"
                        + "<td style='padding:6px 0;font-weight:700;color:#dc2626;font-family:monospace;font-size:15px;'>"
                        + emp.getPassword() + "</td></tr>"
                        + "</table></div>"
                        + "<p style='margin:20px 0 0;font-size:13px;color:#9ca3af;'> Vui long dang nhap va <strong style='color:#374151;'>doi mat khau ngay</strong> de bao mat tai khoan.</p>"
                        + "</div>"
                        + "<div style='padding:16px 32px;background:#f8fafc;border-top:1px solid #e5e7eb;font-size:12px;color:#9ca3af;'>Tran trong, <strong>Team FamiCoats</strong></div>"
                        + "</div></body></html>";
                emailUtil.sendHtmlMail(emp.getEmail(), subject, html);
                System.out.println("Email sent successfully to " + emp.getEmail());
            } catch (Exception e) {
                System.out.println("Failed to send email to " + emp.getEmail() + " - Lỗi: " + e.getMessage());
                e.printStackTrace();
            }
        });
    }
}
