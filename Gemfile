source "https://rubygems.org"

group :default do # XXX: all environments, think twice before adding Gems here
  gem "rake", "13"
  gem "test-unit", "3.5.3"
  gem "unicorn", "6.1.0"
  gem "rails", ">=6"
  gem "sprockets", "3.5.2"
  gem "rails-i18n", ">4"
  gem "pg"
  gem "therubyracer", "0.12.3"
  gem "haml-rails"
  gem "jquery-rails", "4.4.0"
  gem "jquery-ui-rails", "6.0.1"
  gem "bootstrap-sass", "3.4.1"
  gem "bootbox-rails"
  gem "select2-rails"
  gem "hiredis"
  gem "readthis", "2.2.0"
  gem "devise", "4.8.1"
  gem "devise-i18n"
  gem "simple_form"
  gem "inherited_resources", git: "https://github.com/activeadmin/inherited_resources.git"
  gem "mini_magick", "4.11"
  gem "carrierwave", "2.2.2"
  gem "acts-as-taggable-on"
  gem "pg_search"
  gem "whenever"
  gem "acts_as_list"
  gem "default_value_for"
  gem "state_machine"
  gem "figaro"
  gem "virtus"
  gem "draper"
  gem "naught"
  gem "premailer-rails"
  gem "nokogiri" # premailer-rails dependency
  gem "delayed_job"
  gem "delayed_job_active_record"
  gem "delayed_job_web"
  gem "daemons" # needed for script/delayed_job
  gem "analytical", git: "https://github.com/jkrall/analytical.git" # released version doesn't allow setting the key in controller
  gem "ace-rails-ap"
  gem "active_utils"
  gem "activemerchant"
  gem "countries"
  gem "country_select", "~> 1.1.3" # TODO: https://github.com/stefanpenner/country_select/blob/master/UPGRADING.md
  gem "biggs"
  gem "charlock_holmes"
  gem "rabl"
  gem "apipie-rails"
  gem "rails-timeago"
  gem "fast_blank"
  gem "retryable"
  gem "rails-patch-json-encode"
  gem "oj"
  gem "crazy_money"
  gem "currency_data"
  gem "email_templator"
  #gem "simple_form-bank_account_number"
  gem "ordinalize_full", require: "ordinalize_full/integer"
  #gem "librato-rails"
  gem "rbtrace"
  gem "geokit-rails"
  gem "typhoeus"
  gem "rack-cors"
  gem "marginalia"
  gem "secure_headers"
  #gem "bugsnag"

  gem "eu_central_bank", require: false
  gem "monetize", require: false
  gem "xero_gateway", require: false
end

group :development do
  gem "webrick" # included explicitly so #chunked warnings no longer show up in the dev log
  gem "yard",       require: false
  gem "brakeman",   require: false
  gem "xray-rails", require: false
  gem "term-ansicolor"
  gem "parallel_tests"
  gem "sextant"
  gem "better_errors"
  gem "binding_of_caller"
  gem "meta_request"
  gem "i15r", require: false
end

group :test do
  gem "database_cleaner"
  gem "simplecov", require: false
  gem "cucumber-rails", require: false
  gem "capybara", require: false
  gem "capybara-screenshot"
  gem "poltergeist", require: false
  gem "launchy"
  gem "guard-rspec"
  gem "i18n-spec"
  gem "rspec-activemodel-mocks"
end

group :staging do
  #gem "mail_safe"
end

group :development, :test do
  gem "fabrication"
  gem "rspec-rails"
  gem "listen"
  #gem "terminal-notifier-guard" # Mac 10.8 system notifications for Guard
  gem "letter_opener"
  gem "bundler-audit", require: false
  gem "bullet"
  gem "rubocop"
  gem "byebug"
  gem "cane"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry-coolline" # as-you-type syntax highlighting
  gem "pry-stack_explorer"
end

group :development, :test, :staging do
  gem "delorean"
end

group :assets do
  gem "coffee-rails"
  gem "uglifier"
  gem "sass-rails"
  gem "bourbon"
end
