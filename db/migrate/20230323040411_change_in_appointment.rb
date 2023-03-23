class ChangeInAppointment < ActiveRecord::Migration[6.0]
  def up
    change_column :appointments , :appointment_date , :date
  end

  def down
    change_column :appointments , :appointment_date , :datetime
  end
end
