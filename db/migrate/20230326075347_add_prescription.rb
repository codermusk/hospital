class AddPrescription < ActiveRecord::Migration[6.0]
  def change
    create_table :prescriptions do |t|
      t.string :tablets
      t.belongs_to :doctor
      t.belongs_to :patient
      t.integer :fees
      t.string :comments
    end
  end
end
