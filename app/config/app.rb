# This files contains all the app related settings.

class Invoicer
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

    # The directory where static files should be served from.
    set :public_folder, Proc.new { File.join(root, 'public') }

    # The directory where view templates are located.
    set :views, Proc.new { File.join(root, 'app', 'views') }

    ###################################################
    ################ Sessions Settings ################
    ###################################################

    # Possible values:
    # - true = Enabled
    # - false = Disabled
    set :sessions, true

    set :session_secret, ENV['SESSION_SECRET'].nil? ? 'supersecret' : ENV['SESSION_SECRET']

  end

  ###################################################
  ########## Environment Specific Settings ##########
  ###################################################

  configure :development do
    enable :dump_errors, :raise_errors, :show_exceptions
  end

  configure :test do
     disable :show_exceptions
  end

  configure :production do
    disable :raise_errors, :show_exceptions
  end
end
