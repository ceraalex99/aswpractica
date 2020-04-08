class User < ApplicationRecord
  has_many :contributions
  validates :name, presence: true
end
