document.addEventListener("DOMContentLoaded", () => {
  const fullAddrInput = document.getElementById("fullAddress");
  const fullAddr = fullAddrInput ? fullAddrInput.value.trim() : "";
  if (fullAddr) {
    const parts = fullAddr.split(",").map((s) => s.trim());
    if (parts.length >= 4) {
      document.getElementById("display-street").textContent = parts
        .slice(0, parts.length - 3)
        .join(", ");
      document.getElementById("display-ward").textContent =
        parts[parts.length - 3];
      document.getElementById("display-district").textContent =
        parts[parts.length - 2];
      document.getElementById("display-province").textContent =
        parts[parts.length - 1];
    } else {
      document.getElementById("display-street").textContent = fullAddr;
      document.getElementById("display-ward").textContent = "Chưa cập nhật";
      document.getElementById("display-district").textContent = "Chưa cập nhật";
      document.getElementById("display-province").textContent = "Chưa cập nhật";
    }
  } else {
    document.getElementById("display-street").textContent = "Chưa cập nhật";
    document.getElementById("display-ward").textContent = "Chưa cập nhật";
    document.getElementById("display-district").textContent = "Chưa cập nhật";
    document.getElementById("display-province").textContent = "Chưa cập nhật";
  }
});
