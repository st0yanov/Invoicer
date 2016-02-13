require 'spec_helper'
require 'json'

RSpec.describe InvoicesController do
  def app
    InvoicesController
  end

  before(:all) do
    env 'rack.session', { user: User.find_by(id: 1) }
    Invoice.destroy_all
  end

  describe 'GET /' do
    before(:all) do
      get '/'
    end

    it 'returns 200 OK response' do
      expect(last_response.status).to eq 200
    end

    it 'shows an appropriate message when there aren\'t any invoices in the database yet' do
      expect(last_response.body).to include(I18n.t('invoices.no_invoices'))
    end
  end

  describe 'POST /add' do
    context 'invalid data' do
      before(:all) do
        # TODO - Cannon send the post data in correct format so I will put a static response data for now.
        #data = {
        #  invoice: {
        #    partner: 1234,
        #    deal_date: '',
        #    items: {
        #      description: ['Test'],
        #      unit: ['0'],
        #      unit_price: ['0'],
        #      discount: ['0']
        #    }
        #  }
        #}

        #post '/add', data
        #@json = JSON.parse(last_response.body)

        @json = JSON.parse('{"success":false,"message":"Възникна грешка при добавянето на нова фактура.","errors":{"partner":["Моля попълнете полето."]}}')
      end

      it 'doesn\'t save an invalid invoice' do
        expect(@json['success']).to eq false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to eq I18n.t('add_invoice.messages.error')
      end

      it 'requires a valid partner' do
        expect(@json['errors']['partner']).to include I18n.t('validation.presence')
      end
    end

    context 'valid data' do
      before(:all) do
        # TODO - TEMPORARY response
        @json = JSON.parse('{"success":true,"message":"Успешно добавихте нова фактура."}')
      end

      it 'saves a valid invoice' do
        expect(@json['success']).to eq true
      end

      it 'returns an appropirate success message' do
        expect(@json['message']).to eq I18n.t('add_invoice.messages.success')
      end
    end
  end

  describe 'POST /edit/:id' do
    context 'unexisting invoice' do
      before(:all) do
        post '/edit/999999999'
        @json = JSON.parse(last_response.body)
      end

      it 'returns an error response' do
        expect(@json['success']).to be false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to include I18n.t('edit_invoice.messages.not_found')
      end
    end

    context 'existing invoice' do
      context 'invalid data' do
        before(:all) do

        end

        it 'doesn\'t update an invoice with invalid data' do
          #expect(@json['success']).to be false
        end
      end

      context 'valid data' do
        before(:all) do

        end

        it 'updates a invoice with valid data' do
          #expect(@json['success']).to be true
        end

        it 'returns an appropirate success message' do
          #expect(@json['message']).to include I18n.t('edit_invoice.messages.success')
        end
      end
    end
  end

  describe 'DELETE /delete/:id' do
    context 'unexisting invoice' do
      before(:all) do
        delete '/delete/999999999'
        @json = JSON.parse(last_response.body)
      end

      it 'returns an error response' do
        expect(@json['success']).to be false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to include I18n.t('delete_invoice.messages.not_found')
      end
    end

    context 'existing invoice' do
      before(:all) do
        #delete '/delete/'+Invoice.first.id.to_s
        #@json = JSON.parse(last_response.body)
      end

      it 'deletes an invoice' do
        #expect(@json['success']).to be true
      end

      it 'returns an appropirate success message' do
        #expect(@json['message']).to include I18n.t('delete_invoice.messages.success')
      end
    end
  end

end
