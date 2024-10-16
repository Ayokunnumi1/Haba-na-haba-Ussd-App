// app/javascript/controllers/load_counties.js
document.addEventListener("turbo:load", function () {
  const districtSelect = document.getElementById("district-select");
  const countySelect = document.getElementById("county-select");

  if (districtSelect) {
    districtSelect.addEventListener("change", function () {
      const districtId = districtSelect.value;

      // Clear out the county dropdown
      countySelect.innerHTML = "<option value=''>Select County</option>";

      if (districtId) {
        fetch(`/branches/load_counties?district_id=${districtId}`)
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
