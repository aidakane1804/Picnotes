class SessionsController < ApplicationController
  respond_to :html, :js

  def index
    @notes = current_user.following_by_type('Notes').order("created_at DESC")
  end

  def show
    @user = current_user
  end

  def user_notes
    @user = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    @notes = Note.where(user: @user).order(id: :asc)
    @count = 0
    my_array = []
    @notes.each do |favorite|
      @count = @count + 1
      if @count < 15
        my_array.push favorite.title_slug
      end
    end
    session[:picnotes] = my_array
  end

  # def user_notes
  #   @user = current_user
  #   @notes = Note.where(user: @user).limit(15)  # Limiting to 15 notes directly in the query
  #   @note_titles = @notes.map(&:title_slug)     # Extracting title_slugs

  #   respond_to do |format|
  #     format.js   # This will respond to Ajax requests
  #   end
  # end

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
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Signed out successfully.' }
      format.js   
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
