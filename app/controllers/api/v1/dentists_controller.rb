class Api::V1::DentistsController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    render json: Dentist.find(params[:id])
  end

  def create
    dentist = Dentist.new(dentist_params)
    if dentist.save
      render json: dentist, status: 201, location: [:api, dentist]
    else
      render json: {errors: dentist.errors}, status: 422
    end
  end

  def update
    dentist = current_dentist

    if dentist.update(dentist_params)
      render json: dentist, status: 200, location: [:api, dentist]
    else
      render json: {errors: dentist.errors}, status: 422
    end
  end

  def destroy
    current_dentist.destroy
    head 204
  end

  private

  def dentist_params
    params.require(:dentist).permit(:email, :password, :password_confirmation)
  end
end
