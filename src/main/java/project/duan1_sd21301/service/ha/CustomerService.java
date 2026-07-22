package project.duan1_sd21301.service.ha;

import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;
import java.util.List;

public interface CustomerService {
    List<Customer> getAllCustomers();
    Customer getCustomerById(int id);
    Customer getCustomerByCode(String code);
    boolean addCustomer(Customer customer);
    boolean updateCustomer(Customer customer);
    boolean deleteCustomer(int id);
    boolean saveCustomerAddress(int customerId, CustomerAddress address);
    boolean deleteCustomerAddress(int customerAddressId);
}
