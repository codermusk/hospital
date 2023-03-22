class CreateDoctor < ActiveRecord::Migration[6.0]
  def change
    create_table :doctors do |t|
      t.belongs_to :hospital
      t.string :name
      t.integer :age
      t.string :address
      t.string :email
      t.datetime :dateofjoining
      t.integer :status , default:0
      t.string :specialization

      t.timestamps
    end
  end
end
