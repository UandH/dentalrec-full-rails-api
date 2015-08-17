module Authenticable
  # Devise methods overwrites
  def current_dentist
    @current_dentist ||= Dentist.find_by(auth_token: request.headers['Authorization'])
  end
end