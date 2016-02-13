require 'sinatra/content_for'
require 'sinatra/json'

class SearchController < ApplicationController
  helpers Sinatra::ContentFor

  before do
    redirect '/auth/login' unless authorized?
  end

  get '/' do
    needle = '%' + params[:q] + '%'
    @data = {
      partners: Partner.where('first_name LIKE :q or last_name LIKE :q or company_name LIKE :q', { q: needle }),
      invoices: Invoice.where('items LIKE :q', { q: needle }),
      payments: Payment.where('gateway LIKE :q or transaction_id LIKE :q', { q: needle })
    }
    erb :search, :layout => :admin_layout
  end
end
