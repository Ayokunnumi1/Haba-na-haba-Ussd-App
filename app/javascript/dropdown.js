document.addEventListener("turbo:load", function () {
  const districtSelect = document.querySelector(".district-select");
  const countySelect = document.querySelector(".county-select");
  const subCountySelect = document.querySelector(".sub-county-select");

  if (districtSelect) {
    districtSelect.addEventListener("change", function () {
      const districtId = this.value;
      const contextPath = this.getAttribute("data-context-path");
      fetch(`/requests/load_counties?district_id=${districtId}`)
        .then((response) => response.json())
        .then((data) => {
          countySelect.innerHTML = '<option value="">Select a county</option>';
          data.forEach((county) => {
            const option = document.createElement("option");
            option.value = county.id;
            option.text = county.name;
            countySelect.appendChild(option);
          });
          subCountySelect.innerHTML = '<option value="">Select a sub-county</option>';
        });
    });
  }

  if (countySelect) {
    countySelect.addEventListener("change", function () {
      const countyId = this.value;
      fetch(`/requests/load_sub_counties?county_id=${countyId}`)
        .then((response) => response.json())
        .then((data) => {
          subCountySelect.innerHTML = '<option value="">Select a sub-county</option>';
          data.forEach((subCounty) => {
            const option = document.createElement("option");
            option.value = subCounty.id;
            option.text = subCounty.name;
            subCountySelect.appendChild(option);
          });
        });
    });
  }
});