class Contribution < ApplicationRecord
  has_many :replies, :dependent => :destroy
  belongs_to :user
  has_many :likes, :dependent => :destroy

  def author
    user.name
  end

end
