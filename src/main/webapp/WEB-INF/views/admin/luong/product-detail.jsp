<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%@ page import="java.util.List" %>
<%!
    public String getColorHex(String colorName) {
        if (colorName == null) return "#cbd5e1";
        String trimmed = colorName.trim();
        if (trimmed.startsWith("#")) {
            return trimmed;
        }
        switch (trimmed.toLowerCase()) {
            case "đăng": // Keep robust in case of typos
            case "đen":
                return "#000000";
            case "trắng":
                return "#ffffff";
            case "be":
            case "beige":
                return "#E6D7C3";
            case "navy":
            case "xanh navy":
                return "#1B365D";
            case "đỏ đô":
            case "đỏ đậm":
                return "#8B0000";
            case "đỏ":
                return "#EF4444";
            case "xám":
            case "ghi":
                return "#808080";
            case "xanh dương":
            case "xanh lam":
                return "#3B82F6";
            case "xanh lá":
            case "xanh lục":
                return "#10B981";
            case "vàng":
                return "#FBBF24";
            case "cam":
                return "#F97316";
            case "hồng":
                return "#EC4899";
            case "nâu":
                return "#78350F";
            case "kem":
                return "#FFFDD0";
            case "tím":
                return "#8B5CF6";
            case "xanh rêu":
                return "#4B5320";
            default:
                return "#cbd5e1"; // Slate grey default
        }
    }
%>
<%
    String requestAction = request.getParameter("action");
    if ("edit".equals(requestAction)) {
        Product prodObj = (Product) request.getAttribute("product");
        request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm " + (prodObj != null ? prodObj.getCode() : ""));
        request.getRequestDispatcher("/WEB-INF/views/admin/product-add.jsp").forward(request, response);
        return;
    }

    Product prod = (Product) request.getAttribute("product");
    String statusClass = "";
    String statusLabel = "";
    if (prod != null) {
        if ("AVAILABLE".equals(prod.getEffectiveStatus())) {
            statusLabel = "Còn hàng";
            statusClass = "available";
        } else {
            statusLabel = "Hết hàng";
            statusClass = "out_of_stock";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - <%= prod != null ? prod.getName() : "Không tìm thấy" %></title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products/product-detail.css">
</head>
<body>
    <div class="app-container">
        <!-- Nhúng Sidebar dùng chung -->
        <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

        <!-- Khu vực nội dung chính bên phải -->
        <main class="main-content">
            <!-- Navbar trên cùng -->
            <header class="navbar">
                <div class="breadcrumb">
                    <span>FamiCoats</span> / <a href="${pageContext.request.contextPath}/admin/products" style="color: inherit; text-decoration: none;">Quản lý sản phẩm</a> / <span class="active-crumb">Chi tiết</span>
                </div>
                <div class="navbar-right">
                    <jsp:include page="/WEB-INF/views/layout/notification.jsp" />
                    <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                    <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
                </div>
            </header>

            <!-- Thân trang -->
            <div class="content-wrapper">
                <% if (prod == null) { %>
                    <div class="detail-card" style="text-align: center; padding: 48px;">
                        <h2 style="color: #64748b; margin-bottom: 16px;">Không tìm thấy thông tin sản phẩm</h2>
                        <a href="${pageContext.request.contextPath}/admin/products" class="back-btn">
                            <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            Quay lại danh sách
                        </a>
                    </div>
                <% } else { %>
                    <!-- Header Tiêu đề & Nút quay lại -->
                    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                        <div>
                            <h1><%= prod.getName() %></h1>
                            <div class="subtitle" style="margin-top: 4px;">Mã sản phẩm: <span style="font-weight: 600; color: #475569;"><%= prod.getCode() %></span></div>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <a href="${pageContext.request.contextPath}/admin/products?action=edit&code=<%= prod.getCode() %>" class="edit-product-btn">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                <span>Chỉnh sửa sản phẩm</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products" class="back-btn">
                                <svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                                Quay lại danh sách
                            </a>
                        </div>
                    </div>

                    <!-- 1. Thông tin chung sản phẩm -->
                    <!-- 1. Thông tin chung sản phẩm -->
                    <div class="form-card">
                        <div class="form-card-title">
                            <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                            Thông tin chung sản phẩm
                        </div>
                        <div class="form-card-body">
                            <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="id">Mã sản phẩm</label>
                                <input type="text" id="code" class="form-input" value="<%= prod.getCode() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="name">Tên sản phẩm</label>
                                <input type="text" id="name" class="form-input" value="<%= prod.getName() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="category">Danh mục</label>
                                <input type="text" id="category" class="form-input" value="<%= prod.getCategory() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="brand">Thương hiệu</label>
                                <input type="text" id="brand" class="form-input" value="<%= prod.getBrand() != null ? prod.getBrand() : "N/A" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="origin">Xuất xứ</label>
                                <input type="text" id="origin" class="form-input" value="<%= prod.getOrigin() != null ? prod.getOrigin() : "N/A" %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="status">Trạng thái</label>
                                <div style="display: flex; align-items: center; height: 41.6px; border: 1px solid #cbd5e1; border-radius: 8px; padding: 0 14px; background-color: #f1f5f9; cursor: not-allowed;">
                                    <span class="badge-status <%= statusClass %>" style="margin: 0;"><%= statusLabel %></span>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="priceRange">Khoảng giá bán</label>
                                <input type="text" id="priceRange" class="form-input" value="<%= prod.getPriceRangeFormatted() %>" readonly style="background-color: #f1f5f9; cursor: not-allowed; font-weight: 700; color: #0f172a;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="sold">Tổng đã bán</label>
                                <input type="text" id="sold" class="form-input" value="<%= prod.getSold() %> sản phẩm" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="stock">Tổng tồn kho</label>
                                <input type="text" id="stock" class="form-input" value="<%= prod.getStock() %> sản phẩm" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="careInstructions">Hướng dẫn bảo quản</label>
                                <textarea id="careInstructions" class="form-textarea" readonly style="background-color: #f1f5f9; cursor: not-allowed;"><%= prod.getCareInstructions() != null ? prod.getCareInstructions() : "Chưa có hướng dẫn bảo quản cho sản phẩm này." %></textarea>
                            </div>
                            <div class="form-group full-width">
                                <label class="form-label" for="description">Mô tả sản phẩm</label>
                                <textarea id="description" class="form-textarea" readonly style="background-color: #f1f5f9; cursor: not-allowed;"><%= prod.getDescription() != null ? prod.getDescription() : "Chưa có mô tả chi tiết cho sản phẩm này." %></textarea>
                            </div>
                        </div>
                        </div>
                    </div>
                
                    <!-- Danh sách biến thể (Read-only) -->
                    <div class="custom-card" style="margin-top: 24px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.04);">
                        <div class="card-header-bar" style="background-color: #12192D; color: #ffffff; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center;">
                            <span class="card-header-title" style="font-size: 13px; font-weight: 700; text-transform: uppercase;">&#8226; Danh sách biến thể của sản phẩm</span>
                        </div>
                        <div style="overflow-x: auto;">
                            <table class="invoice-table" style="width: 100%; min-width: 800px; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">STT</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Hình ảnh</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Màu sắc</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Kích cỡ</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Đơn giá</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Số lượng</th>
                                    <th style="text-align: center; padding: 12px; border-bottom: 1px solid #e2e8f0; font-size: 12px; white-space: nowrap;">Trạng thái</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (prod.getDetails() != null && !prod.getDetails().isEmpty()) {
                                        int stt = 1;
                                        for (project.duan1_sd21301.model.luong.ProductDetail v : prod.getDetails()) {
                                            Integer pStatus = v.getStatus();
                                            boolean isAvail = (pStatus != null && pStatus == 1 && v.getStock() > 0);
                                            String vStatusClass = isAvail ? "available" : "out_of_stock";
                                            String vStatusLabel = isAvail ? "Còn hàng" : "Hết hàng";
                                %>
                                <tr>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; color: #64748b; font-weight: 500;"><%= stt++ %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <% 
                                            String vImg = (v.getImages() != null && !v.getImages().isEmpty()) ? v.getImages().get(0) : null;
                                            boolean hasVImg = vImg != null && !vImg.trim().isEmpty() && !"null".equalsIgnoreCase(vImg.trim());
                                            if (hasVImg) {
                                                String vImgSrc = (vImg.startsWith("http://") || vImg.startsWith("https://")) 
                                                    ? vImg 
                                                    : (request.getContextPath() + "/assets/img/" + vImg);
                                        %>
                                            <img src="<%= vImgSrc %>" onerror="this.src='${pageContext.request.contextPath}/assets/img/anh-default.png'" alt="Image" style="width: 90px; height: 90px; object-fit: cover; border-radius: 10px; border: 1.5px solid #cbd5e1; display: inline-block; box-shadow: 0 2px 6px rgba(0,0,0,0.1);">
                                        <% } else { %>
                                            <div style="width: 90px; height: 90px; border-radius: 10px; background-color: #f8fafc; border: 1.5px dashed #cbd5e1; display: inline-flex; align-items: center; justify-content: center; color: #94a3b8; margin: 0 auto;">
                                                <svg viewBox="0 0 24 24" width="28" height="28" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #0f172a;"><%= v.getColor() != null ? v.getColor() : "" %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <span style="background-color: #f1f5f9; color: #475569; font-size: 12px; padding: 4px 8px; border-radius: 4px; font-weight: 600;"><%= v.getSize() != null ? v.getSize() : "" %></span>
                                    </td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #1e293b;"><%= String.format("%,.0f", v.getPrice()) %> đ</td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #475569;"><%= v.getStock() %></td>
                                    <td style="text-align: center; padding: 12px; border-bottom: 1px solid #f1f5f9;">
                                        <span style="display: inline-block; padding: 2px 8px; border-radius: 6px; font-size: 11px; font-weight: 600; <%= vStatusClass.equals("available") ? "background-color: #ecfdf5; color: #065f46;" : "background-color: #fef2f2; color: #991b1b;" %>"><%= vStatusLabel %></span>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #9ca3af;">Không có dữ liệu biến thể.</td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>

