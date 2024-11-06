document.addEventListener("turbo:load", function() {
    const selectCheckbox = document.getElementById("select-all");
    const donorRequestChecks = document.querySelectorAll(".donor-request-checkbox");
    const bulkDeleteBtn = document.querySelector("#bulk-delete");


    selectCheckbox.addEventListener("change", () => {
        donorRequestChecks.forEach(requestCheck => {
            requestCheck.checked = selectCheckbox.checked;
        })
    })

    bulkDeleteBtn.addEventListener("click", () => {
        const selectedIds = Array.from(donorRequestChecks)
          .filter(checkbox => checkbox.checked)
          .map(checkbox => checkbox.value);
    
        if (selectedIds.length > 0) {
          if (confirm("Are you sure you want to delete the selected items?")) {
            fetch("/requests/bulk_delete", {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
              },
              body: JSON.stringify({ ids: selectedIds })
            }).then(response => {
              if (response.ok) {
                location.reload();
              } else {
                alert("Failed to delete items.");
              }
            });
          }
        } else {
          alert("No items selected.");
        }
      });

})