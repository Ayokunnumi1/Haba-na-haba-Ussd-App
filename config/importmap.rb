# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@2.5.2/dist/flowbite.turbo.min.js"
pin "flowbite", to: "/javascripts/flowbite.turbo.min.js"
pin "requestDropdown", to: "requestDropdown.js"
pin "truncate", to: "truncate.js"
pin "dropdown", to: "dropdown.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin_all_from "app/javascript/users", under: "users"
pin "dashboard", to: "dashboard.js"
pin "inventoryDonorType", to: "inventoryDonorType.js"

