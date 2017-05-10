require 'rails_helper'

RSpec.describe Rating, type: :model do

  before :all do
    User.create username:"NewUser", password:"Password123", password_confirmation:"Password123"
    Post.create name:"NewPost", text:"TextForPostTextForPostTextForPost"
  end

  it "has the score set correctly and can be saved to database" do
    rating = Rating.new score:10, user:User.first, post:Post.first

    expect(rating.score).to eq(10)
    expect(rating).to be_valid
  end

  it "without a score is not valid" do
    rating = Rating.new user:User.first, post:Post.first

    expect(rating).not_to be_valid
  end

  it "with a negative score is not valid" do
    rating = Rating.new score:-1, user:User.first, post:Post.first

    expect(rating).not_to be_valid
  end

  it "with a score over 100 is not valid" do
    rating = Rating.new score:111, user:User.first, post:Post.first

    expect(rating).not_to be_valid
  end

  it "with post already rated by same user is not valid" do
    Rating.create score:36, user:User.first, post:Post.first
    rating = Rating.new score:55, user:User.first, post:Post.first

    expect(rating).not_to be_valid
  end
end
