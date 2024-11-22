document.addEventListener("turbo:load", function () {
  // Dropdown toggle functionality
  const dropDownButton = document.querySelector("#dropDownMenuBtn");
  const dropDownMenu = document.querySelector("#dropDownMenu");

  dropDownButton.addEventListener("click", function () {
    console.log("clicked");
    dropDownMenu.classList.toggle("hidden");
  });

  // Role filtering functionality
  const dropdownItems = document.querySelectorAll("#dropDownItems");
  const userElements = document.querySelectorAll("#users-grid");

  dropdownItems.forEach((item) => {
    item.addEventListener("click", function () {
      const role = this.getAttribute("data-role");

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
});