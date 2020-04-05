class CreateMylistVtubers < ActiveRecord::Migration[5.0]
  def change
    create_table :mylist_vtubers do |t|
      t.references :mylist, foreign_key: true
      t.references :vtuber, foreign_key: true
      t.timestamps
    end
  end
end
