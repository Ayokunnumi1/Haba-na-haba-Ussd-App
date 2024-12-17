document.addEventListener("turbo:load", function () {
  const districtSelect = document.querySelector(".district-select");
  const countySelect = document.querySelector(".county-select");

  if (districtSelect) {
    districtSelect.addEventListener("change", function () {
      const districtId = districtSelect.value;
      const contextPath = districtSelect.dataset.contextPath || "";

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
            throw new Error(`Error loading counties: ${error.message}`);
          });
      }
    });
  }
});
