class Post < Contribution
  validates :title, presence: true

  validate :url_xor_text

  before_create :default_values

  def default_values
    if url.blank?
      self.tipo = "ask"
    else
      self.tipo = "url"
    end
  end

  def url_xor_text
    unless url.blank? ^ text.blank?
      errors.add(:base, 'Specify a url or a text, not both')
    end
  end
end
