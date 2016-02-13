require 'spec_helper'
require 'json'

RSpec.describe PaymentsController do
  def app
    PaymentsController
  end

  before(:all) do
    env 'rack.session', { user: User.find_by(id: 1) }
    Payment.destroy_all
    Invoice.destroy_all
    Partner.destroy_all

    partner_data = {
      first_name: 'Веселин',
      last_name: 'Стоянов',
      country: 'BG',
      city: 'Добрич',
      address: 'Студентски град, бл. 55, вх. Б',
      postcode: 1000,
      phone_number: '359895955158',
      company_name: 'Тест 123',
      eik: '203683521',
      vat_id: 'BG203683521'
    }
    partner = Partner.create(partner_data)

    data = {
      partner: partner,
      number: '1000000001',
      items: '{}',
      total: 5,
      deal_date: '2016-02-11'
    }
    @test_invoice = Invoice.create(data)
  end

  describe 'GET /' do
    before(:all) do
      get '/'
    end

    it 'returns 200 OK response' do
      expect(last_response.status).to eq 200
    end

    it 'shows an appropriate message when there aren\'t any payments in the database yet' do
      expect(last_response.body).to include(I18n.t('payments.no_payments'))
    end
  end

  describe 'POST /add' do
    context 'invalid data' do
      before(:all) do
        data = {
          invoice: 0,
          gateway: '',
          date: '',
          transaction_id: '',
          amount: 'asd'
        }

        post '/add', data
        @json = JSON.parse(last_response.body)
      end

      it 'doesn\'t save an invalid payment' do
        expect(@json['success']).to eq false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to eq I18n.t('add_payment.messages.error')
      end

      it 'requires a valid invoice' do
        expect(@json['errors']['invoice']).to include I18n.t('validation.presence')
      end

      it 'validates gateway short length' do
        search = I18n.t('validation.length.too_short')[0..26]
        expect(@json['errors']['gateway'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end

      it 'validates transaction_id short length' do
        search = I18n.t('validation.length.too_short')[0..26]
        expect(@json['errors']['transaction_id'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end

      it 'validates amount numericality' do
        expect(@json['errors']['amount']).to include I18n.t('validation.amount.numericality')
      end
    end

    context 'invalid data - length cases' do
      before(:all) do
        long_string = ''
        65.times { long_string << 'a' }

        data = {
          invoice: 0,
          gateway: long_string,
          date: '',
          transaction_id: long_string,
          amount: ''
        }

        post '/add', data
        @json = JSON.parse(last_response.body)
      end

      it 'validates gateway long length' do
        search = I18n.t('validation.length.too_long')[0..27]
        expect(@json['errors']['gateway'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end

      it 'validates transaction_id long length' do
        search = I18n.t('validation.length.too_long')[0..27]
        expect(@json['errors']['transaction_id'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end
    end

    context 'valid data' do
      before(:all) do
        data = {
          invoice: @test_invoice.id.to_s,
          gateway: 'EasyPay',
          date: '2016-02-11',
          transaction_id: '123456',
          amount: '10.00'
        }

        post '/add', data
        @json = JSON.parse(last_response.body)
      end

      it 'saves a valid payment' do
        expect(@json['success']).to eq true
      end

      it 'returns an appropirate success message' do
        expect(@json['message']).to eq I18n.t('add_payment.messages.success')
      end
    end
  end

  describe 'POST /edit/:id' do
    context 'unexisting payment' do
      before(:all) do
        post '/edit/999999999'
        @json = JSON.parse(last_response.body)
      end

      it 'returns an error response' do
        expect(@json['success']).to be false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to include I18n.t('edit_payment.messages.not_found')
      end
    end

    context 'existing payment' do
      context 'invalid data' do
        before(:all) do
          long_string = ''
          65.times { long_string << 'a' }

          data = {
            invoice: 0,
            gateway: long_string,
            date: '',
            transaction_id: long_string,
            amount: ''
          }

          post '/edit/'+Payment.last.id.to_s, data
          @json = JSON.parse(last_response.body)
        end

        it 'doesn\'t update an invoice with invalid data' do
          expect(@json['success']).to be false
        end
      end

      context 'valid data' do
        before(:all) do
          data = {
            invoice: @test_invoice.id.to_s,
            gateway: 'EasyPay',
            date: '2016-02-11',
            transaction_id: '123456',
            amount: '10.00'
          }

          post '/edit/'+Payment.last.id.to_s, data
          @json = JSON.parse(last_response.body)
        end

        it 'updates a invoice with valid data' do
          expect(@json['success']).to be true
        end

        it 'returns an appropirate success message' do
          expect(@json['message']).to include I18n.t('edit_payment.messages.success')
        end
      end
    end
  end

  describe 'DELETE /delete/:id' do
    context 'unexisting payment' do
      before(:all) do
        delete '/delete/999999999'
        @json = JSON.parse(last_response.body)
      end

      it 'returns an error response' do
        expect(@json['success']).to be false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to include I18n.t('delete_payment.messages.not_found')
      end
    end

    context 'existing payment' do
      before(:all) do
        delete '/delete/'+Payment.last.id.to_s
        @json = JSON.parse(last_response.body)
      end

      it 'deletes an invoice' do
        expect(@json['success']).to be true
      end

      it 'returns an appropirate success message' do
        expect(@json['message']).to include I18n.t('delete_payment.messages.success')
      end
    end
  end

end
