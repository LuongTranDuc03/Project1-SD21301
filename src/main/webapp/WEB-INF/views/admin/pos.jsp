<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="project.duan1_sd21301.model.luong.Product" %>
<%@ page import="project.duan1_sd21301.model.luong.ProductDetail" %>
<%@ page import="project.duan1_sd21301.model.ha.Customer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "Bán hàng tại quầy"}</title>
    <!-- Nhúng Google Fonts (Inter) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Nhúng CSS Custom -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=<%= System.currentTimeMillis() %>">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pos.css?v=1.0">
    <!-- Nhúng FontAwesome để dùng icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body style="background-color: #f8fafc; margin: 0; font-family: 'Inter', sans-serif;">

<div style="display: flex; min-height: 100vh;">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <!-- Main Content -->
    <main class="main-content" style="flex: 1; padding: 0; background-color: #f8fafc;">
        <!-- Thanh Navbar trên cùng -->
        <header class="navbar">
            <div class="breadcrumb">
                <span>FamiCoats</span> / <span class="active-crumb">Bán hàng tại quầy</span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                    <span class="notif-badge"></span>
                </button>
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span>${sessionScope.currentUserRole != null ? sessionScope.currentUserRole : 'Hệ thống'}</span>
                </div>
            </div>
        </header>

        <div class="pos-container">
            <!-- Header -->
            <div class="pos-header">
                <div class="pos-title-area">
                    <h2>Bán hàng tại quầy</h2>
                    <p class="pos-subtitle">
                        Người bán: <strong>${sessionScope.loggedInUser != null ? sessionScope.loggedInUser.fullName : 'Admin'}</strong>
                    </p>
                </div>
                <button class="btn-create-order" onclick="createOrder()">
                    <i class="fa-solid fa-plus"></i> Tạo đơn hàng
                </button>
            </div>

            <!-- Tabs Container -->
            <div class="pos-tabs-container" id="orderTabsContainer">
                <!-- Order tabs will be generated here by JS -->
            </div>

            <!-- Main Order Content -->
            <div class="pos-content-card">
                <div class="pos-section-header">
                    <h3 class="pos-section-title">Sản phẩm</h3>
                    <div class="pos-actions">
                        <button class="btn-scan-qr" onclick="startCameraScan()">Quét QR sản phẩm</button>
                        <button class="btn-add-product" onclick="openVariantModal()">Thêm sản phẩm</button>
                    </div>
                </div>

                <!-- Empty State -->
                <div class="pos-empty-state" id="emptyState">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <path d="M16 10a4 4 0 0 1-8 0"></path>
                    </svg>
                    <p>Không có dữ liệu</p>
                </div>
                
                <!-- Added products table will go here later -->
                <div id="addedProductsContainer" style="display: none;">
                    <!-- Not implemented yet -->
                </div>
            </div>
            
            <!-- Checkout Grid -->
            <div class="pos-checkout-grid" id="checkoutGrid" style="display: none;">
                <!-- Thông tin khách hàng -->
                <div class="pos-card-box">
                    <div class="pos-card-header">
                        <h3>Thông tin khách hàng</h3>
                        <div class="pos-card-actions" style="display: flex; gap: 10px; align-items: center;">
                            <button class="btn-outline-primary" onclick="openCustomerModal()"><i class="fa-solid fa-user-plus" style="margin-right: 5px;"></i> Chọn KH</button>
                            <button class="btn-outline-primary" id="btnChooseAddress" style="display: none;" onclick="openAddressSelectionModal()"><i class="fa-solid fa-map-location-dot" style="margin-right: 5px;"></i> Chọn địa chỉ</button>
                        </div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; padding-top: 10px;">
                        <!-- Cột trái: Thông tin khách hàng (người mua) -->
                        <div class="customer-info-basic" style="display: flex; flex-direction: column; gap: 12px;">
                            <h4 style="margin: 0 0 5px 0; font-size: 14px; color: #475569; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px;">Người mua hàng</h4>
                            
                            <div class="form-group">
                                <label class="form-label">Tên khách hàng <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="customerNameInput" placeholder="Khách lẻ" oninput="updateCheckoutState()">
                                <div id="customerNameError" class="text-danger" style="display: none; font-size: 12px; margin-top: 5px;">Tên khách hàng chỉ được chứa chữ cái và khoảng trắng</div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="buyerPhoneInput" placeholder="SĐT người mua..." oninput="this.value = this.value.replace(/[^0-9]/g, ''); document.getElementById('buyerPhoneError').style.display='none'; updateCheckoutState()">
                                <div id="buyerPhoneError" class="text-danger" style="display: none; font-size: 12px; margin-top: 5px;"></div>
                            </div>
                            
                            <p class="text-muted" id="deliveryHintText" style="margin-top: 10px; margin-bottom: 0; font-size: 13px;">Tại quầy: khách tự mang về, không cần lưu địa chỉ.</p>
                            
                            <div class="form-group" style="margin-top: 10px;">
                                <label class="form-label">Ghi chú đơn hàng</label>
                                <textarea class="form-control" id="orderNoteInput" rows="2" placeholder="Ghi chú (Tùy chọn)..." oninput="updateCheckoutState()" style="resize: none;"></textarea>
                            </div>
                        </div>
                        
                        <!-- Cột phải: Địa chỉ giao hàng -->
                        <div class="customer-address-form" style="display: flex; flex-direction: column; gap: 12px;">
                            <h4 style="margin: 0 0 5px 0; font-size: 14px; color: #475569; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px;">Thông tin nhận hàng</h4>
                            
                            <div id="deliveryForm" style="display: none; flex-direction: column; gap: 12px;">
                                <div class="form-group">
                                    <label class="form-label">Tên người nhận (nếu có)</label>
                                    <input type="text" class="form-control" id="recipientNameInput" placeholder="Tên người nhận..." oninput="updateCheckoutState()">
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="customerPhoneInput" placeholder="Nhập số điện thoại..." oninput="this.value = this.value.replace(/[^0-9]/g, ''); document.getElementById('deliveryPhoneError').style.display='none'; updateCheckoutState()">
                                    <div id="deliveryPhoneError" class="text-danger" style="display: none; font-size: 12px; margin-top: 5px;"></div>
                                </div>
                                
                                <div class="form-group" style="width: 100%;">
                                    <label>Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="customerAddressInput" placeholder="Số nhà, ngõ, đường..." oninput="updateCheckoutState()">
                                </div>
                                
                                <!-- Block for Khách lẻ (API Comboboxes) -->
                                <div class="form-row three-cols" id="apiAddressComboboxes" style="margin-top: 0;">
                                    <div class="form-group">
                                        <label>Tỉnh/TP <span class="text-danger">*</span></label>
                                        <select class="form-control" id="provinceSelect" onchange="fetchDistricts(this.value); updateCheckoutState()">
                                            <option value="">Chọn Tỉnh/Thành phố...</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Quận/Huyện <span class="text-danger">*</span></label>
                                        <select class="form-control" id="districtSelect" onchange="fetchWards(this.value); updateCheckoutState()">
                                            <option value="">Chọn Quận/Huyện...</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Xã/Phường <span class="text-danger">*</span></label>
                                        <select class="form-control" id="wardSelect" onchange="updateCheckoutState()">
                                            <option value="">Chọn Xã/Phường...</option>
                                        </select>
                                    </div>
                                </div>
        
                                <!-- Block for Fixed Customer (Readonly Inputs) -->
                                <div class="form-row three-cols" id="fixedAddressInputs" style="display: none; margin-top: 0;">
                                    <div class="form-group">
                                        <label>Tỉnh/TP <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="provinceFixed" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label>Quận/Huyện <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="districtFixed" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label>Xã/Phường <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="wardFixed" readonly>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Thông tin thanh toán -->
                <div class="pos-card-box">
                    <div class="pos-card-header">
                        <h3>Thông tin thanh toán</h3>
                        <div class="toggle-delivery">
                            <span id="deliveryLabel">Tại quầy</span>
                            <label class="switch">
                                <input type="checkbox" id="deliveryToggle" onchange="toggleDelivery(); updateCheckoutState()">
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    
                    <div class="coupon-section">
                        <div class="coupon-inputs">
                            <div class="form-group" style="flex: 1; width: 100%;">
                                <label>Mã phiếu giảm giá</label>
                                <select class="form-control" id="discountCodeInput" onchange="applyDiscountSelect()" style="text-transform: uppercase;">
                                    <option value="">-- Chọn mã giảm giá --</option>
                                    <c:forEach var="c" items="${activeCoupons}">
                                        <option value="${c.code}" 
                                            data-type="${c.discountType}" 
                                            data-value="${c.discountValue}" 
                                            data-min="${c.minOrderValue != null ? c.minOrderValue : 0}" 
                                            data-max="${c.maxDiscountAmount != null ? c.maxDiscountAmount : 0}">
                                            ${c.code} - ${c.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="payment-summary">
                        <div class="summary-row">
                            <span class="summary-label">Tiền hàng</span>
                            <span class="summary-value" id="summaryTotalItems">0 đ</span>
                        </div>
                        
                        <div class="summary-row" id="shippingRow">
                            <span class="summary-label">Phí vận chuyển</span>
                            <div class="shipping-fee-input">
                                <input type="text" class="form-control text-right" id="shippingFeeInput" value="" placeholder="0" style="width: 80px;" oninput="updateCheckoutState()">
                                <span>đ</span>
                            </div>
                        </div>
                        
                        <div class="summary-row">
                            <span class="summary-label">Giảm giá</span>
                            <span class="summary-value text-danger" id="summaryDiscount">- 300.000 đ</span>
                        </div>
                        
                        <div class="summary-row total-row">
                            <span class="summary-label">Tổng số tiền</span>
                            <span class="summary-value text-danger" id="summaryTotalPayment">0 đ</span>
                        </div>
                        
                        <div class="summary-row" style="flex-direction: column; align-items: flex-start; gap: 8px;">
                            <span class="summary-label">Hình thức thanh toán</span>
                            <div style="display: flex; gap: 10px; width: 100%;">
                                <button type="button" class="btn-payment-method active" id="btnPayCash" onclick="setPaymentMethod('CASH')"><i class="fa-solid fa-money-bill-wave"></i> Tiền mặt</button>
                                <button type="button" class="btn-payment-method" id="btnPayTransfer" onclick="setPaymentMethod('TRANSFER')"><i class="fa-solid fa-qrcode"></i> Chuyển khoản</button>
                            </div>
                        </div>
                        
                        <div class="summary-row" id="customerPayRow">
                            <span class="summary-label">Khách thanh toán <i class="fa-solid fa-money-bill-wave"></i></span>
                            <div class="customer-pay-input">
                                <input type="text" class="form-control text-right" id="customerPayInput" value="0" oninput="handleCurrencyInput(this)">
                                <span>đ</span>
                            </div>
                        </div>
                        
                        <div class="summary-row" id="summaryChangeRow">
                            <span class="summary-label" id="summaryChangeLabel">Tiền thiếu</span>
                            <span class="summary-value" id="summaryChange">0 đ</span>
                        </div>
                    </div>
                    
                    <button class="btn-confirm-order" onclick="confirmOrder()">XÁC NHẬN ĐẶT HÀNG</button>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Customer Modal -->
<div class="pos-modal-overlay" id="customerModalOverlay">
    <div class="pos-modal" style="max-width: 1200px;">
        <div class="pos-modal-header">
            <h3>Chọn khách hàng</h3>
            <button class="btn-close-modal" onclick="closeCustomerModal()">
                <i class="fa-solid fa-times"></i>
            </button>
        </div>
        <div class="pos-modal-body">
            <div class="pos-filter-group search-group" style="margin-bottom: 15px;">
                <input type="text" class="pos-filter-input" id="customerSearch" placeholder="Tìm kiếm theo tên, số điện thoại..." style="width: 100%;" oninput="filterCustomers()">
            </div>
            <div class="pos-table-container">
                <table class="pos-table">
                    <thead>
                        <tr>
                            <th>Mã KH</th>
                            <th>Tên khách hàng</th>
                            <th>Số điện thoại</th>
                            <th>Địa chỉ mặc định</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="customerTableBody">
                        <tr class="customer-row">
                            <td></td>
                            <td style="font-weight: 600;">Khách lẻ</td>
                            <td></td>
                            <td></td>
                            <td><button class="btn-add-variant" onclick="selectCustomer('Khách lẻ', '', this)">Chọn</button></td>
                        </tr>
                        <% 
                        java.util.List<Customer> customers = (java.util.List<Customer>) request.getAttribute("customers");
                        if (customers != null) {
                            for (Customer c : customers) {
                                project.duan1_sd21301.model.ha.CustomerAddress defAddr = c.getDefaultAddress();
                                String phone = c.getPhoneNumber() != null ? c.getPhoneNumber() : "";
                                String prov = defAddr != null && defAddr.getProvince() != null ? defAddr.getProvince() : "";
                                String dist = defAddr != null && defAddr.getDistrict() != null ? defAddr.getDistrict() : "";
                                String ward = defAddr != null && defAddr.getWard() != null ? defAddr.getWard() : "";
                                String detail = defAddr != null && defAddr.getDetailedAddress() != null ? defAddr.getDetailedAddress() : "";
                                String addrStr = defAddr != null ? defAddr.getFormattedAddress() : "Chưa có địa chỉ";
                        %>
                        <tr class="customer-row" 
                            data-prov="<%= prov %>"
                            data-dist="<%= dist %>"
                            data-ward="<%= ward %>"
                            data-detail="<%= detail %>">
                            <td><%= c.getCode() %></td>
                            <td style="font-weight: 600;"><%= c.getFullName() %></td>
                            <td><%= phone %></td>
                            <td><%= addrStr %></td>
                            <td><button class="btn-add-variant" onclick="selectCustomer('<%= c.getFullName() %>', '<%= phone %>', this)">Chọn</button></td>
                        </tr>
                        <% 
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Address Selection Modal -->
<div class="pos-modal-overlay" id="addressSelectionModalOverlay">
    <div class="pos-modal" style="max-width: 800px;">
        <div class="pos-modal-header">
            <h3>Chọn địa chỉ giao hàng</h3>
            <button class="btn-close-modal" onclick="closeAddressSelectionModal()">
                <i class="fa-solid fa-times"></i>
            </button>
        </div>
        <div class="pos-modal-body">
            <div class="pos-table-container">
                <table class="pos-table">
                    <thead>
                        <tr>
                            <th>Người nhận</th>
                            <th>Số điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="addressSelectionTableBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    const customerAddressesMap = {};
    <%
    if (customers != null) {
        for (Customer c : customers) {
            if (c.getAddresses() != null && !c.getAddresses().isEmpty()) {
                out.print("customerAddressesMap['" + c.getCode() + "'] = [");
                for (int i = 0; i < c.getAddresses().size(); i++) {
                    project.duan1_sd21301.model.ha.CustomerAddress ca = c.getAddresses().get(i);
                    String recName = ca.getRecipientName() != null ? ca.getRecipientName().replace("'", "\\'") : c.getFullName().replace("'", "\\'");
                    String recPhone = ca.getPhoneNumber() != null ? ca.getPhoneNumber() : c.getPhoneNumber();
                    String prov = ca.getProvince() != null ? ca.getProvince() : "";
                    String dist = ca.getDistrict() != null ? ca.getDistrict() : "";
                    String ward = ca.getWard() != null ? ca.getWard() : "";
                    String detail = ca.getDetailedAddress() != null ? ca.getDetailedAddress().replace("'", "\\'") : "";
                    String fullAddr = ca.getFormattedAddress() != null ? ca.getFormattedAddress().replace("'", "\\'") : "";
                    boolean isDef = ca.isDefault();
                    out.print(String.format("{name:'%s', phone:'%s', prov:'%s', dist:'%s', ward:'%s', detail:'%s', fullAddr:'%s', isDefault:%b}", 
                            recName, recPhone, prov, dist, ward, detail, fullAddr, isDef));
                    if (i < c.getAddresses().size() - 1) out.print(",");
                }
                out.print("];\n");
            }
        }
    }
    %>
</script>

<!-- Variant Modal -->
<div class="pos-modal-overlay" id="variantModalOverlay">
    <div class="pos-modal">
        <div class="pos-modal-header">
            <h3>Chọn biến thể để thêm vào đơn <span id="totalVariantsCount" style="font-size: 14px; font-weight: normal; color: #64748b; margin-left: 8px;"></span></h3>
            <button class="btn-close-modal" onclick="closeVariantModal()">
                <i class="fa-solid fa-times"></i>
            </button>
        </div>
        
        <div class="pos-modal-body">
            <div class="pos-filters">
                <div class="pos-filter-group search-group">
                    <label class="pos-filter-label">Tìm kiếm</label>
                    <input type="text" id="variantSearch" class="pos-filter-input" placeholder="Tìm mã, tên, màu, kích cỡ..." oninput="filterVariants()">
                </div>
                
                <div class="pos-filter-group">
                    <label class="pos-filter-label">Màu sắc</label>
                    <select id="colorFilter" class="pos-filter-select" onchange="filterVariants()">
                        <option value="">Tất cả màu</option>
                        <% 
                        List<String> reqColors = (List<String>) request.getAttribute("colors");
                        if (reqColors != null) {
                            java.util.Set<String> uniqueColors = new java.util.LinkedHashSet<>();
                            for (String c : reqColors) {
                                if (c != null && !c.trim().isEmpty()) {
                                    uniqueColors.add(c.trim());
                                }
                            }
                            for (String color : uniqueColors) {
                        %>
                        <option value="<%= color %>"><%= color %></option>
                        <%  
                            }
                        }
                        %>
                    </select>
                </div>
                
                <div class="pos-filter-group">
                    <label class="pos-filter-label">Kích cỡ</label>
                    <select id="sizeFilter" class="pos-filter-select" onchange="filterVariants()">
                        <option value="">Tất cả kích cỡ</option>
                        <% 
                        List<String> reqSizes = (List<String>) request.getAttribute("sizes");
                        if (reqSizes != null) {
                            java.util.Set<String> uniqueSizes = new java.util.LinkedHashSet<>();
                            for (String s : reqSizes) {
                                if (s != null && !s.trim().isEmpty()) {
                                    uniqueSizes.add(s.trim());
                                }
                            }
                            for (String size : uniqueSizes) {
                        %>
                        <option value="<%= size %>"><%= size %></option>
                        <%  
                            }
                        }
                        %>
                    </select>
                </div>
                
                <div class="pos-filter-group">
                    <label class="pos-filter-label">Danh mục</label>
                    <select id="categoryFilter" class="pos-filter-select" onchange="filterVariants()">
                        <option value="">Tất cả danh mục</option>
                        <% 
                        List<String> reqCategories = (List<String>) request.getAttribute("categories");
                        if (reqCategories != null) {
                            java.util.Set<String> uniqueCategories = new java.util.LinkedHashSet<>();
                            for (String c : reqCategories) {
                                if (c != null && !c.trim().isEmpty()) {
                                    uniqueCategories.add(c.trim());
                                }
                            }
                            for (String category : uniqueCategories) {
                        %>
                        <option value="<%= category %>"><%= category %></option>
                        <%  
                            }
                        }
                        %>
                    </select>
                </div>
                
                <button class="btn-reset-filters" onclick="resetFilters()">Đặt lại</button>
            </div>
            
            <div class="pos-table-wrapper">
                <table class="pos-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã SP</th>
                            <th>Mã BT</th>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Màu sắc</th>
                            <th>Kích cỡ</th>
                            <th>Số lượng</th>
                            <th>Giá bán</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody id="variantsTableBody">
                        <% 
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            int stt = 1;
                            for (Product p : products) {
                                if (p.getStatus() == null || p.getStatus() != 1) continue;
                                if (p.getDetails() != null) {
                                    for (ProductDetail v : p.getDetails()) {
                                        if (v.getStatus() == null || v.getStatus() != 1) continue;
                                        String img = (v.getImages() != null && !v.getImages().isEmpty()) ? v.getImages().get(0) : "";
                                        String imageUrl = "";
                                        if (img != null && !img.trim().isEmpty() && !"null".equalsIgnoreCase(img.trim())) {
                                            if (img.startsWith("http") || img.startsWith("/")) {
                                                imageUrl = img;
                                            } else {
                                                imageUrl = request.getContextPath() + "/assets/img/" + img;
                                            }
                                        }
                        %>
                        <tr class="variant-row" 
                            data-code="<%= v.getCode() != null ? v.getCode() : "" %>" 
                            data-productcode="<%= p.getCode() != null ? p.getCode() : "" %>"
                            data-name="<%= p.getName() != null ? p.getName() : "" %>" 
                            data-color="<%= v.getColor() != null ? v.getColor() : "" %>" 
                            data-size="<%= v.getSize() != null ? v.getSize() : "" %>"
                            data-category="<%= p.getCategory() != null ? p.getCategory().trim() : "" %>"
                            data-price="<%= v.getPrice() %>"
                            data-stock="<%= v.getStock() %>"
                            data-image="<%= imageUrl %>">
                            <td><%= stt++ %></td>
                            <td style="font-weight: 600; color: #475569;"><%= (p.getCode() != null) ? p.getCode() : "N/A" %></td>
                            <td style="font-weight: 600; color: #475569;"><%= v.getCode() %></td>
                            <td>
                                <% if (!imageUrl.isEmpty()) { %>
                                    <img src="<%= imageUrl %>" alt="Product Image" class="pos-product-img">
                                <% } else { %>
                                    <div class="pos-product-img"></div>
                                <% } %>
                            </td>
                            <td class="pos-product-name"><%= p.getName() %></td>
                            <td><%= v.getColor() != null ? v.getColor() : "" %></td>
                            <td><%= v.getSize() != null ? v.getSize() : "" %></td>
                            <td class="td-stock"><%= v.getStock() %></td>
                            <td style="font-weight: 600; color: #7f1d1d; white-space: nowrap;"><%= String.format("%,.0f đ", v.getPrice()) %></td>
                            <td>
                                <button class="btn-add-variant" onclick="addVariantToOrder('<%= v.getCode() %>')" title="Thêm vào đơn">Thêm</button>
                            </td>
                        </tr>
                        <%
                                    }
                                }
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="pos-modal-footer">
            <button class="btn-close-bottom" onclick="closeVariantModal()">Đóng</button>
        </div>
    </div>
</div>

<script>
    // -----------------------------------------------------
    // JS Logic for POS
    // -----------------------------------------------------
    
    let orders = [];
    let currentOrderId = null;
    const MAX_ORDERS = 10;
    let nextOrderId = parseInt('${nextOrderIndex}') || 1;

    let autoSaveTimeout = null;
    function saveOrdersToStorage() {
        if (autoSaveTimeout) clearTimeout(autoSaveTimeout);
        autoSaveTimeout = setTimeout(() => {
            if (!currentOrderId) return;
            const order = orders.find(o => o.id === currentOrderId);
            if (!order) return;
            
            fetch(window.location.pathname.replace('/pos', '/pos/api/update-draft-info'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(order)
            }).catch(err => console.error('Auto-save error:', err));
        }, 800);
    }

    async function initPOS() {
        try {
            const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/get-drafts'));
            const data = await res.json();
            if (data && data.length > 0) {
                orders = data.map(d => {
                    let addrStr = d.deliveryAddress || '';
                    let parts = addrStr.split(', ');
                    let p = '', dist = '', w = '', a = addrStr;
                    if (parts.length >= 4) {
                        p = parts.pop();
                        dist = parts.pop();
                        w = parts.pop();
                        a = parts.join(', ');
                    }
                    
                    return {
                        id: d.id.toString(),
                        name: d.code,
                        items: d.items || [],
                        customerName: d.customerName || 'Khách lẻ',
                        customerCode: d.customerCode || '',
                        recipientName: d.recipientName || '',
                        customerPhone: d.customerPhone || '',
                        isDelivery: !!d.isDelivery,
                        deliveryPhone: d.deliveryPhone || '',
                        deliveryAddress: a,
                        province: p,
                        district: dist,
                        ward: w,
                        discountCode: d.discountCode || '',
                        discountValue: d.discountValue || '',
                        shippingFee: d.shippingFee || '',
                        note: d.note || '',
                        customerPay: '',
                        paymentMethod: 'CASH'
                    };
                });
                currentOrderId = orders[0].id;
                renderTabs();
                renderCurrentOrderItems();
                renderCheckoutState();
            } else {
                await createOrder();
            }
        } catch (e) {
            console.error("Error loading drafts", e);
            await createOrder();
        }
        countTotalVariants();
        fetchProvinces();
        updateAvailableStockDisplay();

        // Khởi tạo trạng thái phí vận chuyển: readonly mặc định (Tại quầy)
        const shippingInput = document.getElementById('shippingFeeInput');
        if (shippingInput) {
            shippingInput.setAttribute('readonly', true);
            shippingInput.style.backgroundColor = '#f3f4f6';
            shippingInput.style.color = '#94a3b8';
        }
    }

    // --- Order Tabs Logic ---
    
    async function createOrder() {
        if (orders.length >= MAX_ORDERS) {
            alert("Chỉ được tạo tối đa " + MAX_ORDERS + " hóa đơn!");
            return;
        }
        
        try {
            const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/create-order'), { method: 'POST' });
            const data = await res.json();
            if (data && data.success) {
                orders.push({
                    id: data.id.toString(),
                    name: data.code,
                    items: [],
                    customerName: 'Khách lẻ',
                    customerCode: '',
                    recipientName: '',
                    customerPhone: '',
                    isDelivery: false,
                    deliveryPhone: '',
                    deliveryAddress: '',
                    province: '',
                    district: '',
                    ward: '',
                    discountCode: '',
                    discountValue: '',
                    shippingFee: '',
                    customerPay: '',
                    paymentMethod: 'CASH'
                });
                currentOrderId = data.id.toString();
                renderTabs();
                renderCurrentOrderItems();
                renderCheckoutState();
            } else {
                alert("Lỗi: " + (data.message || 'Không thể tạo đơn hàng'));
            }
        } catch (e) {
            console.error("Error creating order", e);
        }
    }
    
    function renderTabs() {
        const container = document.getElementById('orderTabsContainer');
        container.innerHTML = '';
        
        let foundActive = false;

        orders.forEach(order => {
            const isActive = order.id === currentOrderId;
            if (isActive) {
                foundActive = true;
            }
            
            const tabDiv = document.createElement('div');
            tabDiv.className = 'pos-tab ' + (isActive ? 'active' : '');
            tabDiv.onclick = (e) => {
                // Prevent switching if clicked on close button
                if (!e.target.closest('.pos-tab-close')) {
                    switchOrder(order.id);
                }
            };
            
            tabDiv.innerHTML = 
                '<span>' + order.name + '</span>' +
                '<span class="pos-tab-close" onclick="closeOrder(\'' + order.id + '\', event)">' +
                    '<i class="fa-solid fa-xmark"></i>' +
                '</span>';
            container.appendChild(tabDiv);
        });
    }
    
    function switchOrder(orderId) {
        currentOrderId = orderId;
        renderTabs();
        renderCurrentOrderItems();
        renderCheckoutState();
    }
    
    function closeOrder(orderId, event) {
        if (event) {
            event.stopPropagation();
        }
        
        showCustomConfirm('Bạn có chắc chắn muốn xóa thông tin hóa đơn này không?', async function(result) {
            if (!result) return;
            
            try {
                const fd = new URLSearchParams();
                fd.append('invoiceId', orderId);
                const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/delete-order'), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: fd.toString()
                });
                const data = await res.json();
                if (data && data.success) {
                    orders = orders.filter(o => o.id !== orderId);

                    if (orders.length === 0) {
                        currentOrderId = null;
                    } else {
                        if (currentOrderId === orderId) {
                            currentOrderId = orders[orders.length - 1].id;
                        }
                    }
                    renderTabs();
                    renderCurrentOrderItems();
                    renderCheckoutState();
                    updateAvailableStockDisplay();
                } else {
                    alert("Lỗi: " + (data.message || 'Không thể xóa đơn hàng'));
                }
            } catch (e) {
                console.error("Error deleting order", e);
            }
        });
    }

    // --- Modal Logic ---
    
    function openVariantModal() {
        if (!currentOrderId) {
            alert('Vui lòng tạo đơn hàng trước!');
            return;
        }
        updateAvailableStockDisplay();
        document.getElementById('variantModalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }
    
    function closeVariantModal() {
        document.getElementById('variantModalOverlay').classList.remove('active');
        document.body.style.overflow = '';
    }
    
    function closeInvoiceModal() {
        location.reload();
    }
    
    // --- Filters Logic (Client-side) ---
    
    function resetFilters() {
        document.getElementById('variantSearch').value = '';
        document.getElementById('colorFilter').value = '';
        document.getElementById('sizeFilter').value = '';
        document.getElementById('categoryFilter').value = '';
        filterVariants();
    }
    
    function filterVariants() {
        const searchText = document.getElementById('variantSearch').value.trim().toLowerCase();
        const colorVal = document.getElementById('colorFilter').value.trim().toLowerCase();
        const sizeVal = document.getElementById('sizeFilter').value.trim().toLowerCase();
        const categoryVal = document.getElementById('categoryFilter').value.trim().toLowerCase();
        
        const rows = document.querySelectorAll('.variant-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const code = (row.getAttribute('data-code') || '').trim().toLowerCase();
            const name = (row.getAttribute('data-name') || '').trim().toLowerCase();
            const color = (row.getAttribute('data-color') || '').trim().toLowerCase();
            const size = (row.getAttribute('data-size') || '').trim().toLowerCase();
            const category = (row.getAttribute('data-category') || '').trim().toLowerCase();
            
            // Search text matches any of these fields
            const matchSearch = !searchText || code.includes(searchText) || name.includes(searchText) || color.includes(searchText) || size.includes(searchText);
            const matchColor = !colorVal || color === colorVal;
            const matchSize = !sizeVal || size === sizeVal;
            const matchCategory = !categoryVal || category === categoryVal;
            
            if (matchSearch && matchColor && matchSize && matchCategory) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        const countElem = document.getElementById('totalVariantsCount');
        if (countElem) countElem.textContent = visibleCount;
        
        // Basic pagination info update (mocked since it's just client-side filtering without actual pages right now)
        const pagInfo = document.getElementById('paginationInfo');
        if (pagInfo) {
            pagInfo.innerHTML = `Trang 1 / 1 - <span id="totalVariantsCount">${visibleCount}</span> biến thể`;
        }
    }
    
    function countTotalVariants() {
        const rows = document.querySelectorAll('.variant-row');
        const countSpan = document.getElementById('totalVariantsCount');
        if (countSpan) {
            countSpan.textContent = rows.length;
        }
    }
    
    async function addVariantToOrder(variantCode) {
        if (!currentOrderId) {
            alert("Vui lòng tạo đơn hàng trước!");
            return;
        }
        
        const row = document.querySelector(`.variant-row[data-code="` + variantCode.replace(/"/g, '\\"') + `"]`);
        if (!row) {
            console.error("Row not found for variantCode: " + variantCode);
            return;
        }
        
        const name = row.getAttribute('data-name') || '';
        const productCode = row.getAttribute('data-productcode') || '';
        const color = row.getAttribute('data-color') || '';
        const size = row.getAttribute('data-size') || '';
        const price = parseFloat(row.getAttribute('data-price')) || 0;
        const stock = parseInt(row.getAttribute('data-stock')) || 0;
        const image = row.getAttribute('data-image') || '';
        
        if (stock <= 0) {
            alert("Sản phẩm này đã hết hàng (Tồn kho = 0)!");
            return;
        }
        
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) {
            console.error("Order not found: " + currentOrderId);
            return;
        }
        
        const order = orders[orderIndex];
        const existingItemIndex = order.items.findIndex(item => item.code === variantCode);
        
        let newQty = 1;
        if (existingItemIndex !== -1) {
            newQty = order.items[existingItemIndex].quantity + 1;
        }

        try {
            const fd = new URLSearchParams();
            fd.append('invoiceId', currentOrderId);
            fd.append('variantCode', variantCode);
            fd.append('quantity', newQty);
            fd.append('variantName', name);
            fd.append('price', price);
            fd.append('colorSize', color + ' - ' + size);

            const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/add-item'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: fd.toString()
            });
            const data = await res.json();

            if (data && data.success) {
                if (existingItemIndex !== -1) {
                    order.items[existingItemIndex].quantity = newQty;
                } else {
                    order.items.push({
                        code: variantCode,
                        productCode: productCode,
                        name: name,
                        color: color,
                        size: size,
                        price: price,
                        image: image,
                        stock: stock,
                        quantity: 1
                    });
                }

                row.setAttribute('data-stock', stock - 1);
                const stockCell = row.querySelector('.pos-stock-td');
                if (stockCell) stockCell.textContent = stock - 1;

                renderCurrentOrderItems();
                updateAvailableStockDisplay();
                closeVariantModal();
            } else {
                alert("Lỗi: " + (data.message || 'Không thể thêm sản phẩm'));
            }
        } catch (e) {
            console.error("Error adding item", e);
        }
    }
    
    function renderCurrentOrderItems() {
        const emptyState = document.getElementById('emptyState');
        const container = document.getElementById('addedProductsContainer');
        
        if (!currentOrderId || orders.length === 0) {
            emptyState.style.display = 'flex';
            container.style.display = 'none';
            document.getElementById('checkoutGrid').style.display = 'none';
            return;
        }
        
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) {
            emptyState.style.display = 'flex';
            container.style.display = 'none';
            document.getElementById('checkoutGrid').style.display = 'none';
            return;
        }
        
        const order = orders[orderIndex];
        
        if (order.items.length === 0) {
            emptyState.style.display = 'flex';
            container.style.display = 'none';
            document.getElementById('checkoutGrid').style.display = 'none';
        } else {
            emptyState.style.display = 'none';
            container.style.display = 'block';
            document.getElementById('checkoutGrid').style.display = 'grid';
            
            let html = '<div class="pos-cart-list">';
            let sumTotal = 0;
            
            order.items.forEach((item, index) => {
                let imgHtml = item.image ? '<img src="' + item.image + '" alt="Img" class="pos-cart-item-img">' : '<div class="pos-cart-item-img"></div>';
                let total = item.price * item.quantity;
                sumTotal += total;
                let formattedPrice = item.price.toLocaleString('vi-VN') + ' đ';
                
                html += 
                    '<div class="pos-cart-item">' +
                        '<div class="pos-cart-item-left">' +
                            imgHtml +
                            '<div class="pos-cart-item-info">' +
                                '<div class="pos-cart-item-name">' + item.name + '</div>' +
                                '<div class="pos-cart-item-variant">' + (item.productCode ? item.productCode + ' &bull; ' : '') + item.code + ' &bull; ' + item.color + ' &bull; ' + item.size + '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="pos-cart-item-right">' +
                            '<div class="pos-cart-item-price">' + (item.price * item.quantity).toLocaleString('vi-VN') + ' đ</div>' +
                            '<div class="pos-qty-control">' +
                                '<button class="btn-qty" onclick="updateItemQty(\'' + item.code + '\', -1)">-</button>' +
                                '<input type="number" class="input-qty" value="' + item.quantity + '" min="1" max="' + item.stock + '" onchange="setItemQty(\'' + item.code + '\', this.value)">' +
                                '<button class="btn-qty" onclick="updateItemQty(\'' + item.code + '\', 1)">+</button>' +
                            '</div>' +
                            '<button class="btn-remove-item" onclick="removeItem(\'' + item.code + '\')">' +
                                '<i class="fa-solid fa-trash"></i>' +
                            '</button>' +
                        '</div>' +
                    '</div>';
            });
            
            let formattedSumTotal = sumTotal.toLocaleString('vi-VN') + ' đ';
            html += '</div>'; // close pos-cart-list
            html += '<div class="pos-cart-total-bar">Tổng tiền <span class="pos-cart-total-value">' + formattedSumTotal + '</span></div>';
            
            container.innerHTML = html;
            
            // Re-apply discount logic based on new total, which will also update the summary
            applyDiscountSelect();
        }
        saveOrdersToStorage();
    }
    
    function toggleDelivery() {
        const toggle = document.getElementById('deliveryToggle');
        const isDelivery = toggle.checked;
        document.getElementById('deliveryLabel').textContent = isDelivery ? "Giao hàng" : "Tại quầy";
        
        if (isDelivery) {
            document.getElementById('btnChooseAddress').style.display = 'inline-block';
            document.getElementById('deliveryHintText').style.display = 'none';
            document.getElementById('deliveryForm').style.display = 'flex';
            // Cho phép nhập phí vận chuyển
            shippingInput.removeAttribute('readonly');
            shippingInput.style.backgroundColor = '';
            shippingInput.style.color = '';
        } else {
            document.getElementById('btnChooseAddress').style.display = 'none';
            document.getElementById('deliveryHintText').style.display = 'block';
            document.getElementById('deliveryForm').style.display = 'none';
            // Khóa phí vận chuyển khi tại quầy
            shippingInput.value = '';
            shippingInput.setAttribute('readonly', true);
            shippingInput.style.backgroundColor = '#f3f4f6';
            shippingInput.style.color = '#94a3b8';
        }
    }
    
    // --- Address & API Logic ---
    function fetchProvinces() {
        fetch('https://provinces.open-api.vn/api/p/')
            .then(res => res.json())
            .then(data => {
                const select = document.getElementById('provinceSelect');
                if(!select) return;
                select.innerHTML = '<option value="">Chọn Tỉnh/Thành phố...</option>';
                data.forEach(p => {
                    const opt = document.createElement('option');
                    opt.value = p.code;
                    opt.text = p.name;
                    select.appendChild(opt);
                });
            })
            .catch(err => console.error("Error fetching provinces:", err));
    }
    
    function fetchDistricts(provinceCode) {
        const select = document.getElementById('districtSelect');
        const wardSelect = document.getElementById('wardSelect');
        select.innerHTML = '<option value="">Chọn Quận/Huyện...</option>';
        wardSelect.innerHTML = '<option value="">Chọn Xã/Phường...</option>';
        
        if (!provinceCode) return;
        
        fetch(`https://provinces.open-api.vn/api/p/\${provinceCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                if (data && data.districts) {
                    data.districts.forEach(d => {
                        const opt = document.createElement('option');
                        opt.value = d.code;
                        opt.text = d.name;
                        select.appendChild(opt);
                    });
                }
            })
            .catch(err => console.error("Error fetching districts:", err));
    }
    
    function fetchWards(districtCode) {
        const select = document.getElementById('wardSelect');
        select.innerHTML = '<option value="">Chọn Xã/Phường...</option>';
        
        if (!districtCode) return;
        
        fetch(`https://provinces.open-api.vn/api/d/\${districtCode}?depth=2`)
            .then(res => res.json())
            .then(data => {
                if (data && data.wards) {
                    data.wards.forEach(w => {
                        const opt = document.createElement('option');
                        opt.value = w.code;
                        opt.text = w.name;
                        select.appendChild(opt);
                    });
                }
            })
            .catch(err => console.error("Error fetching wards:", err));
    }
    
    // --- Customer Modal Logic ---
    function openCustomerModal() {
        document.getElementById('customerModalOverlay').classList.add('active');
    }
    
    function closeCustomerModal() {
        document.getElementById('customerModalOverlay').classList.remove('active');
    }
    
    function filterCustomers() {
        const searchText = document.getElementById('customerSearch').value.toLowerCase();
        const rows = document.querySelectorAll('#customerTableBody tr.customer-row');
        
        rows.forEach(row => {
            const code = (row.children[0].textContent || '').toLowerCase();
            const name = (row.children[1].textContent || '').toLowerCase();
            const phone = (row.children[2].textContent || '').toLowerCase();
            
            if (!searchText || code.includes(searchText) || name.includes(searchText) || phone.includes(searchText)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
    
    function selectCustomer(name, phone, btnElement) {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex !== -1) {
            orders[orderIndex].customerName = name;
            orders[orderIndex].recipientName = name;
            orders[orderIndex].customerPhone = phone;
            
            if (name !== 'Khách lẻ') {
                if (btnElement) {
                    const row = btnElement.closest('tr');
                    const code = row.children[0].textContent.trim();
                    orders[orderIndex].customerCode = code;
                    
                    let defAddr = null;
                    if (customerAddressesMap[code] && customerAddressesMap[code].length > 0) {
                        defAddr = customerAddressesMap[code].find(a => a.isDefault);
                        if (!defAddr) defAddr = customerAddressesMap[code][0];
                    }
                    
                    if (defAddr) {
                        orders[orderIndex].recipientName = defAddr.name;
                        orders[orderIndex].deliveryPhone = defAddr.phone;
                        orders[orderIndex].province = defAddr.prov;
                        orders[orderIndex].district = defAddr.dist;
                        orders[orderIndex].ward = defAddr.ward;
                        orders[orderIndex].deliveryAddress = defAddr.detail;
                    } else {
                        orders[orderIndex].recipientName = name;
                        orders[orderIndex].deliveryPhone = phone;
                        orders[orderIndex].province = row.getAttribute('data-prov') || '';
                        orders[orderIndex].district = row.getAttribute('data-dist') || '';
                        orders[orderIndex].ward = row.getAttribute('data-ward') || '';
                        orders[orderIndex].deliveryAddress = row.getAttribute('data-detail') || '';
                    }
                }
            } else {
                orders[orderIndex].customerCode = '';
                orders[orderIndex].recipientName = 'Khách lẻ';
                orders[orderIndex].deliveryPhone = '';
                orders[orderIndex].province = '';
                orders[orderIndex].district = '';
                orders[orderIndex].ward = '';
                orders[orderIndex].deliveryAddress = '';
            }
            saveOrdersToStorage();
        }
        
        renderCheckoutState();
        closeCustomerModal();
    }
    
    // --- Address Selection Modal ---
    function openAddressSelectionModal() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        if (!order.customerCode || !customerAddressesMap[order.customerCode] || customerAddressesMap[order.customerCode].length === 0) {
            alert('Khách hàng này không có địa chỉ nào khác để chọn!');
            return;
        }
        
        const addresses = customerAddressesMap[order.customerCode];
        const tbody = document.getElementById('addressSelectionTableBody');
        tbody.innerHTML = '';
        
        addresses.forEach((addr, idx) => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>
                    <div style="font-weight: 600;">\${addr.name}</div>
                    \${addr.isDefault ? '<div style="color:red; font-size: 12px; margin-top: 2px;">(Mặc định)</div>' : ''}
                </td>
                <td>\${addr.phone}</td>
                <td>\${addr.fullAddr}</td>
                <td><button class="btn-add-variant" onclick="selectAddressFromModal(\${idx})">Chọn</button></td>
            `;
            tbody.appendChild(tr);
        });
        
        document.getElementById('addressSelectionModalOverlay').classList.add('active');
    }
    
    function closeAddressSelectionModal() {
        document.getElementById('addressSelectionModalOverlay').classList.remove('active');
    }
    
    function selectAddressFromModal(index) {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        const addr = customerAddressesMap[order.customerCode][index];
        order.deliveryPhone = addr.phone;
        order.recipientName = addr.name;
        order.province = addr.prov;
        order.district = addr.dist;
        order.ward = addr.ward;
        order.deliveryAddress = addr.detail;
        
        saveOrdersToStorage();
        renderCheckoutState();
        closeAddressSelectionModal();
    }
    
    // --- Checkout State Management ---
    function handleCurrencyInput(input) {
        let val = input.value.replace(/\D/g, '');
        if (val) {
            input.value = parseInt(val, 10).toLocaleString('vi-VN');
        } else {
            input.value = '';
        }
        updateCheckoutState();
    }
    
    function updateTotals() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        let sumTotal = 0;
        if (order.items) {
            order.items.forEach(item => {
                sumTotal += (item.price * item.quantity);
            });
        }

        const select = document.getElementById('discountCodeInput');

        // --- SUGGESTION LOGIC ---
        if (select) {
            let maxPossibleDiscount = -1;
            let bestOptionIndices = [];

            for (let i = 1; i < select.options.length; i++) {
                let opt = select.options[i];
                if (!opt.hasAttribute('data-original-text')) {
                    opt.setAttribute('data-original-text', opt.text);
                }
                opt.text = opt.getAttribute('data-original-text');
                opt.style.backgroundColor = '';
                opt.style.color = '';
                opt.style.fontWeight = '';

                const type = parseInt(opt.getAttribute('data-type'));
                const value = parseFloat(opt.getAttribute('data-value'));
                const minOrder = parseFloat(opt.getAttribute('data-min'));
                const maxDiscountOpt = parseFloat(opt.getAttribute('data-max'));

                let possibleDiscount = 0;
                if (sumTotal > 0 && sumTotal >= minOrder) {
                    if (type === 1) {
                        possibleDiscount = value;
                    } else if (type === 0) {
                        possibleDiscount = sumTotal * (value / 100.0);
                        if (maxDiscountOpt > 0 && possibleDiscount > maxDiscountOpt) {
                            possibleDiscount = maxDiscountOpt;
                        }
                    }
                    if (possibleDiscount > sumTotal) {
                        possibleDiscount = sumTotal;
                    }
                }

                if (possibleDiscount > 0) {
                    if (possibleDiscount > maxPossibleDiscount) {
                        maxPossibleDiscount = possibleDiscount;
                        bestOptionIndices = [i];
                    } else if (possibleDiscount === maxPossibleDiscount) {
                        bestOptionIndices.push(i);
                    }
                }
            }

            if (maxPossibleDiscount > 0) {
                bestOptionIndices.forEach(idx => {
                    let bestOpt = select.options[idx];
                    bestOpt.text = bestOpt.getAttribute('data-original-text') + ' (Gợi ý)';
                    bestOpt.style.backgroundColor = '#e6f4ea';
                    bestOpt.style.color = '#137333';
                    bestOpt.style.fontWeight = 'bold';
                });
            }
        }
        // --- END SUGGESTION LOGIC ---

        // Cập nhật lại discount dựa trên tổng tiền hiện tại để đảm bảo luôn đúng % và điều kiện minOrder
        let discount = 0;
        if (order.discountCode && select) {
            let option = null;
            for (let i = 0; i < select.options.length; i++) {
                if (select.options[i].value === order.discountCode) {
                    option = select.options[i];
                    break;
                }
            }
            if (option) {
                const type = parseInt(option.getAttribute('data-type'));
                const value = parseFloat(option.getAttribute('data-value'));
                const minOrder = parseFloat(option.getAttribute('data-min'));
                const maxDiscount = parseFloat(option.getAttribute('data-max'));
                if (sumTotal > 0 && sumTotal >= minOrder) {
                    if (type === 1) { // VND
                        discount = value;
                    } else if (type === 0) { // %
                        discount = sumTotal * (value / 100.0);
                        if (maxDiscount > 0 && discount > maxDiscount) {
                            discount = maxDiscount;
                        }
                    }
                    if (discount > sumTotal) {
                        discount = sumTotal; // Không giảm quá tổng tiền hàng
                    }
                } else {
                    // Không đủ điều kiện nữa thì gỡ bỏ
                    order.discountCode = '';
                    if (select.value === option.value) select.value = '';
                }
            } else {
                order.discountCode = '';
            }
        }
        order.discountValue = discount.toString();

        document.getElementById('summaryTotalItems').textContent = sumTotal.toLocaleString('vi-VN') + ' đ';
        
        let shippingFee = order.isDelivery ? (parseFloat((order.shippingFee || '0').toString().replace(/\D/g, '')) || 0) : 0;
        
        document.getElementById('summaryDiscount').textContent = discount.toLocaleString('vi-VN') + ' đ';
        
        let finalTotal = sumTotal + shippingFee - discount;
        if (finalTotal < 0) finalTotal = 0;
        
        document.getElementById('summaryTotalPayment').textContent = finalTotal.toLocaleString('vi-VN') + ' đ';
        
        let customerPay = parseFloat((order.customerPay || '0').toString().replace(/\D/g, '')) || 0;
        let change = customerPay - finalTotal;
        const changeLabel = document.getElementById('summaryChangeLabel');
        const changeValue = document.getElementById('summaryChange');
        
        const customerPayRow = document.getElementById('customerPayRow');
        const summaryChangeRow = document.getElementById('summaryChangeRow');
        
        if (order.paymentMethod === 'TRANSFER') {
            customerPayRow.style.display = 'none';
            summaryChangeRow.style.display = 'none';
        } else {
            customerPayRow.style.display = 'flex';
            summaryChangeRow.style.display = 'flex';
            
            if (change >= 0) {
                changeLabel.textContent = "Tiền thừa";
                changeValue.textContent = change.toLocaleString('vi-VN') + ' đ';
                changeValue.className = "summary-value text-success";
            } else {
                changeLabel.textContent = "Tiền thiếu";
                changeValue.textContent = Math.abs(change).toLocaleString('vi-VN') + ' đ';
                changeValue.className = "summary-value text-danger";
            }
        }
    }

    function updateCheckoutState() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        order.isDelivery = document.getElementById('deliveryToggle').checked;
        const nameInput = document.getElementById('customerNameInput');
        if (nameInput) order.customerName = nameInput.value;
        const buyerPhone = document.getElementById('buyerPhoneInput');
        if (buyerPhone) order.customerPhone = buyerPhone.value;
        
        const recInput = document.getElementById('recipientNameInput');
        if (recInput) order.recipientName = recInput.value;
        
        order.deliveryPhone = document.getElementById('customerPhoneInput').value;
        order.deliveryAddress = document.getElementById('customerAddressInput').value;
        
        const isFixed = order.customerName && order.customerName.trim() !== '' && order.customerName !== 'Khách lẻ';
        if (!isFixed) {
            const pSel = document.getElementById('provinceSelect');
            const dSel = document.getElementById('districtSelect');
            const wSel = document.getElementById('wardSelect');
            order.province = pSel.options[pSel.selectedIndex] ? pSel.options[pSel.selectedIndex].text : '';
            order.district = dSel.options[dSel.selectedIndex] ? dSel.options[dSel.selectedIndex].text : '';
            order.ward = wSel.options[wSel.selectedIndex] ? wSel.options[wSel.selectedIndex].text : '';
            
            // Need to save codes somewhere if we want to restore the dropdowns later. 
            // For now, restoring might break if we only save text.
            order.provinceCode = pSel.value;
            order.districtCode = dSel.value;
            order.wardCode = wSel.value;
        }
        
        order.shippingFee = document.getElementById('shippingFeeInput').value;
        order.customerPay = document.getElementById('customerPayInput').value;
        order.discountCode = document.getElementById('discountCodeInput').value;
        order.note = document.getElementById('orderNoteInput').value;
        
        updateTotals();
        saveOrdersToStorage();
    }
    
    function renderCheckoutState() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) {
            document.getElementById('customerNameInput').value = 'Khách lẻ';
            document.getElementById('buyerPhoneInput').value = '';
            document.getElementById('recipientNameInput').value = '';
            document.getElementById('customerPhoneInput').value = '';
            document.getElementById('customerAddressInput').value = '';
            document.getElementById('shippingFeeInput').value = '';
            document.getElementById('customerPayInput').value = '';
            document.getElementById('discountCodeInput').value = '';
            document.getElementById('orderNoteInput').value = '';
            document.getElementById('summaryTotalItems').textContent = '0 đ';
            document.getElementById('summaryTotalPayment').textContent = '0 đ';
            document.getElementById('summaryChange').textContent = '0 đ';
            return;
        }
        const order = orders[orderIndex];
        
        const isFixedCustomer = order.customerName && order.customerName.trim() !== '' && order.customerName !== 'Khách lẻ';

        const nameInput = document.getElementById('customerNameInput');
        if (nameInput) {
            nameInput.value = order.customerName || 'Khách lẻ';
            if (isFixedCustomer) {
                nameInput.setAttribute('readonly', true);
                nameInput.style.backgroundColor = '#f3f4f6'; // Thêm màu nền xám để biểu thị không sửa được
            } else {
                nameInput.removeAttribute('readonly');
                nameInput.style.backgroundColor = '';
            }
        }
        
        const buyerPhoneInput = document.getElementById('buyerPhoneInput');
        if (buyerPhoneInput) {
            buyerPhoneInput.value = order.customerPhone || '';
            if (isFixedCustomer) {
                buyerPhoneInput.setAttribute('readonly', true);
                buyerPhoneInput.style.backgroundColor = '#f3f4f6';
            } else {
                buyerPhoneInput.removeAttribute('readonly');
                buyerPhoneInput.style.backgroundColor = '';
            }
        }
        
        const recInput = document.getElementById('recipientNameInput');
        if (recInput) {
            recInput.value = order.recipientName || order.customerName || '';
            if (isFixedCustomer) {
                recInput.setAttribute('readonly', true);
                recInput.style.backgroundColor = '#f3f4f6';
            } else {
                recInput.removeAttribute('readonly');
                recInput.style.backgroundColor = '';
            }
        }
        
        const phoneInput = document.getElementById('customerPhoneInput');
        if (phoneInput) {
            phoneInput.value = order.deliveryPhone || '';
            if (isFixedCustomer) {
                phoneInput.setAttribute('readonly', true);
                phoneInput.style.backgroundColor = '#f3f4f6';
            } else {
                phoneInput.removeAttribute('readonly');
                phoneInput.style.backgroundColor = '';
            }
        }
        
        if (order.paymentMethod === 'TRANSFER') {
            document.getElementById('btnPayTransfer').classList.add('active');
            document.getElementById('btnPayCash').classList.remove('active');
        } else {
            document.getElementById('btnPayCash').classList.add('active');
            document.getElementById('btnPayTransfer').classList.remove('active');
        }
        
        const toggle = document.getElementById('deliveryToggle');
        toggle.checked = !!order.isDelivery;
        
        const isFixed = order.customerName && order.customerName !== 'Khách lẻ';
        
        const isDelivery = toggle.checked;
        document.getElementById('deliveryLabel').textContent = isDelivery ? "Giao hàng" : "Tại quầy";

        const shippingInput = document.getElementById('shippingFeeInput');
        if (isDelivery) {
            document.getElementById('btnChooseAddress').style.display = 'inline-block';
            document.getElementById('deliveryHintText').style.display = 'none';
            document.getElementById('deliveryForm').style.display = 'flex';
            shippingInput.removeAttribute('readonly');
            shippingInput.style.backgroundColor = '';
            shippingInput.style.color = '';
        } else {
            document.getElementById('btnChooseAddress').style.display = 'none';
            document.getElementById('deliveryHintText').style.display = 'block';
            document.getElementById('deliveryForm').style.display = 'none';
            shippingInput.setAttribute('readonly', true);
            shippingInput.style.backgroundColor = '#f3f4f6';
            shippingInput.style.color = '#94a3b8';
            if (!isDelivery) shippingInput.value = '';
        }
        
        document.getElementById('customerPhoneInput').value = order.deliveryPhone || '';
        document.getElementById('customerAddressInput').value = order.deliveryAddress || '';
        
        // Handle fixed fields for DB customers
        const pInput = document.getElementById('customerPhoneInput');
        const aInput = document.getElementById('customerAddressInput');
        const apiBlock = document.getElementById('apiAddressComboboxes');
        const fixedBlock = document.getElementById('fixedAddressInputs');
        
        if (isFixed) {
            pInput.setAttribute('readonly', 'readonly');
            aInput.setAttribute('readonly', 'readonly');
            
            apiBlock.style.display = 'none';
            fixedBlock.style.display = 'flex';
            
            document.getElementById('provinceFixed').value = order.province || '';
            document.getElementById('districtFixed').value = order.district || '';
            document.getElementById('wardFixed').value = order.ward || '';
        } else {
            pInput.removeAttribute('readonly');
            aInput.removeAttribute('readonly');
            
            apiBlock.style.display = 'flex';
            fixedBlock.style.display = 'none';
            
            document.getElementById('provinceSelect').value = order.provinceCode || '';
            
            if (order.provinceCode) {
                fetch(`https://provinces.open-api.vn/api/p/\${order.provinceCode}?depth=2`)
                    .then(res => res.json())
                    .then(data => {
                        const select = document.getElementById('districtSelect');
                        select.innerHTML = '<option value="">Chọn Quận/Huyện...</option>';
                        if (data && data.districts) {
                            data.districts.forEach(d => {
                                const opt = document.createElement('option');
                                opt.value = d.code;
                                opt.text = d.name;
                                select.appendChild(opt);
                            });
                        }
                        select.value = order.districtCode || '';
                        
                        if (order.districtCode) {
                            fetch(`https://provinces.open-api.vn/api/d/\${order.districtCode}?depth=2`)
                                .then(res => res.json())
                                .then(data2 => {
                                    const wSelect = document.getElementById('wardSelect');
                                    wSelect.innerHTML = '<option value="">Chọn Xã/Phường...</option>';
                                    if (data2 && data2.wards) {
                                        data2.wards.forEach(w => {
                                            const opt = document.createElement('option');
                                            opt.value = w.code;
                                            opt.text = w.name;
                                            wSelect.appendChild(opt);
                                        });
                                    }
                                    wSelect.value = order.wardCode || '';
                                })
                                .catch(err => console.error(err));
                        } else {
                            document.getElementById('wardSelect').innerHTML = '<option value="">Chọn Xã/Phường...</option>';
                        }
                    })
                    .catch(err => console.error(err));
            } else {
                document.getElementById('districtSelect').innerHTML = '<option value="">Chọn Quận/Huyện...</option>';
                document.getElementById('wardSelect').innerHTML = '<option value="">Chọn Xã/Phường...</option>';
            }
        }
        
        document.getElementById('shippingFeeInput').value = order.shippingFee || '';
        document.getElementById('customerPayInput').value = order.customerPay || '';
        document.getElementById('discountCodeInput').value = order.discountCode || '';
        document.getElementById('orderNoteInput').value = order.note || '';

    }
    
    function applyDiscountSelect() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        let sumTotal = 0;
        if (order.items) {
            order.items.forEach(item => {
                sumTotal += (item.price * item.quantity);
            });
        }
        
        const select = document.getElementById('discountCodeInput');
        const option = select.options[select.selectedIndex];
        
        if (!option.value) {
            order.discountCode = '';
            order.discountValue = '0';
            updateTotals();
            saveOrdersToStorage();
            return;
        }
        
        if (sumTotal === 0) {
            alert('Giỏ hàng đang trống, không thể áp dụng mã giảm giá!');
            select.value = '';
            order.discountCode = '';
            order.discountValue = '0';
            updateTotals();
            saveOrdersToStorage();
            return;
        }
        
        const type = parseInt(option.getAttribute('data-type'));
        const value = parseFloat(option.getAttribute('data-value'));
        const minOrder = parseFloat(option.getAttribute('data-min'));
        const maxDiscount = parseFloat(option.getAttribute('data-max'));
        
        if (sumTotal < minOrder) {
            alert('Đơn hàng chưa đạt giá trị tối thiểu ' + minOrder.toLocaleString('vi-VN') + ' đ để áp dụng mã này!');
            select.value = '';
            order.discountCode = '';
            order.discountValue = '0';
            updateTotals();
            saveOrdersToStorage();
            return;
        }
        
        let discountAmt = 0;
        if (type === 1) { // VND
            discountAmt = value;
        } else if (type === 0) { // %
            discountAmt = sumTotal * (value / 100.0);
            if (maxDiscount > 0 && discountAmt > maxDiscount) {
                discountAmt = maxDiscount;
            }
        }
        
        if (discountAmt > sumTotal) {
            discountAmt = sumTotal; // Không giảm quá tổng tiền hàng
        }
        
        order.discountCode = option.value;
        order.discountValue = discountAmt.toString();
        
        updateTotals();
        saveOrdersToStorage();
    }
    
    async function updateItemQty(code, change) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        const item = order.items.find(i => i.code === code);
        if (!item) return;
        
        let newQty = item.quantity + change;
        if (newQty > 0) {
            if (change > 0 && getAvailableStock(code) < change) {
                alert("Số lượng vượt quá tồn kho hiện có!");
                return;
            }

            try {
                const fd = new URLSearchParams();
                fd.append('invoiceId', currentOrderId);
                fd.append('variantCode', code);
                fd.append('quantity', newQty);
                fd.append('variantName', item.name);
                fd.append('price', item.price);
                fd.append('colorSize', item.color + ' - ' + item.size);

                const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/update-item'), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: fd.toString()
                });
                const data = await res.json();
                if (data && data.success) {
                    item.quantity = newQty;

                    const row = document.querySelector(`.variant-row[data-code="` + code.replace(/"/g, '\\"') + `"]`);
                    if (row) {
                        const currentStock = parseInt(row.getAttribute('data-stock')) || 0;
                        row.setAttribute('data-stock', currentStock - change);
                        const stockCell = row.querySelector('.pos-stock-td');
                        if (stockCell) stockCell.textContent = currentStock - change;
                    }

                    renderCurrentOrderItems();
                    updateAvailableStockDisplay();
                } else {
                    alert("Lỗi: " + (data.message || 'Không thể cập nhật số lượng'));
                }
            } catch (e) {
                console.error(e);
            }
        }
    }
    
    async function setItemQty(code, value) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        const item = order.items.find(i => i.code === code);
        if (!item) return;
        
        let val = parseInt(value) || 1;
        if (val < 1) val = 1;
        
        let diff = val - item.quantity;
        if (diff > 0 && getAvailableStock(code) < diff) {
            alert("Số lượng vượt quá tồn kho hiện có!");
            val = item.quantity + getAvailableStock(code);
            diff = val - item.quantity;
            if (diff === 0) {
                renderCurrentOrderItems();
                return;
            }
        }

        try {
            const fd = new URLSearchParams();
            fd.append('invoiceId', currentOrderId);
            fd.append('variantCode', code);
            fd.append('quantity', val);
            fd.append('variantName', item.name);
            fd.append('price', item.price);
            fd.append('colorSize', item.color + ' - ' + item.size);

            const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/update-item'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: fd.toString()
            });
            const data = await res.json();
            if (data && data.success) {
                item.quantity = val;

                const row = document.querySelector(`.variant-row[data-code="` + code.replace(/"/g, '\\"') + `"]`);
                if (row) {
                    const currentStock = parseInt(row.getAttribute('data-stock')) || 0;
                    row.setAttribute('data-stock', currentStock - diff);
                    const stockCell = row.querySelector('.pos-stock-td');
                    if (stockCell) stockCell.textContent = currentStock - diff;
                }

                renderCurrentOrderItems();
                updateAvailableStockDisplay();
            } else {
                alert("Lỗi: " + (data.message || 'Không thể cập nhật số lượng'));
                renderCurrentOrderItems();
            }
        } catch (e) {
            console.error(e);
            renderCurrentOrderItems();
        }
    }
    
    async function removeItem(code) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        const item = order.items.find(i => i.code === code);
        if (!item) return;

        try {
            const fd = new URLSearchParams();
            fd.append('invoiceId', currentOrderId);
            fd.append('variantCode', code);

            const res = await fetch(window.location.pathname.replace('/pos', '/pos/api/remove-item'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: fd.toString()
            });
            const data = await res.json();
            if (data && data.success) {
                order.items = order.items.filter(i => i.code !== code);

                const row = document.querySelector(`.variant-row[data-code="` + code.replace(/"/g, '\\"') + `"]`);
                if (row) {
                    const currentStock = parseInt(row.getAttribute('data-stock')) || 0;
                    row.setAttribute('data-stock', currentStock + item.quantity);
                    const stockCell = row.querySelector('.pos-stock-td');
                    if (stockCell) stockCell.textContent = currentStock + item.quantity;
                }

                renderCurrentOrderItems();
                updateAvailableStockDisplay();
            } else {
                alert("Lỗi: " + (data.message || 'Không thể xóa sản phẩm'));
            }
        } catch (e) {
            console.error(e);
        }
    }
    
    // --- QR and Success Modals ---
    function setPaymentMethod(method) {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        order.paymentMethod = method;
        
        if (method === 'TRANSFER') {
            openQrModal(order);
        }
        
        renderCheckoutState();
        updateTotals();
        saveOrdersToStorage();
    }
    
    function openQrModal(order) {
        let sumTotal = 0;
        if (order.items) {
            order.items.forEach(item => {
                sumTotal += (item.price * item.quantity);
            });
        }
        let discount = parseFloat((order.discountValue || '0').toString().replace(/\D/g, '')) || 0;
        let shippingFee = order.isDelivery ? (parseFloat((order.shippingFee || '0').toString().replace(/\D/g, '')) || 0) : 0;
        let finalTotal = sumTotal + shippingFee - discount;
        if (finalTotal < 0) finalTotal = 0;
        
        document.getElementById('qrAmountDisplay').textContent = finalTotal.toLocaleString('vi-VN') + ' đ';
        
        // Sử dụng ảnh tĩnh mã QR người dùng yêu cầu
        const qrUrl = `\${window.location.origin}${pageContext.request.contextPath}/assets/img/my-qr.jpg`;
        
        document.getElementById('qrImage').src = qrUrl;
        document.getElementById('qrModal').classList.add('active');
    }

    function closeQrModal() {
        document.getElementById('qrModal').classList.remove('active');
    }

    function demoSuccessfulTransfer() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        let sumTotal = 0;
        if (order.items) {
            order.items.forEach(item => {
                sumTotal += (item.price * item.quantity);
            });
        }
        let discount = parseFloat((order.discountValue || '0').toString().replace(/\D/g, '')) || 0;
        let shippingFee = order.isDelivery ? (parseFloat((order.shippingFee || '0').toString().replace(/\D/g, '')) || 0) : 0;
        let finalTotal = sumTotal + shippingFee - discount;
        if (finalTotal < 0) finalTotal = 0;
        
        order.customerPay = finalTotal;
        
        closeQrModal();
        renderCheckoutState();
        updateTotals();
        saveOrdersToStorage();
        
        checkoutAjax(order, finalTotal);
    }
    
    function openSuccessInvoiceModal(order, finalTotal, invoiceCode) {
        document.getElementById('invoiceSuccessCode').textContent = invoiceCode || '---';
        document.getElementById('invoiceCustomerName').textContent = order.customerName || 'Khách lẻ';
        document.getElementById('invoiceBuyerPhone').textContent = order.customerPhone || '---';
        
        document.getElementById('invoiceTotalAmount').textContent = finalTotal.toLocaleString('vi-VN') + ' đ';
        
        const methodStr = (order.paymentMethod === 'CASH') ? 'Tiền mặt' : 'Chuyển khoản';
        document.getElementById('invoicePaymentMethod').textContent = methodStr;
        
        const deliverySection = document.getElementById('invoiceDeliverySection');
        if (order.isDelivery) {
            deliverySection.style.display = 'block';
            
            document.getElementById('invoiceRecipientName').textContent = order.recipientName || order.customerName || '---';
            document.getElementById('invoiceRecipientPhone').textContent = order.deliveryPhone || '---';
            
            let addrParts = [];
            if (order.deliveryAddress && order.deliveryAddress.trim() !== '') addrParts.push(order.deliveryAddress);
            if (order.ward) {
                const wOpt = document.querySelector(`#wardSelect option[value="\${order.ward}"]`);
                if(wOpt && wOpt.text && !wOpt.text.includes('Chọn')) {
                    addrParts.push(wOpt.text);
                } else {
                    addrParts.push(order.ward);
                }
            }
            if (order.district) {
                const dOpt = document.querySelector(`#districtSelect option[value="\${order.district}"]`);
                if(dOpt && dOpt.text && !dOpt.text.includes('Chọn')) {
                    addrParts.push(dOpt.text);
                } else {
                    addrParts.push(order.district);
                }
            }
            if (order.province) {
                const pOpt = document.querySelector(`#provinceSelect option[value="\${order.province}"]`);
                if(pOpt && pOpt.text && !pOpt.text.includes('Chọn')) {
                    addrParts.push(pOpt.text);
                } else {
                    addrParts.push(order.province);
                }
            }
            
            document.getElementById('invoiceCustomerAddress').textContent = addrParts.length > 0 ? addrParts.join(', ') : '---';
        } else {
            deliverySection.style.display = 'none';
        }
        
        const tbody = document.getElementById('invoiceProductList');
        tbody.innerHTML = '';
        if (order.items && order.items.length > 0) {
            order.items.forEach(item => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="padding: 8px; border-bottom: 1px solid #f1f5f9;">
                        <div>\${item.name}</div>
                        <div style="font-size: 12px; color: #64748b;">\${item.productCode ? item.productCode + ' &bull; ' : ''}\${item.code} &bull; \${item.color} &bull; \${item.size}</div>
                    </td>
                    <td style="padding: 8px; border-bottom: 1px solid #f1f5f9; text-align: center;">\${item.quantity}</td>
                    <td style="padding: 8px; border-bottom: 1px solid #f1f5f9; text-align: right;">\${item.price.toLocaleString('vi-VN')} đ</td>
                    <td style="padding: 8px; border-bottom: 1px solid #f1f5f9; text-align: right;">\${(item.price * item.quantity).toLocaleString('vi-VN')} đ</td>
                `;
                tbody.appendChild(tr);
            });
        }
        
        document.getElementById('invoiceModal').classList.add('active');
    }
    
    function confirmOrder() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        if (!order.items || order.items.length === 0) {
            alert("Vui lòng thêm sản phẩm vào hóa đơn trước khi xác nhận!");
            return;
        }
        
        if (!order.customerName || order.customerName.trim() === '') {
            order.customerName = 'Khách lẻ';
        }
        
        const phoneRegex = /(84|0[3|5|7|8|9])+([0-9]{8})\b/;
        const bError = document.getElementById('buyerPhoneError');
        if (!order.customerPhone || order.customerPhone.trim() === '') {
            bError.textContent = "Vui lòng nhập số điện thoại khách hàng!";
            bError.style.display = 'block';
            document.getElementById('buyerPhoneInput').focus();
            return;
        }
        
        if (!phoneRegex.test(order.customerPhone.trim())) {
            bError.textContent = "Số điện thoại không hợp lệ (VD: 0912345678)!";
            bError.style.display = 'block';
            document.getElementById('buyerPhoneInput').focus();
            return;
        }
        
        if (order.isDelivery) {
            const dError = document.getElementById('deliveryPhoneError');
            if (!order.deliveryPhone || order.deliveryPhone.trim() === '') {
                dError.textContent = "Vui lòng nhập số điện thoại người nhận!";
                dError.style.display = 'block';
                document.getElementById('customerPhoneInput').focus();
                return;
            }
            if (!phoneRegex.test(order.deliveryPhone.trim())) {
                dError.textContent = "Số điện thoại không hợp lệ (VD: 0912345678)!";
                dError.style.display = 'block';
                document.getElementById('customerPhoneInput').focus();
                return;
            }
            if (!order.deliveryAddress || order.deliveryAddress.trim() === '') {
                alert("Vui lòng nhập địa chỉ cụ thể người nhận!");
                return;
            }
        }
        
        if (order.paymentMethod === 'TRANSFER') {
            openQrModal(order);
        } else {
            // Thanh toán tiền mặt
            let sumTotal = 0;
            order.items.forEach(item => { sumTotal += (item.price * item.quantity); });
            let discount = parseFloat((order.discountValue || '0').toString().replace(/\D/g, '')) || 0;
            let shippingFee = order.isDelivery ? (parseFloat((order.shippingFee || '0').toString().replace(/\D/g, '')) || 0) : 0;
            let finalTotal = sumTotal + shippingFee - discount;
            if (finalTotal < 0) finalTotal = 0;
            
            let customerPay = parseFloat((order.customerPay || '0').toString().replace(/\D/g, '')) || 0;
            if (customerPay < finalTotal) {
                alert("Khách thanh toán chưa đủ số tiền!");
                return;
            }
            
            checkoutAjax(order, finalTotal);
        }
    }
    let isCheckingOut = false;
    
    function checkoutAjax(order, finalTotal) {
        if (isCheckingOut) return;
        isCheckingOut = true;
        
        fetch(`\${window.location.origin}${pageContext.request.contextPath}/admin/pos/checkout`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(order)
        })
        .then(res => res.json())
        .then(data => {
            isCheckingOut = false;
            if (data.success) {
                openSuccessInvoiceModal(order, finalTotal, data.invoiceCode);
                // Clear order after success
                orders.splice(orders.findIndex(o => o.id === order.id), 1);
                if (orders.length === 0) createOrder();
                else switchOrder(orders[0].id);
                saveOrdersToStorage();
            } else {
                alert("Lỗi thanh toán: " + data.message);
            }
        })
        .catch(err => {
            isCheckingOut = false;
            console.error(err);
            alert("Lỗi kết nối máy chủ!");
        });
    }

    
    function closeInvoiceModal() {
        document.getElementById('invoiceModal').classList.remove('active');
        window.location.reload();
    }

    // Initialize
    window.addEventListener('DOMContentLoaded', initPOS);
    
</script>

<!-- Modal QR Code -->
<div class="pos-modal-overlay" id="qrModal">
    <div class="pos-modal" style="width: 400px; text-align: center; padding: 20px; position: relative;">
        <button type="button" onclick="closeQrModal()" style="position: absolute; top: 10px; right: 15px; background: none; border: none; font-size: 20px; cursor: pointer; color: #64748b;">&times;</button>
        <h3 style="margin-top: 0;">Quét mã thanh toán</h3>
        <p style="color: #64748b; font-size: 14px;">Mở ứng dụng ngân hàng và quét mã QR dưới đây</p>
        <div style="margin: 20px 0;">
            <img id="qrImage" src="" alt="QR Code" style="width: 250px; height: 250px; object-fit: contain; border: 1px solid #e2e8f0; border-radius: 8px;">
        </div>
        <p style="font-weight: bold; font-size: 20px; color: #b91c1c; margin-bottom: 20px;" id="qrAmountDisplay">0 đ</p>
        <button class="btn-outline-primary" style="width: 100%; background: #22c55e; color: white; border-color: #22c55e; padding: 10px; border-radius: 8px; font-weight: bold;" onclick="demoSuccessfulTransfer()">Demo chuyển khoản thành công</button>
    </div>
</div>

<!-- Invoice/Success Modal -->
<div class="pos-modal-overlay" id="invoiceModal">
    <div class="pos-modal" style="width: 600px; padding: 25px; position: relative;">
        <button type="button" onclick="closeInvoiceModal()" style="position: absolute; top: 10px; right: 15px; background: none; border: none; font-size: 20px; cursor: pointer; color: #64748b;">&times;</button>
        <div style="text-align: center; margin-bottom: 20px;">
            <i class="fa-solid fa-circle-check" style="color: #22c55e; font-size: 48px; margin-bottom: 10px;"></i>
            <h3 style="margin: 0; color: #16a34a;">Thanh toán thành công</h3>
            <div style="margin-top: 10px; font-size: 16px;">
                <strong style="color: #475569;">Mã hóa đơn:</strong> 
                <span id="invoiceSuccessCode" style="font-weight: bold; color: #b91c1c; font-size: 18px;">---</span>
            </div>
        </div>
        
        <div style="background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; display: flex; flex-direction: column; gap: 10px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                <div><strong style="color: #475569;">Người mua:</strong> <span id="invoiceCustomerName">Khách lẻ</span></div>
                <div><strong style="color: #475569;">SĐT:</strong> <span id="invoiceBuyerPhone">---</span></div>
            </div>
            
            <div id="invoiceDeliverySection" style="display: none; border-top: 1px dashed #cbd5e1; padding-top: 10px; margin-top: 5px;">
                <strong style="color: #475569; display: block; margin-bottom: 5px;">Thông tin nhận hàng:</strong>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 5px;">
                    <div><span style="color: #64748b; font-size: 13px;">Người nhận:</span> <span id="invoiceRecipientName">---</span></div>
                    <div><span style="color: #64748b; font-size: 13px;">SĐT nhận:</span> <span id="invoiceRecipientPhone">---</span></div>
                </div>
                <div><span style="color: #64748b; font-size: 13px;">Địa chỉ:</span> <span id="invoiceCustomerAddress">---</span></div>
            </div>
            
            <div style="border-top: 1px dashed #cbd5e1; padding-top: 10px; margin-top: 5px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                <div><strong style="color: #475569;">Hình thức:</strong> <span id="invoicePaymentMethod">Chuyển khoản</span></div>
                <div><strong style="color: #475569;">Trạng thái:</strong> <span style="color: #16a34a; font-weight: bold;">Đã thanh toán</span></div>
            </div>
        </div>
        
        <div style="margin-bottom: 20px; max-height: 250px; overflow-y: auto;">
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f1f5f9; color: #475569;">
                        <th style="padding: 10px; text-align: left;">Sản phẩm</th>
                        <th style="padding: 10px; text-align: center;">SL</th>
                        <th style="padding: 10px; text-align: right;">Đơn giá</th>
                        <th style="padding: 10px; text-align: right;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody id="invoiceProductList">
                </tbody>
            </table>
        </div>
        
        <div style="border-top: 1px dashed #cbd5e1; padding-top: 15px; display: flex; justify-content: space-between; align-items: center;">
            <strong style="font-size: 16px;">Tổng cộng:</strong>
            <strong style="font-size: 20px; color: #b91c1c;" id="invoiceTotalAmount">0 đ</strong>
        </div>
        
        <button class="btn-outline-primary" style="width: 100%; margin-top: 25px; background: #3b82f6; color: white; border-color: #3b82f6; padding: 10px; border-radius: 8px; font-weight: bold;" onclick="closeInvoiceModal()">Đóng</button>
    </div>
</div>

<!-- Custom Alert Modal -->
<div class="pos-modal-overlay" id="customAlertModal" style="z-index: 10000;">
    <div class="pos-modal" style="width: 400px; text-align: center; padding: 24px; position: relative;">
        <h3 style="margin-bottom: 16px; font-size: 18px; color: #1e293b;">Thông báo</h3>
        <p id="customAlertMessage" style="color: #475569; margin-bottom: 24px; font-size: 14px; line-height: 1.5;"></p>
        <button class="btn-primary" onclick="closeCustomAlert()" style="padding: 8px 24px; display: flex; align-items: center; justify-content: center; margin: 0 auto;">Đóng</button>
    </div>
</div>

<!-- Custom Confirm Modal -->
<div class="pos-modal-overlay" id="customConfirmModal" style="z-index: 10000;">
    <div class="pos-modal" style="width: 400px; text-align: center; padding: 24px; position: relative;">
        <h3 style="margin-bottom: 16px; font-size: 18px; color: #1e293b;">Xác nhận</h3>
        <p id="customConfirmMessage" style="color: #475569; margin-bottom: 24px; font-size: 14px; line-height: 1.5;"></p>
        <div style="display: flex; gap: 12px; justify-content: center;">
            <button class="btn-outline-primary" onclick="closeCustomConfirm(false)" style="padding: 8px 24px;">Hủy</button>
            <button class="btn-primary" onclick="closeCustomConfirm(true)" style="padding: 8px 24px; background: #E11D48; border-color: #E11D48;">Đồng ý</button>
        </div>
    </div>
</div>

<script>
    function showCustomAlert(message) {
        document.getElementById('customAlertMessage').textContent = message;
        document.getElementById('customAlertModal').classList.add('active');
    }

    function closeCustomAlert() {
        document.getElementById('customAlertModal').classList.remove('active');
    }

    let confirmCallback = null;
    function showCustomConfirm(message, callback) {
        document.getElementById('customConfirmMessage').textContent = message;
        confirmCallback = callback;
        document.getElementById('customConfirmModal').classList.add('active');
    }

    function closeCustomConfirm(result) {
        document.getElementById('customConfirmModal').classList.remove('active');
        if (confirmCallback) {
            confirmCallback(result);
            confirmCallback = null;
        }
    }
    
    function getDbStock(variantCode) {
        const row = document.querySelector('.variant-row[data-code="' + variantCode.replace(/"/g, '\\"') + '"]');
        if (row) {
            return parseInt(row.getAttribute('data-stock')) || 0;
        }
        let fallbackStock = 0;
        orders.forEach(o => {
            if (o.items) {
                o.items.forEach(i => {
                    if (i.code === variantCode && i.stock) fallbackStock = i.stock;
                });
            }
        });
        return fallbackStock;
    }

    function getAvailableStock(variantCode) {
        return getDbStock(variantCode);
    }

    function updateAvailableStockDisplay() {
        const rows = document.querySelectorAll('.variant-row');
        rows.forEach(row => {
            const code = row.getAttribute('data-code');
            const available = getAvailableStock(code);
            // Dùng class 'td-stock' để chọn chính xác cột Số lượng, tránh lỗi index cứng
            const stockTd = row.querySelector('.td-stock');
            if (stockTd) {
                stockTd.textContent = available;
            }
        });
    }

    // Override default alert globally in this page to catch all alerts
    window.alert = showCustomAlert;
</script>

<!-- Modal Scanner Camera -->
<div id="qrCameraModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 2000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div style="background: #ffffff; border-radius: 12px; width: 90%; max-width: 600px; padding: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); display: flex; flex-direction: column; align-items: center; position: relative;">
        <h3 style="margin-top: 0; color: #1e293b; font-size: 16px;">Đưa mã vạch vào khung hình</h3>
        <div id="qrReader" style="width: 100%; max-width: 550px; border-radius: 8px; overflow: hidden; border: 2px solid #e2e8f0;"></div>
        <div style="margin-top: 20px; display: flex; gap: 10px; width: 100%;">
            <button id="btnToggleTorch" onclick="toggleTorch()" style="flex: 1; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; background: #fef9c3; color: #854d0e; font-weight: 600; cursor: pointer;">🔦 Bật Đèn</button>
            <button onclick="stopCameraScan()" style="flex: 1; padding: 10px; border: none; border-radius: 8px; background: #ef4444; color: #ffffff; font-weight: 600; cursor: pointer;">Đóng</button>
        </div>
    </div>
</div>

<script src="https://unpkg.com/html5-qrcode"></script>
<script>
    let html5QrCode = null;
    let isScannerRunning = false;
    let torchOn = false;

    function startCameraScan() {
        if (!currentOrderId) {
            showCustomAlert('Vui lòng tạo đơn hàng trước khi quét sản phẩm!');
            return;
        }

        if (isScannerRunning) return;

        const modal = document.getElementById('qrCameraModal');
        modal.style.display = 'flex';

        html5QrCode = new Html5Qrcode("qrReader");

        const config = {
            fps: 10,
            qrbox: { width: 450, height: 250 },
            aspectRatio: 1.0,
            experimentalFeatures: {
                useBarCodeDetectorIfSupported: true
            },
            rememberLastUsedCamera: false
        };

        const onScanSuccess = (decodedText) => {
            stopCameraScan();
            // Tận dụng hàm addVariantToOrder đã có sẵn trong pos.jsp
            addVariantToOrder(decodedText);
        };

        html5QrCode.start({ facingMode: "environment" }, config, onScanSuccess, () => {})
        .then(() => {
            isScannerRunning = true;
        })
        .catch(() => {
            // Nếu camera sau lỗi thì dùng camera trước
            html5QrCode.start({ facingMode: "user" }, config, onScanSuccess, () => {})
            .then(() => {
                isScannerRunning = true;
            })
            .catch((err) => {
                console.error("Không mở được camera:", err);
                modal.style.display = 'none';
                showCustomAlert('Không thể mở Camera. Vui lòng kiểm tra quyền truy cập.');
            });
        });
    }

    async function toggleTorch() {
        if (!html5QrCode) return;
        try {
            torchOn = !torchOn;
            await html5QrCode.applyVideoConstraints({ advanced: [{ torch: torchOn }] });
            const btn = document.getElementById('btnToggleTorch');
            btn.textContent = torchOn ? '🔦 Tắt Đèn' : '🔦 Bật Đèn';
            btn.style.background = torchOn ? '#fde047' : '#fef9c3';
        } catch(e) { console.log('Torch not supported'); }
    }

    function stopCameraScan() {
        const modal = document.getElementById('qrCameraModal');
        modal.style.display = 'none';
        isScannerRunning = false;

        if (html5QrCode) {
            const instance = html5QrCode;
            html5QrCode = null;
            instance.stop()
            .then(() => instance.clear())
            .catch(() => {
                try { instance.clear(); } catch(e) {}
            });
        }
    }
</script>

</body>
</html>
