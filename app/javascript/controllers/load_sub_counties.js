document.addEventListener("turbo:load", function () {
  const countySelect = document.querySelector(".county-select");
  const subCountySelect = document.querySelector(".sub-county-select");

  if (countySelect) {
    countySelect.addEventListener("change", function () {
      const countyId = countySelect.value;
      const contextPath = countySelect.dataset.contextPath || "";

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
          .catch((error) => {
            throw new Error(`Error loading sub-counties: ${error.message}`);
          });
      }
    });
  }
});
