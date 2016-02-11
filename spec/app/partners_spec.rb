require 'spec_helper'
require 'json'

RSpec.describe PartnersController do
  def app
    PartnersController
  end

  before(:all) do
    env 'rack.session', { user: User.find_by(id: 1) }
    Partner.destroy_all
  end

  describe 'GET /' do
    before(:all) do
      get '/'
    end

    it 'returns 200 OK response' do
      expect(last_response.status).to eq 200
    end

    it 'shows an appropriate message when there aren\'t any partners in the database yet' do
      expect(last_response.body).to include(I18n.t('partners.no_partners'))
    end
  end

  describe 'POST /add' do
    context 'invalid blank data' do
      before(:all) do
        post '/add', {
                        partner: {
                          company_name: 'A'
                        }
                      }
        @json = JSON.parse(last_response.body)
      end

      it 'doesn\'t save an invalid partner' do
        expect(@json['success']).to eq false
      end

      it 'returns an appropirate error message' do
        expect(@json['message']).to eq I18n.t('add_partner.messages.error')
      end

      it 'validates first_name, last_name, country, city, address, phone_number presence' do
        expect(@json['errors']['first_name']).to include I18n.t('validation.presence')
        expect(@json['errors']['last_name']).to include I18n.t('validation.presence')
        expect(@json['errors']['country']).to include I18n.t('validation.presence')
        expect(@json['errors']['city']).to include I18n.t('validation.presence')
        expect(@json['errors']['address']).to include I18n.t('validation.presence')
        expect(@json['errors']['phone_number']).to include I18n.t('validation.presence')
      end

      it 'validates first_name, last_name, city, company_name minimum length' do
        search = I18n.t('validation.length.too_short')[0..26]
        expect(@json['errors']['first_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['last_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['city'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['company_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end
    end

    context 'invalid provided data' do
      before(:all) do
        long_string = ''
        65.times { long_string << 'a' }
        post '/add', {
                        partner: {
                          first_name: long_string,
                          last_name: long_string,
                          country: 'ASD',
                          city: long_string,
                          address: long_string,
                          postcode: 'ASD',
                          phone_number: long_string,
                          company_name: long_string,
                          eik: 123,
                          vat_id: 123
                        }
                      }

        @json = JSON.parse(last_response.body)
      end

      it 'validates first_name, last_name, city, address, phone_number, company_name maximum length' do
        search = I18n.t('validation.length.too_long')[0..27]
        expect(@json['errors']['first_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['last_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['city'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['address'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['phone_number'].any? { |error| search =~ /#{error}/ }).to be_falsey
        expect(@json['errors']['company_name'].any? { |error| search =~ /#{error}/ }).to be_falsey
      end

      it 'validates possible countries' do
        expect(@json['errors']['country']).to include I18n.t('validation.inclusion')
      end

      it 'validates postcode numericality' do
        expect(@json['errors']['postcode']).to include I18n.t('validation.postcode.numericality')
      end

      it 'validates EIK number' do
        #expect(@json['errors']['eik']).to include I18n.t('validation.eik.validity')
      end

      it 'validates VAT number' do
        expect(@json['errors']['vat_id']).to include I18n.t('validation.vat_id.validity')
      end
    end

    context 'valid data' do
      before(:all) do
        post '/add', {
                        partner: {
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
                      }

        @json = JSON.parse(last_response.body)
      end

      it 'returns a success response' do
        expect(@json['success']).to be true
      end

      it 'returns an appropirate success message' do
        expect(@json['message']).to eq I18n.t('add_partner.messages.success')
      end

      it 'doesn\'t save a partner with duplicated unique fields - company_name, eik, vat_id' do
        post '/add', {
                        partner: {
                          company_name: 'Тест 123',
                          eik: '203683521',
                          vat_id: 'BG203683521'
                        }
                      }

        @json = JSON.parse(last_response.body)

        expect(@json['errors']['company_name']).to include I18n.t('validation.company_name.uniqueness')
        expect(@json['errors']['eik']).to include I18n.t('validation.eik.uniqueness')
        expect(@json['errors']['vat_id']).to include I18n.t('validation.vat_id.uniqueness')
      end

    end
  end

end
