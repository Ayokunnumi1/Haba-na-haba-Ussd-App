const toggleDropdown = (requestId) => {
  const dropdown = document.getElementById(`dropdown-${requestId}`);
  dropdown.classList.toggle("hidden");
}

window.toggleDropdown = toggleDropdown;