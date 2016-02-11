require 'sinatra/content_for'
require 'sinatra/json'

class InvoicesController < ApplicationController
  helpers Sinatra::ContentFor

  before do
    redirect '/auth/login' unless authorized?
  end

  get '/' do
    invoices = Invoice.all.order(id: :desc)
    erb :invoices, :layout => :admin_layout, :locals => { invoices: invoices }
  end

  get '/add' do
    partners = Partner.all.order(id: :desc)
    erb :add_invoice, :layout => :admin_layout, :locals => { partners: partners }
  end

  post '/add' do
    invoice = Invoice.create(params[:invoice])

    if invoice.valid?
      json :success => true, :message => t('add_invoice.messages.success')
    else
      json :success => false,
           :message => t('add_invoice.messages.error'),
           :errors => invoice.errors.messages
    end
  end

  get '/edit/:id' do |id|
    invoice = Invoice.find_by(id: id)

    if invoice
      erb :edit_invoice, :layout => :admin_layout, :locals => { invoice: invoice }
    else
      halt 404, t('edit_invoice.messages.not_found')
    end
  end

  post '/edit/:id' do |id|
    invoice = Invoice.find_by(id: id)

    if invoice
      invoice.attributes = params[:invoice]

      if invoice.save
        json :success => true, :message => t('edit_invoice.messages.success')
      else
        json :success => false,
             :message => t('edit_invoice.messages.error'),
             :errors => invoice.errors.messages
      end
    else
      json :success => false, :message => t('edit_invoice.messages.not_found')
    end
  end

  delete '/delete/:id' do |id|
    invoice = Invoice.find_by(id: id)

    if invoice
      if invoice.destroy
        json :success => true, :message => t('delete_invoice.messages.success')
      else
        json :success => false, :message => t('delete_invoice.messages.error')
      end
    else
      json :success => false, :message => t('delete_invoice.messages.not_found')
    end
  end

end
