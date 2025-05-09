// Make dropdown toggle functionality globally available
window.handleRoleDropdownToggle = function () {
  const dropDownMenuButton = document.querySelector("#dropDownMenuBtn");
  const dropDownMenu = document.querySelector("#dropDownMenu");
  
  if (dropDownMenuButton && dropDownMenu) {
    // Remove previous listeners to prevent duplicates
    const oldClickHandler = dropDownMenuButton._clickHandler;
    if (oldClickHandler) {
      dropDownMenuButton.removeEventListener("click", oldClickHandler);
    }
    
    // Add new click handler
    const clickHandler = function () {
      dropDownMenu.classList.toggle("hidden");
    };
    dropDownMenuButton.addEventListener("click", clickHandler);
    dropDownMenuButton._clickHandler = clickHandler;  // Store for later removal
  }
};

// Make role filtering functionality globally available
window.handleRoleFiltering = function () {
  const dropdownItems = document.querySelectorAll("#dropDownItems");
  const userElements = document.querySelectorAll("#users-grid");

  if (dropdownItems.length === 0 || userElements.length === 0) return;

  dropdownItems.forEach((item) => {
    item.addEventListener("click", (e) => {
      const role = e.target.getAttribute("data-role");

      userElements.forEach((user) => {
        if (user.getAttribute("data-users-type") === role) {
          user.classList.remove("hidden");
          user.classList.add("ssm:flex", "mmd:block");
        } else {
          user.classList.add("hidden");
          user.classList.remove("ssm:flex", "mmd:block");
        }
      });
    });
  });
};

// Initialize on DOMContentLoaded
document.addEventListener("DOMContentLoaded", () => {
  window.handleRoleDropdownToggle();
  window.handleRoleFiltering();
});

// Re-initialize on Turbo navigation
document.addEventListener("turbo:load", () => {
  window.handleRoleDropdownToggle();
  window.handleRoleFiltering();
});
