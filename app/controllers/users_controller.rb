class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def favorite(note)
    favorited.find_or_create_by(note: note)
  end

  def unfavorite(note)
    favorite.where(note: note).destroy_all
    note.reload
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

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :gender, :date_of_birth)
  end
end
