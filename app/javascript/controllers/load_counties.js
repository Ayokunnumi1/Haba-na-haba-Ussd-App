// Track whether listeners have been initialized
let listenersInitialized = false;

function initializeDistrictCountyListeners() {
  // If already initialized on this page load, don't duplicate listeners
  if (listenersInitialized) return;
  
  const districtSelect = document.querySelector(".district-select");
  const countySelect = document.querySelector(".county-select");
  const subCountySelect = document.querySelector(".sub-county-select");

  if (districtSelect && countySelect) {
    // Clear any existing listeners by cloning and replacing elements
    const newDistrictSelect = districtSelect.cloneNode(true);
    districtSelect.parentNode.replaceChild(newDistrictSelect, districtSelect);
    
    const newCountySelect = countySelect.cloneNode(true);
    countySelect.parentNode.replaceChild(newCountySelect, countySelect);
    
    // Clone and replace sub-county select if it exists
    let newSubCountySelect;
    if (subCountySelect) {
      newSubCountySelect = subCountySelect.cloneNode(true);
      subCountySelect.parentNode.replaceChild(newSubCountySelect, subCountySelect);
    }
    
    // Re-assign variables to the new elements
    const districtSelectNew = document.querySelector(".district-select");
    const countySelectNew = document.querySelector(".county-select");
    const subCountySelectNew = document.querySelector(".sub-county-select");
    
    function fetchCounties(districtId, contextPath) {
  // Store currently selected value if it exists
  const selectedCountyId = countySelectNew.dataset.selectedId;
  
  // Clear existing options
  countySelectNew.innerHTML = "<option value=''>Select County</option>";
  if (subCountySelectNew) subCountySelectNew.innerHTML = "<option value=''>Select Sub-County</option>";

  if (districtId) {
    fetch(`/${contextPath}/load_counties?district_id=${districtId}`)
      .then((response) => response.json())
      .then((data) => {
        data.forEach((county) => {
          const option = document.createElement("option");
          option.value = county.id;
          option.text = county.name;
          // Restore selection if this was the previously selected county
          if (selectedCountyId && county.id == selectedCountyId) {
            option.selected = true;
          }
          countySelectNew.appendChild(option);
        });
        
        // If we have a selected county, make sure to load its sub-counties
        if (selectedCountyId) {
          fetchSubCounties(selectedCountyId, contextPath);
        }
      })
      .catch((error) => {
        console.error(`Error loading counties: ${error.message}`);
      });
  }
}

function fetchSubCounties(countyId, contextPath) {
  if (!subCountySelectNew) return;
  
  // Store currently selected value if it exists
  const selectedSubCountyId = subCountySelectNew.dataset.selectedId;
  
  subCountySelectNew.innerHTML = "<option value=''>Select Sub-County</option>";
  
  if (countyId) {
    fetch(`/${contextPath}/load_sub_counties?county_id=${countyId}`)
      .then((response) => response.json())
      .then((data) => {
        data.forEach((subCounty) => {
          const option = document.createElement("option");
          option.value = subCounty.id;
          option.text = subCounty.name;
          // Restore selection if this was the previously selected sub-county
          if (selectedSubCountyId && subCounty.id == selectedSubCountyId) {
            option.selected = true;
          }
          subCountySelectNew.appendChild(option);
        });
      })
      .catch((error) => {
        console.error(`Error loading sub-counties: ${error.message}`);
      });
  }
}

    // District change event
    districtSelectNew.addEventListener("change", function () {
      const districtId = districtSelectNew.value;
      const contextPath = districtSelectNew.dataset.contextPath || "";
      fetchCounties(districtId, contextPath);
    });

    // County change event
    if (countySelectNew && subCountySelectNew) {
      countySelectNew.addEventListener("change", function () {
        const countyId = countySelectNew.value;
        const contextPath = districtSelectNew.dataset.contextPath || "";
        fetchSubCounties(countyId, contextPath);
      });
    }

    // Load initial data if needed
    const initialDistrictId = districtSelectNew.value;
    if (initialDistrictId) {
      const contextPath = districtSelectNew.dataset.contextPath || "";
      fetchCounties(initialDistrictId, contextPath);
      
      // If there's an initial county value, load sub-counties
      setTimeout(() => {
        const initialCountyId = countySelectNew.value;
        if (initialCountyId) {
          fetchSubCounties(initialCountyId, contextPath);
        }
      }, 300);
    }
    
    // Mark as initialized
    listenersInitialized = true;
  }
}

// Use turbo:load instead of turbo:render to avoid multiple initializations
document.addEventListener("turbo:load", initializeDistrictCountyListeners);
document.addEventListener("DOMContentLoaded", initializeDistrictCountyListeners);

// Reset initialization flag when navigating away
document.addEventListener("turbo:before-visit", function() {
  listenersInitialized = false;
});