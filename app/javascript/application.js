import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
import "./modal.js";
import "./controllers/load_counties.js";
import "./controllers/load_sub_counties.js";
import "./controllers/load_counties_modal.js";
import "./requestDropdown.js";
import "./controllers/toggleFilter.js";
import "./dropdown.js";
import "./nested_forms.js";
import "./district.js";
import "truncate.js";
import "chartkick.js";
import "Chart.bundle.js";
import "./users/filterUsers.js";
import "./users/userDropDown.js";
import "./controllers/filter_modal.js";
import "./dashboard.js";
import "./eventUser.js";
import "./eventTab.js";
import "inventoryDonorType.js";
import "./scroll_to_top.js";

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