class NewPrescriptionTable < ActiveRecord::Migration[6.0]
  def change
    create_table :prescription do |t|
      t.string :tablets
      t.belongs_to :appointment
      t.integer :fees
      t.string :comments
    end
  end
end
