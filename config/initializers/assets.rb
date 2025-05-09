# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
# Be sure to restart your server when you modify this file.

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("app/javascript")
Rails.application.config.assets.paths << Rails.root.join("app/javascript/controllers")
Rails.application.config.assets.paths << Rails.root.join("app/javascript/users")

# Add all JavaScript files to precompile array
Rails.application.config.assets.precompile += %w(
  modal.js 
  controllers/load_counties.js
  controllers/load_sub_counties.js
  controllers/load_counties_modal.js
  controllers/toggleFilter.js
  dropdown.js
  nested_forms.js
  district.js
  users/filterUsers.js
  users/userDropDown.js
  controllers/filter_modal.js
  dashboard.js
  eventUser.js
  eventTab.js
  scroll_to_top.js
)