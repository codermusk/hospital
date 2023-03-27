class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.string :review
      t.integer :rating
      t.references :ratable , polymorphic:true  , null:false
    end
  end
end
