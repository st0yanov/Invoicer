require 'rubygems'
require 'bundler/setup'

require 'yaml'

require 'active_support/all'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'

require 'i18n'
require 'i18n/backend/fallbacks'

require_relative 'config/app'
require_relative 'autoload'

configure do
  set :app_file, __FILE__

  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'app', 'translations', '*.yml')]
  I18n.backend.load_translations

  I18n.enforce_available_locales = false
  I18n.available_locales = ["bg-BG"]
  I18n.default_locale = :'bg-BG'
end

environment = Sinatra::Application.environment
db = YAML.load_file('./app/config/database.yml')[environment.to_s]

configure do
  set :database, db
end
