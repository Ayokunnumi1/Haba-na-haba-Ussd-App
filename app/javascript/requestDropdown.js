const toggleDropdown = (requestId) => {
  const requestDropDown = document.getElementById(`dropdown-${requestId}`);

  const button = document.querySelector(
    `button[onclick="toggleDropdown(${requestId})"]`
  );
  console.log("clicked");
  console.log(button);

  const requestType = button.getAttribute("data-request-type");
  console.log(requestType);

  if (requestDropDown) {
    requestDropDown.classList.toggle("hidden");

    const links = requestDropDown.querySelectorAll("a, form");

    links.forEach((link) => {
      if (requestType === "food_request") {
        // Hide specific links for food_request
        if (
          link.href &&
          (link.href.includes("organization_beneficiary") ||
            link.href.includes("inventories/new?type=food") ||
            link.href.includes("inventories/new?type=cash") ||
            link.href.includes("inventories/new?type=cloth") ||
            link.href.includes("inventories/new?type=other_items"))
        ) {
          link.style.display = "none";
        } else {
          link.style.display = "block";
        }
      } else {
        // Show all links for other request types
        link.style.display = "block";
      }
    });

    // Add event listener to hide dropdown when clicking outside
    const handleClickOutside = (event) => {
      if (
        !requestDropDown.contains(event.target) &&
        !button.contains(event.target)
      ) {
        requestDropDown.classList.add("hidden");
        document.removeEventListener("click", handleClickOutside);
      }
    };

    // Add the event listener only once
    setTimeout(() => {
      document.addEventListener("click", handleClickOutside);
    }, 0);
  } else {
    console.error(`Dropdown with ID dropdown-${requestId} not found.`);
  }
};

// Make the function available globally
window.toggleDropdown = toggleDropdown;
