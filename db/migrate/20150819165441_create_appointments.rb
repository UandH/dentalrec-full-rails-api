class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :date
      t.string :symptoms
      t.belongs_to :dentist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
