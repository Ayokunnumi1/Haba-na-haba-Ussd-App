// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "./controllers";
import "./controllers/load_counties";
import "./controllers/load_sub_counties";
import "./dropdown";
import "flowbite"
import 'select2/dist/css/select2.min.css';
import $ from 'jquery';
import 'select2';


window.jQuery = $;
window.$ = $;

$(document).on('turbolinks:load', function() {
  // Initialize select2 for the user select element
  $('#user_ids').select2({
    placeholder: 'Select users',
    allowClear: true
  });
});
