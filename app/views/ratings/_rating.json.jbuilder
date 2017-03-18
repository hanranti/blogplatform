json.extract! rating, :id, :score, :user_id, :post_id, :created_at, :updated_at
json.url rating_url(rating, format: :json)
