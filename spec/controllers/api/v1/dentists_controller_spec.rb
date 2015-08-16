require 'rails_helper'

RSpec.describe Api::V1::DentistsController, type: :controller do
  before(:each) { request.headers['Accept'] = 'application/vnd.dentalrec.v1' }

  describe 'GET #show' do
    before(:each) do
      @dentist = FactoryGirl.create :dentist
      get :show, id: @dentist.id, format: :json
    end

    it 'checks the received dentists email' do
      dentist_response = JSON.parse(response.body, symbolize_names: true)
      expect(dentist_response[:email]).to eql @dentist.email
    end

    it 'response should be 200' do
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @dentist_attributes = FactoryGirl.attributes_for :dentist
        post :create, {dentist: @dentist_attributes}, format: :json
      end

      it 'renders the json representation for the dentist record just created' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect(dentist_response[:email]).to eql @dentist_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        #notice I'm not including the email
        @invalid_dentist_attributes = {password: '12345678',
                                       password_confirmation: '12345678'}
        post :create, {dentist: @invalid_dentist_attributes}, format: :json
      end

      it 'renders an errors json' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect(dentist_response).to have_key(:errors)
      end

      it 'renders the json errors on why the dentist could not be created' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect(dentist_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do

    context 'when is successfully updated' do
      before(:each) do
        dentist = FactoryGirl.create :dentist
        patch :update, {id: dentist.id,
                        dentist: {email: 'newmail@example.com'}}, format: :json
      end

      it 'renders the json representation for the updated dentist' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect(dentist_response[:email]).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        dentist = FactoryGirl.create :dentist
        patch :update, {id: dentist.id,
                        dentist: {email: 'bademail.com'}}, format: :json
      end

      it 'renders an errors json' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect( dentist_response).to have_key(:errors)
      end

      it 'renders the json errors why the dentist could not be created' do
        dentist_response = JSON.parse(response.body, symbolize_names: true)
        expect(dentist_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end
end
