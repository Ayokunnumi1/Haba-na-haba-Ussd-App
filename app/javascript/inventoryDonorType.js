document.addEventListener("turbo:load", function () {
console.log("group")
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


document.addEventListener("turbo:load", function () {
    const requestTypeSelect = document.getElementById("request_type");
    const foodTypeFields = document.getElementById("food-type-select");
    const foodNameField = document.getElementById("food-name-select");
    
    function toggleFields() {
        const selectedType = requestTypeSelect.value;
        console.log(selectedType, "Selected")

        foodTypeFields.classList.add("hidden");
        foodNameField.classList.add("hidden");

    
        if (selectedType === "food_donation") {
            foodTypeFields.classList.remove("hidden");
            foodNameField.classList.remove('hidden');
        } else if (selectedType === "food_request") {
            foodTypeFields.classList.add("hidden");
            foodNameField.classList.add('hidden');
        }
    }
    
    toggleFields();
    
    requestTypeSelect.addEventListener("change", toggleFields);
    });
        
