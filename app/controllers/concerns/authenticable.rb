module Authenticable
  # Devise methods overwrites
  def current_dentist
    @current_dentist ||= Dentist.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render json: {errors: 'Not authenticated'}, status: :unauthorized unless dentist_signed_in?
  end

  def dentist_signed_in?
    current_dentist.present?
  end
end