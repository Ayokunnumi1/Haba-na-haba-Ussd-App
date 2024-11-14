document.addEventListener("turbo:load", function () {
  const districtSelect = document.getElementById("district-select");
  const countySelect = document.getElementById("county-select");

  if (districtSelect) {
    districtSelect.addEventListener("change", function () {
      const selectedDistrictIds = Array.from(districtSelect.selectedOptions).map(option => option.value);
      const contextPath = districtSelect.dataset.contextPath || "";

      countySelect.innerHTML = "<option value=''>Select County</option>";

      if (selectedDistrictIds.length > 0) {
        fetch(`/${contextPath}/load_counties?district_ids=${selectedDistrictIds.join(",")}`)
          .then((response) => response.json())
          .then((data) => {
            data.forEach((county) => {
              const option = document.createElement("option");
              option.value = county.id;
              option.text = county.name;
              countySelect.appendChild(option);
            });
          })
          .catch((error) => console.log("Error loading counties: ", error));
      }
    });
  }
});
