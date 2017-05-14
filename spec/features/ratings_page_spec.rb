require 'rails_helper'

include Helpers

describe "Ratings page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "should not have any before been created" do
    visit ratings_path
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts this week: 0'
  end

  it "should contain created post" do
    create_user(username:"NameOfTheUser", password:"Password1")
    sign_in(username:"NameOfTheUser", password:"Password1")
    create_post(name:'NameOfTheNewPost', text:'texttexttexttexttext123123123123')
    visit ratings_path
    
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts this week: 1'
    expect(page).to have_content 'NameOfTheNewPost'
    expect(page).to have_content 'By: NameOfTheUser'
    expect(page).to have_content 'average of ratings: 0'
    expect(page).to have_content Time.now.strftime("%A")
  end

  it "should not contain post with too short name" do
    create_user(username:"NameOfTheUser", password:"Password1")
    sign_in(username:"NameOfTheUser", password:"Password1")
    create_post(name:'ukh', text:'texttexttexttexttext123123123123')
    visit posts_path
    
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts: 0'
    expect(page).not_to have_content 'ukh'
    expect(page).not_to have_content 'By: NameOfTheUser'
    expect(page).not_to have_content 'average of ratings: 0'
    expect(page).not_to have_content Time.now.strftime("%A")
  end

  it "should not contain post with too long name" do
    create_user(username:"NameOfTheUser", password:"Password1")
    sign_in(username:"NameOfTheUser", password:"Password1")
    create_post(name:'1234567890123456789012345678901', text:'texttexttexttexttext123123123123')
    visit posts_path
    
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts: 0'
    expect(page).not_to have_content '1234567890123456789012345678901'
    expect(page).not_to have_content 'By: NameOfTheUser'
    expect(page).not_to have_content 'average of ratings: 0'
    expect(page).not_to have_content Time.now.strftime("%A")
  end

  it "should not contain post with too short text" do
    create_user(username:"NameOfTheUser", password:"Password1")
    sign_in(username:"NameOfTheUser", password:"Password1")
    create_post(name:'NameOfThePost', text:'123456789')
    visit posts_path
    
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts: 0'
    expect(page).not_to have_content 'NameOfThePost'
    expect(page).not_to have_content 'By: NameOfTheUser'
    expect(page).not_to have_content 'average of ratings: 0'
    expect(page).not_to have_content Time.now.strftime("%A")
  end

  it "should be rated correctly" do
    create_user(username:"NameOfThePoster", password:"Password1")
    sign_in(username:"NameOfThePoster", password:"Password1")
    create_post(name:'NameOfTheRatedPost', text:'texttexttexttexttext123123123123')
    sign_out

    create_user(username:"Rater1", password:"Rate1")
    sign_in(username:"Rater1", password:"Rate1")
    rate_post(post_id:Post.first.id, score:5)
    sign_out

    create_user(username:"Rater2", password:"Rate2")
    sign_in(username:"Rater2", password:"Rate2")
    rate_post(post_id:Post.first.id, score:25)
    sign_out

    visit ratings_path
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts this week: 1'
    expect(page).to have_content 'NameOfTheRatedPost'
    expect(page).to have_content 'By: NameOfThePoster'
    expect(page).to have_content 'average of ratings: 15'
    expect(page).to have_content Time.now.strftime("%A")
  end

  it "should not contain post created week ago" do
    create_user(username:"NameOfTheUser", password:"Password1")
    sign_in(username:"NameOfTheUser", password:"Password1")
    create_post(name:'NameOfTheNewPost', text:'texttexttexttexttext123123123123')
    Post.first.update_attribute(:created_at, Post.first.created_at - 1.week)
    visit ratings_path
    
    expect(page).to have_content 'Top blogs this week'
    expect(page).to have_content 'Number of posts this week: 0'
    expect(page).not_to have_content 'NameOfTheNewPost'
    expect(page).not_to have_content 'By: NameOfTheUser'
    expect(page).not_to have_content 'average of ratings: 0'
    expect(page).not_to have_content Time.now.strftime("%A")
  end
end