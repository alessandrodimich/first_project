include ApplicationHelper

def login_user(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara as well.
    auth_token = User.new_auth_token
    cookies[:auth_token] = auth_token
    user.update_attribute(:auth_token, User.encrypt(auth_token))
  else
    visit login_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end

def full_name(user)
  [user.first_name, user.last_name].join " "
end