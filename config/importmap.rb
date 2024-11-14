# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@2.5.2/dist/flowbite.turbo.min.js"
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"
pin "select2", to: "https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"
pin "select2-css", to: "https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css"
pin "dropdown", to: "dropdown.js"