require 'rubygems'
require 'bundler/setup'

require 'yaml'

require 'active_support/all'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'

require_relative 'config/app'
require_relative 'autoload'

configure do
  set :app_file, __FILE__
end

environment = Sinatra::Application.environment
db = YAML.load_file('./app/config/database.yml')[environment.to_s]

configure do
  set :database, db
end
