require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'dotenv'

require File.expand_path('../app/config/app', __FILE__)
require File.expand_path('../app/config/database', __FILE__)
require File.expand_path('../app/autoload', __FILE__)

configure do
  set :app_file, __FILE__
end

run Sinatra::Application

# Loads the environment specific settings
Dotenv.load('.env.'+settings.environment.to_s)
