  document.addEventListener('DOMContentLoaded', function() {
    function truncateText(element, maxLength) {
      if (element.textContent.length > maxLength) {
        element.textContent = element.textContent.substring(0, maxLength) + '..';
      }
    }

    function applyTruncation() {
      const screenWidth = window.innerWidth;
      const maxLength = 5;
      const elements = document.querySelectorAll('[id^="user-first-name-"]');

      elements.forEach(function(element) {
        if (screenWidth <= 320) {
          truncateText(element, maxLength);
        } else {
          element.textContent = element.getAttribute('data-full-name');
        }
      });
    }

    applyTruncation();
    window.addEventListener('resize', applyTruncation);
  });