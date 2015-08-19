require 'rails_helper'

RSpec.describe Api::V1::AppointmentsController, type: :controller do
  describe 'GET #show' do
    before(:each) do
      @appointment = FactoryGirl.create :appointment
      get :show, id: @appointment.id
    end

    it 'returns the single appointment by id' do
      appointment_response = json_response
      expect(appointment_response[:symptoms]).to eql @appointment.symptoms
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create :appointment }
      get :index
    end

    it 'returns 4 records from the database' do
      appointment_response = json_response
      expect(appointment_response[:appointments]).to  have(4).items
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        dentist = FactoryGirl.create :dentist
        @appointment_attributes = FactoryGirl.attributes_for :appointment
        api_authorization_header dentist.auth_token
        post :create, { dentist_id: dentist.id, appointment: @appointment_attributes }
      end

      it 'renders the json representation for the product record just created' do
        appointment_response = json_response
        expect(appointment_response[:symptoms]).to eql @appointment_attributes[:symptoms]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        dentist = FactoryGirl.create :dentist
        @invalid_appointment_attributes = { date: '2014-08-19 18:54:41'}
        api_authorization_header dentist.auth_token
        post :create, { dentist_id: dentist.id, appointment: @invalid_appointment_attributes }
      end

      it 'renders an errors json' do
        appointment_response = json_response
        expect(appointment_response).to have_key(:errors)
      end

      it 'renders the json errors on whe the product could not be created' do
        appointment_response = json_response
        expect(appointment_response[:errors][:symptoms]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end
