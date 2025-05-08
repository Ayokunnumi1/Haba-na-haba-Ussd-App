import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
import "./modal";
import "./controllers/load_counties";
import "./controllers/load_sub_counties";
import "./controllers/load_counties_modal";
import "requestDropdown";
import "./controllers/toggleFilter";
import "./dropdown";
import "./nested_forms";
import "./district";
import "truncate";
import "chartkick";
import "Chart.bundle";
import "./users/filterUsers";
import "./users/userDropDown";
import "./controllers/filter_modal";
import "./dashboard";
import "./eventUser";
import "./eventTab";
import "inventoryDonorType";
import "./scroll_to_top";

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