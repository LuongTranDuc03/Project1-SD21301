// Lấy context path tự động từ URL hoặc cần định nghĩa biến toàn cục CONTEXT_PATH trong trang JSP.
// Nếu JSP chưa có CONTEXT_PATH, script sẽ dùng fallback qua API ngoài.
const CONTEXT_PATH = window.CONTEXT_PATH || '';

let _provinces = null;
let _districtsCache = {};
let _wardsCache = {};

// Hàm lấy danh sách Tỉnh/Thành
async function loadProvinces() {
    if (_provinces) return _provinces;
    const urls = [CONTEXT_PATH + '/api/v1/p', 'https://provinces.open-api.vn/api/v1/p'];
    for (const url of urls) {
        try {
            const r = await fetch(url, { signal: AbortSignal.timeout(10000) });
            if (r.ok) {
                const d = await r.json();
                if (Array.isArray(d) && d.length > 0) { _provinces = d; return d; }
            }
        } catch (e) { }
    }
    return [];
}

// Hàm lấy danh sách Quận/Huyện theo mã Tỉnh
async function loadDistricts(pCode) {
    if (_districtsCache[pCode]) return _districtsCache[pCode];
    const urls = [CONTEXT_PATH + '/api/v1/p/' + pCode + '?depth=2', 'https://provinces.open-api.vn/api/v1/p/' + pCode + '?depth=2'];
    for (const url of urls) {
        try {
            const r = await fetch(url, { signal: AbortSignal.timeout(10000) });
            if (r.ok) {
                const d = await r.json();
                if (d && d.districts) { _districtsCache[pCode] = d.districts; return d.districts; }
            }
        } catch (e) { }
    }
    return [];
}

// Hàm lấy danh sách Phường/Xã theo mã Quận
async function loadWards(dCode) {
    if (_wardsCache[dCode]) return _wardsCache[dCode];
    const urls = [CONTEXT_PATH + '/api/v1/d/' + dCode + '?depth=2', 'https://provinces.open-api.vn/api/v1/d/' + dCode + '?depth=2'];
    for (const url of urls) {
        try {
            const r = await fetch(url, { signal: AbortSignal.timeout(10000) });
            if (r.ok) {
                const d = await r.json();
                if (d && d.wards) { _wardsCache[dCode] = d.wards; return d.wards; }
            }
        } catch (e) { }
    }
    return [];
}

// Phân tích chuỗi địa chỉ để tìm Tỉnh, Quận, Phường, Số nhà
function parseAddress(str) {
    if (!str || !str.trim()) return { province: '', district: '', ward: '', street: '' };
    const parts = str.split(',').map(s => s.trim()).filter(s => s);
    if (parts.length >= 4) return {
        province: parts[parts.length - 1],
        district: parts[parts.length - 2],
        ward: parts[parts.length - 3],
        street: parts.slice(0, parts.length - 3).join(', ')
    };
    return { province: '', district: '', ward: '', street: str.trim() };
}

// Khởi tạo các Select và gán sự kiện cho bộ địa chỉ
async function initAddressBlock(hidden, provSel, distSel, wardSel, streetIn) {
    if (!hidden || !provSel || !distSel || !wardSel || !streetIn) return;
    provSel.innerHTML = '<option value="">\u0110ang t\u1ea3i...</option>';
    provSel.disabled = true;
    const provinces = await loadProvinces();
    provSel.innerHTML = '<option value="">-- Ch\u1ecdn T\u1ec9nh/Th\u00e0nh --</option>';
    provinces.forEach(p => {
        const o = document.createElement('option');
        o.value = p.code; o.textContent = p.name;
        provSel.appendChild(o);
    });
    provSel.disabled = false;

    async function fillDistricts(pCode) {
        distSel.innerHTML = '<option value="">\u0110ang t\u1ea3i...</option>';
        wardSel.innerHTML = '<option value="">-- Ch\u1ecdn Ph\u01b0\u1eddng/X\u00e3 --</option>';
        distSel.disabled = true;
        wardSel.disabled = true;
        if (!pCode) {
            distSel.innerHTML = '<option value="">-- Ch\u1ecdn Qu\u1eadn/Huy\u1ec7n --</option>';
            return;
        }
        const dists = await loadDistricts(pCode);
        distSel.innerHTML = '<option value="">-- Ch\u1ecdn Qu\u1eadn/Huy\u1ec7n --</option>';
        dists.forEach(d => {
            const o = document.createElement('option');
            o.value = d.code; o.textContent = d.name;
            distSel.appendChild(o);
        });
        distSel.disabled = false;
    }

    async function fillWards(dCode) {
        wardSel.innerHTML = '<option value="">\u0110ang t\u1ea3i...</option>';
        wardSel.disabled = true;
        if (!dCode) {
            wardSel.innerHTML = '<option value="">-- Ch\u1ecdn Ph\u01b0\u1eddng/X\u00e3 --</option>';
            return;
        }
        const wards = await loadWards(dCode);
        wardSel.innerHTML = '<option value="">-- Ch\u1ecdn Ph\u01b0\u1eddng/X\u00e3 --</option>';
        wards.forEach(w => {
            const o = document.createElement('option');
            o.value = w.code; o.textContent = w.name;
            wardSel.appendChild(o);
        });
        if (wards.length) wardSel.disabled = false;
    }

    // syncHidden: luôn cập nhật hidden dù chưa điền đủ cả 4 trƶờng
    function syncHidden() {
        const pv = provSel.value, dv = distSel.value, wv = wardSel.value, s = streetIn.value.trim();
        const pt = pv ? provSel.options[provSel.selectedIndex].text : '';
        const dt = dv ? distSel.options[distSel.selectedIndex].text : '';
        const wt = wv ? wardSel.options[wardSel.selectedIndex].text : '';
        // Đặt giá trị hidden bất kể có đủ hay không để server có dữ liệu
        const parts = [s, wt, dt, pt].filter(x => x);
        hidden.value = parts.join(', ');
    }
    // Expose để có thể gọi từ bên ngoài (ví dụ trước khi submit)
    hidden._syncAddress = syncHidden;

    provSel.addEventListener('change', async () => { await fillDistricts(provSel.value); syncHidden(); });
    distSel.addEventListener('change', async () => { await fillWards(distSel.value); syncHidden(); });
    wardSel.addEventListener('change', syncHidden);
    streetIn.addEventListener('input', syncHidden);

    // Phục hồi dữ liệu (Edit mode)
    const existing = (hidden.value || '').trim();
    if (!existing) return;
    const p = parseAddress(existing);
    if (p.street) streetIn.value = p.street;
    if (!p.province) return;

    const pm = provinces.find(x => x.name.toLowerCase().trim() === p.province.toLowerCase().trim());
    if (!pm) return;
    provSel.value = pm.code;

    const dists = await loadDistricts(pm.code);
    distSel.innerHTML = '<option value="">-- Ch\u1ecdn Qu\u1eadn/Huy\u1ec7n --</option>';
    dists.forEach(d => { const o = document.createElement('option'); o.value = d.code; o.textContent = d.name; distSel.appendChild(o); });
    distSel.disabled = false;

    if (!p.district) return;
    const dm = dists.find(d => d.name.toLowerCase().trim() === p.district.toLowerCase().trim());
    if (!dm) return;
    distSel.value = dm.code;

    const wards = await loadWards(dm.code);
    wardSel.innerHTML = '<option value="">-- Ch\u1ecdn Ph\u01b0\u1eddng/X\u00e3 --</option>';
    wards.forEach(w => { const o = document.createElement('option'); o.value = w.code; o.textContent = w.name; wardSel.appendChild(o); });
    if (wards.length) wardSel.disabled = false;

    if (!p.ward) return;
    for (let i = 0; i < wardSel.options.length; i++) {
        if (wardSel.options[i].text.toLowerCase().trim() === p.ward.toLowerCase().trim()) { wardSel.selectedIndex = i; break; }
    }
}