class AddColumnToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :cover, :text
    add_column :videos, :liveStreamingDetails, :boolean
  end
end
