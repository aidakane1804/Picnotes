class DislikesController < ApplicationController
  def create
    note = Note.find params[:note_id]
    dislike = Dislike.new(user: current_user, note: note)
    if !can? :dislike, note
      head :unauthorized
    elsif dislike.save
      redirect_to note, notice: 'Thank you for disliking!'
    else
      redirect_to note, alert: 'You already disliked the note.'
    end
  end

  def destroy
    dislike = Dislike.find params[:id]
    if can? :destroy, dislike
      dislike.destroy
      redirect_to dislike.note, notice: 'Dislike removed'
    else
      head :unauthorized
    end
  end
end
