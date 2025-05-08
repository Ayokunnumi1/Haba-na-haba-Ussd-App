import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
import "modal";  // Remove the ./
import "controllers/load_counties";  // Remove the ./
import "controllers/load_sub_counties";  // Remove the ./
import "controllers/load_counties_modal";  // Remove the ./
import "requestDropdown";
import "controllers/toggleFilter";  // Remove the ./
import "dropdown";  // Remove the ./
import "nested_forms";  // Remove the ./
import "district";  // Remove the ./
import "truncate";
import "chartkick";
import "Chart.bundle";
import "users/filterUsers";  // Remove the ./
import "users/userDropDown";  // Remove the ./
import "controllers/filter_modal";  // Remove the ./
import "dashboard";  // Remove the ./
import "eventUser";  // Remove the ./
import "eventTab";  // Remove the ./
import "inventoryDonorType";
import "scroll_to_top";  // Remove the ./

// The rest remains the same
// And add this for proper initialization with Turbo
document.addEventListener("turbo:load", function() {
  // Use window.initFlowbite if it's attached to window
  if (typeof window.initFlowbite === 'function') {
    window.initFlowbite();
  } 
  // Or try looking for Flowbite global if available
  else if (typeof Flowbite !== 'undefined' && typeof Flowbite.init === 'function') {
    Flowbite.init();
  }
});

if ("serviceWorker" in navigator) {
  navigator.serviceWorker
    .register("/service-worker.js", { scope: "./" })
    .then((registration) => {
      let serviceWorker;
      const kindElement = document.querySelector("#kind");
      
      if (registration.installing) {
        serviceWorker = registration.installing;
        if (kindElement) kindElement.textContent = "installing";
      } else if (registration.waiting) {
        serviceWorker = registration.waiting;
        if (kindElement) kindElement.textContent = "waiting";
      } else if (registration.active) {
        serviceWorker = registration.active;
        if (kindElement) kindElement.textContent = "active";
      }

      if (serviceWorker && kindElement) {
        serviceWorker.addEventListener("statechange", (e) => {
          kindElement.textContent = e.target.state;
        });
      }
    })
    .catch(() => {
      // Handle registration failure silently
    });
}