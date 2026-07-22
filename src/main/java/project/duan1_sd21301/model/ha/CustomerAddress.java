package project.duan1_sd21301.model.ha;

public class CustomerAddress {
    private int id;
    private Customer customer;
    private Address address;
    private String recipientName;
    private String phoneNumber;
    private boolean isDefault;
    private String note;

    public CustomerAddress() {
    }

    public CustomerAddress(int id, Customer customer, Address address, String recipientName, String phoneNumber, boolean isDefault, String note) {
        this.id = id;
        this.customer = customer;
        this.address = address;
        this.recipientName = recipientName;
        this.phoneNumber = phoneNumber;
        this.isDefault = isDefault;
        this.note = note;
    }

    public String getFormattedAddress() {
        return address != null ? address.getFormattedAddress() : "";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public Address getAddress() { return address; }
    public void setAddress(Address address) { this.address = address; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    // Convenience getters for backwards compatibility
    public String getProvince() { return address != null ? address.getProvince() : null; }
    public String getDistrict() { return address != null ? address.getDistrict() : null; }
    public String getWard() { return address != null ? address.getWard() : null; }
    public String getDetailedAddress() { return address != null ? address.getDetailedAddress() : null; }
    public String getCode() { return address != null ? address.getCode() : null; }

    // Builder
    public static CustomerAddressBuilder builder() {
        return new CustomerAddressBuilder();
    }

    public static class CustomerAddressBuilder {
        private int id;
        private Customer customer;
        private Address address;
        private String recipientName;
        private String phoneNumber;
        private boolean isDefault;
        private String note;

        public CustomerAddressBuilder id(int id) { this.id = id; return this; }
        public CustomerAddressBuilder customer(Customer customer) { this.customer = customer; return this; }
        public CustomerAddressBuilder address(Address address) { this.address = address; return this; }
        public CustomerAddressBuilder recipientName(String recipientName) { this.recipientName = recipientName; return this; }
        public CustomerAddressBuilder phoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; return this; }
        public CustomerAddressBuilder isDefault(boolean isDefault) { this.isDefault = isDefault; return this; }
        public CustomerAddressBuilder note(String note) { this.note = note; return this; }

        public CustomerAddress build() {
            return new CustomerAddress(id, customer, address, recipientName, phoneNumber, isDefault, note);
        }
    }
}
