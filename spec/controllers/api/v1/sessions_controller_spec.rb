require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do

    before(:each) do
      @dentist = FactoryGirl.create :dentist
    end

    context 'when the credentials are correct' do

      before(:each) do
        credentials = {email: @dentist.email, password: '12345678'}
        post :create, {session: credentials}
      end

      it 'returns the user record corresponding to the given credentials' do
        @dentist.reload
        expect(json_response[:dentist][:auth_token]).to eql @dentist.auth_token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do

      before(:each) do
        credentials = {email: @dentist.email, password: 'invalidpassword'}
        post :create, {session: credentials}
      end

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with 422 }
    end

  end

  describe 'DELETE #destroy' do

    before(:each) do
      @dentist = FactoryGirl.create :dentist
      sign_in @dentist
      delete :destroy, id: @dentist.auth_token
    end

    it { should respond_with 204 }

  end
end
