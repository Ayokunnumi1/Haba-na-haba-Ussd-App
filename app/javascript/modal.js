document.addEventListener("turbo:load", function () {
  window.toggleModal = function(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.classList.toggle("hidden");
  };
});
