# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

BuckyBox::Application.configure do
  # Precompile additional assets
  config.assets.precompile += %w(admin.js admin.css distributor.js distributor.css customer.js customer.css print.js print.css)
  config.assets.precompile += %w(sign_up_wizard.js sign_up_wizard.css)
  config.assets.precompile += %w(vendor/leaflet.js vendor/leaflet.css)
  config.assets.precompile += %w(vendor/Chart.min.js)
end
