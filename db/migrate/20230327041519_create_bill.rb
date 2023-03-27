class CreateBill < ActiveRecord::Migration[6.0]
  def change
    remove_column :prescribtions , :fees , :integer

    create_table :bills do |t|
      t.belongs_to :appointment
      t.integer :doctor_fees
      t.boolean :status  , default: false
      t.timestamps
    end
    end
    end
