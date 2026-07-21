package project.duan1_sd21301.model.ha;

public class Address {
    private int id;
    private String code;
    private Customer customer;
    private String recipientName;
    private String phoneNumber;
    private String province;
    private String district;
    private String ward;
    private String detailedAddress;
    private boolean isDefault;
    private String note;

    public Address() {
    }

    public Address(int id, String code, Customer customer, String recipientName, String phoneNumber, 
                   String province, String district, String ward, String detailedAddress, 
                   boolean isDefault, String note) {
        this.id = id;
        this.code = code;
        this.customer = customer;
        this.recipientName = recipientName;
        this.phoneNumber = phoneNumber;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.detailedAddress = detailedAddress;
        this.isDefault = isDefault;
        this.note = note;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getDetailedAddress() { return detailedAddress; }
    public void setDetailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    // Builder Pattern
    public static AddressBuilder builder() {
        return new AddressBuilder();
    }

    public static class AddressBuilder {
        private int id;
        private String code;
        private Customer customer;
        private String recipientName;
        private String phoneNumber;
        private String province;
        private String district;
        private String ward;
        private String detailedAddress;
        private boolean isDefault;
        private String note;

        public AddressBuilder id(int id) { this.id = id; return this; }
        public AddressBuilder code(String code) { this.code = code; return this; }
        public AddressBuilder customer(Customer customer) { this.customer = customer; return this; }
        public AddressBuilder recipientName(String recipientName) { this.recipientName = recipientName; return this; }
        public AddressBuilder phoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; return this; }
        public AddressBuilder province(String province) { this.province = province; return this; }
        public AddressBuilder district(String district) { this.district = district; return this; }
        public AddressBuilder ward(String ward) { this.ward = ward; return this; }
        public AddressBuilder detailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; return this; }
        public AddressBuilder isDefault(boolean isDefault) { this.isDefault = isDefault; return this; }
        public AddressBuilder note(String note) { this.note = note; return this; }

        public Address build() {
            return new Address(id, code, customer, recipientName, phoneNumber, province, district, ward, detailedAddress, isDefault, note);
        }
    }
}
