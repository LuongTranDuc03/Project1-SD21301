package project.duan1_sd21301;

import project.duan1_sd21301.model.HoaDon;
import project.duan1_sd21301.repository.HoaDonRepository;

import java.util.List;

public class TestDB {
    public static void main(String[] args) {
        try {
            System.out.println("Connecting to DB and fetching HoaDon...");
            project.duan1_sd21301.repository.HoaDonRepository repo = new project.duan1_sd21301.repository.HoaDonRepository();
            List<project.duan1_sd21301.model.HoaDon> list = repo.findAll(null, 0, 10);
            System.out.println("Total records: " + list.size());
            for (project.duan1_sd21301.model.HoaDon hd : list) {
                System.out.println("HD ID: " + hd.getId() + " - KhachHang: " + hd.getTenKhachHang() + " - Trang thai: " + hd.getTrangThaiDonHang());
            }
            System.exit(0);
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
