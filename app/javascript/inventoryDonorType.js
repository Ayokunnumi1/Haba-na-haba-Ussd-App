document.addEventListener("turbo:load", function () {
  const donorTypeSelect = document.getElementById("donor-type-select");
  const familyFields = document.getElementById("family-fields");
  const organizationFields = document.getElementById("organization-fields");

  // Exit early if any required elements don't exist
  if (!donorTypeSelect || !familyFields || !organizationFields) return;

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

  // Only call these if we confirmed the elements exist
  toggleFields();
  donorTypeSelect.addEventListener("change", toggleFields);
});
