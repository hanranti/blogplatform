require 'rails_helper'

RSpec.describe Comment, type: :model do

  before :all do
    User.create username:"Username1", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username2", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username3", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username4", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username5", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username7", password:"Password1", password_confirmation:"Password1"
    User.create username:"Username8", password:"Password1", password_confirmation:"Password1"
  end
  it "has the text set correctly and can be saved to database" do
    comment = Comment.new text:"commentcommentcommentcomment"

    expect(comment.text).to eq("commentcommentcommentcomment")
    expect(comment).to be_valid
  end

  it "without text is not valid" do
    comment = Comment.new

    expect(comment).not_to be_valid
  end

  it "with a blank text is not valid" do
      comment = Comment.new text:""

      expect(comment).not_to be_valid
  end

  it "with no likes has 0 as like_ratio" do
    comment = Comment.create text:"commentcommentcommentcomment"

    expect(comment.likes_ratio).to eq(0)
  end

  it "has correct positive like_ratio" do
    comment = Comment.create text:"commentcommentcommentcomment98789888"
    Like.create like:true, comment:comment, user:User.all[0]
    Like.create like:true, comment:comment, user:User.all[1]
    Like.create like:true, comment:comment, user:User.all[2]
    Like.create like:true, comment:comment, user:User.all[3]
    Like.create like:true, comment:comment, user:User.all[4]
    Like.create like:false, comment:comment, user:User.all[5]
    Like.create like:false, comment:comment, user:User.all[6]
    expect(comment.likes_ratio).to eq(3)
  end

  it "has correct negative like_ratio" do
    comment = Comment.create text:"commentcommentcommentcomment98789888"
    Like.create like:true, comment:comment, user:User.all[0]
    Like.create like:false, comment:comment, user:User.all[1]
    Like.create like:false, comment:comment, user:User.all[2]
    Like.create like:false, comment:comment, user:User.all[3]
    Like.create like:false, comment:comment, user:User.all[4]
    Like.create like:false, comment:comment, user:User.all[5]
    Like.create like:false, comment:comment, user:User.all[6]

    expect(comment.likes_ratio).to eq(-5)
  end

  it "with equal amount of likes and dislikes has correct like_ratio" do
    comment = Comment.create text:"commentcommentcommentcomment98789888"
    Like.create like:true, comment:comment, user:User.all[0]
    Like.create like:true, comment:comment, user:User.all[1]
    Like.create like:true, comment:comment, user:User.all[2]
    Like.create like:false, comment:comment, user:User.all[3]
    Like.create like:false, comment:comment, user:User.all[4]
    Like.create like:false, comment:comment, user:User.all[5]

    expect(comment.likes_ratio).to eq(0)
  end
end