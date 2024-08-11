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
      logger.debug "Users Found: #{@users.inspect}"
      respond_to do |format|
        format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
        format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
      end
    else
     @notes = Note.order(created_at: :desc).all
      respond_to do |format|
        format.html
        format.js { render partial: 'notes' } 
      end
    end
  end

  def notes_by_tag
    if params[:tag].present?
      @tag_name = params[:tag]
      @notes = Note.includes(:tags).where(tags: { name: @tag_name }).all
    else
      @notes = Note.paginate(page: params[:page], per_page: 20)
    end

    respond_to do |format|
      format.js { render partial: 'notes' }
      format.html { render partial: 'notes' } # Assuming you want to render the same partial for HTML format
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
