document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".actions-button").forEach((button) => {
    button.addEventListener("click", (event) => {
      event.stopPropagation();

      const dropdown = button.nextElementSibling;
      dropdown.classList.toggle("hidden");

      // Reset previous position adjustments
      dropdown.style.top = "";
      dropdown.style.bottom = "";

      const dataTable = document.querySelector(".data-table");
      const buttonRect = button.getBoundingClientRect();
      const dropdownRect = dropdown.getBoundingClientRect();
      const viewportHeight = dataTable.innerHeight;

      console.log(viewportHeight);

      // Check space below button
      if (buttonRect.bottom + dropdownRect.height > viewportHeight) {
        // Not enough space below: show dropdown above the button
        dropdown.style.bottom = `${buttonRect.height}px`;
      } else {
        // Enough space below: show dropdown below the button
        dropdown.style.top = `${buttonRect.height}px`;
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
