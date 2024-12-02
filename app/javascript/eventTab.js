document.addEventListener("DOMContentLoaded", () => {
    const tabs = document.querySelectorAll(".tab-btn");
    const panels = document.querySelectorAll(".tab-panel");

    tabs.forEach(tab => {
        tab.addEventListener("click", () => {
            const target = tab.getAttribute("data-tab-target");

            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove("text-blue-600", "border-blue-600"));
            // Add active class to the clicked tab
            tab.classList.add("text-blue-600", "border-blue-600");

            // Hide all panels
            panels.forEach(panel => panel.classList.add("hidden"));
            // Show the targeted panel
            document.querySelector(`[data-tab="${target}"]`).classList.remove("hidden");
        });
    });
});
