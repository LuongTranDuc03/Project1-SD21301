// Hiển thị lỗi server dưới dạng toast sau khi toast.jsp đã load
(function () {
  if (typeof _serverErrors !== "undefined" && _serverErrors.length > 0) {
    var msg = _serverErrors.join("<br>");
    if (typeof window.showToast === "function") {
      window.showToast(_serverErrors[0], "error");
      // Nếu có nhiều lỗi, hiện từng cái một với delay
      for (var i = 1; i < _serverErrors.length; i++) {
        (function (err, delay) {
          setTimeout(function () {
            if (typeof window.showToast === "function")
              window.showToast(err, "error");
          }, delay);
        })(_serverErrors[i], i * 800);
      }
    }
  }
})();
