# This file contains all the database related settings.

configure do
  # Log queries to STDOUT in development and use sqlite database.
  if settings.development? or settings.test?
    set :database, { adapter: "sqlite3", database: "database.sqlite3" }
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  else
    set :database, {
                      adapter: 'mysql2',
                      host:     ENV['DATABASE_SERVER'],
                      username: ENV['DATABASE_USER'],
                      password: ENV['DATABASE_PASSWORD'],
                      database: ENV['DATABASE_NAME']
                   }
  end

end
