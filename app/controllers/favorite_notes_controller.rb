class FavoriteNotesController < ApplicationController
  before_action :set_note, only: [:create, :destroy]

  def index
    @user = current_user
    @favorites = current_user.favorited_notes
  end

  def create
    if Favorite.create(favorited: @note, user: current_user)
      redirect_to @note, notice: 'Note has been favorited'
    else
      redirect_to @note, alert: 'Something went wrong'
    end
  end

  def destroy
    Favorite.where(favorited_id: @note.id, user_id: current_user.id).first.destroy
    redirect_to @note, notice: 'Note is no longer in favorites'
  end

  private

  def set_note
    @note = Note.find(params[:note_id] || params[:id])
  end
end
