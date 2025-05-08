import "@hotwired/turbo-rails";
import "controllers";
import "./modal";
import "./controllers";
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
import { initFlowbite } from "flowbite";
document.addEventListener("turbo:load", function () {
  initFlowbite(); // Now properly imported
});

if ("serviceWorker" in navigator) {
  navigator.serviceWorker
    .register("/service-worker.js", { scope: "./" })
    .then((registration) => {
      let serviceWorker;
      if (registration.installing) {
        serviceWorker = registration.installing;
        document.querySelector("#kind").textContent = "installing";
      } else if (registration.waiting) {
        serviceWorker = registration.waiting;
        document.querySelector("#kind").textContent = "waiting";
      } else if (registration.active) {
        serviceWorker = registration.active;
        document.querySelector("#kind").textContent = "active";
      }

      // Listen for state changes in the service worker
      if (serviceWorker) {
        serviceWorker.addEventListener("statechange", (e) => {
          document.querySelector("#kind").textContent = e.target.state;
        });
      }
    })
    .catch(() => {
      // Handle registration failure silently
    });
}
