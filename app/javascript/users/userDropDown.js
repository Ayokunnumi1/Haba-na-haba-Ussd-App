document.addEventListener("DOMContentLoaded", () => {
    document.addEventListener("click",  (e) => {
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
  });
});
