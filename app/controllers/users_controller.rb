class UsersController < ApplicationController

  layout 'basic', only: :new

  before_action :verify_if_signed_in, only: [:new, :create]
  before_action :verify_if_not_signed_in, only: [:index, :edit, :update]

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :authorized_user, only: [:edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password_confirmation = @user.password if @user.password
    if @user.save
      login_user(@user, "remember_me_yes")
      flash[:success] = "Thank you for signing up!"
      redirect_to root_url
    else

      render "new", layout: 'basic'
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params_edit)
      flash[:success] = "Your profile has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password)
    end

    def user_params_edit
      params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation)
    end

    def authorized_user
      unless current_user &&  ( current_user.id == @user.id || current_user.admin?)
      flash[:warning] = "you are not authorized to perform this action!"
      redirect_to users_path
      end
    end

  end
