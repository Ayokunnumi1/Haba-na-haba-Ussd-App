document.addEventListener("turbo:load", () => {
  document.body.addEventListener("click", (e) => {
    if (e.target && e.target.matches(".add_fields")) {
      e.preventDefault();
      
      // Get the clicked link and its associated data
      const link = e.target;
      const association = link.dataset.association;
      const content = link.dataset.fields.replace(/new_record/g, new Date().getTime());
      
      // Insert the new fields before the link
      link.insertAdjacentHTML("beforebegin", content);

      // Hide the "Add County" or "Add Sub-County" button after clicking
      link.style.display = 'none';
    }
  });
});
