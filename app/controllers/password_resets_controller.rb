class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      session[:user_id] = @user.id

      flash[:notice] = 'Thank you for signing in!'
      redirect_to feed_index_path
    else
      render 'edit'                                     # Case (2)
    end
  end

  private
  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
