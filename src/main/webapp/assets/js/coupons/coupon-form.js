document.addEventListener("DOMContentLoaded", function () {
  const inputs = document.querySelectorAll("input, select, textarea");
  inputs.forEach((input) => {
    input.setAttribute("disabled", "disabled");
    input.style.backgroundColor = "#f1f5f9";
    input.style.cursor = "not-allowed";
  });
  const btnSubmit = document.getElementById("btnSubmit");
  if (btnSubmit) {
    btnSubmit.style.display = "none";
  }
});
