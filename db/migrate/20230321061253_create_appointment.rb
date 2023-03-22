class CreateAppointment < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.datetime :appointment_date
      t.belongs_to :doctor
      t.belongs_to :patient
      t.timestamps

    end
  end
end
