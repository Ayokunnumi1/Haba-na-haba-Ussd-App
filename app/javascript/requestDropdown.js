const toggleDropdown = (requestId) => {
  const requestDropDown = document.getElementById(`dropdown-${requestId}`);

  const button = document.querySelector(
    `button[onclick="toggleDropdown(${requestId})"]`
  );

  const requestType = button.getAttribute("data-request-type");

  if (requestDropDown) {
    requestDropDown.classList.toggle("hidden");

    const links = requestDropDown.querySelectorAll("a, form");

    links.forEach((link) => {
      if (requestType === "food_request") {
        // Hide specific links for food_request
        if (
          link.href &&
          (link.href.includes("inventories/new?type=food") ||
            link.href.includes("inventories/new?type=cash") ||
            link.href.includes("inventories/new?type=cloth") ||
            link.href.includes("inventories/new?type=other_items"))
        ) {
          link.style.display = "none";
        } else {
          link.style.display = "block";
        }
      } else if (
        requestType === "food_donation" ||
        requestType === "cash_donation" ||
        requestType === "cloth_donation" ||
        requestType === "other_donation"
      ) {
        // Hide specific links for donation_request and others
        if (
          link.href &&
          (link.href.includes("individual_beneficiary") ||
            link.href.includes("family_beneficiary") ||
            link.href.includes("organization_beneficiary"))
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
