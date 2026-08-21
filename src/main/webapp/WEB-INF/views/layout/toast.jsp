<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    ============================================================
    Toast thông báo dùng chung (hiển thị giữa - phía trên màn hình,
    tự động biến mất sau một khoảng thời gian ngắn).

    * Dùng phía server (sau khi xử lý thành công rồi redirect):
          request.getSession().setAttribute("toastMessage", "Thêm sản phẩm thành công!");
          request.getSession().setAttribute("toastType", "success"); // success | error | info
      ProductController sẽ tự chuyển 2 giá trị này từ session -> request khi GET.

    * Dùng phía client (JavaScript):
          window.showToast("Nội dung thông báo", "success");
    ============================================================
--%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout/toast.css">

<div id="toast-container" class="toast-container"></div>

<script>
    (function () {
        var ICONS = {
            success: '<svg viewBox="0 0 24 24" width="24" height="24" stroke="#10B981" stroke-width="2" fill="none"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
            error: '<svg viewBox="0 0 24 24" width="24" height="24" stroke="#EF4444" stroke-width="2" fill="none"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>',
            info: '<svg viewBox="0 0 24 24" width="24" height="24" stroke="#3B82F6" stroke-width="2" fill="none"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>'
        };

        var TITLES = {
            success: 'Thành công!',
            error: 'Lỗi!',
            info: 'Thông báo'
        };

        window.showToast = function (message, type, duration) {
            if (!message) return;
            type = type || 'success';
            duration = duration || 3000;

            var container = document.getElementById('toast-container');
            if (!container) return;

            var toast = document.createElement('div');
            toast.className = 'toast ' + type;

            var iconHtml = ICONS[type] || ICONS.success;
            var titleText = TITLES[type] || TITLES.success;

            toast.innerHTML = 
                iconHtml +
                '<div class="toast-content">' +
                    '<div class="toast-title">' + titleText + '</div>' +
                    '<div class="toast-text">' + message + '</div>' +
                '</div>' +
                '<button class="toast-close">✕</button>';

            toast.querySelector('.toast-close').addEventListener('click', function() {
                toast.classList.remove('show');
                setTimeout(function () {
                    if (toast.parentNode) toast.parentNode.removeChild(toast);
                }, 300);
            });

            container.appendChild(toast);

            // Kích hoạt hiệu ứng trượt xuống + hiện dần
            requestAnimationFrame(function () { toast.classList.add('show'); });

            // Tự động ẩn sau `duration` mili-giây
            setTimeout(function () {
                toast.classList.remove('show');
                setTimeout(function () {
                    if (toast.parentNode) toast.parentNode.removeChild(toast);
                }, 300);
            }, duration);
        };

        // Tự hiển thị toast do server gửi xuống (flash message)
        document.addEventListener('DOMContentLoaded', function () {
            var flash = document.getElementById('server-flash-toast');
            if (flash) {
                window.showToast(flash.getAttribute('data-message'), flash.getAttribute('data-type') || 'success');
                if (flash.parentNode) flash.parentNode.removeChild(flash);
            }
        });
    })();
</script>

<%
    String __toastMsg = (String) request.getAttribute("toastMessage");
    String __toastType = (String) request.getAttribute("toastType");
    if (__toastMsg != null && !__toastMsg.isEmpty()) {
        String __safeMsg = __toastMsg
                .replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
        String __safeType = (__toastType == null || __toastType.isEmpty()) ? "success" : __toastType;
%>
<div id="server-flash-toast" data-message="<%= __safeMsg %>" data-type="<%= __safeType %>" style="display:none;"></div>
<%
    }
%>