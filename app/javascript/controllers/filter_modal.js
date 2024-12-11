document.addEventListener("turbo:load", () => {
  const filterModal = document.getElementById("filter-modal");
  const filterModalButton = document.getElementById("filter-modal-button");
  const closeModalButton = document.getElementById("close-modal-button");
  const clearFiltersSmall = document.getElementById("clear-filters-small");
  const clearFiltersLarge = document.getElementById("clear-filters-large");
  const clearFiltersForm = document.getElementById("clear-filters-form");

  if (filterModalButton) {
    filterModalButton.addEventListener("click", () => {
      filterModal.classList.remove("hidden");
      filterModal.classList.add("flex");
    });
  }

  if (closeModalButton) {
    closeModalButton.addEventListener("click", () => {
      filterModal.classList.add("hidden");
      filterModal.classList.remove("flex");
    });
  }

  if (filterModal) {
    filterModal.addEventListener("click", (event) => {
      if (event.target === filterModal) {
        filterModal.classList.add("hidden");
        filterModal.classList.remove("flex");
      }
    });
  }

  if (clearFiltersSmall) {
    clearFiltersSmall.addEventListener("click", () => {
      clearFiltersForm.submit();
    });
  }

  if (clearFiltersLarge) {
    clearFiltersLarge.addEventListener("click", () => {
      clearFiltersForm.submit();
    });
  }
  
  const resetFilterButton = document.getElementById("reset-filter-button");

  filterModalButton.addEventListener("click", () => {
    filterModal.classList.remove("hidden");
    filterModal.classList.add("flex");
  });

  closeModalButton.addEventListener("click", () => {
    filterModal.classList.add("hidden");
    filterModal.classList.remove("flex");
  });

  resetFilterButton.addEventListener("click", () => {
    document
      .querySelectorAll("#filter-modal input, #filter-modal select")
      .forEach((element) => {
        element.value = "";
      });
  });

  filterModal.addEventListener("click", (event) => {
    if (event.target === filterModal) {
      filterModal.classList.add("hidden");
      filterModal.classList.remove("flex");
    }
  });
});
