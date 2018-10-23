class LikesController < ApplicationController
  def create
    note = Note.find params[:note_id]
    like = Like.new(user: current_user, note: note)
    if !can? :like, note
      head :unauthorized
    elsif like.save
      redirect_to note, notice: 'Thank you for liking!'
    else
      redirect_to note, alert: 'You already liked the note.'
    end
  end

  def destroy
    like = Like.find params[:id]
    if can? :destroy, like
      like.destroy
      redirect_to like.note, notice: 'Like removed'
    else
      head :unauthorized
    end
  end
end
