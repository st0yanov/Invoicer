require 'spec_helper'
require 'json'

RSpec.describe AuthenticationController do
  def app
    AuthenticationController
  end

  describe 'GET /login' do
    it 'returns 200 OK response' do
      get '/login'

      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /login' do
    context 'invalid credentials' do
      before(:all) do
        post '/login', :username => 'blabla', :password => 'blabla'
        @json = JSON.parse(last_response.body)
      end

      it 'returns 200 OK response' do
        expect(last_response.status).to eq 200
      end

      it 'returns an appropriate status' do
        expect(@json['success']).to eq false
      end

      it 'returns an appropriate error message' do
        expect(@json['message']).to eq I18n.t('login.messages.error')
      end
    end

    context 'valid credentials' do
      before(:all) do
        post '/login', :username => 'admin', :password => 'admin123'
        @json = JSON.parse(last_response.body)
      end

      it 'returns 200 OK response' do
        expect(last_response.status).to eq 200
      end

      it 'returns an appropriate status' do
        expect(@json['success']).to eq true
      end

      it 'returns an appropriate success message' do
        expect(@json['message']).to eq I18n.t('login.messages.success')
      end

      it 'has successfully authorized the user' do
        expect(session['user'].nil?).to eq false
      end

      it 'redirects user to homepage if logged in' do
        get '/login'
      end
    end
  end

  describe 'GET /logout' do
    before(:all) do
      post '/login', :username => 'admin', :password => 'admin123'
    end

    it 'check authorized' do
      expect(session['user'].nil?).to eq false
    end

    it 'logs the user out' do
      get '/logout'
      expect(session['user'].nil?).to eq true
    end
  end
end
