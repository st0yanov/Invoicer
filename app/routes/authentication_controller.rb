require 'sinatra/content_for'

class AuthenticationController < ApplicationController
  helpers Sinatra::ContentFor

  get '/login' do
    erb :login
  end

  post '/login' do
    username = params['username']
    password = params['password']


  end
end
