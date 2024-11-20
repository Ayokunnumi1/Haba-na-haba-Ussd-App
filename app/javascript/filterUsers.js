document.addEventListener("turbo:load", function () {
  const dropdownItems = document.querySelectorAll("#dropdownId2 [data-role]");
  const userElements = document.querySelectorAll(
    ".users-grid [data-users-type]"
  );

  dropdownItems.forEach((item) => {
    item.addEventListener("click", function () {
      const role = this.getAttribute("data-role");

      userElements.forEach((user) => {
        if (user.getAttribute("data-users-type") === role) {
          user.classList.remove("hidden");
          user.classList.add("flex", "mmd:block");
        } else {
          user.classList.add("hidden");
          user.classList.remove("flex", "mmd:block");
        }
      });
    });
  });
});
