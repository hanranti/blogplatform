require 'rails_helper'

RSpec.describe Like, type: :model do

  before :all do
    User.create username:"NewUser", password:"Password123", password_confirmation:"Password123"
    Comment.create text:"TextForCommentTextForCommentTextForComment"
  end

  it "has the like set correctly and can be saved to database" do
    like = Like.new like:false, user:User.first, comment:Comment.first

    expect(like.like).to eq(false)
    expect(like).to be_valid
  end

  it "with a comment already liked by the same user is not valid" do
    Like.create like:false, user:User.first, comment:Comment.first
    like = Like.new like:true, user:User.first, comment:Comment.first

    expect(like).not_to be_valid
  end

  it "with same commenter and liker is not valid" do
    comment = Comment.create text:"12345678901234567890", user:User.first
    like = Like.new like:false, user:User.first, comment:comment

    expect(like).not_to be_valid
  end
end