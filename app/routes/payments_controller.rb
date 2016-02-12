require 'sinatra/content_for'
require 'sinatra/json'

class PaymentsController < ApplicationController
  helpers Sinatra::ContentFor, InvoiceHelpers

  before do
    redirect '/auth/login' unless authorized?
  end

  get '/' do
    @payments = Payment.all.order(id: :desc)
    erb :payments, :layout => :admin_layout
  end

  get '/add' do
    @invoices = Invoice.where(paid: false).order(id: :desc)
    erb :add_payment, :layout => :admin_layout
  end

  post '/add' do
    payment = Payment.new

    payment.invoice = Invoice.find_by(id: params[:invoice])
    payment.gateway = params[:gateway]
    payment.date = params[:date]
    payment.transaction_id = params[:transaction]
    payment.amount = params[:amount]

    if payment.save
      mark_paid(payment.invoice)
      json :success => true, :message => t('add_payment.messages.success')
    else
      json :success => false,
           :message => t('add_payment.messages.error'),
           :errors => payment.errors.messages
    end
  end

  get '/edit/:id' do |id|
    @payment = Payment.find_by(id: id)
    @invoices = Invoice.all.order(id: :desc)

    if @payment
      erb :edit_payment, :layout => :admin_layout
    else
      halt 404, t('edit_payment.messages.not_found')
    end
  end

  post '/edit/:id' do |id|
    @payment = Payment.find_by(id: id)

    if @payment
      @payment.invoice = Invoice.find_by(id: params[:invoice])
      @payment.gateway = params[:gateway]
      @payment.date = params[:date]
      @payment.transaction_id = params[:transaction]
      @payment.amount = params[:amount]

      if @payment.save
        mark_paid(@payment.invoice)
        json :success => true, :message => t('edit_payment.messages.success')
      else
        json :success => false,
             :message => t('edit_payment.messages.error'),
             :errors => @payment.errors.messages
      end
    else
      json :success => false, :message => t('edit_payment.messages.not_found')
    end
  end

  delete '/delete/:id' do |id|
    payment = Payment.find_by(id: id)

    if payment
      invoice = payment.invoice
      if payment.destroy
        mark_paid(invoice)
        json :success => true, :message => t('delete_payment.messages.success')
      else
        json :success => false, :message => t('delete_payment.messages.error')
      end
    else
      json :success => false, :message => t('delete_payment.messages.not_found')
    end
  end

  private
  def mark_paid(invoice)
    invoice.paid = calculate_payments(invoice) >= vat_price(invoice)
    invoice.save!
  end

end
