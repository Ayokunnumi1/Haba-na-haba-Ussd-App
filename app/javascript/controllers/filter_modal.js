document.addEventListener("turbo:load", () => {
  const filterModal = document.getElementById("filter-modal");
  const filterModalButton = document.getElementById("filter-modal-button");
  const closeModalButton = document.getElementById("close-modal-button");
  const resetFilterButton = document.getElementById("reset-filter-button");

  // Open modal
  filterModalButton.addEventListener("click", () => {
    filterModal.classList.remove("hidden");
    filterModal.classList.add("flex");
  });

  // Close modal
  closeModalButton.addEventListener("click", () => {
    filterModal.classList.add("hidden");
    filterModal.classList.remove("flex");
  });

  // Reset filters
  resetFilterButton.addEventListener("click", () => {
    document
      .querySelectorAll("#filter-modal input, #filter-modal select")
      .forEach((element) => {
        element.value = "";
      });
  });

  // Close modal on background click
  filterModal.addEventListener("click", (event) => {
    if (event.target === filterModal) {
      filterModal.classList.add("hidden");
      filterModal.classList.remove("flex");
    }
  });
});
