class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :score, numericality: { greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 100,
                                    only_integer: true }
  validate do |rating|
    rating.errors[:user_post] << 'You already rated this post!' if Rating.where(user_id:rating.user_id, post_id:rating.post_id).count > 0
  end

end
