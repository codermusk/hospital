class RemoveRefer < ActiveRecord::Migration[6.0]
  def change
    remove_reference :doctors , :hospital
  end
end
