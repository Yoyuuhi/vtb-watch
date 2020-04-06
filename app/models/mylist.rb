class Mylist < ApplicationRecord
  has_many :vtubers, through: :mylist_vtubers
  has_many :mylist_vtubers
  belongs_to :user
end
