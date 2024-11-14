function toggleDropdown(event, button) {
  event.stopPropagation();

  // Find the dropdown menu within the same dropdown container
  const dropdownContainer = button.closest("[data-dropdown-container]");
  const dropdownMenu = dropdownContainer.querySelector("[data-dropdown-menu]");
  const dataTable = document.querySelector(".data-table");

  // Check if dropdown menu exists
  if (!dropdownMenu) {
    console.error("Dropdown element not found");
    return;
  }

  // Close all other dropdowns
  document.querySelectorAll("[data-dropdown-menu]").forEach((menu) => {
    if (menu !== dropdownMenu) menu.classList.add("hidden");
  });

  // Toggle visibility of this dropdown menu
  const isDropdownOpen = !dropdownMenu.classList.contains("hidden");
  dropdownMenu.classList.toggle("hidden", isDropdownOpen);

  // Adjust dropdown position if necessary
  if (!isDropdownOpen) {
    dropdownMenu.style.top = "";
    dropdownMenu.style.bottom = "";

    const buttonRect = button.getBoundingClientRect();
    const dropdownRect = dropdownMenu.getBoundingClientRect();
    const dataTableRect = dataTable.getBoundingClientRect();

    // Check if the dropdown goes out of view below and adjust
    if (buttonRect.bottom + dropdownRect.height > dataTableRect.bottom) {
      dropdownMenu.style.bottom = `${buttonRect.height}px`;
    } else {
      dropdownMenu.style.top = `${buttonRect.height}px`;
    }
  }
}

function initializeDropdowns() {
  document.querySelectorAll("[data-dropdown-button]").forEach((button) => {
    button.addEventListener("click", (event) => toggleDropdown(event, button));
  });

  // Close dropdown when clicking outside
  document.addEventListener("click", () => {
    document.querySelectorAll("[data-dropdown-menu]").forEach((dropdown) => {
      dropdown.classList.add("hidden");
    });
  });
}

// Expose functions to the global scope
window.toggleDropdown = toggleDropdown;
window.initializeDropdowns = initializeDropdowns;

// Initialize dropdowns on DOM content load
document.addEventListener("DOMContentLoaded", initializeDropdowns);
