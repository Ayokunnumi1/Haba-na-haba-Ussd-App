// Make the dropdown function globally accessible by attaching to window
window.handleUserDropdown = function (e) {
  const button = e.target.closest("button[id^='userDropDwnBtn']");
  if (button) {
    const userId = button.id.replace("userDropDwnBtn", "");
    const userDropDownMenu = document.getElementById(
      `userDropDwnMenu${userId}`
    );

    if (userDropDownMenu) {
      userDropDownMenu.classList.toggle("hidden");
    }
  }
};

// Initialize on DOMContentLoaded
document.addEventListener("DOMContentLoaded", () => {
  document.addEventListener("click", window.handleUserDropdown);
});

// Re-initialize on Turbo navigation
document.addEventListener("turbo:load", () => {
  // Remove and re-add to prevent duplicate handlers
  document.removeEventListener("click", window.handleUserDropdown);
  document.addEventListener("click", window.handleUserDropdown);
});
