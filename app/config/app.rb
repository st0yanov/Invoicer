# This files contains all the app related settings.
configure do

  ###################################################
  ############### Project Environment ###############
  ###################################################

  # Possible values:
  # - :development
  # - :test
  # - :production
  set :environment, :development

  ###################################################
  ################### Directories ###################
  ###################################################

  # The directory used as a base for the application.
  set :root, File.dirname(File.expand_path('../..', __FILE__))

  # Main Application File.
  set :app_file, Proc.new { File.join(root, 'app.rb') }

  # The directory where static files should be served from.
  set :public_folder, Proc.new { File.join(root, 'public') }

  # The directory where view templates are located.
  set :views, Proc.new { File.join(root, 'app/views') }

  ###################################################
  ################ Sessions Settings ################
  ###################################################

  # Possible values:
  # - true = Enabled
  # - false = Disabled
  set :sessions, true

end

###################################################
########## Environment Specific Settings ##########
###################################################

configure :development do
  enable :dump_errors, :raise_errors, :show_exceptions
end

configure :test
   disable :show_exceptions
end

configure :production do
  disable :raise_errors, :show_exceptions
end