class ChangeBills < ActiveRecord::Migration[6.0]
  def up
    remove_reference :bills , :appointment
    add_reference :bills , :prescribtion

  end
  def down
    add_reference :bills , :appointment_id
  end
end
