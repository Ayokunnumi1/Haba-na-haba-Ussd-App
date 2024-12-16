document.addEventListener("turbo:load", () => {
  // Dropdown toggle
  const dropdownButton = document.getElementById("tabsDropdownButton");
  const dropdownMenu = document.getElementById("tabsDropdown");
  dropdownButton.addEventListener("click", () => {
    dropdownMenu.classList.toggle("hidden");
  });

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
      target.classList.remove("hidden");
      button.setAttribute("aria-selected", "true");

      // Hide the dropdown
      dropdownMenu.classList.add("hidden");
    });
  });
});
