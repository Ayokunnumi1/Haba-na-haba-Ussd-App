document.addEventListener("DOMContentLoaded", function () {
  function truncateText(element, maxLength) {
    if (element.textContent.length > maxLength) {
      element.textContent = element.textContent.substring(0, maxLength) + "..";
    }
  }

  function applyTruncation() {
    const screenWidth = window.innerWidth;
    const maxLength = 5;

    // Truncate first names
    const firstNameElements = document.querySelectorAll(
      '[id^="user-first-name-"]'
    );
    firstNameElements.forEach(function (element) {
      if (screenWidth <= 320) {
        truncateText(element, maxLength);
      } else {
        element.textContent = element.getAttribute("data-full-name");
      }
    });

    // Truncate roles
    const roleElements = document.querySelectorAll('[id^="user-role-"]');
    roleElements.forEach(function (element) {
      if (screenWidth <= 320) {
        truncateText(element, maxLength);
      } else {
        element.textContent = element.getAttribute("data-role-full");
      }
    });
  }

  applyTruncation();
  window.addEventListener("resize", applyTruncation);
});
