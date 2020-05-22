# frozen_string_literal: true
class Interaction < Contribution
  def respostes
    results = []
    replies.each do |reply|
      results << reply.as_json(except: [:updated_at, :title, :url, :tipo],:methods => [:type, :author,:respostes, :liked])
    end
    results
  end
end
