require 'rails_helper'

RSpec.describe Api::V1::DentistsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @dentist = FactoryGirl.create :dentist
      get :show, id: @dentist.id
    end

    it 'checks the received dentists email' do
      dentist_response = json_response[:dentist]
      expect(dentist_response[:email]).to eql @dentist.email
    end

    it "has the appointment ids as an embeded object" do
      dentist_response = json_response[:dentist]
      expect(dentist_response[:appointment_ids]).to eql nil
    end

    it 'response should be 200' do
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do

    context 'when is successfully created' do
      before(:each) do
        @dentist_attributes = FactoryGirl.attributes_for :dentist
        post :create, {dentist: @dentist_attributes}
      end

      it 'renders the json representation for the dentist record just created' do
        dentist_response = json_response[:dentist]
        expect(dentist_response[:email]).to eql @dentist_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        #notice I'm not including the email
        @invalid_dentist_attributes = {password: '12345678',
                                       password_confirmation: '12345678'}
        post :create, {dentist: @invalid_dentist_attributes}
      end

      it 'renders an errors json' do
        dentist_response = json_response
        expect(dentist_response).to have_key(:errors)
      end

      it 'renders the json errors and why the dentist could not be created' do
        dentist_response = json_response
        expect(dentist_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @dentist = FactoryGirl.create :dentist
      api_authorization_header @dentist.auth_token
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, {id: @dentist.id,
                        dentist: {email: 'newmail@example.com'}}
      end

      it 'renders the json representation for the updated dentist' do
        dentist_response = json_response[:dentist]
        expect(dentist_response[:email]).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        dentist = FactoryGirl.create :dentist
        patch :update, {id: dentist.id,
                        dentist: {email: 'bademail.com'}}
      end

      it 'renders an errors json' do
        dentist_response = json_response
        expect(dentist_response).to have_key(:errors)
      end

      it 'renders the json errors why the dentist could not be created' do
        dentist_response = json_response
        expect(dentist_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @dentist = FactoryGirl.create :dentist
      api_authorization_header @dentist.auth_token
      delete :destroy, {id: @dentist.id}
    end

    it { should respond_with 204 }
  end
end
