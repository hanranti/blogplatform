require 'rails_helper'

RSpec.describe Post, type: :model do
  it "has the name, text set correctly and can be saved to database" do
    post = Post.new name:"PostName", text:"texttexttexttext"

    expect(post.name).to eq("PostName")
    expect(post.text).to eq("texttexttexttext")
    expect(post).to be_valid
  end

  it "without a name is not valid" do
    post = Post.new text:"someTextSomeTextSomeText"

    expect(post).not_to be_valid
  end

  it "without text is not valid" do
    post = Post.new name:"NameOfThePost"

    expect(post).not_to be_valid
  end

  it "with too short name is not valid" do
    post = Post.new name:"Pos", text:"12345678901234567890"

    expect(post).not_to be_valid
  end

  it "with too long name is not valid" do
    post = Post.new name:"1234567890123456789012345678901", text:"12345678901234567890"

    expect(post).not_to be_valid
  end

  it "with too short text is not valid" do
    post = Post.new name:"PostWithTooShortText", text:"123456789"

    expect(post).not_to be_valid
  end

  it "with no ratings has 0 as average_rating" do
    post = Post.create name:"PostWithNoRatings", text:"1234567890"

    expect(post.average_rating).to eq(0)
  end

  it "has correct average_rating" do
    post = Post.create name:"Post", text:"1234567890"

    user1 = User.create username:"UserForRatingPosts1", password:"Password123", password_confirmation:"Password123"
    user2 = User.create username:"UserForRatingPosts2", password:"Password123", password_confirmation:"Password123"
    Rating.create score:75, post:post, user:user1
    Rating.create score:35, post:post, user:user2

    expect(post.average_rating).to eq(55)
  end

  it "has correct most_liked_comment" do
    user1 = User.create username:"UserWithMostLikedComment", password:"Passwrod321", password_confirmation:"Passwrod321"
    user2 = User.create username:"UserWithSecondLikedComment", password:"Abc123", password_confirmation:"Abc123"
    user3 = User.create username:"UserWithMostDislikedComment", password:"Cba321", password_confirmation:"Cba321"
    
    post = Post.create name:"PostWithComments", text:"1231231231313123123131"

    comment1 = Comment.create text:"CommentWithMostLikes", post:post, user:user1
    comment2 = Comment.create text:"CommentWithSecondMostLikes", post:post, user:user2
    comment3 = Comment.create text:"CommentWithMostDislikes", post:post, user:user3

    Like.create user:user1, comment:comment2, like:true
    Like.create user:user1, comment:comment3, like:false

    Like.create user:user2, comment:comment1, like:true
    Like.create user:user2, comment:comment3, like:false

    Like.create user:user3, comment:comment1, like:true
    Like.create user:user3, comment:comment2, like:false

    expect(comment1).to eq(post.most_liked_comment)
  end
end