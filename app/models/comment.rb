class Comment < Interaction
  belongs_to :post

  validates :text, presence: true

end
