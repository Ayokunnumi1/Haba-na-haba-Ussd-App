function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle('hidden');
  }
  
  window.toggleModal = toggleModal;
  