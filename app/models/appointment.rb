class Appointment < ActiveRecord::Base
  belongs_to :dentist

  validates :date, :dentist_id, :symptoms, presence: true
end
