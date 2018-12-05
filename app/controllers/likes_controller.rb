class LikesController < ApplicationController
  def create
    note = Note.find params[:note_id]
    like = Like.new(user: current_user, note: note)
    if !can? :like, note
      head :unauthorized
    elsif like.save
      respond_to do |format|
        format.js
        format.html
      end
    else
      redirect_to note, alert: 'You already liked the note.'
    end
  end

  def destroy
    like = Like.find params[:id]
    if can? :destroy, like
      like.destroy
      respond_to do |format|
        format.js
        format.html
      end
    else
      head :unauthorized
    end
  end
end
