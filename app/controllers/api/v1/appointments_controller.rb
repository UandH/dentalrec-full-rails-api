class Api::V1::AppointmentsController < ApplicationController

  before_action :authenticate_with_token!, only: [:create]
  respond_to :json

  def show
    respond_with Appointment.find(params[:id])
  end

  def index
    respond_with Appointment.all
  end

  def create
    appointment = current_dentist.appointments.build(appointment_params)
    if appointment.save
      render json: appointment, status: 201, location: [:api, appointment]
    else
      render json: {errors: appointment.errors}, status: 422
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:date, :symptoms)
  end
end
