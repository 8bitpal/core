# Be sure to restart your server when you modify this file.

BuckyBox::Application.config.session_store :cookie_store,
  key: '_bucky_box_session',
  secure: !Rails.env.development? && !Rails.env.test?,
  httponly: true,
  domain: :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# BuckyBox::Application.config.session_store :active_record_store
