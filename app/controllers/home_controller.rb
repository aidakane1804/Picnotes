class HomeController < ActionController::Base
  protect_from_forgery with: :exception
  def index
    if params[:search].present?
      search_notes_and_users(params[:search])
      logger.debug "Users Found: #{@users.inspect}"
      respond_to do |format|
        format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
        format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
      end
    else
      @users = []
      @notesTagged = []
      @tagged = []
      @notes = Note.order(id: :desc).all
      respond_to do |format|
        format.html 
        format.js
      end
    end
    my_array = []
    session[:picnotes] = my_array
    @searchresult = params[:search]
    @folders = current_user.folders if user_signed_in?
    @favorites = current_user.favorited_notes if user_signed_in?  
  end
                      
  def trending
    if params[:search].present?
      search_notes_and_users(params[:search])
      respond_to do |format|
        format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
        format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
      end
    end
  end

  # def index
  #   if params[:search]
  #     if params[:search].blank?
  #       redirect_to search_index_path
  #     else
  #       @notesTagged = Note.tagged_with(params[:search], wild: true, any: true)
  #       @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{params[:search]}%")
  #       @tagged = Array.new
  #       @notesTagged.each do |noteTag|
  #         @tagged.push(noteTag.id)
  #       end
  #       @notes = Note.where("title ILIKE ?", "%#{params[:search]}%")
  #       @notes = @notes.where.not(id: @tagged)
  #       search_notes_and_users(params[:search])
  #       logger.debug "Users Found: #{@users.inspect}"
  #       respond_to do |format|
  #         format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
  #         format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
  #       end
  #     end
  #     @searchresult = params[:search]
  #   else
  #     @users = []
  #     @notesTagged = []
  #     @tagged = []
  #     @notes = Note.order(id: :desc).paginate(page: params[:page], per_page: 20)
  #     Rails.logger.debug "Request format: #{request.format.symbol}"
  #     respond_to do |format|
  #       format.html
  #       format.js
  #     end
  #   end
  # end

  def notes_by_tag
    if params[:tag].present?
      @tag_name = params[:tag]
      @notes = Note.includes(:tags).where(tags: { name: @tag_name }).all
    end

    respond_to do |format|
      format.js { render partial: 'notes' }
      format.html { render partial: 'notes' }
    end
  end



  private

    def search_notes_and_users(query)
      @notesTagged = Note.tagged_with(query, wild: true, any: true)
      @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{query}%")
      @tagged = @notesTagged.pluck(:id)
      @notes = Note.where("title ILIKE ?", "%#{query}%").where.not(id: @tagged)
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
end
