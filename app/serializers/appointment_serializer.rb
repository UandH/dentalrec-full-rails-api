class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :date, :symptoms

  has_one :dentist
end
