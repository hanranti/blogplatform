module PostsHelper
  def top_this_week
    Post.where(:created_at => 1.week.ago..Time.now).sort { |a, b| b.average_rating <=> a.average_rating }
  end
end
