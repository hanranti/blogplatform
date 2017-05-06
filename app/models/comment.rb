class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_many :likes

  validates :text, length: { minimum: 1, maximum: 200 }

  def likes_ratio
    #return 0 if likes.count == 0
    amount = 0;
    likes.each do |like|
      if like.like
        amount += 1
      else
        amount -= 1
      end
    end
    amount
  end
end
