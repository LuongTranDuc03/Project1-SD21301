package project.duan1_sd21301.model.ha;

public class Address {
    private int id;
    private String code;
    private String province;
    private String district;
    private String ward;
    private String detailedAddress;

    public Address() {
    }

    public Address(int id, String code, String province, String district, String ward, String detailedAddress) {
        this.id = id;
        this.code = code;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.detailedAddress = detailedAddress;
    }

    public String getFormattedAddress() {
        StringBuilder sb = new StringBuilder();
        if (detailedAddress != null && !detailedAddress.trim().isEmpty()) {
            sb.append(detailedAddress.trim());
        }
        if (ward != null && !ward.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(ward.trim());
        }
        if (district != null && !district.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(district.trim());
        }
        if (province != null && !province.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(province.trim());
        }
        return sb.toString();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getDetailedAddress() { return detailedAddress; }
    public void setDetailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; }

    // Builder Pattern
    public static AddressBuilder builder() {
        return new AddressBuilder();
    }

    public static class AddressBuilder {
        private int id;
        private String code;
        private String province;
        private String district;
        private String ward;
        private String detailedAddress;

        public AddressBuilder id(int id) { this.id = id; return this; }
        public AddressBuilder code(String code) { this.code = code; return this; }
        public AddressBuilder province(String province) { this.province = province; return this; }
        public AddressBuilder district(String district) { this.district = district; return this; }
        public AddressBuilder ward(String ward) { this.ward = ward; return this; }
        public AddressBuilder detailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; return this; }

        public Address build() {
            return new Address(id, code, province, district, ward, detailedAddress);
        }
    }
}
