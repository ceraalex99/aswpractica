class Interaction < Contribution
  has_many :replies
  validates :text, presence: true
end
