class Interaction < Contribution
  has_many :Reply
  validates :text, presence: true
end
