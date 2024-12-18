function initializeDependentSelects() {
  const districtSelects = document.querySelectorAll("[id^='district-select-']");

  districtSelects.forEach((districtSelect) => {
    const uuid = districtSelect.dataset.uuid;
    const countySelect = document.querySelector(`#county-select-${uuid}`);
    const subCountySelect = document.querySelector(`#sub-county-select-${uuid}`);
    const contextPath = districtSelect.dataset.contextPath || "";

    // Preload counties and sub-counties if a district is already selected
    const preloadData = () => {
      const districtId = districtSelect.value;

      if (districtId) {
        fetch(`/${contextPath}/load_counties?district_id=${districtId}`)
          .then((res) => res.json())
          .then((data) => {
            countySelect.innerHTML = "<option value=''>Select County</option>";

            data.forEach((county) => {
              const option = document.createElement("option");
              option.value = county.id;
              option.textContent = county.name;
              countySelect.appendChild(option);
            });

            // Pre-select the county if applicable
            const selectedCountyId = countySelect.dataset.selected;
            if (selectedCountyId) {
              countySelect.value = selectedCountyId;
              countySelect.dispatchEvent(new Event("change"));
            }
          })
          .catch((error) => console.log("Error loading counties: ", error));
      }
    };

    // Add change event listener for district select
    districtSelect.addEventListener("change", function () {
      const districtId = districtSelect.value;

      // Reset dependent selects
      if (countySelect) countySelect.innerHTML = "<option value=''>Select County</option>";
      if (subCountySelect) subCountySelect.innerHTML = "<option value=''>Select Sub-County</option>";

      if (districtId) {
        // Fetch counties
        fetch(`/${contextPath}/load_counties?district_id=${districtId}`)
          .then((res) => res.json())
          .then((data) => {
            data.forEach((county) => {
              const option = document.createElement("option");
              option.value = county.id;
              option.textContent = county.name;
              countySelect.appendChild(option);
            });
          })
          .catch((error) => console.log("Error loading counties: ", error));
      }
    });

    // Add change event listener for county select
    if (countySelect) {
      countySelect.addEventListener("change", function () {
        const countyId = countySelect.value;

        subCountySelect.innerHTML = "<option value=''>Select Sub-County</option>";

        if (countyId) {
          fetch(`/${contextPath}/load_sub_counties?county_id=${countyId}`)
            .then((response) => response.json())
            .then((data) => {
              data.forEach((subCounty) => {
                const option = document.createElement("option");
                option.value = subCounty.id;
                option.text = subCounty.name;
                subCountySelect.appendChild(option);
              });
            })
            .catch((error) => console.log("Error loading sub-counties: ", error));
        }
      });
    }

    // Preload data for selected district and county on page load
    preloadData();
  });
}

// Reinitialize when Turbo renders
document.addEventListener("turbo:load", initializeDependentSelects);
document.addEventListener("turbo:render", initializeDependentSelects);
