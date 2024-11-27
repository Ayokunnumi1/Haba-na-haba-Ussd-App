document.addEventListener("turbo:load", function() {
  const searchInput = document.getElementById("user_search");
  const usersList = document.getElementById("users-list");
  const roleFilter = document.getElementById("role_filter");

  // Listen for user input to search and filter
  searchInput.addEventListener("input", filterUsers);
  roleFilter.addEventListener("change", filterUsers);

  function filterUsers() {
      const searchText = searchInput.value.toLowerCase();
      const selectedRole = roleFilter.value;
      
      // Get all users' data (we assume you have this data set up in your form already)
      const users = usersList.getElementsByClassName("user-item");
      
      Array.from(users).forEach(user => {
          const userName = user.querySelector(".user-name").textContent.toLowerCase();
          const userPhone = user.querySelector(".user-phone").textContent.toLowerCase();
          const userRole = user.querySelector(".user-role").textContent.toLowerCase();

          // Filter logic
          const matchesSearch = userName.includes(searchText) || userPhone.includes(searchText);
          const matchesRole = selectedRole === "all" || userRole.includes(selectedRole);

          // Show or hide user based on matches
          if (matchesSearch && matchesRole) {
              user.style.display = "";
          } else {
              user.style.display = "none";
          }
      });
  }
});
