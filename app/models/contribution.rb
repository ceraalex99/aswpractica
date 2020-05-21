class Contribution < ApplicationRecord
  has_many :replies, :dependent => :destroy
  belongs_to :user
  has_many :likes, :dependent => :destroy
  cattr_accessor :current_user

  def author
    user.name
  end

  def liked
    !likes.find_by(user_id: current_user.id).nil?
  end

end
