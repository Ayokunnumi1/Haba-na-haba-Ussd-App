document.addEventListener("DOMContentLoaded", function () {
  const dropdownToggles = document.querySelectorAll("[data-dropdown-toggle]");

  dropdownToggles.forEach((toggle) => {
    toggle.addEventListener("click", function () {
      const targetId = toggle.getAttribute("data-dropdown-toggle");
      const dropdown = document.getElementById(targetId);

      if (dropdown) {
        // Toggle visibility
        dropdown.classList.toggle("hidden");
      }
    });
  });

  // Close the dropdown if clicked outside
  document.addEventListener("click", function (event) {
    if (!event.target.closest(".relative")) {
      dropdownToggles.forEach((toggle) => {
        const targetId = toggle.getAttribute("data-dropdown-toggle");
        const dropdown = document.getElementById(targetId);
        if (dropdown && !dropdown.classList.contains("hidden")) {
          dropdown.classList.add("hidden");
        }
      });
    }
  });
});
