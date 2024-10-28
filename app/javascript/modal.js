function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle('hidden');
  }
  
  // Export function to be accessible globally
  window.toggleModal = toggleModal;
  