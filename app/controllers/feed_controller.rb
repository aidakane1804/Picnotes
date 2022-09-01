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
    @count = 0
    session[:picnotes] = []
    if @notes.count > 0
      @notes.where(archived: false).each do |note|
        @count = @count + 1
        if @count < 15
          my_array.push note.title_slug
        end
      end
    end
    session[:picnotes] = my_array
    if params[:search].present?
      @searched_users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{params[:search]}%")
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    else
      @searched_users = User.all
      respond_to do |format|
        format.js { render partial: 'search-results'}
      end
    end
  end
end
