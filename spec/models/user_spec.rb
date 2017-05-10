require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the name, password and password_confirmation set correctly and can be saved to database" do
    user = User.new username:"newUser", password:"Password1", password_confirmation:"Password1"

    expect(user.username).to eq("newUser")
    expect(user).to be_valid
  end

  it "without a username is not valid" do
    user = User.new password:"Password2", password_confirmation:"Password2"

    expect(user).not_to be_valid
  end

  it "without a password is not valid" do
    user = User.new username:"newUserName"

    expect(user).not_to be_valid
  end

  it "with too short username is not valid" do
    user = User.new username:"12", password:"3drowssaP", password_confirmation:"3drowssaP"

    expect(user).not_to be_valid
  end

  it "with password and password_confirmation not matching is not valid" do
      user = User.new username:"newUser2", password:"Password4", password_confirmation:"DifferentPassword4"

      expect(user).not_to be_valid
  end
end