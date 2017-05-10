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
    post = Post.create name:"PostWithNoRatings", text:"123456789"

    expect(post.average_rating).to eq(0)
  end

  it "has correct average_rating" do
    post = Post.create name:"Post", text:"123456789"

    user1 = User.create username:"UserForRatingPosts1", password:"Password123", password_confirmation:"Password123"
    user2 = User.create username:"UserForRatingPosts2", password:"Password123", password_confirmation:"Password123"
    Rating.create score:75, post:post, user:user1
    Rating.create score:35, post:post, user:user2
    byebug

    expect(post.average_rating).to eq(55)
  end
end