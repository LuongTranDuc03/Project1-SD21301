package project.duan1_sd21301.service.ha;

import project.duan1_sd21301.model.ha.Customer;
import project.duan1_sd21301.model.ha.CustomerAddress;
import project.duan1_sd21301.repository.ha.CustomerRepository;
import project.duan1_sd21301.repository.ha.CustomerRepositoryImpl;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {

    private final CustomerRepository customerRepository = new CustomerRepositoryImpl();

    @Override
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    @Override
    public Customer getCustomerById(int id) {
        return customerRepository.findById(id);
    }

    @Override
    public Customer getCustomerByCode(String code) {
        return customerRepository.findByCode(code);
    }

    @Override
    public boolean addCustomer(Customer customer) {
        return customerRepository.add(customer);
    }

    @Override
    public boolean updateCustomer(Customer customer) {
        return customerRepository.update(customer);
    }

    @Override
    public boolean deleteCustomer(int id) {
        return customerRepository.delete(id);
    }

    @Override
    public boolean saveCustomerAddress(int customerId, CustomerAddress address) {
        if (customerRepository instanceof CustomerRepositoryImpl) {
            try (java.sql.Connection conn = project.duan1_sd21301.util.DatabaseConnection.getConnection()) {
                return ((CustomerRepositoryImpl) customerRepository).saveAddressAndLinkToCustomer(customerId, address, conn);
            } catch (Exception e) {
                System.err.println("Lỗi khi lưu địa chỉ khách hàng qua Service: " + e.getMessage());
            }
        }
        return false;
    }

    @Override
    public boolean deleteCustomerAddress(int customerAddressId) {
        String sql = "DELETE FROM khach_hang_dia_chi WHERE id = ?";
        try (java.sql.Connection conn = project.duan1_sd21301.util.DatabaseConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerAddressId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi xóa địa chỉ khách hàng: " + e.getMessage());
        }
        return false;
    }
}
