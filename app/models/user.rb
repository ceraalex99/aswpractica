class User < ApplicationRecord
  has_many :contributions, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  validates :name, presence: true
end
