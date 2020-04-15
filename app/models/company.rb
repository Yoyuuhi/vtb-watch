class Company < ApplicationRecord
  has_many :vtubers

  validates :name, presence: true
end
