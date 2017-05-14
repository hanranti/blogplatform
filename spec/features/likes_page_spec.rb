require 'rails_helper'

include Helpers

describe "Likes page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "should not have any before been created" do
    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 0'
  end

  it "should contain created comment" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"textForComment")

    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 1'
    expect(page).to have_content "Post123: textForComment by Commenter"
  end

  it "should not contain comment with empty text" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"")

    visit comments_path
    expect(page).to have_content 'Listing Comments'
    expect(page).to have_content 'Number of comments: 0'
    expect(page).not_to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A %d %B %Y")}"
  end

  it "should not contain comment created week ago" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"textForComment")
    Comment.first.update_attribute(:created_at, Comment.first.created_at - 1.week)

    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 0'
    expect(page).not_to have_content "Post123: textForComment by Commenter"
  end

  it "should show positive amount of likes for comment" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"textForComment")

    create_user(username:"Liker1", password:"Like123")
    sign_in(username:"Liker1", password:"Like123")
    like_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id, like:true)
    sign_out

    create_user(username:"Liker2", password:"Like321")
    sign_in(username:"Liker2", password:"Like321")
    like_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id, like:true)
    sign_out

    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 1'
    expect(page).to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A")} +2"
  end

  it "should show negative amount of likes for comment" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"textForComment")

    create_user(username:"Liker1", password:"Like123")
    sign_in(username:"Liker1", password:"Like123")
    dislike_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id)
    sign_out

    create_user(username:"Liker2", password:"Like321")
    sign_in(username:"Liker2", password:"Like321")
    dislike_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id)
    sign_out

    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 1'
    expect(page).to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A")} -2"
  end

  it "should not show equal amount of likes for comment" do
    create_user(username:"Poster", password:"Poster1")
    sign_in(username:"Poster", password:"Poster1")
    create_post(name:"Post123", text:"sdasadakdnajndoandonasdoasdnasodasodnas")
    sign_out

    create_user(username:"Commenter", password:"Comment1")
    sign_in(username:"Commenter", password:"Comment1")
    create_comment(post_id:Post.first.id, text:"textForComment")

    create_user(username:"Liker1", password:"Like123")
    sign_in(username:"Liker1", password:"Like123")
    like_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id)
    sign_out

    create_user(username:"Liker2", password:"Like321")
    sign_in(username:"Liker2", password:"Like321")
    dislike_most_liked_comment(post_id:Comment.first.post.id, comment_id:Comment.first.id)
    sign_out

    visit likes_path
    expect(page).to have_content 'Top comments this week'
    expect(page).to have_content 'Number of comments this week: 1'
    expect(page).to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A")}"
    expect(page).not_to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A")} -"
    expect(page).not_to have_content "Post123: textForComment by Commenter, created at: #{Time.now.strftime("%A")} +"
  end
end