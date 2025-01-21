import "@hotwired/turbo-rails";
import "controllers";
import "flowbite";
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
import "./users/filterUsers";
import "./users/userDropDown";
import "inventoryDonorType";
import "./controllers/filter_modal";
import "./scroll_to_top";
if ("serviceWorker" in navigator) {
    navigator.serviceWorker
      .register("/service-worker.js", {
        scope: "./",
      })
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
        if (serviceWorker) {
          serviceWorker.addEventListener("statechange", (e) => {
            console.log("Service worker state changed to:", e.target.state);
          });
        }
      })
      .catch((error) => {
        console.error("Service worker registration failed:", error);
      });
  
    navigator.serviceWorker.addEventListener('message', (event) => {
      const message = event.data;
      // Handle the message from the service worker
      alert(message); // Replace this with your desired way of handling messages
    });
  } else {
    console.warn("Service workers are not supported in this browser.");
  }