document.getElementById('district-select').addEventListener('change', function() {
    let districtId = this.value;

    fetch(`/requests/load_counties?district_id=${districtId}`)
      .then(response => response.json())
      .then(counties => {
        let countySelect = document.getElementById('county-select');
        countySelect.innerHTML = '<option value="">Select a county</option>';
        counties.forEach(county => {
          let option = document.createElement('option');
          option.value = county.id;
          option.text = county.name;
          countySelect.appendChild(option);
        });
      });

    fetch(`/requests/load_branches?district_id=${districtId}`)
      .then(response => response.json())
      .then(branches => {
        let branchSelect = document.getElementById('branch-select');
        branchSelect.innerHTML = '<option value="">Select a branch</option>';
        branches.forEach(branch => {
          let option = document.createElement('option');
          option.value = branch.id;
          option.text = branch.name;
          branchSelect.appendChild(option);
        });
      });
  });
