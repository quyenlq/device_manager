class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:show, :edit, :update]
  def new
  	@user=User.new

  end

  def show
  	@user= User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Mail Sauron, thanks for using our service"
      sign_in(@user)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def signed_in_user
      redirect_to signin_url, warning: "Please sign in." unless signed_in?
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
  end

  def user_params
      params.require(:user).permit(:password, :password_confirmation, :username, :name)
    end
end