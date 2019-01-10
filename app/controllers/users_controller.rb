class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :current_user

  def index
    @users = current_user.followers
  end

  def followers
    @user = User.find params[:id]
    @follower = @user.followers
  end

  def following
    @user = User.find params[:id]
    @following = @user.following
  end

  def new
    @user = User.new user_params
  end

  def create
    @user = User.new user_params

    if @user.save
      # SignupMailer.signup_email(@user).deliver
      session[:user_id] = @user.id

      flash[:notice] = 'Thank you for signing up!'
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit
  end

  def update
      if @user.update(user_params)
        redirect_to feed_index_path
      else
        redirect_to edit_user_path(@user)
      end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :city, :date_of_birth, :avatar, :message)
  end
end
