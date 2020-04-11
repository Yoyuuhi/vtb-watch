class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :videoId, null: false
      t.string :name
      t.datetime :publishedAt
      t.datetime :scheduledStartTime
      t.datetime :actualStartTime
      t.datetime :actualEndTime
      t.references :vtuber, foreign_key: true
      t.timestamps
    end
  end
end
