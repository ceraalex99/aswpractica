json.extract! contribution, :id, :tipo, :text, :user_id, :points, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)
