# This file contains all the database related settings.

configure do
  if settings.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  set :database {
                  adapter: 'mysql2',
                  host:     ENV['DATABASE_SERVER'],
                  username: ENV['DATABASE_USER'],
                  password: ENV['DATABASE_PASSWORD'],
                  database: ENV['DATABASE_NAME']
                }
end