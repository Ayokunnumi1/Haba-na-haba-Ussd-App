document.addEventListener("turbo:load", function() {
  RequestType = document.getElementById("request_type");
  console.log(RequestType);
  console.log("fffgds");

  
  function toggleFields() {
   const selectedRequestTypeValue = RequestType.value;
   const foodType = document.getElementById("food-type");
   console.log(foodType);
   console.log(selectedRequestTypeValue);


   if (selectedRequestTypeValue === "food_request") {
    foodType.classList.add("hidden");
   } else if (selectedRequestTypeValue === "food_donation") {
    foodType.classList.remove("hidden");
   } 
  }

  toggleFields();


  RequestType.addEventListener("change", toggleFields);

});