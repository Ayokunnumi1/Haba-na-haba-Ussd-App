function initializeDistrictCountyListeners() {
  const districtSelect = document.querySelector(".district-select");
  const countySelect = document.querySelector(".county-select");

  if (districtSelect) {
    function fetchCounties(districtId, contextPath) {
      countySelect.innerHTML = "<option value=''>Select County</option>";

      if (districtId) {
        fetch(`/${contextPath}/load_counties?district_id=${districtId}`)
          .then((response) => response.json())
          .then((data) => {
            data.forEach((county) => {
              const option = document.createElement("option");
              option.value = county.id;
              option.text = county.name;
              countySelect.appendChild(option);
            });
          })
          .catch((error) => {
            console.error(`Error loading counties: ${error.message}`);
          });
      }
    }

    districtSelect.addEventListener("change", function () {
      const districtId = districtSelect.value;
      const contextPath = districtSelect.dataset.contextPath || "";
      fetchCounties(districtId, contextPath);
    });

    const initialDistrictId = districtSelect.value;
    if (initialDistrictId && !countySelect.value) {
      const contextPath = districtSelect.dataset.contextPath || "";
      fetchCounties(initialDistrictId, contextPath);
    }
  }
}

document.addEventListener("turbo:render", initializeDistrictCountyListeners);
