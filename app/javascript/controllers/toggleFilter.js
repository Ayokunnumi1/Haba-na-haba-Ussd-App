function toggleFilter() {
  const filterForm = document.querySelector(".filter-form");
  const toggleButton = document.querySelector(".toggle-button");
  const clearFilter = document.querySelector(".clear-filter");

  filterForm.classList.toggle("hidden");
  toggleButton.classList.toggle("hidden");
  clearFilter.classList.add("hidden");
}

function handleFilterSubmit(event) {
  event.preventDefault();
  const form = event.target;
  const filterForm = document.querySelector(".filter-form");
  const toggleButton = document.querySelector(".toggle-button");
  const clearFilter = document.querySelector(".clear-filter");

  form.submit();

  filterForm.classList.add("hidden");
  toggleButton.classList.remove("hidden");
  clearFilter.classList.remove("hidden");
}

window.toggleFilter = toggleFilter;
window.handleFilterSubmit = handleFilterSubmit;
