document.addEventListener("DOMContentLoaded", () => {
  document.body.addEventListener("click", (e) => {
    if (e.target && e.target.matches(".add_fields")) {
      e.preventDefault();
      const link = e.target;
      const association = link.dataset.association;
      const content = link.dataset.fields.replace(/new_record/g, new Date().getTime());
      link.insertAdjacentHTML("beforebegin", content);
    }
  });
});
