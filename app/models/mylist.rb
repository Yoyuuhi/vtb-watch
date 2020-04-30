class Mylist < ApplicationRecord
  has_many :vtubers, through: :mylist_vtubers
  has_many :mylist_vtubers, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
end
