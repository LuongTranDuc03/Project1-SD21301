<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=1.1">
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
                <span>FamiCoats Admin</span> / <span class="active-crumb">Bán hàng tại quầy</span>
            </div>
            <div class="navbar-right">
                <button class="notif-btn">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                    <span class="notif-badge"></span>
                </button>
                <div class="date-pill"><%= project.duan1_sd21301.util.DateUtil.getCurrentDateString() %></div>
                <div class="profile-pill">
                    <span class="profile-avatar-mini">${sessionScope.employee != null ? sessionScope.employee.fullName.substring(0, 1).toUpperCase() : 'A'}</span>
                    <span>${sessionScope.employee != null ? sessionScope.employee.fullName : 'Admin'}</span>
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
                        <button class="btn-scan-qr">Quét QR sản phẩm</button>
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
                        <div class="pos-card-actions">
                            <button class="btn-outline-primary" onclick="openCustomerModal()"><i class="fa-solid fa-user-plus" style="margin-right: 5px;"></i> Chọn khách hàng</button>
                            <button class="btn-outline-primary" id="btnChooseAddress" style="display: none;">Chọn địa chỉ</button>
                        </div>
                    </div>
                    
                    <div class="customer-info-basic">
                        <div class="info-row">
                            <span class="info-label">Tên khách hàng:</span>
                            <span class="info-value" id="customerNameDisplay">Khách lẻ</span>
                        </div>
                        <p class="text-muted" id="deliveryHintText">Tại quầy: chỉ cần chọn sản phẩm và thanh toán.</p>
                    </div>
                    
                    <div class="customer-address-form" id="deliveryForm" style="display: none;">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="customerPhoneInput" placeholder="Nhập số điện thoại..." oninput="updateCheckoutState()">
                            </div>
                            <div class="form-group">
                                <label>Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="customerAddressInput" placeholder="Số nhà, ngõ, đường..." oninput="updateCheckoutState()">
                            </div>
                        </div>
                        <!-- Block for Khách lẻ (API Comboboxes) -->
                        <div class="form-row three-cols" id="apiAddressComboboxes">
                            <div class="form-group">
                                <label>Tỉnh/Thành phố <span class="text-danger">*</span></label>
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
                        <div class="form-row three-cols" id="fixedAddressInputs" style="display: none;">
                            <div class="form-group">
                                <label>Tỉnh/Thành phố <span class="text-danger">*</span></label>
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
                            <div class="form-group" style="flex: 3;">
                                <label>Mã phiếu giảm giá</label>
                                <input type="text" class="form-control" id="discountCodeInput" placeholder="Nhập mã" oninput="updateCheckoutState()">
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label>Giá trị</label>
                                <input type="text" class="form-control" id="discountValueInput" placeholder="" oninput="updateCheckoutState()">
                            </div>
                        </div>
                    </div>
                    
                    <div class="payment-summary">
                        <div class="summary-row">
                            <span class="summary-label">Tiền hàng</span>
                            <span class="summary-value" id="summaryTotalItems">0 đ</span>
                        </div>
                        
                        <div class="summary-row shipping-row" id="shippingRow" style="display: none;">
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
                        
                        <div class="summary-row">
                            <span class="summary-label">Khách thanh toán <i class="fa-solid fa-money-bill-wave"></i></span>
                            <div class="customer-pay-input">
                                <input type="text" class="form-control text-right" id="customerPayInput" value="0" oninput="updateCheckoutState()">
                                <span>đ</span>
                            </div>
                        </div>
                        
                        <div class="summary-row">
                            <span class="summary-label" id="summaryChangeLabel">Tiền thiếu</span>
                            <span class="summary-value" id="summaryChange">0 đ</span>
                        </div>
                    </div>
                    
                    <button class="btn-confirm-order">XÁC NHẬN ĐẶT HÀNG</button>
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
                        List<String> colors = (List<String>) request.getAttribute("colors");
                        if (colors != null) {
                            for (String color : colors) {
                                if (color != null && !color.trim().isEmpty()) {
                        %>
                        <option value="<%= color %>"><%= color %></option>
                        <%      }
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
                        List<String> sizes = (List<String>) request.getAttribute("sizes");
                        if (sizes != null) {
                            for (String size : sizes) {
                                if (size != null && !size.trim().isEmpty()) {
                        %>
                        <option value="<%= size %>"><%= size %></option>
                        <%      }
                            }
                        }
                        %>
                    </select>
                </div>
                
                <div class="pos-filter-group">
                    <label class="pos-filter-label">Sản phẩm</label>
                    <select id="productFilter" class="pos-filter-select" onchange="filterVariants()">
                        <option value="">Tất cả sản phẩm</option>
                        <% 
                        List<Product> products = (List<Product>) request.getAttribute("products");
                        if (products != null) {
                            for (Product p : products) {
                        %>
                        <option value="<%= p.getName() %>"><%= p.getName() %></option>
                        <%  }
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
                            <th>Mã</th>
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
                        if (products != null) {
                            int stt = 1;
                            for (Product p : products) {
                                if (p.getDetails() != null) {
                                    for (ProductDetail v : p.getDetails()) {
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
                            data-name="<%= p.getName() != null ? p.getName() : "" %>" 
                            data-color="<%= v.getColor() != null ? v.getColor() : "" %>" 
                            data-size="<%= v.getSize() != null ? v.getSize() : "" %>"
                            data-price="<%= v.getPrice() %>"
                            data-stock="<%= v.getStock() %>"
                            data-image="<%= imageUrl %>">
                            <td><%= stt++ %></td>
                            <td style="font-weight: 600;"><%= v.getCode() %></td>
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
                            <td><%= v.getStock() %></td>
                            <td style="font-weight: 600; color: #7f1d1d;"><%= String.format("%,.0f đ", v.getPrice()) %></td>
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

    function saveOrdersToStorage() {
        localStorage.setItem('pos_orders', JSON.stringify(orders));
        if (currentOrderId) {
            localStorage.setItem('pos_current_order_id', currentOrderId);
        }
    }

    function initPOS() {
        const savedOrders = localStorage.getItem('pos_orders');
        if (savedOrders) {
            try {
                orders = JSON.parse(savedOrders);
                currentOrderId = localStorage.getItem('pos_current_order_id');
                
                if (!orders || !Array.isArray(orders) || orders.length === 0) {
                    orders = [];
                    createOrder();
                } else {
                    const exists = orders.find(o => o.id === currentOrderId);
                    if (!exists) {
                        currentOrderId = orders[0].id;
                    }
                    
                    let maxLocalId = 0;
                    orders.forEach(o => {
                        if (o.id && o.id.startsWith('HD')) {
                            const num = parseInt(o.id.substring(2));
                            if (!isNaN(num) && num > maxLocalId) {
                                maxLocalId = num;
                            }
                        }
                    });
                    const serverNextId = parseInt('${nextOrderIndex}') || 1;
                    nextOrderId = Math.max(serverNextId, maxLocalId + 1);
                    
                    renderTabs();
                    renderCurrentOrderItems();
                }
            } catch (e) {
                console.error("Error parsing pos orders", e);
                orders = [];
                createOrder();
            }
        } else {
            createOrder();
        }
        
        countTotalVariants();
        fetchProvinces();
    }

    // --- Order Tabs Logic ---
    
    function createOrder() {
        if (orders.length >= MAX_ORDERS) {
            alert("Chỉ được tạo tối đa " + MAX_ORDERS + " hóa đơn!");
            return;
        }
        
        const newOrderId = "HD" + String(nextOrderId).padStart(3, '0');
        nextOrderId++;
        
        orders.push({
            id: newOrderId,
            name: newOrderId,
            items: [],
            customerName: 'Khách lẻ',
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
            customerPay: ''
        });
        
        currentOrderId = newOrderId;
        
        renderTabs();
        renderCurrentOrderItems();
        renderCheckoutState();
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
        
        if (orders.length === 1) {
            alert('Không thể đóng đơn hàng cuối cùng!');
            return;
        }
        
        if (!confirm('Bạn có chắc chắn muốn xóa thông tin hóa đơn này không?')) {
            return;
        }
        
        orders = orders.filter(o => o.id !== orderId);
        
        if (currentOrderId === orderId) {
            // Switch to the last available order
            currentOrderId = orders[orders.length - 1].id;
        }
        
        renderTabs();
        renderCurrentOrderItems();
        renderCheckoutState();
    }

    // --- Modal Logic ---
    
    function openVariantModal() {
        if (!currentOrderId) {
            alert('Vui lòng tạo đơn hàng trước!');
            return;
        }
        document.getElementById('variantModalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }
    
    function closeVariantModal() {
        document.getElementById('variantModalOverlay').classList.remove('active');
        document.body.style.overflow = '';
    }
    
    // --- Filters Logic (Client-side) ---
    
    function resetFilters() {
        document.getElementById('variantSearch').value = '';
        document.getElementById('colorFilter').value = '';
        document.getElementById('sizeFilter').value = '';
        document.getElementById('productFilter').value = '';
        filterVariants();
    }
    
    function filterVariants() {
        const searchText = document.getElementById('variantSearch').value.toLowerCase();
        const colorVal = document.getElementById('colorFilter').value.toLowerCase();
        const sizeVal = document.getElementById('sizeFilter').value.toLowerCase();
        const productVal = document.getElementById('productFilter').value.toLowerCase();
        
        const rows = document.querySelectorAll('.variant-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const code = (row.getAttribute('data-code') || '').toLowerCase();
            const name = (row.getAttribute('data-name') || '').toLowerCase();
            const color = (row.getAttribute('data-color') || '').toLowerCase();
            const size = (row.getAttribute('data-size') || '').toLowerCase();
            
            // Search text matches any of these fields
            const matchSearch = !searchText || code.includes(searchText) || name.includes(searchText) || color.includes(searchText) || size.includes(searchText);
            const matchColor = !colorVal || color === colorVal;
            const matchSize = !sizeVal || size === sizeVal;
            const matchProduct = !productVal || name === productVal;
            
            if (matchSearch && matchColor && matchSize && matchProduct) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });
        
        document.getElementById('totalVariantsCount').textContent = visibleCount;
        
        // Basic pagination info update (mocked since it's just client-side filtering without actual pages right now)
        document.getElementById('paginationInfo').innerHTML = `Trang 1 / 1 - <span id="totalVariantsCount">${visibleCount}</span> biến thể`;
    }
    
    function countTotalVariants() {
        const rows = document.querySelectorAll('.variant-row');
        const countSpan = document.getElementById('totalVariantsCount');
        if (countSpan) {
            countSpan.textContent = rows.length;
        }
    }
    
    function addVariantToOrder(variantCode) {
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
        
        if (existingItemIndex !== -1) {
            if (order.items[existingItemIndex].quantity < stock) {
                order.items[existingItemIndex].quantity += 1;
            } else {
                alert("Số lượng vượt quá tồn kho!");
                return;
            }
        } else {
            order.items.push({
                code: variantCode,
                name: name,
                color: color,
                size: size,
                price: price,
                image: image,
                stock: stock,
                quantity: 1
            });
        }
        
        renderCurrentOrderItems();
        closeVariantModal();
    }
    
    function renderCurrentOrderItems() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        
        const order = orders[orderIndex];
        const emptyState = document.getElementById('emptyState');
        const container = document.getElementById('addedProductsContainer');
        
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
                            '<input type="checkbox" class="pos-cart-checkbox" checked>' +
                            imgHtml +
                            '<div class="pos-cart-item-info">' +
                                '<div class="pos-cart-item-name">' + item.name + '</div>' +
                                '<div class="pos-cart-item-variant">' + item.code + ' &bull; ' + item.color + ' &bull; ' + item.size + '</div>' +
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
            
            // Update summary
            document.getElementById('summaryTotalItems').textContent = formattedSumTotal;
            let discount = 300000;
            let finalTotal = sumTotal - discount;
            if (finalTotal < 0) finalTotal = 0;
            document.getElementById('summaryTotalPayment').textContent = finalTotal.toLocaleString('vi-VN') + ' đ';
            document.getElementById('summaryChange').textContent = finalTotal.toLocaleString('vi-VN') + ' đ';
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
            document.getElementById('shippingRow').style.display = 'flex';
        } else {
            document.getElementById('btnChooseAddress').style.display = 'none';
            document.getElementById('deliveryHintText').style.display = 'block';
            document.getElementById('deliveryForm').style.display = 'none';
            document.getElementById('shippingRow').style.display = 'none';
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
        
        fetch(`https://provinces.open-api.vn/api/p/${provinceCode}?depth=2`)
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
        
        fetch(`https://provinces.open-api.vn/api/d/${districtCode}?depth=2`)
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
            if (name !== 'Khách lẻ') {
                orders[orderIndex].deliveryPhone = phone;
                if (btnElement) {
                    const row = btnElement.closest('tr');
                    orders[orderIndex].province = row.getAttribute('data-prov') || '';
                    orders[orderIndex].district = row.getAttribute('data-dist') || '';
                    orders[orderIndex].ward = row.getAttribute('data-ward') || '';
                    orders[orderIndex].deliveryAddress = row.getAttribute('data-detail') || '';
                }
            } else {
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
    
    // --- Checkout State Management ---
    function updateCheckoutState() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        order.isDelivery = document.getElementById('deliveryToggle').checked;
        order.deliveryPhone = document.getElementById('customerPhoneInput').value;
        order.deliveryAddress = document.getElementById('customerAddressInput').value;
        
        const isFixed = order.customerName && order.customerName !== 'Khách lẻ';
        if (!isFixed) {
            order.province = document.getElementById('provinceSelect').value;
            order.district = document.getElementById('districtSelect').value;
            order.ward = document.getElementById('wardSelect').value;
        }
        
        order.shippingFee = document.getElementById('shippingFeeInput').value;
        order.customerPay = document.getElementById('customerPayInput').value;
        order.discountCode = document.getElementById('discountCodeInput').value;
        order.discountValue = document.getElementById('discountValueInput').value;
        
        saveOrdersToStorage();
    }
    
    function renderCheckoutState() {
        const orderIndex = orders.findIndex(o => o.id === currentOrderId);
        if (orderIndex === -1) return;
        const order = orders[orderIndex];
        
        document.getElementById('customerNameDisplay').textContent = order.customerName || 'Khách lẻ';
        
        const toggle = document.getElementById('deliveryToggle');
        toggle.checked = !!order.isDelivery;
        
        const isFixed = order.customerName && order.customerName !== 'Khách lẻ';
        
        const isDelivery = toggle.checked;
        document.getElementById('deliveryLabel').textContent = isDelivery ? "Giao hàng" : "Tại quầy";
        if (isDelivery) {
            document.getElementById('btnChooseAddress').style.display = 'inline-block';
            document.getElementById('deliveryHintText').style.display = 'none';
            document.getElementById('deliveryForm').style.display = 'flex';
            document.getElementById('shippingRow').style.display = 'flex';
        } else {
            document.getElementById('btnChooseAddress').style.display = 'none';
            if (isFixed) {
                document.getElementById('deliveryHintText').style.display = 'none';
                document.getElementById('deliveryForm').style.display = 'flex';
            } else {
                document.getElementById('deliveryHintText').style.display = 'block';
                document.getElementById('deliveryForm').style.display = 'none';
            }
            document.getElementById('shippingRow').style.display = 'none';
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
            
            document.getElementById('provinceSelect').value = order.province || '';
            
            if (order.province) {
                fetch(`https://provinces.open-api.vn/api/p/${order.province}?depth=2`)
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
                        select.value = order.district || '';
                        
                        if (order.district) {
                            fetch(`https://provinces.open-api.vn/api/d/${order.district}?depth=2`)
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
                                    wSelect.value = order.ward || '';
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
        document.getElementById('discountValueInput').value = order.discountValue || '';

    }
    
    function updateItemQty(code, change) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        const item = order.items.find(i => i.code === code);
        if (!item) return;
        
        let newQty = item.quantity + change;
        if (newQty > 0 && newQty <= item.stock) {
            item.quantity = newQty;
            renderCurrentOrderItems();
        } else if (newQty > item.stock) {
            alert("Số lượng vượt quá tồn kho!");
        }
    }
    
    function setItemQty(code, value) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        const item = order.items.find(i => i.code === code);
        if (!item) return;
        
        let val = parseInt(value) || 1;
        if (val > item.stock) {
            alert("Số lượng vượt quá tồn kho!");
            val = item.stock;
        } else if (val < 1) {
            val = 1;
        }
        item.quantity = val;
        renderCurrentOrderItems();
    }
    
    function removeItem(code) {
        const order = orders.find(o => o.id === currentOrderId);
        if (!order) return;
        
        order.items = order.items.filter(i => i.code !== code);
        renderCurrentOrderItems();
    }
    
    // Initialize
    window.addEventListener('DOMContentLoaded', initPOS);
    
</script>

</body>
</html>
