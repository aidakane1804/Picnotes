class FeedController < ApplicationController
  def index
    @user = current_user
    @following = current_user.following
    @notes = Note.where(user_id: current_user.following.pluck(:id))
    @notes = @notes.order(created_at: :desc)
  end
end
