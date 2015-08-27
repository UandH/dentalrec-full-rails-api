class Appointment < ActiveRecord::Base
  belongs_to :dentist

  validates :date, :dentist_id, :symptoms, presence: true

  scope :recent, -> {
    order(:date)
  }

  def self.search(params = {})
    appointments = params[:appointment_ids].present? ? Appointment.find(params[:appointment_ids]) : Appointment.all
    appointments = appointments.recent(params[:recent]) if params[:recent].present?

    appointments
  end
end
