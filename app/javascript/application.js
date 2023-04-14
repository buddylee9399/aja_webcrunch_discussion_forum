// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
$(document).on('turbo:load', function() {
  // alert('hi');
  $('.notification').delay(2000).fadeOut(2000);
});