package project.duan1_sd21301.controller.admin.luong;

import java.util.ArrayList;
import java.util.List;
import project.duan1_sd21301.model.luong.Product;
import project.duan1_sd21301.model.luong.ProductDetail;

public class ProductValidator {

    public static final List<String> VALID_BRANDS = java.util.Arrays.asList(
            "Nike", "Adidas", "Uniqlo", "Zara", "H&M", "Levi's", "The North Face", "FamiCoats", "Gucci", "Puma");

    public static final List<String> VALID_ORIGINS = java.util.Arrays.asList(
            "Việt Nam", "Mỹ", "Nhật Bản", "Hàn Quốc", "Trung Quốc", "Đức", "Ý", "Pháp", "Anh", "Thái Lan");

    private static String removeAccent(String s) {
        if (s == null)
            return "";
        String temp = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD);
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replace('đ', 'd').replace('Đ', 'd').toLowerCase();
    }

    public static int getLevenshteinDistance(String s1, String s2) {
        if (s1 == null || s2 == null)
            return Integer.MAX_VALUE;
        String a1 = removeAccent(s1.trim());
        String a2 = removeAccent(s2.trim());
        int[] costs = new int[a2.length() + 1];
        for (int i = 0; i <= a1.length(); i++) {
            int lastValue = i;
            for (int j = 0; j <= a2.length(); j++) {
                if (i == 0) {
                    costs[j] = j;
                } else {
                    if (j > 0) {
                        int newValue = costs[j - 1];
                        if (a1.charAt(i - 1) != a2.charAt(j - 1)) {
                            newValue = Math.min(Math.min(newValue, lastValue), costs[j]) + 1;
                        }
                        costs[j - 1] = lastValue;
                        lastValue = newValue;
                    }
                }
            }
            if (i > 0)
                costs[a2.length()] = lastValue;
        }
        return costs[a2.length()];
    }

    public static String normalizeBrand(String brand) {
        if (brand == null || brand.trim().isEmpty())
            return "";
        String trimmed = brand.trim();
        for (String b : VALID_BRANDS) {
            if (b.equalsIgnoreCase(trimmed)) {
                return b;
            }
        }
        return trimmed;
    }

    public static String normalizeOrigin(String origin) {
        if (origin == null || origin.trim().isEmpty())
            return "";
        String trimmed = origin.trim().replaceAll("\\s+", " ");
        for (String o : VALID_ORIGINS) {
            if (o.equalsIgnoreCase(trimmed)) {
                return o;
            }
        }
        String lower = trimmed.toLowerCase();
        if (lower.equals("viet nam") || lower.equals("vietnam") || lower.equals("vn")) {
            return "Việt Nam";
        }
        if (lower.equals("nhat ban") || lower.equals("japan")) {
            return "Nhật Bản";
        }
        if (lower.equals("han quoc") || lower.equals("korea")) {
            return "Hàn Quốc";
        }
        if (lower.equals("trung quoc") || lower.equals("china")) {
            return "Trung Quốc";
        }
        if (lower.equals("thai lan") || lower.equals("thailand")) {
            return "Thái Lan";
        }
        if (lower.equals("my") || lower.equals("usa")) {
            return "Mỹ";
        }
        return trimmed;
    }

    public static List<String> validateProduct(
            String code,
            String name,
            String category,
            String brand,
            String origin,
            String status,
            boolean isEdit,
            List<Product> existingProducts,
            String[] sizes,
            String[] colors,
            String[] styles,
            String[] prices,
            String[] stocks,
            String[] lengths,
            String[] widths,
            String[] thicknesses,
            String[] weights,
            String[] variantImages) {
        List<String> errors = new ArrayList<>();

        // 1. Validate Product Code (if adding)
        if (!isEdit) {
            if (code != null && !code.trim().isEmpty()) {
                String codeTrim = code.trim();
                if (!codeTrim.matches("^SP\\d{3,5}$")) {
                    errors.add("Mã sản phẩm phải bắt đầu bằng 'SP' theo sau là 3 đến 5 chữ số (Ví dụ: SP009).");
                } else {
                    // Check duplicate
                    for (Product p : existingProducts) {
                        if (p.getCode().equalsIgnoreCase(codeTrim)) {
                            errors.add(
                                    "Mã sản phẩm '" + codeTrim + "' đã tồn tại trong hệ thống. Vui lòng chọn mã khác.");
                            break;
                        }
                    }
                }
            }
        }

        // 2. Validate Product Name
        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên sản phẩm không được để trống hoặc chỉ chứa khoảng trắng.");
        } else {
            String nameTrim = name.trim();
            if (nameTrim.length() < 3 || nameTrim.length() > 100) {
                errors.add("Tên sản phẩm phải có độ dài từ 3 đến 100 ký tự.");
            }
            if (nameTrim.contains("<") || nameTrim.contains(">") || nameTrim.contains("%")) {
                errors.add("Tên sản phẩm không được chứa các ký tự đặc biệt nguy hiểm (<, >, %).");
            }
        }

        // 3. Validate Category
        if (category == null || category.trim().isEmpty()) {
            errors.add("Danh mục sản phẩm không được để trống.");
        }

        if (brand != null && !brand.trim().isEmpty()) {
            if (brand.trim().length() > 50) {
                errors.add("Thương hiệu không được vượt quá 50 ký tự.");
            } else {
                String normalized = normalizeBrand(brand);
                if (!VALID_BRANDS.contains(normalized)) {
                    String suggestion = null;
                    int minDistance = Integer.MAX_VALUE;
                    for (String b : VALID_BRANDS) {
                        int dist = getLevenshteinDistance(normalized, b);
                        if (dist < minDistance && dist <= 2) {
                            minDistance = dist;
                            suggestion = b;
                        }
                    }
                    if (suggestion != null) {
                        errors.add("Thương hiệu '" + brand + "' không hợp lệ. Có phải bạn muốn nhập '" + suggestion
                                + "' không?");
                    } else {
                        errors.add("Thương hiệu '" + brand + "' không hợp lệ. Vui lòng chọn một trong các thương hiệu: "
                                + String.join(", ", VALID_BRANDS));
                    }
                }
            }
        }
        if (origin != null && !origin.trim().isEmpty()) {
            if (origin.trim().length() > 50) {
                errors.add("Xuất xứ không được vượt quá 50 ký tự.");
            } else {
                String normalized = normalizeOrigin(origin);
                if (!VALID_ORIGINS.contains(normalized)) {
                    String suggestion = null;
                    int minDistance = Integer.MAX_VALUE;
                    for (String o : VALID_ORIGINS) {
                        int dist = getLevenshteinDistance(normalized, o);
                        if (dist < minDistance && dist <= 2) {
                            minDistance = dist;
                            suggestion = o;
                        }
                    }
                    if (suggestion != null) {
                        errors.add("Xuất xứ '" + origin + "' không hợp lệ. Có phải bạn muốn nhập '" + suggestion
                                + "' không?");
                    } else {
                        errors.add("Xuất xứ '" + origin + "' không hợp lệ. Vui lòng chọn một trong các xuất xứ: "
                                + String.join(", ", VALID_ORIGINS));
                    }
                }
            }
        }

        // 5. Validate Status
        if (status == null || status.trim().isEmpty()) {
            errors.add("Trạng thái sản phẩm không được để trống.");
        }

        // 6. Validate Variants count
        if (sizes == null || sizes.length == 0) {
            errors.add("Sản phẩm phải có ít nhất 1 biến thể con.");
            return errors;
        }

        // 7. Validate each Variant
        for (int i = 0; i < sizes.length; i++) {
            String prefix = "Biến thể " + (i + 1) + ": ";

            // Size
            if (sizes[i] == null || sizes[i].trim().isEmpty()) {
                errors.add(prefix + "Kích cỡ không được để trống.");
            }

            // Color
            if (colors == null || colors.length <= i || colors[i] == null || colors[i].trim().isEmpty()) {
                errors.add(prefix + "Màu sắc không được để trống hoặc chỉ chứa khoảng trắng.");
            } else if (colors[i].trim().length() > 30) {
                errors.add(prefix + "Tên màu sắc không được dài quá 30 ký tự.");
            }

            // Style
            if (styles != null && styles.length > i && styles[i] != null && styles[i].trim().length() > 50) {
                errors.add(prefix + "Kiểu dáng không được vượt quá 50 ký tự.");
            }

            // Prices
            double p = -1;
            try {
                if (prices != null && prices.length > i && prices[i] != null && !prices[i].trim().isEmpty()) {
                    p = Double.parseDouble(prices[i]);
                    if (p < 0) {
                        errors.add(prefix + "Giá bán phải là số không âm.");
                    }
                } else {
                    errors.add(prefix + "Giá bán không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Giá bán phải là một số hợp lệ.");
            }

            // Stock
            try {
                if (stocks != null && stocks.length > i && stocks[i] != null && !stocks[i].trim().isEmpty()) {
                    int st = Integer.parseInt(stocks[i]);
                    if (st < 0) {
                        errors.add(prefix + "Số lượng tồn kho phải là số nguyên không âm.");
                    }
                } else {
                    errors.add(prefix + "Số lượng tồn kho không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Số lượng tồn kho phải là số nguyên hợp lệ.");
            }

            // Dimensions (length, width, thickness, weight)
            try {
                if (lengths != null && lengths.length > i && lengths[i] != null && !lengths[i].trim().isEmpty()) {
                    double len = Double.parseDouble(lengths[i]);
                    if (len <= 0)
                        errors.add(prefix + "Chiều dài phải là số dương lớn hơn 0.");
                } else {
                    errors.add(prefix + "Chiều dài không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Chiều dài phải là số hợp lệ.");
            }

            try {
                if (widths != null && widths.length > i && widths[i] != null && !widths[i].trim().isEmpty()) {
                    double wid = Double.parseDouble(widths[i]);
                    if (wid <= 0)
                        errors.add(prefix + "Chiều rộng phải là số dương lớn hơn 0.");
                } else {
                    errors.add(prefix + "Chiều rộng không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Chiều rộng phải là số hợp lệ.");
            }

            try {
                if (thicknesses != null && thicknesses.length > i && thicknesses[i] != null
                        && !thicknesses[i].trim().isEmpty()) {
                    double thick = Double.parseDouble(thicknesses[i]);
                    if (thick <= 0)
                        errors.add(prefix + "Độ dày phải là số dương lớn hơn 0.");
                } else {
                    errors.add(prefix + "Độ dày không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Độ dày phải là số hợp lệ.");
            }

            try {
                if (weights != null && weights.length > i && weights[i] != null && !weights[i].trim().isEmpty()) {
                    double w = Double.parseDouble(weights[i]);
                    if (w <= 0)
                        errors.add(prefix + "Trọng lượng phải là số dương lớn hơn 0.");
                } else {
                    errors.add(prefix + "Trọng lượng không được để trống.");
                }
            } catch (NumberFormatException e) {
                errors.add(prefix + "Trọng lượng phải là số hợp lệ.");
            }

            // Images
            if (variantImages == null || variantImages.length <= i || variantImages[i] == null
                    || variantImages[i].trim().isEmpty() || "anh-default.png".equals(variantImages[i].trim())) {
                errors.add(prefix + "Vui lòng tải lên hoặc chọn ít nhất một hình ảnh thực tế cho biến thể.");
            }
        }

        return errors;
    }

    public static List<String> validateSingleVariant(
            String color,
            String size,
            String style,
            String priceStr,
            String stockStr,
            String lengthStr,
            String widthStr,
            String thicknessStr,
            String weightStr,
            String imagesStr) {
        List<String> errors = new ArrayList<>();

        if (color == null || color.trim().isEmpty()) {
            errors.add("Màu sắc không được để trống hoặc chỉ chứa khoảng trắng.");
        } else if (color.trim().length() > 30) {
            errors.add("Tên màu sắc không được dài quá 30 ký tự.");
        }

        if (size == null || size.trim().isEmpty()) {
            errors.add("Kích cỡ không được để trống.");
        }

        if (style != null && style.trim().length() > 50) {
            errors.add("Kiểu dáng không được vượt quá 50 ký tự.");
        }

        double p = -1;
        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                p = Double.parseDouble(priceStr);
                if (p < 0)
                    errors.add("Giá bán phải là số không âm.");
            } else {
                errors.add("Giá bán không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Giá bán phải là số hợp lệ.");
        }

        try {
            if (stockStr != null && !stockStr.trim().isEmpty()) {
                int st = Integer.parseInt(stockStr);
                if (st < 0)
                    errors.add("Số lượng tồn kho phải là số nguyên không âm.");
            } else {
                errors.add("Số lượng tồn kho không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Số lượng tồn kho phải là số nguyên hợp lệ.");
        }

        try {
            if (lengthStr != null && !lengthStr.trim().isEmpty()) {
                double len = Double.parseDouble(lengthStr);
                if (len <= 0)
                    errors.add("Chiều dài phải là số dương lớn hơn 0.");
            } else {
                errors.add("Chiều dài không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Chiều dài phải là số hợp lệ.");
        }

        try {
            if (widthStr != null && !widthStr.trim().isEmpty()) {
                double wid = Double.parseDouble(widthStr);
                if (wid <= 0)
                    errors.add("Chiều rộng phải là số dương lớn hơn 0.");
            } else {
                errors.add("Chiều rộng không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Chiều rộng phải là số hợp lệ.");
        }

        try {
            if (thicknessStr != null && !thicknessStr.trim().isEmpty()) {
                double thick = Double.parseDouble(thicknessStr);
                if (thick <= 0)
                    errors.add("Độ dày phải là số dương lớn hơn 0.");
            } else {
                errors.add("Độ dày không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Độ dày phải là số hợp lệ.");
        }

        try {
            if (weightStr != null && !weightStr.trim().isEmpty()) {
                double w = Double.parseDouble(weightStr);
                if (w <= 0)
                    errors.add("Trọng lượng phải là số dương lớn hơn 0.");
            } else {
                errors.add("Trọng lượng không được để trống.");
            }
        } catch (NumberFormatException e) {
            errors.add("Trọng lượng phải là số hợp lệ.");
        }

        if (imagesStr == null || imagesStr.trim().isEmpty() || "anh-default.png".equals(imagesStr.trim())) {
            errors.add("Hình ảnh biến thể không được để trống. Vui lòng chọn hoặc tải lên ít nhất một ảnh.");
        }

        return errors;
    }
}