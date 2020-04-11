class AddColumnsToVtubers < ActiveRecord::Migration[5.0]
  def change
    add_column :vtubers, :icon, :text
    add_column :vtubers, :banner, :text
    add_column :vtubers, :channelTitle, :string
  end
end
