class Api::V1::SessionsController < ApplicationController
  def create
    dentist_password = params[:session][:password]
    dentist_email = params[:session][:email]
    dentist = dentist_email.present? && Dentist.find_by(email: dentist_email)

    if dentist.valid_password? dentist_password
      sign_in dentist, store: false
      dentist.generate_authentication_token!
      dentist.save
      render json: dentist, status: 200, location: [:api, dentist]
    else
      render json: { errors: 'Invalid email or password'}, status: 422
    end
  end

  def destroy
    dentist = Dentist.find_by(auth_token: params[:id])
    dentist.generate_authentication_token!
    dentist.save
    head 204
  end
end
