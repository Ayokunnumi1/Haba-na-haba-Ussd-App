// Get the button
const scrollToTopBtn = document.getElementById('scrollToTopBtn');

// Show the button when the user scrolls down 20px from the top of the document
window.onscroll = function() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    scrollToTopBtn.classList.remove('hidden');
  } else {
    scrollToTopBtn.classList.add('hidden');
  }
};

// Scroll to the top of the document when the button is clicked
scrollToTopBtn.onclick = function() {
  window.scrollTo({ top: 0, behavior: 'smooth' });
};