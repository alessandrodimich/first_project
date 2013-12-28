class PasswordResetsController < ApplicationController

  layout 'basic'

  before_filter :verify_if_signed_in, only: [ :edit, :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      flash[:info] = "An email has been sent to your account with password reset instructions"
    redirect_to root_url
    else
      flash.now[:warning] = "Unable to find user with email #{params[:email]}"
      render 'new'
    end
  end

  def edit
    begin
      @user = User.find_by! password_reset_token: user_params
    rescue
      flash[:warning] = "Sorry, something went wrong!"
      redirect_to root_url
    end
  end

  def update

    @user = User.find_by! password_reset_token: user_params
    if @user
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:warning] = "Password reset has expired, please re-submit your email"
      redirect_to reset_password_path
    elsif @user.update_attributes(password: @user.password, password_confirmation: @user.password_confirmation)
      login_user(@user, "remember_me_yes")
      flash[:success] = "Your password has been reset!"
      redirect_to root_url
    else
      render "edit"
    end
  end

private

  def verify_if_signed_in
    if current_user
      flash[:info] = "You are already logged in, Please change your password from the settings page"
      redirect_to root_url #or to the profile page
    end
  end

  def user_params
     params.require(:id)
  end

end
