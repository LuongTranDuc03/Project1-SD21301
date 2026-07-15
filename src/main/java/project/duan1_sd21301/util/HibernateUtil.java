package project.duan1_sd21301.util;

import lombok.Getter;
import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Environment;
// (model root package does not exist — entities are in model.phuc and model.luong)
import project.duan1_sd21301.model.luong.ProductDetail;
import project.duan1_sd21301.model.phuc.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class HibernateUtil {

    @Getter
    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            // 1. Đọc thông tin kết nối từ db.properties
            Properties dbProps = loadDbProperties();

            // 2. Build StandardServiceRegistry với các properties
            StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
                    .applySetting(Environment.DRIVER,       dbProps.getProperty("db.driver"))
                    .applySetting(Environment.URL,          dbProps.getProperty("db.url"))
                    .applySetting("hibernate.connection.username", dbProps.getProperty("db.username"))
                    .applySetting("hibernate.connection.password", dbProps.getProperty("db.password"))
                    .applySetting(Environment.DIALECT,      dbProps.getProperty("hibernate.dialect"))
                    .applySetting(Environment.SHOW_SQL,     dbProps.getProperty("hibernate.show_sql"))
                    .applySetting(Environment.FORMAT_SQL,   dbProps.getProperty("hibernate.format_sql"))
                    .applySetting(Environment.HBM2DDL_AUTO, dbProps.getProperty("hibernate.hbm2ddl.auto"))
                    .build();

            // 3. Đăng ký tất cả Entity classes qua MetadataSources
            MetadataSources sources = new MetadataSources(registry);
//            sources.addAnnotatedClass(NhanVien.class);
//            sources.addAnnotatedClass(KhachHang.class);
            sources.addAnnotatedClass(Address.class);
            sources.addAnnotatedClass(ProductDetail.class);
            sources.addAnnotatedClass(Coupon.class);
            sources.addAnnotatedClass(PaymentMethod.class);
            sources.addAnnotatedClass(Invoice.class);
            sources.addAnnotatedClass(InvoiceDetail.class);
            sources.addAnnotatedClass(InvoiceHistory.class);
            sources.addAnnotatedClass(PaymentHistory.class);

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

}
