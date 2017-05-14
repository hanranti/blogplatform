require 'rails_helper'

include Helpers

describe "Post page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "should contain all the fields given when created" do
    create_user(username:"ASDFG", password:"Pass321")
    sign_in(username:"ASDFG", password:"Pass321")
    create_post(name:"NameOfThePost", text:"asdasdasdasdasdasdasdasd123123123123123123123123")

    visit post_path(Post.first.id)
    expect(page).to have_content 'NameOfThePost'
    expect(page).to have_content 'Written by: ASDFG'
    expect(page).to have_content 'asdasdasdasdasdasdasdasd123123123123123123123123'
    expect(page).to have_content 'Average of 0 ratings: 0'
  end

  it "should contain 1 created rating" do
    create_user(username:"ASDFG", password:"Pass321")
    sign_in(username:"ASDFG", password:"Pass321")
    create_post(name:"NameOfThePost", text:"asdasdasdasdasdasdasdasd123123123123123123123123")
    sign_out
    create_user(username:"QWERTY", password:"Rater123")
    sign_in(username:"QWERTY", password:"Rater123")
    rate_post(post_id:Post.first.id, score:99)

    visit post_path(Post.first.id)
    expect(page).to have_content 'NameOfThePost'
    expect(page).to have_content 'Written by: ASDFG'
    expect(page).to have_content 'asdasdasdasdasdasdasdasd123123123123123123123123'
    expect(page).to have_content 'Average of 1 rating: 99'
  end

  it "should contain 2 created ratings" do
    create_user(username:"ASDFG", password:"Pass321")
    sign_in(username:"ASDFG", password:"Pass321")
    create_post(name:"NameOfThePost", text:"asdasdasdasdasdasdasdasd123123123123123123123123")
    sign_out
    create_user(username:"QWERTY", password:"Rater123")
    sign_in(username:"QWERTY", password:"Rater123")
    rate_post(post_id:Post.first.id, score:42)
    sign_out
    create_user(username:"ZXCVB", password:"Rater321")
    sign_in(username:"ZXCVB", password:"Rater321")
    rate_post(post_id:Post.first.id, score:24)

    visit post_path(Post.first.id)
    expect(page).to have_content 'NameOfThePost'
    expect(page).to have_content 'Written by: ASDFG'
    expect(page).to have_content 'asdasdasdasdasdasdasdasd123123123123123123123123'
    expect(page).to have_content 'Average of 2 ratings: 33'
  end

  it "should contain the only created comment as the most liked comment" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Most liked comment: Commenter: commentcomment'
  end

  it "should contain the only liked comment as the most liked comment" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")
    sign_out
    create_user(username:"SecondCommenter", password:"Aaa111")
    sign_in(username:"SecondCommenter", password:"Aaa111")
    like_most_liked_comment(post_id:Post.first.id)
    create_comment(post_id:Post.first.id, text:"tnemmoctnemmoc")

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Most liked comment: Commenter: commentcomment like dislike +1'
  end

  it "should contain the only not disliked comment as the most liked comment" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")
    sign_out
    create_user(username:"SecondCommenter", password:"Aaa111")
    sign_in(username:"SecondCommenter", password:"Aaa111")
    dislike_most_liked_comment(post_id:Post.first.id)
    create_comment(post_id:Post.first.id, text:"tnemmoctnemmoc")

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Most liked comment: SecondCommenter: tnemmoctnemmoc'
  end

  it "should contain disliked comments" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")
    sign_out
    create_user(username:"Disliker", password:"Aaa111")
    sign_in(username:"Disliker", password:"Aaa111")
    dislike_most_liked_comment(post_id:Post.first.id)

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Commenter: commentcomment like dislike -1'
  end

  it "should allow to edit or delete your own comment" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Most liked comment: Commenter: commentcomment edit comment delete comment'
    expect(page).not_to have_content 'Most liked comment: Commenter: commentcomment like dislike'
  end

  it "should not allow to edit or delete your own comment" do
    create_user(username:"Poster", password:"Post123")
    sign_in(username:"Poster", password:"Post123")
    create_post(name:"ASDASDASDASD", text:"QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321")
    sign_out
    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"commentcomment")
    sign_out
    sign_in(username:"Poster", password:"Post123")

    visit post_path(Post.first.id)
    expect(page).to have_content 'ASDASDASDASD'
    expect(page).to have_content 'Written by: Poster'
    expect(page).to have_content 'QWEQWEQWEQWEQWEQWEQWEQWEQWEQWEqwe123123321321'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).not_to have_content 'Most liked comment: Commenter: commentcomment edit comment delete comment'
    expect(page).to have_content 'Most liked comment: Commenter: commentcomment like dislike'    
  end

  it "should allow user to edit own post" do
    create_user(username:"Post123", password:"Post321")
    sign_in(username:"Post123", password:"Post321")
    create_post(name:"Post123s post", text:"qwertyuiopasdfghjklzxcvbnm")

    visit post_path(Post.first.id)
    expect(page).to have_content 'Post123s post'
    expect(page).to have_content 'Written by: Post123'
    expect(page).to have_content 'qwertyuiopasdfghjklzxcvbnm'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).to have_content 'Edit post | Back'
  end

  it "should not allow user to edit other users post" do
    create_user(username:"Post123", password:"Post321")
    sign_in(username:"Post123", password:"Post321")
    create_post(name:"Post123s post", text:"qwertyuiopasdfghjklzxcvbnm")
    sign_out
    create_user(username:"user123", password:"Password9")
    sign_in(username:"user123", password:"Password9")

    visit post_path(Post.first.id)
    expect(page).to have_content 'Post123s post'
    expect(page).to have_content 'Written by: Post123'
    expect(page).to have_content 'qwertyuiopasdfghjklzxcvbnm'
    expect(page).to have_content 'Average of 0 ratings: 0'
    expect(page).not_to have_content 'Edit post | Back'
  end
end