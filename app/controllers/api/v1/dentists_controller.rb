class Api::V1::DentistsController < ApplicationController
  respond_to :json

  def show
    respond_with Dentist.find(params[:id])
  end
end
