class Reply < Interaction
  belongs_to :contribution

  def parent_type
    contribution.type
  end
end
