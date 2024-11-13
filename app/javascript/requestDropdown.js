const toggleDropdown = (requestId) => {
  console.log(`toggleDropdown called with requestId: ${requestId}`);

  const dropdown = document.getElementById(`dropdown-${requestId}`);
  console.log(`Dropdown element:`, dropdown);

  const button = document.querySelector(
    `button[onclick="toggleDropdown(${requestId})"]`
  );
  console.log(`Button element:`, button);

  const requestType = button.getAttribute("data-request-type");
  console.log(`Request type: ${requestType}`);

  if (dropdown) {
    dropdown.classList.toggle("hidden");
    console.log(`Toggled 'hidden' class for dropdown-${requestId}`);

    const links = dropdown.querySelectorAll("a, form");
    console.log(`Links in dropdown:`, links);

    links.forEach((link) => {
      if (requestType === "Donation") {
        // Show all links except 'Individual Beneficiary', 'Family Beneficiary', and 'Organization Beneficiary'
        if (
          link.href &&
          (link.href.includes("individual_beneficiary") ||
            link.href.includes("family_beneficiary") ||
            link.href.includes("organization_beneficiary"))
        ) {
          link.style.display = "none";
          console.log(`Hiding link: ${link.href}`);
        } else {
          link.style.display = "block";
          console.log(`Showing link: ${link.href}`);
        }
      } else if (requestType === "Beneficiary") {
        // Show all links except the one with 'inventories/new' in its href
        if (link.href && link.href.includes("inventories/new")) {
          link.style.display = "none";
          console.log(`Hiding link: ${link.href}`);
        } else {
          link.style.display = "block";
          console.log(`Showing link: ${link.href}`);
        }
      } else {
        // Default case: show all links
        link.style.display = "block";
        console.log(`Showing link: ${link.href}`);
      }
    });
  } else {
    console.error(`Dropdown with ID dropdown-${requestId} not found.`);
  }
};

// Make the function available globally
window.toggleDropdown = toggleDropdown;
