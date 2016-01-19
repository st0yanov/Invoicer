# Rakefile
require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require 'sinatra'
    require 'sinatra/activerecord'
    require File.expand_path('../app/config/app', __FILE__)
    require File.expand_path('../app/config/database', __FILE__)
  end
end
