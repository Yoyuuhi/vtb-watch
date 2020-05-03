class RemoveCoverFromMylists < ActiveRecord::Migration[5.0]
  def change
    remove_column :mylists, :cover, :text
  end
end
