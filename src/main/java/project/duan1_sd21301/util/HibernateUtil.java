package project.duan1_sd21301.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Environment;
import project.duan1_sd21301.model.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            // 1. Đọc thông tin kết nối từ db.properties
            Properties dbProps = loadDbProperties();

            // 2. Build StandardServiceRegistry với các properties
            StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
                .applySetting(Environment.DRIVER,       dbProps.getProperty("db.driver"))
                .applySetting(Environment.URL,          dbProps.getProperty("db.url"))
                .applySetting(Environment.USER,         dbProps.getProperty("db.username"))
                .applySetting(Environment.PASS,         dbProps.getProperty("db.password"))
                .applySetting(Environment.DIALECT,      dbProps.getProperty("hibernate.dialect"))
                .applySetting(Environment.SHOW_SQL,     dbProps.getProperty("hibernate.show_sql"))
                .applySetting(Environment.FORMAT_SQL,   dbProps.getProperty("hibernate.format_sql"))
                .applySetting(Environment.HBM2DDL_AUTO, dbProps.getProperty("hibernate.hbm2ddl.auto"))
                .build();

            // 3. Đăng ký tất cả Entity classes qua MetadataSources
            MetadataSources sources = new MetadataSources(registry);
            sources.addAnnotatedClass(NhanVien.class);
            sources.addAnnotatedClass(KhachHang.class);
            sources.addAnnotatedClass(DiaChi.class);
            sources.addAnnotatedClass(ChiTietSanPham.class);
            sources.addAnnotatedClass(PhieuGiamGia.class);
            sources.addAnnotatedClass(PhuongThucThanhToan.class);
            sources.addAnnotatedClass(HoaDon.class);
            sources.addAnnotatedClass(ChiTietHoaDon.class);
            sources.addAnnotatedClass(LichSuHoaDon.class);
            sources.addAnnotatedClass(LichSuThanhToan.class);

            // 4. Build Metadata và SessionFactory
            Metadata metadata = sources.buildMetadata();
            SessionFactory sf = metadata.buildSessionFactory();

            System.out.println("[HibernateUtil] SessionFactory created successfully.");
            return sf;

        } catch (Throwable ex) {
            System.err.println("[HibernateUtil] SessionFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    /**
     * Đọc file db.properties từ classpath (src/main/resources/).
     */
    private static Properties loadDbProperties() {
        Properties props = new Properties();
        try (InputStream input = HibernateUtil.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new RuntimeException(
                    "[HibernateUtil] Không tìm thấy file 'db.properties' trong classpath.");
            }
            props.load(input);
        } catch (IOException e) {
            throw new RuntimeException("[HibernateUtil] Không đọc được db.properties: " + e.getMessage(), e);
        }
        return props;
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
