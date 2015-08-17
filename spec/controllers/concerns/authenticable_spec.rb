require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_dentist' do
    before do
      @dentist = FactoryGirl.create :dentist
      request.headers['Authorization'] = @dentist.auth_token
      authentication.stub(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_dentist.auth_token).to eql @dentist.auth_token
    end
  end

  describe '#authenticate_with_token' do
    before do
      @dentist = FactoryGirl.create :dentist
      authentication.stub(:current_dentist).and_return(nil)
      response.stub(:response_code).and_return(401)
      response.stub(:body).and_return({'errors' => 'Not authenticated'}.to_json)
      authentication.stub(:response).and_return(response)
    end

    it 'render a json error message' do
      expect(json_response[:errors]).to eql 'Not authenticated'
    end

    it { should respond_with 401 }
  end
end