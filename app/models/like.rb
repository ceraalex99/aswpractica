class Like < ApplicationRecord
  belongs_to :contribution
  belongs_to :user

  validates :user_id, uniqueness: {scope: :contribution_id}
end
