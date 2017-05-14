require 'rails_helper'

include Helpers

describe "Users page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "should not have any before been created" do
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 0'
  end

  it "should contain created user" do
    create_user(username:"Asd123", password:"Password1")
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 1'
    expect(page).to have_content 'Asd123'
  end

  it "should not contain user with invalid fields" do
    create_user(username:"ax", password:"a")
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 0'
    expect(page).not_to have_content 'ax'
  end

  it "does not show admin users for normal users" do
    create_admin_user(username:"Owner", password:"Admin1")
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 1'
    expect(page).to have_content 'Owner'
    expect(page).not_to have_content 'Admin account'
  end

  it "shows admin users for admin users" do
    create_admin_user(username:"Owner", password:"Admin1")
    sign_in(username:"Owner", password:"Admin1")
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 1'
    expect(page).to have_content 'Admin account'
  end

  it "allows admin to destroy users" do
    create_admin_user(username:"Owner", password:"Admin1")
    create_user(username:"Username123", password:"Password1")
    sign_in(username:"Owner", password:"Admin1")
    visit users_path
    page.all(:css, '.btn')[1].click
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 1'
    expect(page).to have_content 'User was successfully destroyed.'
    expect(page).not_to have_content 'Username123'
  end

  it "does not show blocked users for normal users" do
    create_admin_user(username:"Owner", password:"Admin1")
    sign_in(username:"Owner", password:"Admin1")
    create_user(username:"User123", password:"Password56")
    block_user(user_id:User.last.id)
    sign_out
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 2'
    expect(page).to have_content 'User123'
    expect(page).not_to have_content 'Account blocked'
  end

  it "shows blocked users for admin users" do
    create_admin_user(username:"Owner", password:"Admin1")
    sign_in(username:"Owner", password:"Admin1")
    create_user(username:"User123", password:"Password32")
    block_user(user_id:User.last.id)
    visit users_path
    expect(page).to have_content 'Listing Users'
    expect(page).to have_content 'Number of users: 2'
    expect(page).to have_content 'User123'
    expect(page).to have_content 'Account blocked'
  end
end