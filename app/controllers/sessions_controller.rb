class SessionsController < ApplicationController

  def index
    @notes = current_user.following_by_type('Notes').order("created_at DESC")
  end

  def show
    @user = current_user
  end

  def user_notes
    @user = current_user
  end

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id

      flash[:notice] = 'Thank you for signing in!'
      redirect_to feed_index_path
    else
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed Out'
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
