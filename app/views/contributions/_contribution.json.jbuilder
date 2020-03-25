json.extract! contribution, :id, :type, :text, :points, :user_id, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)
