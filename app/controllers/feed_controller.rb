class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:search].present?
      search_notes_and_users(params[:search])
      respond_to do |format|
        format.html { render partial: 'home/searching_result', locals: { search_results: render_to_string(partial: 'home/searching_result', locals: { search_results: @users }) } }
        format.js { render partial: 'home/searching_result', locals: { search_results: render_to_string(partial: 'home/searching_result', locals: { search_results: @users }) } }
      end
    else
      # Preserve the existing logic for handling notes based on user_id or current_user
      @notes = Note.paginate(page: params[:page], per_page: 20)
      
      if params[:user_id].present?
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
  
      respond_to do |format|
        format.html
        format.js
      end
    end
  
    @searchresult = params[:search]
    @folders = current_user.folders if user_signed_in?
    @favorites = current_user.favorited_notes if user_signed_in?
  end
  

  def feed_index
    @notes = Note.order(id: :desc)
  end

  def reference_note
    @note = Note.find(params[:note_id])
    @reference = Reference.new
  end

  def user_search
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
  def search_notes_and_users(query)
    @notesTagged = Note.tagged_with(query, wild: true, any: true)
    @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{query}%")
    @tagged = @notesTagged.pluck(:id)
    @notes = Note.where("title ILIKE ?", "%#{query}%").where.not(id: @tagged)
  end
end
