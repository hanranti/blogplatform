require 'rails_helper'

include Helpers

describe "User page" do
  before(:each) do
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  it "does not allow normal users to change blocked status of users" do
    create_user(username:"NameOfTheUser", password:"Password123")
    create_user(username:"newUser", password:"Password1")
    sign_in(username:"newUser", password:"Password1")
    visit user_path(User.first.id)

    expect(page).to have_content 'Name: NameOfTheUser'
    expect(page).not_to have_content 'Admin account'
    expect(page).not_to have_content 'Account blocked'
    expect(page).not_to have_content 'Change blocked status'
  end

  it "does not show admin status for normal accounts" do
    create_admin_user(username:"Admin1", password:"Admin123")
    create_user(username:"Username321", password:"Pass12321")
    sign_in(username:"Username321", password:"Pass12321")
    visit user_path(User.first.id)

    expect(page).to have_content 'Name: Admin1'
    expect(page).not_to have_content 'Admin account'
    expect(page).not_to have_content 'Account blocked'
    expect(page).not_to have_content 'Change blocked status'
  end

  it "does not show blocked status for normal accounts" do
    create_admin_user(username:"Admin1", password:"Admin123")
    create_user(username:"Username321", password:"Pass12321")
    create_user(username:"BlockedUser", password:"Block123")
    sign_in(username:"Username321", password:"Pass12321")
    visit user_path(User.last.id)

    expect(page).to have_content 'Name: BlockedUser'
    expect(page).not_to have_content 'Admin account'
    expect(page).not_to have_content 'Account blocked'
    expect(page).not_to have_content 'Change blocked status'
  end

  it "shows admin status for admin accounts" do
    create_admin_user(username:"NameOfTheUser", password:"Password123")
    sign_in(username:"NameOfTheUser", password:"Password123")
    visit user_path(User.first.id)

    expect(page).to have_content 'Name: NameOfTheUser'
    expect(page).to have_content 'Admin account'
    expect(page).not_to have_content 'Account blocked'
    expect(page).to have_content 'Change blocked status'
  end

  it "shows blocked status for admin accounts" do
    create_user(username:"NameOfTheUser", password:"Password123")
    create_admin_user(username:"Admin", password:"Admin1")
    sign_in(username:"Admin", password:"Admin1")
    block_user(user_id: User.first.id)
    visit user_path(User.first.id)

    expect(page).to have_content 'Name: NameOfTheUser'
    expect(page).not_to have_content 'Admin account'
    expect(page).to have_content 'Account blocked'
    expect(page).to have_content 'Change blocked status'
  end
end