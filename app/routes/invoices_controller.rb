require 'sinatra/content_for'
require 'sinatra/json'
require 'pdfkit'

class InvoicesController < ApplicationController
  helpers Sinatra::ContentFor, InvoiceHelpers

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
    invoice = Invoice.new
    invoice.partner = Partner.find_by(id: params[:invoice][:partner])
    invoice.number = '1000000001'
    invoice.items = params[:invoice][:items].to_json
    invoice.total = calculate_total(format_items(params[:invoice][:items]))
    invoice.deal_date = params[:invoice][:deal_date]

    if invoice.save
      json :success => true, :message => t('add_invoice.messages.success')
    else
      json :success => false,
           :message => t('add_invoice.messages.error'),
           :errors => invoice.errors.messages
    end
  end

  get '/edit/:id' do |id|
    invoice = Invoice.find_by(id: id)
    partners = Partner.all.order(id: :desc)

    if invoice
      erb :edit_invoice, :layout => :admin_layout, :locals => { invoice: invoice, partners: partners }
    else
      halt 404, t('edit_invoice.messages.not_found')
    end
  end

  post '/edit/:id' do |id|
    invoice = Invoice.find_by(id: id)

    if invoice
      invoice.partner = Partner.find_by(id: params[:invoice][:partner])
      invoice.items = params[:invoice][:items].to_json
      invoice.total = calculate_total(format_items(params[:invoice][:items]))
      invoice.deal_date = params[:invoice][:deal_date]

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

  get '/download/:id' do |id|
    @invoice = Invoice.find_by(id: id)
    @payments = @invoice.payments

    case params[:format]
    when 'html'
      erb :invoice_template, :layout => false
    when 'pdf'
      html = erb :invoice_template, :layout => false
      kit = PDFKit.new(html)
      pdf = kit.to_pdf
      content_type 'application/pdf'
      body pdf
    else
      halt 404, t('download_invoice.messages.invalid_format')
    end
  end

end
