class MylistVtuber < ApplicationRecord
  belongs_to :mylist
  belongs_to :vtuber

  validates_uniqueness_of :vtuber_id, :scope => [:mylist_id]
end
