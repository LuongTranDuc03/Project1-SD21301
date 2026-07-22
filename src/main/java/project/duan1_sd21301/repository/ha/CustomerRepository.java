package project.duan1_sd21301.repository.ha;

import project.duan1_sd21301.model.ha.Customer;
import java.util.List;

public interface CustomerRepository {
    List<Customer> findAll();
    Customer findById(int id);
    Customer findByCode(String code);
    boolean add(Customer customer);
    boolean update(Customer customer);
    boolean delete(int id);
}
