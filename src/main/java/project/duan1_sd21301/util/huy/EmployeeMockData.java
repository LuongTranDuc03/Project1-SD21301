package project.duan1_sd21301.util.huy;

import project.duan1_sd21301.model.huy.Employee;
import project.duan1_sd21301.model.huy.Role;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Đọc dữ liệu mẫu nhân viên từ resources/huy/mock_data.json.
 * Dùng làm fallback khi DB chưa có dữ liệu (ví dụ trang profile dev).
 */
public final class EmployeeMockData {

    private static final String RESOURCE = "/huy/mock_data.json";
    private static List<Employee> cachedEmployees;
    private static List<Role> cachedRoles;

    private EmployeeMockData() {
    }

    public static Employee findById(int id) {
        if (id <= 0) {
            return null;
        }
        for (Employee employee : loadAll()) {
            if (id == employee.getId()) {
                return employee;
            }
        }
        return null;
    }

    public static List<Employee> loadAll() {
        if (cachedEmployees != null) {
            return cachedEmployees;
        }

        cachedEmployees = new ArrayList<>();
        try (InputStream inputStream = EmployeeMockData.class.getResourceAsStream(RESOURCE)) {
            if (inputStream == null) {
                return cachedEmployees;
            }

            String json = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
            Map<Integer, String> roleNames = parseRoleNames(json);
            Matcher blockMatcher = Pattern.compile("\\{[^{}]*\"ma_nhan_vien\"[^{}]*\\}")
                    .matcher(json);

            while (blockMatcher.find()) {
                Employee employee = parseEmployeeBlock(blockMatcher.group(), roleNames);
                if (employee != null) {
                    cachedEmployees.add(employee);
                }
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return cachedEmployees;
    }

    /**
     * Đọc danh sách vai trò từ mock_data.json.
     */
    public static List<Role> loadAllRoles() {
        if (cachedRoles != null) {
            return cachedRoles;
        }
        cachedRoles = new ArrayList<>();
        try (InputStream inputStream = EmployeeMockData.class.getResourceAsStream(RESOURCE)) {
            if (inputStream == null) {
                return cachedRoles;
            }
            String json = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
            Matcher roleMatcher = Pattern
                    .compile("\\{\\s*\"id\"\\s*:\\s*(\\d+)\\s*,\\s*\"ten_vai_tro\"\\s*:\\s*\"([^\"]+)\"\\s*,\\s*\"mo_ta\"\\s*:\\s*\"([^\"]*)\"\\s*,\\s*\"trang_thai\"\\s*:\\s*(\\d+)")
                    .matcher(json);
            while (roleMatcher.find()) {
                int roleId = Integer.parseInt(roleMatcher.group(1));
                String tenVaiTro = roleMatcher.group(2);
                String moTa = roleMatcher.group(3);
                int trangThai = Integer.parseInt(roleMatcher.group(4));
                cachedRoles.add(new Role(roleId, tenVaiTro, moTa, trangThai));
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return cachedRoles;
    }

    private static Map<Integer, String> parseRoleNames(String json) {
        Map<Integer, String> roleNames = new HashMap<>();
        Matcher roleMatcher = Pattern
                .compile("\\{\\s*\"id\"\\s*:\\s*(\\d+)\\s*,\\s*\"ten_vai_tro\"\\s*:\\s*\"([^\"]+)\"")
                .matcher(json);

        while (roleMatcher.find()) {
            roleNames.put(Integer.parseInt(roleMatcher.group(1)), roleMatcher.group(2));
        }
        return roleNames;
    }

    private static Employee parseEmployeeBlock(String block, Map<Integer, String> roleNames) {
        int id = extractInt(block, "id");
        if (id <= 0) {
            return null;
        }

        Employee employee = new Employee();
        employee.setId(id);
        employee.setMaNhanVien(extractString(block, "ma_nhan_vien"));
        employee.setFullName(extractString(block, "ho_ten"));
        employee.setEmail(extractString(block, "email"));
        employee.setPassword(extractString(block, "mat_khau"));
        employee.setPhoneNumber(extractString(block, "so_dien_thoai"));
        employee.setBirthday(parseDate(extractString(block, "ngay_sinh")));
        employee.setGender(extractBoolean(block, "gioi_tinh"));
        employee.setCccd(extractString(block, "cccd"));
        employee.setAvatar(extractString(block, "anh_dai_dien"));
        employee.setStatus(extractInt(block, "trang_thai"));
        employee.setAddress(extractString(block, "dia_chi_tong_hop"));

        // Xây dựng Role object từ mock data
        int roleId = extractInt(block, "id_vai_tro");
        Role role = new Role();
        role.setId(roleId);
        role.setRoleName(roleNames.getOrDefault(roleId, ""));
        employee.setRole(role);

        return employee;
    }

    private static String extractString(String block, String key) {
        Matcher matcher = Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]*)\"").matcher(block);
        return matcher.find() ? matcher.group(1) : "";
    }

    private static int extractInt(String block, String key) {
        Matcher matcher = Pattern.compile("\"" + key + "\"\\s*:\\s*(\\d+)").matcher(block);
        return matcher.find() ? Integer.parseInt(matcher.group(1)) : 0;
    }

    private static double extractDouble(String block, String key) {
        Matcher matcher = Pattern.compile("\"" + key + "\"\\s*:\\s*([\\d.]+)").matcher(block);
        return matcher.find() ? Double.parseDouble(matcher.group(1)) : 0.0;
    }

    private static Boolean extractBoolean(String block, String key) {
        Matcher matcher = Pattern.compile("\"" + key + "\"\\s*:\\s*(true|false)").matcher(block);
        if (!matcher.find()) {
            return null;
        }
        return Boolean.parseBoolean(matcher.group(1));
    }

    private static java.util.Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(value);
        } catch (ParseException ex) {
            return null;
        }
    }

    public static boolean insert(Employee employee) {
        if (cachedEmployees == null) loadAll();
        int maxId = 0;
        for (Employee e : cachedEmployees) {
            if (e.getId() > maxId) maxId = e.getId();
        }
        employee.setId(maxId + 1);
        if (employee.getMaNhanVien() == null || employee.getMaNhanVien().isEmpty()) {
            employee.setMaNhanVien(getNextMaNhanVien());
        }
        cachedEmployees.add(0, employee);
        return true;
    }

    public static boolean update(Employee employee) {
        if (cachedEmployees == null) loadAll();
        for (int i = 0; i < cachedEmployees.size(); i++) {
            if (cachedEmployees.get(i).getId() == employee.getId()) {
                cachedEmployees.set(i, employee);
                return true;
            }
        }
        return false;
    }

    public static String getNextMaNhanVien() {
        if (cachedEmployees == null) loadAll();
        int max = 0;
        for (Employee e : cachedEmployees) {
            String ma = e.getMaNhanVien();
            if (ma != null && ma.startsWith("NV")) {
                try {
                    int num = Integer.parseInt(ma.substring(2));
                    if (num > max) max = num;
                } catch (Exception ignored) {}
            }
        }
        return "NV" + String.format("%03d", max + 1);
    }

    public static boolean isEmailExist(String email, Integer excludeId) {
        if (cachedEmployees == null) loadAll();
        for (Employee e : cachedEmployees) {
            if (e.getEmail() != null && e.getEmail().equalsIgnoreCase(email)) {
                if (excludeId != null && e.getId() == excludeId) continue;
                return true;
            }
        }
        return false;
    }

    public static boolean isPhoneExist(String phone, Integer excludeId) {
        if (cachedEmployees == null) loadAll();
        for (Employee e : cachedEmployees) {
            if (e.getPhoneNumber() != null && e.getPhoneNumber().equals(phone)) {
                if (excludeId != null && e.getId() == excludeId) continue;
                return true;
            }
        }
        return false;
    }
    public static boolean isMaNhanVienExist(String maNhanVien, Integer excludeId) {
        if (cachedEmployees == null) loadAll();
        for (Employee e : cachedEmployees) {
            if (e.getMaNhanVien() != null && e.getMaNhanVien().equalsIgnoreCase(maNhanVien)) {
                if (excludeId != null && e.getId() == excludeId) continue;
                return true;
            }
        }
        return false;
    }

    public static Employee login(String email, String password) {
        if (cachedEmployees == null) loadAll();
        for (Employee e : cachedEmployees) {
            if (e.getEmail() != null && e.getEmail().equalsIgnoreCase(email)
                    && e.getPassword() != null && e.getPassword().equals(password)
                    && e.getStatus() == 1) {
                return e;
            }
        }
        return null;
    }
}
