class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validates :like, uniqueness: { scope: [:user_id, :comment_id] }
end
