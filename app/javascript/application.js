// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Remove the flash message after 5 seconds
document.addEventListener('turbo:load', function() {
  setTimeout(function() {
  var alertElement = document.querySelector('[role="alert"]');
  if (alertElement) {
    alertElement.remove();
  }}, 1500);
});