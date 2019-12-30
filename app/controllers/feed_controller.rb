class FeedController < ApplicationController
  def index
    if params[:user_id]
      # if params[:user_id] != current_user.id.to_s
        user = User.find_by(id: params[:user_id])
        @user = user
        @following = user.following rescue ''
        @notes = Note.where(user_id: user.following.pluck(:id)) rescue ''
        @notes = @notes.order(created_at: :desc) rescue ''
    else
      @user = current_user
      @following = current_user.following rescue ''
      @notes = Note.where(user_id: current_user.following.pluck(:id)) rescue ''
      @notes = @notes.order(created_at: :desc) rescue ''
    end

  end
end