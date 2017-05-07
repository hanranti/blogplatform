class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validates :like, uniqueness: { scope: [:user_id, :comment_id] }
  validate do |l|
    l.errors[:you] << 'cannot like your own comment!' if l.user == l.comment.user
  end
end
