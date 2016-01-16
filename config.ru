require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv'

require File.expand_path('../app/config/app', __FILE__)

configure do
  set :app_file, __FILE__
end

run Sinatra::Application

# Loads the environment specific settings
Dotenv.load('.env.'+settings.environment.to_s)
