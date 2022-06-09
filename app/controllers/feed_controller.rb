class FeedController < ApplicationController
  def index
    if params[:user_id].present?
      # if params[:user_id] != current_user.id.to_s
        user = User.find_by(id: params[:user_id])
        @user = user
        @following = user.following rescue ''
        @notes = Note.where(user_id: user.following.pluck(:id)) rescue ''
        @notes = @notes.order(created_at: :desc) rescue ''
    elsif current_user.present?
      @user = current_user
      @following = current_user.following rescue ''
      @notes = Note.where(user_id: current_user.following.pluck(:id)) rescue ''
      @notes = @notes.order(created_at: :desc) rescue ''
    else
      # @notes = Note.all rescue ''
      @notes = Note.order(created_at: :desc) rescue ''
    end
    my_array = []

    session[:picnotes] = my_array
  end
end
