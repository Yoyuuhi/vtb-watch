class CreateVtubers < ActiveRecord::Migration[5.0]
  def change
    create_table :vtubers do |t|
      t.string :name, null: false
      t.index :name, unique: true
      t.string :twitter, null: false
      t.index :twitter, unique:true
      t.references :company, foreign_key: true
      t.string :channel, null: false
      t.index :channel, unique: true
      t.timestamps
    end
  end
end
