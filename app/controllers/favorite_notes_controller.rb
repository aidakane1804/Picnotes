class FavoriteNotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:create, :destroy]

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      @user = user
      @favorites = user.favorited_notes
    else
      @user = current_user
      @favorites = current_user.favorited_notes
    end
    @count = 0
    my_array = []
    @favorites.each do |favorite|
      @count += 1
      my_array.push favorite.title_slug if @count < 15
    end
    session[:picnotes] = my_array

    respond_to do |format|
      format.html # Renders index.html.erb if requested
      format.js   # Renders index.js.erb if requested
    end
  end
  def create
    if Favorite.create(favorited: @note, user: current_user)
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to @note, alert: 'Something went wrong'
    end
  end

  def destroy
    Favorite.where(favorited_id: @note.id, user_id: current_user.id).first.destroy
    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  def set_note
    @note = Note.find(params[:note_id] || params[:id])
  end
end
