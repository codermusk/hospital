class AddColumn < ActiveRecord::Migration[6.0]
  def change
    add_reference :ratings, :patient
  end
end
