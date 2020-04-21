class Vtuber < ApplicationRecord
  has_many :mylists, through: :mylist_vtubers
  has_many :mylist_vtubers
  has_many :videos
  belongs_to :company

  validates :name, presence: true
  validates :twitter, presence: true
  validates :channel, presence: true
end
