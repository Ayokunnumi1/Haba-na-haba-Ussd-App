document.addEventListener("turbo:load", () => {
  const dashboardElement = document.querySelector(".dashboard-selector");
  if (!dashboardElement) return;

  // Dropdown toggle
  const dropdownButton = document.getElementById("tabsDropdownButton");
  const dropdownMenu = document.getElementById("tabsDropdown");

  // Add this null check for dropdown elements
  if (dropdownButton && dropdownMenu) {
    dropdownButton.addEventListener("click", () => {
      dropdownMenu.classList.toggle("hidden");
    });
  }

  // Tab switching
  const tabButtons = document.querySelectorAll("[data-tabs-target]");
  tabButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      // Hide all tab contents
      document.querySelectorAll("[role='tabpanel']").forEach((tab) => {
        tab.classList.add("hidden");
      });

      // Remove active state from all buttons
      tabButtons.forEach((btn) => {
        btn.setAttribute("aria-selected", "false");
      });

      // Show the targeted tab and set active state
      const target = document.querySelector(
        button.getAttribute("data-tabs-target")
      );

      // Add this null check for target
      if (target) {
        target.classList.remove("hidden");
      }

      button.setAttribute("aria-selected", "true");

      // Hide the dropdown only if it exists
      if (dropdownMenu) {
        dropdownMenu.classList.add("hidden");
      }
    });
  });
});
