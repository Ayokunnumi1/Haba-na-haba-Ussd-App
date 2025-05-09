document.addEventListener("turbo:load", () => {
  const toggleButton = document.getElementById("edit-district-toggle");
  const formContainer = document.getElementById("edit-district-form");

  // Only proceed if both elements exist
  if (!toggleButton || !formContainer) return;
  
  toggleButton.addEventListener("click", (event) => {
    event.preventDefault(); // Prevent the default link action
    formContainer.classList.toggle("hidden"); // Toggle the visibility
  });
});