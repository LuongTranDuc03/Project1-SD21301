document.addEventListener("DOMContentLoaded", function () {
  const savedOrders = localStorage.getItem("pos_orders");
  if (savedOrders) {
    try {
      const orders = JSON.parse(savedOrders);
      let reservedByProductName = {};
      orders.forEach((o) => {
        if (o.items) {
          o.items.forEach((i) => {
            let pName = (i.name || "").toLowerCase();
            if (!reservedByProductName[pName]) reservedByProductName[pName] = 0;
            reservedByProductName[pName] += i.quantity;
          });
        }
      });

      const rows = document.querySelectorAll("#productTbody tr");
      rows.forEach((row) => {
        const pName = row.getAttribute("data-name");
        if (pName && reservedByProductName[pName]) {
          const dbStock = parseInt(row.getAttribute("data-stock")) || 0;
          const available = Math.max(0, dbStock - reservedByProductName[pName]);

          const stockTd = row.children[6];
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
