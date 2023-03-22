class CreatePatient < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :sex
      t.string :address
      t.string :email
      t.string :mobile_number
      t.integer :age
      t.timestamps

    end
  end
end
