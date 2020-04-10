class User < ApplicationRecord
  has_many :contributions
  has_many :likes
  validates :name, presence: true
end
