// app/javascript/packs/nested_forms.js
document.addEventListener("DOMContentLoaded", () => {
    document.body.addEventListener("click", (e) => {
      if (e.target && e.target.matches(".add_fields")) {
        e.preventDefault();
        const link = e.target;
        const association = link.dataset.association;
        const content = link.dataset.fields.replace(/new_record/g, new Date().getTime());
        const target = link.closest('.nested-fields');
        target.insertAdjacentHTML("beforebegin", content);
      }
    });
  });
  