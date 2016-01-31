require 'sinatra/content_for'
require 'sinatra/json'

class AuthenticationController < ApplicationController
  helpers Sinatra::ContentFor

  before do
    if /\/logout/.match(request.path).nil?
      redirect '/' if authorized?
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    username, password = params['username'], params['password']
    user = User.find_by(username: username)

    if not user.nil? and user.check_password(password)
      session['user'] = user
      json :success => true, :message => t('login.messages.success')
    else
      json :success => false, :message => t('login.messages.error')
    end
  end

  get '/logout' do
    logout!
    redirect to('/login')
  end
end
