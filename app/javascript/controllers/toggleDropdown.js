document.addEventListener("DOMContentLoaded", () => {
  const dataTable = document.querySelector(".data-table");

  document.querySelectorAll(".actions-button").forEach((button) => {
    button.addEventListener("click", (event) => {
      event.stopPropagation();

      // Get the associated dropdown for this button
      const dropdown = button.nextElementSibling;

      // Check if the dropdown is already open
      const isDropdownOpen = !dropdown.classList.contains("hidden");

      // Close all other dropdowns
      document.querySelectorAll(".dropdown-menu").forEach((menu) => {
        menu.classList.add("hidden");
      });

      // Toggle this dropdown based on its current state
      if (!isDropdownOpen) {
        // Reset position before calculating
        dropdown.style.top = "";
        dropdown.style.bottom = "";

        // Calculate the necessary heights
        const buttonRect = button.getBoundingClientRect();
        const dropdownRect = dropdown.getBoundingClientRect();
        const dataTableRect = dataTable.getBoundingClientRect();

        // Check if dropdown would go out of the data-table view and adjust position
        if (buttonRect.bottom + dropdownRect.height > dataTableRect.bottom) {
          // Not enough space below, position above
          dropdown.style.bottom = `${buttonRect.height}px`;
        } else {
          // Enough space below, position below
          dropdown.style.top = `${buttonRect.height}px`;
        }

        // Show the dropdown
        dropdown.classList.remove("hidden");
      }
    });
  });

  // Close dropdown when clicking outside
  document.addEventListener("click", () => {
    document.querySelectorAll(".dropdown-menu").forEach((dropdown) => {
      dropdown.classList.add("hidden");
    });
  });
});
