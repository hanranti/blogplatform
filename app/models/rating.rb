class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :score, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 100,
                                    only_integer: true }
  validate :user_must_not_have_rated_post, :on => :create
#  validate do |rating|
#    rating.errors[:you] << 'already rated this post!' if Rating.where(user_id:rating.user_id, post_id:rating.post_id).count > 0
#  end

  def user_must_not_have_rated_post
    errors[:you] << 'already rated this post!' if Rating.where(user_id:user_id, post_id:post_id).count > 0
  end
end
