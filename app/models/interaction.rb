class Interaction < Contribution
  has_many :replies, :dependent => :destroy
  validates :text, presence: true
end
