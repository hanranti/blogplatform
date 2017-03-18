json.extract! user, :id, :name, :password, :password_confirmation, :admin, :blocked, :created_at, :updated_at
json.url user_url(user, format: :json)
