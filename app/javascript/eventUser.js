document.addEventListener("turbo:load", function () {
  const searchInput = document.getElementById("user_search");
  const usersList = document.getElementById("users-list");
  const roleFilter = document.getElementById("role_filter");

  // Exit early if any of the required elements don't exist
  if (!searchInput || !usersList || !roleFilter) return;

  // Listen for user input to search and filter
  searchInput.addEventListener("input", filterUsers);
  roleFilter.addEventListener("change", filterUsers);

  function filterUsers() {
    const searchText = searchInput.value.toLowerCase();
    const selectedRole = roleFilter.value;

    // Get all users' data
    const users = usersList.getElementsByClassName("user-item");

    Array.from(users).forEach((user) => {
      const userNameElement = user.querySelector(".user-name");
      const userPhoneElement = user.querySelector(".user-phone");
      const userRoleElement = user.querySelector(".user-role");

      // Skip this user if any required elements are missing
      if (!userNameElement || !userPhoneElement || !userRoleElement) return;

      const userName = userNameElement.textContent.toLowerCase();
      const userPhone = userPhoneElement.textContent.toLowerCase();
      const userRole = userRoleElement.textContent.toLowerCase();

      // Filter logic
      const matchesSearch =
        userName.includes(searchText) || userPhone.includes(searchText);
      const matchesRole =
        selectedRole === "all" || userRole.includes(selectedRole);

      // Show or hide user based on matches
      if (matchesSearch && matchesRole) {
        user.style.display = "";
      } else {
        user.style.display = "none";
      }
    });
  }
});
