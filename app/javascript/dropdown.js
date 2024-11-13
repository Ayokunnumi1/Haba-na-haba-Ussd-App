document.addEventListener('click', function (event) {
    const button = event.target.closest('.dropdown-toggle');

    // Toggle dropdown if the button was clicked
    if (button) {
        const dropdown = button.nextElementSibling;
        dropdown.classList.toggle('hidden');
        event.stopPropagation();
    } else {
        // Close all dropdowns if clicking outside
        document.querySelectorAll('.relative .absolute').forEach(dropdown => {
            dropdown.classList.add('hidden');
        });
    }
});
