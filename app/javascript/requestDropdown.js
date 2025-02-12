const toggleDropdown = (requestId, event) => {
  const requestDropDown = document.getElementById(`dropdown-${requestId}`);

  if (!requestDropDown) {
    console.error(`Dropdown with ID dropdown-${requestId} not found.`);
    return;
  }

  const button = event.currentTarget; // Gets the clicked button element
  const requestType = button.getAttribute("data-request-type");

  // Toggle the dropdown visibility
  requestDropDown.classList.toggle("hidden");

  const links = requestDropDown.querySelectorAll("a, form");

  links.forEach((link) => {
    if (requestType === "food_request") {
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
      link.style.display = "block";
    }
  });

  // Close dropdown when clicking outside
  const handleClickOutside = (event) => {
    if (
      !requestDropDown.contains(event.target) &&
      !button.contains(event.target)
    ) {
      requestDropDown.classList.add("hidden");
      document.removeEventListener("click", handleClickOutside);
    }
  };

  setTimeout(() => {
    document.addEventListener("click", handleClickOutside);
  }, 0);
};

// Ensure the function is globally accessible
window.toggleDropdown = toggleDropdown;
