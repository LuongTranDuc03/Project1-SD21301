/**
 * address-dropdown.js (v1.4)
 * Custom Searchable Dropdown cho tất cả ô chọn địa chỉ (Tỉnh thành, Quận huyện, Phường xã).
 * 100% Thả thẳng xuống dưới, độ rộng 100% bằng ô input (không bao giờ làm phình cột hay đẩy lệch khung).
 */
function makeSearchableDropdown(target) {
    const select = typeof target === 'string' ? document.getElementById(target) : target;
    if (!select || select.dataset.customDropdownInitialized) return;
    
    select.dataset.customDropdownInitialized = 'true';

    // Khởi tạo wrapper nếu chưa có
    let wrapper = select.parentElement;
    if (!wrapper || !wrapper.classList.contains('custom-select-wrapper')) {
        wrapper = document.createElement('div');
        wrapper.className = 'custom-select-wrapper';
        wrapper.style.cssText = 'position: relative; width: 100%; min-width: 0; box-sizing: border-box;';
        select.parentNode.insertBefore(wrapper, select);
        wrapper.appendChild(select);
    }

    // Ẩn select gốc
    select.style.display = 'none';

    // Tạo nút toggle hiển thị
    const toggle = document.createElement('div');
    toggle.className = 'custom-select-toggle ' + (select.className || '');
    toggle.style.cssText = 'display: flex; align-items: center; justify-content: space-between; cursor: pointer; background: #ffffff; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; color: #1e293b; user-select: none; width: 100%; min-width: 0; box-sizing: border-box; min-height: 40px;';
    
    const textSpan = document.createElement('span');
    textSpan.className = 'custom-select-text';
    textSpan.style.cssText = 'white-space: nowrap; overflow: hidden; text-overflow: ellipsis; flex: 1; min-width: 0; text-align: left;';
    
    const arrow = document.createElement('i');
    arrow.className = 'fa-solid fa-chevron-down';
    arrow.style.cssText = 'font-size: 11px; color: #64748b; margin-left: 8px; transition: transform 0.2s ease; flex-shrink: 0;';

    toggle.appendChild(textSpan);
    toggle.appendChild(arrow);
    wrapper.appendChild(toggle);

    // Khung menu thả xuống 100% THẢ XUỐNG DƯỚI, chuẩn độ rộng 100% vừa khít
    const menu = document.createElement('div');
    menu.className = 'custom-select-menu';
    menu.style.cssText = 'display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0; width: 100%; background: #ffffff; border: 1px solid #cbd5e1; border-radius: 8px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.15), 0 8px 10px -6px rgba(0,0,0,0.1); z-index: 999999; padding: 6px 0; max-height: 240px; flex-direction: column; box-sizing: border-box;';

    // Ô gõ tìm kiếm (Unicode Escapes)
    const searchBox = document.createElement('div');
    searchBox.style.cssText = 'padding: 6px 8px 8px 8px; border-bottom: 1px solid #f1f5f9; box-sizing: border-box;';
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = 'G\u00f5 \u0111\u1ec3 t\u00ecm ki\u1ebfm...'; // Gõ để tìm kiếm...
    searchInput.style.cssText = 'width: 100%; padding: 7px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 12px; outline: none; box-sizing: border-box;';
    searchBox.appendChild(searchInput);
    menu.appendChild(searchBox);

    // Khung chứa các lựa chọn
    const optionsBox = document.createElement('div');
    optionsBox.className = 'custom-select-options-box';
    optionsBox.style.cssText = 'max-height: 180px; overflow-y: auto; display: flex; flex-direction: column; width: 100%; box-sizing: border-box;';
    menu.appendChild(optionsBox);

    wrapper.appendChild(menu);

    function updateToggleText() {
        if (select.disabled) {
            toggle.style.backgroundColor = '#f1f5f9';
            toggle.style.cursor = 'not-allowed';
            toggle.style.opacity = '0.7';
        } else {
            toggle.style.backgroundColor = '#ffffff';
            toggle.style.cursor = 'pointer';
            toggle.style.opacity = '1';
        }
        const selectedOpt = select.options[select.selectedIndex];
        textSpan.textContent = selectedOpt ? selectedOpt.text : 'Ch\u1ecdn...';
    }

    function renderOptions() {
        optionsBox.innerHTML = '';
        const filterText = searchInput.value.toLowerCase().trim();
        let matchCount = 0;

        Array.from(select.options).forEach((opt, idx) => {
            if (opt.text.toLowerCase().includes(filterText)) {
                matchCount++;
                const item = document.createElement('div');
                item.className = 'custom-select-item';
                item.style.cssText = 'padding: 8px 12px; font-size: 13px; line-height: 1.4; color: #334155; cursor: pointer; transition: background 0.15s; text-align: left; white-space: normal; word-break: break-word; border-bottom: 1px solid #f8fafc; box-sizing: border-box;';
                
                if (idx === select.selectedIndex) {
                    item.style.backgroundColor = '#eff6ff';
                    item.style.fontWeight = '600';
                    item.style.color = '#1d4ed8';
                }
                item.textContent = opt.text;
                item.addEventListener('mouseenter', () => {
                    if (idx !== select.selectedIndex) item.style.backgroundColor = '#f8fafc';
                });
                item.addEventListener('mouseleave', () => {
                    if (idx !== select.selectedIndex) item.style.backgroundColor = 'transparent';
                });
                item.addEventListener('click', (e) => {
                    e.stopPropagation();
                    select.selectedIndex = idx;
                    select.value = opt.value;
                    updateToggleText();
                    closeMenu();
                    select.dispatchEvent(new Event('change', { bubbles: true }));
                });
                optionsBox.appendChild(item);
            }
        });

        if (matchCount === 0) {
            const noRes = document.createElement('div');
            noRes.style.cssText = 'padding: 10px 12px; font-size: 12px; color: #94a3b8; text-align: center;';
            noRes.textContent = 'Kh\u00f4ng t\u00ecm th\u1ea5y k\u1ebft qu\u1ea3'; // Không tìm thấy kết quả
            optionsBox.appendChild(noRes);
        }
    }

    function openMenu() {
        if (select.disabled) return;
        document.querySelectorAll('.custom-select-menu').forEach(m => {
            if (m !== menu) m.style.display = 'none';
        });
        menu.style.display = 'flex';
        arrow.style.transform = 'rotate(180deg)';
        searchInput.value = '';
        renderOptions();
        setTimeout(() => searchInput.focus(), 50);
    }

    function closeMenu() {
        menu.style.display = 'none';
        arrow.style.transform = 'rotate(0deg)';
    }

    toggle.addEventListener('click', (e) => {
        e.stopPropagation();
        if (menu.style.display === 'flex') {
            closeMenu();
        } else {
            openMenu();
        }
    });

    searchInput.addEventListener('input', renderOptions);
    searchInput.addEventListener('click', (e) => e.stopPropagation());

    document.addEventListener('click', (e) => {
        if (!wrapper.contains(e.target)) {
            closeMenu();
        }
    });

    const observer = new MutationObserver(() => {
        updateToggleText();
        if (menu.style.display === 'flex') renderOptions();
    });
    observer.observe(select, { childList: true, subtree: true, attributes: true });

    select.addEventListener('change', updateToggleText);
    updateToggleText();
}

// Tự động kích hoạt khi DOM sẵn sàng
document.addEventListener('DOMContentLoaded', () => {
    const addressSelectIds = [
        'provinceSelect', 'districtSelect', 'wardSelect',
        'defaultProvince', 'defaultDistrict', 'defaultWard',
        'province', 'district', 'ward'
    ];
    addressSelectIds.forEach(id => {
        const el = document.getElementById(id);
        if (el) makeSearchableDropdown(el);
    });

    document.querySelectorAll('.other-province, .other-district, .other-ward').forEach(el => {
        makeSearchableDropdown(el);
    });
});
