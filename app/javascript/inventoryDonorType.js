document.addEventListener("turbo:load", function () {
  const donorTypeSelect = document.getElementById("donor-type-select");
  const familyFields = document.getElementById("family-fields");
  const organizationFields = document.getElementById("organization-fields");
  function toggleFields() {
    const selectedType = donorTypeSelect.value;

    familyFields.classList.add("hidden");
    organizationFields.classList.add("hidden");

    if (selectedType === "family_donor") {
      familyFields.classList.remove("hidden");
    } else if (selectedType === "organization_donor") {
      organizationFields.classList.remove("hidden");
    }
  }

  toggleFields();

  donorTypeSelect.addEventListener("change", toggleFields);
});
