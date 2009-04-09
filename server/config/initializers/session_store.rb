# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_server_session',
  :secret      => '94e9869c05b28ccc211ed07acdfe2e94c9e31b2362905cf09bb1e7cd7aa0f38902fcaaca9a699cb5aa3083e8a5d36d5286f2e5cdf2586fc5daf0ba2231ab0d24'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
