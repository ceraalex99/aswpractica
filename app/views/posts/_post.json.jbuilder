json.extract! post, :id, :url, :tipo, :title, :created_at, :updated_at
json.url post_url(post, format: :json)
