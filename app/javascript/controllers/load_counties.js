document.addEventListener("turbo:load", function () {
  const districtSelect = document.getElementById("district-select");
  const countySelect = document.getElementById("county-select");
  const branchSelect = document.getElementById("branch-select");

  if (districtSelect) {
    districtSelect.addEventListener("change", function () {
      const districtId = districtSelect.value;
      const contextPath = districtSelect.dataset.contextPath || "";

      // Reset counties and branches
      countySelect.innerHTML = "<option value=''>Select County</option>";
      branchSelect.innerHTML = "<option value=''>Select Branch</option>";

      if (districtId) {
        // Load counties
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
          .catch((error) => console.log("Error loading counties: ", error));

        // Load branches
        fetch(`/${contextPath}/load_branches?district_id=${districtId}`)
          .then((response) => response.json())
          .then((data) => {
            data.forEach((branch) => {
              const option = document.createElement("option");
              option.value = branch.id;
              option.text = branch.name;
              branchSelect.appendChild(option);
            });
          })
          .catch((error) => console.log("Error loading branches: ", error));
      }
    });
  }
});
