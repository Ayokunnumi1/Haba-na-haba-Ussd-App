document.addEventListener("turbo:load", () => {
  // Get all elements
  const filterModal = document.getElementById("filter-modal");
  const filterModalButton = document.getElementById("filter-modal-button");
  const closeModalButton = document.getElementById("close-modal-button");
  const clearFiltersSmall = document.getElementById("clear-filters-small");
  const clearFiltersLarge = document.getElementById("clear-filters-large");
  const clearFiltersForm = document.getElementById("clear-filters-form");
  const resetFilterButton = document.getElementById("reset-filter-button");

  // Check if the main filter modal elements exist, if not we can exit early
  if (!filterModal) return;

  // Show modal when filter button is clicked
  if (filterModalButton) {
    filterModalButton.addEventListener("click", () => {
      filterModal.classList.remove("hidden");
      filterModal.classList.add("flex");
    });
  }

  // Hide modal when close button is clicked
  if (closeModalButton) {
    closeModalButton.addEventListener("click", () => {
      filterModal.classList.add("hidden");
      filterModal.classList.remove("flex");
    });
  }

  // Close modal when clicking outside of content
  filterModal.addEventListener("click", (event) => {
    if (event.target === filterModal) {
      filterModal.classList.add("hidden");
      filterModal.classList.remove("flex");
    }
  });

  // Handle clear filters actions
  if (clearFiltersSmall && clearFiltersForm) {
    clearFiltersSmall.addEventListener("click", () => {
      clearFiltersForm.submit();
    });
  }

  if (clearFiltersLarge && clearFiltersForm) {
    clearFiltersLarge.addEventListener("click", () => {
      clearFiltersForm.submit();
    });
  }

  // Reset filter fields
  if (resetFilterButton) {
    resetFilterButton.addEventListener("click", () => {
      document
        .querySelectorAll("#filter-modal input, #filter-modal select")
        .forEach((element) => {
          element.value = "";
        });
    });
  }
});
