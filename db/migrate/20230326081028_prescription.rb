class Prescription < ActiveRecord::Migration[6.0]
  def change
    drop_table :prescriptions
  end
end
