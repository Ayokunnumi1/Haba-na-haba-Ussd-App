document.addEventListener('click', function (event) {
    const button = event.target.closest('.dropdown-toggle');
    if (button) {
        const dropdown = button.nextElementSibling;
        dropdown.classList.toggle('hidden');
        event.stopPropagation();
    } else {
        document.querySelectorAll('.relative .absolute').forEach(dropdown => {
            dropdown.classList.add('hidden');
        });
    }
});