// districts.js
(function () {
  // Store a reference to the handler to ensure proper removal
  let handleAddFields = null;

  // Initialize event listeners
  function initializeAddFields() {
    // Remove any existing listener to prevent duplicates
    if (handleAddFields) {
      document.body.removeEventListener("click", handleAddFields);
    }

    // Define the handler
    handleAddFields = function (e) {
      if (e.target.matches(".add_fields")) {
        e.preventDefault();
        e.stopImmediatePropagation(); // Stop all propagation to prevent double triggers

        console.log("Add fields clicked:", e.target); // Debug: Log the clicked element

        const link = e.target;
        const association = link.dataset.association;
        const content = link.dataset.fields.replace(/new_record/g, new Date().getTime());

        // Determine the target container
        let targetContainer;
        if (association === "counties") {
          targetContainer = document.querySelector("#counties");
        } else if (association === "sub_counties") {
          targetContainer = link.closest(".nested-fields").querySelector(".sub-counties");
        }

        // Insert the new fields
        if (targetContainer) {
          targetContainer.insertAdjacentHTML("beforeend", content);
        } else {
          link.insertAdjacentHTML("beforebegin", content);
        }

        // Hide the clicked link
        link.style.display = "none";
      }
    };

    // Attach the listener
    document.body.addEventListener("click", handleAddFields);
    console.log("Add fields listener attached"); // Debug: Confirm listener attachment
  }

  // Listen for Turbo events
  document.addEventListener("turbo:load", initializeAddFields);
  document.addEventListener("turbo:render", initializeAddFields); // Handle Turbo frame renders

  // Cleanup on Turbo cache
  document.addEventListener("turbo:before-cache", () => {
    if (handleAddFields) {
      document.body.removeEventListener("click", handleAddFields);
      console.log("Add fields listener removed before cache"); // Debug: Confirm removal
    }
  });
})();