class Api::V1::AppointmentsController < ApplicationController

  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json

  def show
    render json: Appointment.find(params[:id])
  end

  def index
    # appointments = params[:appointment_ids].present? ? Appointment.search(params[:appointment_ids]) : Appointment.all
    appointments = Appointment.search(params)
    render json: appointments
  end

  def create
    appointment = current_dentist.appointments.build(appointment_params)
    if appointment.save
      render json: appointment, status: 201, location: [:api, appointment]
    else
      render json: {errors: appointment.errors}, status: 422
    end
  end

  def update
    appointment = current_dentist.appointments.find(params[:id])
    if appointment.update(appointment_params)
      render json: appointment, status: 200, location: [:api, appointment]
    else
      render json: { errors: appointment }, status: 422
    end
  end

  def destroy
    appointment = current_dentist.appointments.find(params[:id])
    appointment.destroy
    head 204
  end

  private

  def appointment_params
    params.require(:appointment).permit(:date, :symptoms)
  end
end
