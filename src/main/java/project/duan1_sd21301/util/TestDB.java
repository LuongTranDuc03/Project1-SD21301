package project.duan1_sd21301.util;

import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.repository.ha.CustomerRepositoryImpl;

public class TestDB {
    public static void main(String[] args) {
        CustomerRepositoryImpl repo = new CustomerRepositoryImpl();
        Customer c = Customer.builder()
            .code("KHTEST99")
            .fullName("Test Khach Hang")
            .email("test99@gmail.com")
            .phoneNumber("0999999999")
            .status("Hoạt động")
            .build();
        
        System.out.println("Trying to add...");
        boolean res = repo.add(c);
        System.out.println("Result: " + res);
        
        if (res) {
            System.out.println("Added successfully with ID: " + c.getId());
        }
    }
}
