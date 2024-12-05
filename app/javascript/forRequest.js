// document.addEventListener("turbo:load", () => {
//   const url = window.location.href;
//   const requestDistrictId = url.split("/")[4]; // Extract request ID from URL
//     console.log("Request ID:", requestDistrictId);
    
//     document
//     .getElementById("request-district-select")
//     .addEventListener("change", function () {
//       let districtId = this.value;

//       fetch(
//         `/requests/${requestDistrictId}/inventories/load_counties?district_id=${districtId}`
//       )
//         .then((response) => response.json())
//         .then((counties) => {
//           let countySelect = document.getElementById("request-county-select");
//           countySelect.innerHTML = '<option value="">Select a county</option>';
//           counties.forEach((county) => {
//             let option = document.createElement("option");
//             option.value = county.id;
//             option.text = county.name;
//             countySelect.appendChild(option);
//           });
//         });

//       fetch(
//         `/requests/${requestDistrictId}/inventories/load_sub_counties?district_id=${districtId}`
//       )
//         .then((response) => response.json())
//         .then((subCounties) => {
//           let subCountySelect = document.getElementById(
//             "request-sub-county-select"
//           );
//           subCountySelect.innerHTML =
//             '<option value="">Select a sub-county</option>';
//           subCounties.forEach((subCounty) => {
//             let option = document.createElement("option");
//             option.value = subCounty.id;
//             option.text = subCounty.name;
//             subCountySelect.appendChild(option);
//           });
//         });
//     });

// //   fetch(`/requests/load_branches?district_id=${districtId}`)
// //     .then((response) => response.json())
// //     .then((branches) => {
// //       let branchSelect = document.getElementById("request-branch-select");
// //       branchSelect.innerHTML = '<option value="">Select a branch</option>';
// //       branches.forEach((branch) => {
// //         let option = document.createElement("option");
// //         option.value = branch.id;
// //         option.text = branch.name;
// //         branchSelect.appendChild(option);
// //       });
// //     });
// });
