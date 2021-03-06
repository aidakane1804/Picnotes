class FavoriteNotesController < ApplicationController
  before_action :set_note, only: [:create, :destroy]

  def index
    @user = current_user
    @favorites = current_user.favorited_notes
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
