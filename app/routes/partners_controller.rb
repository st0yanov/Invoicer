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

  get '/edit/:id' do |id|
    partner = Partner.find_by(id: id)

    if partner
      erb :edit_partner, :layout => :admin_layout, :locals => { :partner => partner }
    else
      halt 404, t('edit_partner.messages.not_found')
    end
  end

  post '/edit/:id' do |id|
    partner = Partner.find_by(id: id)

    if partner
      partner.attributes = params[:partner]

      if partner.save
        json :success => true, :message => t('edit_partner.messages.success')
      else
        json :success => false,
             :message => t('add_partner.messages.error'),
             :errors => partner.errors.messages
      end
    else
      json :success => false, :message => t('edit_partner.messages.not_found')
    end
  end

  delete '/delete/:id' do |id|

  end

end
