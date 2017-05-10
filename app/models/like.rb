class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validate do |l|
    l.errors[:you] << 'cannot like your own comment!' if l.user == l.comment.user
    l.errors[:you_already] << 'liked this comment!' if Like.where(user:l.user, comment:l.comment).count > 0
  end
end
