require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'app'
run Sinatra::Application

# Loads the environment specific settings
Dotenv.load('.env.'+settings.environment.to_s)