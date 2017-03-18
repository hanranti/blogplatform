class User < ActiveRecord::Base
    has_many :posts
    has_many :comments
    has_many :ratings
    has_many :likes
    has_many :follows
end
