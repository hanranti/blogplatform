module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def sign_out()
    click_link('Sign out')
  end

  def create_user(credentials)
    visit new_user_path
    fill_in('Username', with:credentials[:username])
    fill_in('Password', with:credentials[:password])
    fill_in('Password confirmation', with:credentials[:password])
    click_button('Create User')
  end

  def create_user_with_different_password_confirmation(credentials)
    visit new_user_path
    fill_in('Username', with:credentials[:username])
    fill_in('Password', with:credentials[:password])
    fill_in('Password confirmation', with:credentials[:password_confirmation])
    click_button('Create User')
  end

  def create_admin_user(credentials)
    User.create username:credentials[:username], password:credentials[:password], password_confirmation:credentials[:password], admin:true
  end

  def create_post(credentials)
    visit new_post_path
    fill_in('Name', with:credentials[:name])
    fill_in('Text', with:credentials[:text])
    click_button('Create Post')
  end

  def create_comment(credentials)
    visit post_path(credentials[:post_id])
    fill_in('Text', with:credentials[:text])
    click_button('Create Comment')
  end

  def rate_post(credentials)
    visit post_path(credentials[:post_id])
    fill_in('Score', with:credentials[:score])
    click_button('Create Rating')
  end

  def like_most_liked_comment(credentials)
    visit post_path(credentials[:post_id])
    page.all(:css, '.btn')[0].click
  end

  def dislike_most_liked_comment(credentials)
    visit post_path(credentials[:post_id])
    page.all(:css, '.btn')[1].click
  end

  def block_user(credentials)
    visit user_path(credentials[:user_id])
    click_link('Change blocked status')
  end
end