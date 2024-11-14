document.addEventListener("DOMContentLoaded", function () {
  const dropdownItems = document.querySelectorAll("#dropdownId2 [data-role]");
  const userElements = document.querySelectorAll(
    ".users-grid [data-users-type]"
  );

  dropdownItems.forEach((item) => {
    item.addEventListener("click", function () {
      const role = this.getAttribute("data-role");

      userElements.forEach((user) => {
        if (user.getAttribute("data-users-type") === role) {
          user.style.display = "block";
        } else {
          user.style.display = "none";
        }
      });
    });
  });
});
