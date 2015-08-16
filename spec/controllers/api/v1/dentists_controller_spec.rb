require 'rails_helper'

RSpec.describe Api::V1::DentistsController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.dentalrec.v1" }

  describe 'GET #show' do
    before(:each) do
      @dentist = FactoryGirl.create :dentist
      get :show, id: @dentist.id, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      dentist_response = JSON.parse(response.body, symbolize_names: true)
      expect(dentist_response[:email]).to eql @dentist.email
    end

    it { should respond_with 200 }
  end
end
