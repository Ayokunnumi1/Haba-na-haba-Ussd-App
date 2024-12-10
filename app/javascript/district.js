document.addEventListener("turbo:load", () => {
    const toggleButton = document.getElementById("edit-district-toggle");
    const formContainer = document.getElementById("edit-district-form");

    toggleButton.addEventListener("click", (event) => {
      event.preventDefault(); // Prevent the default link action
      formContainer.classList.toggle("hidden"); // Toggle the visibility
    });
  });