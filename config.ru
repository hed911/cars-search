# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

use Rack::Session::Cookie, secret: File.read(".session.key"), same_site: true, max_age: 86400
run Sidekiq::Web

run Rails.application
Rails.application.load_server
