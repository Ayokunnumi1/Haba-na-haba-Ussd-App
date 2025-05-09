// In modal.js - make the function available immediately rather than waiting for turbo:load
window.toggleModal = function (modalId) {
  const modal = document.getElementById(modalId);
  if (modal) modal.classList.toggle("hidden");
};

// Still set up the event listener to re-initialize for Turbo navigation
document.addEventListener("turbo:load", function () {
  // The function is already defined globally, so no need to redefine it here
});
