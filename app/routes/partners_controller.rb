require 'sinatra/content_for'
require 'sinatra/json'

class PartnersController < ApplicationController
  helpers Sinatra::ContentFor

  before do
    redirect '/auth/login' unless authorized?
  end

  get '/add' do
    erb :add_partner, :layout => :admin_layout
  end

  post '/add' do
    partner = Partner.create(params[:partner])

    if partner.valid?
      json :success => true, :message => t('add_partner.messages.success')
    else
      json :success => false,
           :message => t('add_partner.messages.error'),
           :errors => partner.errors.messages
    end
  end

  get '/edit' do

  end

  post '/edit' do

  end

  delete '/delete' do

  end

end
