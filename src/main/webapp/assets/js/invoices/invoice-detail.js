function openConfirmModal(message, formId) {
  document.getElementById("genericConfirmMessage").innerText = message;
  var confirmBtn = document.getElementById("genericConfirmBtn");
  confirmBtn.onclick = function () {
    document.getElementById(formId).submit();
  };
  openModal("genericConfirmModal");
}
