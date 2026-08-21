function downloadBarcodeImage() {
  const container = document.getElementById("barcodeContainer");
  const variantCode = document.getElementById("view-variantCode").value;
  if (!variantCode) return;

  // Tạm thời bỏ border và shadow để ảnh lưu ra đẹp hơn như một thẻ tag
  const oldBorder = container.style.border;
  const oldShadow = container.style.boxShadow;
  container.style.border = "none";
  container.style.boxShadow = "none";

  html2canvas(container, {
    scale: 2, // Tạo ảnh chất lượng cao
    backgroundColor: "#ffffff",
  })
    .then((canvas) => {
      // Restore style
      container.style.border = oldBorder;
      container.style.boxShadow = oldShadow;

      const link = document.createElement("a");
      link.download = "barcode_" + variantCode + ".png";
      link.href = canvas.toDataURL("image/png");
      link.click();
    })
    .catch((err) => {
      console.error("Lỗi khi tạo ảnh barcode:", err);
      container.style.border = oldBorder;
      container.style.boxShadow = oldShadow;
      alert("Không thể lưu ảnh Barcode.");
    });
}

document.addEventListener("DOMContentLoaded", function () {
  const savedOrders = localStorage.getItem("pos_orders");
  if (savedOrders) {
    try {
      const orders = JSON.parse(savedOrders);
      let reservedQty = {};
      orders.forEach((o) => {
        if (o.items) {
          o.items.forEach((i) => {
            if (!reservedQty[i.code]) reservedQty[i.code] = 0;
            reservedQty[i.code] += i.quantity;
          });
        }
      });

      const rows = document.querySelectorAll(".variant-data-row");
      rows.forEach((row) => {
        const code = row.getAttribute("data-code");
        if (code && reservedQty[code]) {
          const dbStock = parseInt(row.getAttribute("data-stock")) || 0;
          const available = Math.max(0, dbStock - reservedQty[code]);

          // Dùng class td-stock để chọn chính xác cột Số lượng,
          // tránh lỗi hardcoded index khi số cột bảng thay đổi
          const stockTd = row.querySelector(".td-stock");
          if (stockTd) {
            const span = stockTd.querySelector("span");
            if (span) span.textContent = available;
          }
        }
      });
    } catch (e) {
      console.error("Error parsing pos orders", e);
    }
  }
});
