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
end
