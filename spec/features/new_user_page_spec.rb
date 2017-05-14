require 'rails_helper'

include Helpers

describe "New user page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "should be able to create user with valid inputs" do
    create_user(username:"Username", password:"Password1")
    expect(page).to have_content 'User was successfully created.'
  end

  it "should not be able to create user with too short username" do
    create_user(username:"ab", password:"Password1")
    expect(page).to have_content 'Username length has to be at least 3 letters!'
  end

  it "should not be able to create user with too long username" do
    create_user(username:"123456789012345678901", password:"Password1")
    expect(page).to have_content 'Username length cannot be more than 20 letters!'
  end

  it "should not be able to create user with too short password" do
    create_user(username:"Username", password:"Pas1")
    expect(page).to have_content 'Password is too short (minimum is 5 characters)'
  end

  it "should not be able to create user with password that does not contain a number" do
    create_user(username:"Username", password:"Password")
    expect(page).to have_content 'Password should contain one number and one capital letter'
  end

  it "should not be able to create user with password that does not contain a capital letter" do
    create_user(username:"Username", password:"password1")
    expect(page).to have_content 'Password should contain one number and one capital letter'
  end

  it "should not be able to create user with password and password confirmation not matching" do
    create_user_with_different_password_confirmation(username:"Username", password:"Password1", password_confirmation:"Password2")
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  it "should not be able to create user with username already in use" do
    create_user(username:"Username", password:"Password1")
    create_user(username:"Username", password:"Password2")
    expect(page).to have_content "This username is already in use!"
  end
end