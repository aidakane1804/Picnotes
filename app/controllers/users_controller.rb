class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :current_user

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
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
    respond_to do |format|
      if @user.update(user_params)
        format.html {redirect_to session_path, notice: 'User successfully updated'}
      else
        format.html {render :edit}
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :city, :date_of_birth, :avatar)
  end
end
