document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click", function (event) {
    // Check if the clicked element (or any of its ancestors) is a button with an id that starts with 'userDropDwnBtn'
    const button = event.target.closest("button[id^='userDropDwnBtn']");
    if (button) {
      // Extract the user ID from the button's id by removing the 'userDropDwnBtn' prefix
      const userId = button.id.replace("userDropDwnBtn", "");
      // Find the corresponding dropdown menu using the extracted user ID
      const userDropDownMenu = document.getElementById(
        `userDropDwnMenu${userId}`
      );

      // If the dropdown menu element exists
      if (userDropDownMenu) {
        // Toggle the 'hidden' class on the dropdown menu to show or hide it
        userDropDownMenu.classList.toggle("hidden");
      }
    }
  });
});
