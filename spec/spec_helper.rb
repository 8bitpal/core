ENV["RAILS_ENV"] ||= 'test'

require 'simplecov' if ENV['COVERAGE']

# Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
# https://github.com/pluginaweek/state_machine/issues/163
require 'rails/application'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec' 
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = Capybara.current_driver
Capybara.asset_host = 'http://buckybox.dev:3000'

require 'capybara-screenshot/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.include Delorean
  config.include Devise::TestHelpers,        type: :controller

  # FIXME: Changed to all use @vars as this is majority convention.
  # Want to change this to passed in vars to avoid side effects when
  # it make sense to do so, in it's own branch on an eve or weekend.
  config.include Devise::ControllerHelpers,  type: :controller
  config.include Devise::RequestHelpers,     type: :request
  config.include Devise::FeatureHelpers,     type: :feature

  config.extend Devise::ControllerMacros,  type: :controller
  config.extend Devise::RequestMacros,     type: :request
  config.extend Devise::FeatureMacros,     type: :feature

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    Time.zone = BuckyBox::Application.config.time_zone
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
