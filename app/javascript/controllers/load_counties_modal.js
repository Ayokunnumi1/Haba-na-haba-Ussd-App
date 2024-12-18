document.addEventListener("turbo:load", function () {
  const districtSelects = document.querySelectorAll("[id^='district-select-']");
  
  districtSelects.forEach((districtSelect) => {
    const uuid = districtSelect.dataset.uuid;
    const countySelect = document.querySelector(`#county-select-${uuid}`);
    const subCountySelect = document.querySelector(`#sub-county-select-${uuid}`);
    const contextPath = districtSelect.dataset.contextPath || "";

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

    // Handling sub-county loading based on county select
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
  });
});