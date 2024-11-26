document.addEventListener("turbo:load", () => {
    initializeUserFilter();
  });
  
  function initializeUserFilter() {
    const userFilterInput = document.getElementById("user_filter");
    const roleFilterSelect = document.getElementById("role_filter");
    const userList = document.getElementById("filtered_users");
    const selectedUsersList = document.getElementById("selected_users").querySelector("ul");
    const selectedUserIdsInput = document.getElementById("selected_user_ids_input");
  
    if (!userFilterInput || !roleFilterSelect || !userList) {
      console.error("User filter or list elements not found. Please check the HTML.");
      return;
    }
  
    const users = userList.querySelectorAll(".user-item");
  
    // Ensure all users are visible at initialization
    users.forEach((user) => (user.style.display = "block"));
  
    // Filter Users Dynamically by Name, Phone, and Role
    function filterUsers() {
      const nameQuery = userFilterInput.value.toLowerCase();
      const roleQuery = roleFilterSelect.value.toLowerCase();
  
      users.forEach((user) => {
        const userName = user.querySelector("input").dataset.userName.toLowerCase();
        const userRole = user.querySelector("input").dataset.userRole.toLowerCase();
        const userPhone = user.querySelector("input").dataset.userPhone.toLowerCase();
  
        if (
          (nameQuery === "" || userName.includes(nameQuery) || userPhone.includes(nameQuery)) &&
          (roleQuery === "" || userRole === roleQuery)
        ) {
          user.style.display = "block";
        } else {
          user.style.display = "none";
        }
      });
    }
  
    userFilterInput.addEventListener("input", filterUsers);
    roleFilterSelect.addEventListener("change", filterUsers);
  
    // Add or Remove User from Selected List
    userList.addEventListener("change", (e) => {
      if (e.target.classList.contains("user-checkbox")) {
        const userId = e.target.value;
        const userName = e.target.dataset.userName;
  
        if (e.target.checked) {
          // Add user to selected list
          const li = document.createElement("li");
          li.textContent = userName;
          li.dataset.userId = userId;
          selectedUsersList.appendChild(li);
        } else {
          // Remove user from selected list
          const listItem = selectedUsersList.querySelector(`li[data-user-id="${userId}"]`);
          if (listItem) {
            selectedUsersList.removeChild(listItem);
          }
        }
  
        // Update Hidden Input with Selected User IDs
        updateSelectedUserIds();
      }
    });
  
    // Update the Hidden Input Field with Selected User IDs
    function updateSelectedUserIds() {
      const selectedIds = Array.from(selectedUsersList.children).map((li) => li.dataset.userId);
      selectedUserIdsInput.value = selectedIds.join(",");
    }
  }
  
  // Reinitialize Filter After Form Submission
  document.addEventListener("turbo:submit-end", () => {
    initializeUserFilter();
  });
  