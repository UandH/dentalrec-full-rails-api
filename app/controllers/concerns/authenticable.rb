module Authenticable
  # Devise methods overwrites
  def current_dentist
    @current_dentist ||= Dentist.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render json: {errors: 'Not authenticated'}, status: :unauthorized unless current_dentist.present?
  end

  # def user_signed_in?
  #   current_user.present?
  # end
end