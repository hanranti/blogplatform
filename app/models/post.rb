class Post < ActiveRecord::Base
  include RatingAverage

  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, length: { minimum: 4, maximum: 30}
  validates :text, length: { minimum: 10 }

  def most_liked_comment
    comments.sort { |a, b| b.likes_ratio <=> a.likes_ratio }.first
  end

  def self.top_last_week
    Post.where(:created_at => 1.week.ago..Time.now).sort { |a, b| b.average_rating <=> a.average_rating }
  end

  def to_s
    name
  end
end
