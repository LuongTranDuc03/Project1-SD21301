<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    address-form.jsp — Form chọn địa chỉ 2 cấp (Tỉnh/Thành → Xã/Phường)
    Chuẩn:
    - Lưu trực tiếp "TÊN" tỉnh và xã (String) vào DB.
    - Cột district (huyện) luôn được ẩn hoặc bỏ trống (sẽ submit rỗng/null).
    
    Các field được submit cùng form cha (không cần action riêng):
        - province      : tên tỉnh/thành (String)
        - ward          : tên xã/phường (String)
        - addressDetail : địa chỉ chi tiết (String)

    Prefill dữ liệu cũ: set request attributes trước khi include:
        request.setAttribute("prefillProvince", address.getProvince());
        request.setAttribute("prefillWard",     address.getWard());
        request.setAttribute("prefillAddress",  address.getAddressDetail());
--%>
<%
    String prefillProvince = (String) request.getAttribute("prefillProvince");
    String prefillWard     = (String) request.getAttribute("prefillWard");
    String prefillAddress  = (String) request.getAttribute("prefillAddress");
%>
<div class="address-form-wrapper">

    <!-- KHU VỰC TỈNH/THÀNH PHỐ -->
    <div class="addr-field">
        <label for="provinceSelect">Tỉnh / Thành phố <span class="req">*</span></label>
        <div class="select-wrapper">
            <select id="provinceSelect" required>
                <option value="">-- Chọn tỉnh/thành --</option>
            </select>
            <!-- Hidden: lưu tên tỉnh -->
            <input type="hidden" id="provinceNameInput" name="province"
                   value="<%= prefillProvince != null ? prefillProvince : "" %>">
        </div>
        <div class="addr-loading" id="provinceLoading">Đang tải...</div>
    </div>

    <!-- KHU VỰC XÃ/PHƯỜNG -->
    <div class="addr-field">
        <label for="wardSelect">Xã / Phường / Thị trấn <span class="req">*</span></label>
        <div class="select-wrapper">
            <select id="wardSelect" required disabled>
                <option value="">-- Chọn tỉnh trước --</option>
            </select>
            <!-- Hidden: lưu tên xã -->
            <input type="hidden" id="wardNameInput" name="ward"
                   value="<%= prefillWard != null ? prefillWard : "" %>">
        </div>
        <div class="addr-loading" id="wardLoading" style="display:none">Đang tải...</div>
    </div>

    <!-- KHU VỰC ĐỊA CHỈ CHI TIẾT -->
    <div class="addr-field">
        <label for="addressDetailInput">Địa chỉ chi tiết <span class="req">*</span></label>
        <input type="text" id="addressDetailInput" name="addressDetail"
               placeholder="Số nhà, tên đường, khu vực..."
               value="<%= prefillAddress != null ? prefillAddress : "" %>"
               required autocomplete="off">
    </div>
</div>

<style>
.address-form-wrapper { display: flex; flex-direction: column; gap: 14px; }
.addr-field { display: flex; flex-direction: column; gap: 5px; }
.addr-field label { font-size: 13px; font-weight: 600; color: #374151; }
.addr-field .req { color: #ef4444; margin-left: 2px; }
.select-wrapper { position: relative; }
.addr-field select,
.addr-field input[type="text"] {
    width: 100%; padding: 9px 12px; font-size: 13px; font-family: 'Inter', sans-serif;
    border: 1.5px solid #e5e7eb; border-radius: 8px; color: #111827;
    background: #fff; outline: none; transition: border-color .2s;
    appearance: none; -webkit-appearance: none;
}
.addr-field select { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2.5'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 10px center; padding-right: 32px; }
.addr-field select:focus,
.addr-field input[type="text"]:focus { border-color: #E11D48; }
.addr-field select:disabled { background: #f9fafb; color: #9ca3af; cursor: not-allowed; }
.addr-loading { font-size: 11px; color: #9ca3af; margin-top: 2px; }
</style>

<%-- KHU VỰC JAVASCRIPT: Gọi API lấy danh sách tỉnh/xã và xử lý tự động chọn --%>
<script>
(function () {
    'use strict';

    var PROVINCES_URL = '${pageContext.request.contextPath}/api/provinces';

    var selProv    = document.getElementById('provinceSelect');
    var selWard    = document.getElementById('wardSelect');
    var inpProvName = document.getElementById('provinceNameInput');
    var inpWardName = document.getElementById('wardNameInput');
    var loadProv   = document.getElementById('provinceLoading');
    var loadWard   = document.getElementById('wardLoading');

    // ---- Prefill values từ server ----
    var prefillProv = '<%= prefillProvince != null ? prefillProvince : "" %>';
    var prefillWard = '<%= prefillWard != null ? prefillWard : "" %>';

    // Hàm tải danh sách các tỉnh/thành phố từ API
    function loadProvinces() {
        loadProv.style.display = 'block';
        fetch(PROVINCES_URL)
            .then(function(r) { return r.json(); })
            .then(function(provinces) {
                loadProv.style.display = 'none';
                
                var prefillProvCode = null;
                
                provinces.forEach(function(p) {
                    var opt = document.createElement('option');
                    opt.value = p.code;
                    opt.textContent = p.name;
                    
                    if (prefillProv && p.name === prefillProv) {
                        opt.selected = true;
                        prefillProvCode = p.code;
                    }
                    selProv.appendChild(opt);
                });

                // Nếu có tỉnh prefill, load danh sách xã cho tỉnh đó
                if (prefillProvCode) {
                    loadWards(prefillProvCode);
                }
            })
            .catch(function(e) {
                loadProv.textContent = '⚠ Không tải được danh sách tỉnh';
                console.error(e);
            });
    }

    // Hàm tải danh sách xã/phường/thị trấn dựa vào mã tỉnh đã chọn
    function loadWards(provinceCode) {
        selWard.disabled = true;
        selWard.innerHTML = '<option value="">Đang tải...</option>';
        loadWard.style.display = 'block';

        fetch(PROVINCES_URL + '?provinceCode=' + provinceCode)
            .then(function(r) { return r.json(); })
            .then(function(provinceData) {
                loadWard.style.display = 'none';
                selWard.innerHTML = '<option value="">-- Chọn xã/phường --</option>';

                var wards = provinceData.wards || [];
                wards.forEach(function(w) {
                    var opt = document.createElement('option');
                    opt.value = w.code;
                    opt.textContent = w.name;
                    if (prefillWard && w.name === prefillWard) {
                        opt.selected = true;
                    }
                    selWard.appendChild(opt);
                });

                selWard.disabled = false;
            })
            .catch(function(e) {
                loadWard.style.display = 'none';
                selWard.innerHTML = '<option value="">⚠ Lỗi tải xã/phường</option>';
                console.error(e);
            });
    }

    // ---- Sự kiện chọn tỉnh ----
    selProv.addEventListener('change', function() {
        var selectedCode = selProv.value;
        var opt = selProv.options[selProv.selectedIndex];
        
        if (!selectedCode) {
            inpProvName.value = '';
            selWard.disabled  = true;
            selWard.innerHTML = '<option value="">-- Chọn tỉnh trước --</option>';
            inpWardName.value = '';
            return;
        }
        
        inpProvName.value = opt.textContent; // Lưu tên tỉnh
        prefillWard       = ''; // Xóa prefill ward
        inpWardName.value = '';
        
        loadWards(selectedCode);
    });

    // ---- Sự kiện chọn xã/phường ----
    selWard.addEventListener('change', function() {
        var opt = selWard.options[selWard.selectedIndex];
        inpWardName.value = selWard.value ? opt.textContent : ''; // Lưu tên xã
    });

    // ---- Khởi động ----
    loadProvinces();
})();
</script>
