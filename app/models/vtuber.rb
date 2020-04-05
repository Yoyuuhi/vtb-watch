class Vtuber < ApplicationRecord
  has_many :mylists, through: :mylist_vtubers
  has_many :mylist_vtubers
  belongs_to :company
end
