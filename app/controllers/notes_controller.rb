class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:add_picnotes_to_folder]
  before_action :authorize_user!, except: [:index, :trending,:notes_by_tag, :show,:create_comment, :comment_section_note, :comment_delete,:explore, :new, :create, :upvote, :community_guideline, :migrate_notes, :tl, :about_us, :contact_us, :freelance_research, :educational_organizations, :downvote, :addfolder, :empty, :terms_and_conditions, :what_is_picnotes, :message_from_the_founder, :sharing_your_knowledge, :communication_and_interaction, :optimizing_your_dashboard, :what_type_of_topics_you_should_share, :contact_us_form, :add_note_to_folder, :for_schools]

  def empty
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
        format.js { render partial: 'note' } 
      end
    end
  end

  def notes_by_tag
    if params[:tag].present?
      @tag_name = params[:tag]
      @tags = @note.tags.order(created_at: :desc)
      @references_unordered = Reference.where(note_id: @note.id)
      # @references = @references_unordered.sort_by &:file_type
      @references = @references_unordered.where(:file_type => 't')
  
      @textbooks = @references_unordered.where(:file_type => 't')
      @videos = @references_unordered.where(:file_type => 'v')
      @papers = @references_unordered.where(:file_type => 'p')
      @sources = @references_unordered.where(:file_type => 's')
  
      @reference = Reference.new
      @like = @note.likes.find_by_user_id current_user
      @dislike = @note.dislikes.find_by_user_id current_user
      @user = current_user
      @folders = Folder.where(user: current_user)
      @note_session = session[:picnotes] || []
      @note_exist = @note_session.include? @note.title_slug
      @previous_note = @note.next
      @next_note = @note.previous
      if @note_exist
        @note_index = @note_session.find_index(@note.title_slug)
        @note_index_next = @note_index + 1
        @next_note = Note.where(title_slug: @note_session[@note_index_next]).first
        @note_index_previous = @note_index - 1
        @previous_note = Note.where(title_slug: @note_session[@note_index_previous]).first
      end
      @similar = Note.tagged_with(@note.tags, :any => true)
      @meta_title = @note.title
      @meta_description = @note.body.slice(0, 120) + "..."
      @meta_keywords = @note.body
      @meta_image = @note.image.url
  
      set_meta_tags title: @meta_title, description: @meta_description, keywords: @meta_keywords
  
      respond_to do |format|
        format.js
        format.html
      end
      @notes = Note.includes(:tags).where(tags: { name: @tag_name }).all
    else
      @notes = Note.paginate(page: params[:page], per_page: 20)
    end

    respond_to do |format|
      format.js { render partial: 'note' }
      format.html { render partial: 'note' }
    end
  end

  def index
    default_meta_tags
    if params[:search]
      if params[:search].blank?
        redirect_to search_index_path
      else
        @notesTagged = Note.tagged_with(params[:search], wild: true, any: true)
        @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{params[:search]}%")
        @tagged = Array.new
        @notesTagged.each do |noteTag|
          @tagged.push(noteTag.id)
        end
        @notes = Note.where("title ILIKE ?", "%#{params[:search]}%")
        @notes = @notes.where.not(id: @tagged)
        search_notes_and_users(params[:search])
        logger.debug "Users Found: #{@users.inspect}"
        respond_to do |format|
          format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
          format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
        end
      end
      @searchresult = params[:search]
    else
      @users = []
      @notesTagged = []
      @tagged = []
      @notes = Note.order(id: :desc).paginate(page: params[:page], per_page: 20)
      Rails.logger.debug "Request format: #{request.format.symbol}"
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def comment_section_note
    @note = Note.find_by_id(params[:id])
    @comments = @note.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  def comment_delete
    @note = Note.find(params[:note_id])
    card_comment = CardCommentLike.find(params[:id])
    
    if card_comment.user == current_user || @note.user == current_user
      card_comment.destroy
      @comments = @note.card_comment_likes.count
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_path, alert: "You are not authorized to delete this comment"
    end
  end
  def card_comment_likes
    note = Note.find(params[:note_id])
    CardCommentLike.create(note: note, user: current_user)
    respond_to do |format|
      format.js
    end
  end
  
  def create_comment
    @note = Note.find_by_id(params[:id])
    if !params["card_comment"].empty? && @note
    @note_comment = CardCommentLike.new(note_id: @note.id, body: params["card_comment"], user_id: current_user.id)
    @note_comment.save
    end
    @comments = @note.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end


  def card_liked
    @note = Note.find(params[:note_id])
    @selected_note = params[:note_id]
    card_like = @note.card_likes.where(user: current_user).last
    unless card_like.present?
      CardLike.create(note: @note, user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end


  def card_liked_destroy
    @note = Note.find(params[:note_id])
    card_like = @note.card_likes.where(user: current_user).last
    if card_like.present?
      card_like.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    redirect_to root_path, alert: "Note not found" unless @note.present?

    @tags = if params[:tag].present?
      @note.tags.where(name: params[:tag])
    else
      @note.tags
    end
    @tags = @tags.order(created_at: :desc)
    @references_unordered = Reference.where(note_id: @note.id)
    # @references = @references_unordered.sort_by &:file_type
    @references = @references_unordered.where(:file_type => 't')

    @textbooks = @references_unordered.where(:file_type => 't')
    @videos = @references_unordered.where(:file_type => 'v')
    @papers = @references_unordered.where(:file_type => 'p')
    @sources = @references_unordered.where(:file_type => 's')

    @reference = Reference.new
    @like = @note.likes.find_by_user_id current_user
    @dislike = @note.dislikes.find_by_user_id current_user
    @user = current_user
    @folders = Folder.where(user: current_user)
    @note_session = session[:picnotes] || []
    @note_exist = @note_session.include? @note.title_slug

    if params.dig(:tag)
      @previous_note = @note.previous tag: params.dig(:tag)
      @next_note = @note.next tag: params.dig(:tag)
    elsif params.dig(:picnotes_type)
      @previous_note = @note.previous user: current_user, picnotes_type: params.dig(:picnotes_type)
      @next_note = @note.next user: current_user, picnotes_type: params.dig(:picnotes_type)
    elsif params.dig(:folderid)
      @previous_note = @note.previous user: current_user, folderid: params.dig(:folderid)
      @next_note = @note.next user: current_user, folderid: params.dig(:folderid)
    else
      @previous_note = @note.next
      @next_note = @note.previous
    end
    
    # if @note_exist
    #   @note_index = @note_session.find_index(@note.title_slug)
    #   @note_index_next = @note_index + 1
    #   @next_note = Note.where(title_slug: @note_session[@note_index_next]).first
    #   @note_index_previous = @note_index - 1
    #   @previous_note = Note.where(title_slug: @note_session[@note_index_previous]).first
    # end

    @similar = Note.tagged_with(@note.tags, :any => true)
    @meta_title = @note.title
    @meta_description = @note.body.slice(0, 120) + "..."
    @meta_keywords = @note.body
    @meta_image = @note.image.url

    set_meta_tags title: @meta_title, description: @meta_description, keywords: @meta_keywords

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @user = current_user
    @note = Note.new
  end

  def home_pagination
    
  end

  def explore
    default_meta_tags
    if params[:search].present?
      @notesTagged = Note.tagged_with(params[:search], wild: true, any: true)
      @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{params[:search]}%")
      @tagged = @notesTagged.pluck(:id)
      @notes = Note.where("title ILIKE ?", "%#{params[:search]}%").where.not(id: @tagged)
  
      respond_to do |format|
        format.html { render partial: 'searching_result', locals: { search_results: @notes } }
        format.js { render partial: 'searching_result', locals: { search_results: @notes } }
      end
    else
      @notes = Note.order(id: :desc).all
      @notesTagged = []
      @tagged = []
      Rails.logger.debug "Request format: #{request.format.symbol}"
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  
 
  def create
    @note = Note.new(note_params)
    @note.user = current_user  # Assuming you have a method to get the current_user
  
    if @note.save
      @note.update_column(:title_slug, @note.title.parameterize + "-#{@note.id}" )
      flash[:notice] = "Note Saved"
       redirect_to new_note_reference_path(@note)
      # redirect_to feed_index_path(@note)

    else
      flash.now[:alert] = @note.errors.full_messages.to_sentence
    end
  end
  
  def edit
    @user = current_user
  end

  def update
    if @note.update note_params
      redirect_to note_path(@note)
    else
      render :edit
    end
  
  end

  def terms_and_conditions
    # @users = User.all
    # aida = User.find_by(id: 2)
    #
    # @users.each do |user|
    #   user.follow(aida)
    # end

    @page_title = 'Terms and Conditions | Picnotes'
    @page_description = 'Sharing your knowledge. Optimizing your dashboard.'
    @page_keywords = 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
  end

  def about_us
    about_us_meta_tags
    if params[:search].present?
      search_notes_and_users(params[:search])
      respond_to do |format|
        format.html do
          render partial: 'searching_result', locals: { search_results: @users }
        end
        format.js do
          render partial: 'searching_result', locals: { search_results: @users }
        end
      end
    else
      # Handle the case where there is no search parameter
      @notes = Note.all
    end
  end

  def tl
    @userId = 55
    session[:user_id] = @userId
    @user = User.where(id: @userId).first
    sign_in_and_redirect @user, :event => :authentication
  end

  def migrate_notes
    @items = Note.all

    @items.each do |item|
      item.update_column(:title_slug, item.title.parameterize + "-#{item.id}")
    end
  end

  def for_schools
    for_schools_meta_tags
  end

  def contact_us
    @page_title = 'Contact Us | Picnotes'
    @page_description = 'Sharing your knowledge. Optimizing your dashboard.'
    @page_keywords = 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
  end

  def contact_us_form
    if params[:Email].present? && params[:Message].present?
      email = params[:Email]
      message = params[:Message]
      UserMailer.contact_us_mail(email, message).deliver_now rescue '""'
      redirect_to contact_us_notes_path
      flash[:notice] = "Message sent successfully."
    else
      flash[:notice] = "Please enter valid email."
      redirect_to contact_us_notes_path
    end
  end

  def community_guideline
    community_guideline_meta_tags
  end

  def freelance_research
    about_us_meta_tags
  end

  def educational_organizations
    @page_title = 'Picnotes Edu.| Picnotes'
    @page_description = 'We build private Picnotes portals for educational organizations such as K-12 schools, tutoring companies, online course providers.'
    @page_keywords = 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    #expires_in(30.days, public: true)
  end

  def what_is_picnotes
    about_us_meta_tags
  end

  def message_from_the_founder
    about_us_meta_tags
  end

  def sharing_your_knowledge
    about_us_meta_tags
  end

  def optimizing_your_dashboard
    about_us_meta_tags
  end

  def what_type_of_topics_you_should_share
    about_us_meta_tags
  end

  def communication_and_interaction
    about_us_meta_tags
  end

  def destroy
    @note.destroy
    redirect_to feed_index_path
  end

  def upvote
    @note = Note.find(params[:id])
    @note.upvote_by current_user
    respond_to do |format|
      format.js
      format.html
    end
  end

  def downvote
    @note = Note.find(params[:id])
    @note.downvote_by current_user
    respond_to do |format|
      format.js
      format.html
    end
  end

  def addfolder
    if params[:folder_id].blank?
      flash[:alert] = "Please select a folder."
      redirect_to request.referer
      return
    end
    @note = Note.find params[:note_id]
    @folder = Folder.find params[:folder_id]
    is_folder_contain_note = @note.folders.include?(@folder)
    @note.folders.push(@folder) unless is_folder_contain_note
    respond_to do |format|
      format.html { redirect_to feed_index_path }
      format.js { render 'create_success', locals: { folder: @folder, note: @note } }

    end
  end

  def add_note_to_folder
    @note = Note.find_by(id: params[:note_id])
    if @note.nil?
      flash[:alert] = "Note not found"
      redirect_to some_path # Redirect to an appropriate path or render an error view
      return
    end
    @folders = Folder.where(user: current_user)
    respond_to do |format|
      format.js
      format.html { render partial: 'add_note_to_folder' }
    end
  end
  
  
  def add_picnotes_to_folder
    @note = Note.find(params[:id])
    @folders = Folder.all
    respond_to do |format|
      format.js
    end
  end
  private

  def is_number? string
    true if Float(string) rescue false
  end

  def note_params
    params.require(:note).permit(:title, :body, :likes, :dislikes, :image, :tag_list, :search, :searchtest, :remote_image_url)
  end

  def find_note
    if is_number?(params[:id])
      @note = Note.where(id: params[:id]).first
    else
      @note = Note.where(title_slug: params[:id]).first
    end
  end

  def authorize_user!
    unless can?(:crud, @note)
      flash[:alert] = "Access Denied!"
      redirect_to root_path
    end
  end

  def search_notes_and_users(query)
    @notesTagged = Note.tagged_with(query, wild: true, any: true)
    @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{query}%")
    @tagged = @notesTagged.pluck(:id)
    @notes = Note.where("title ILIKE ?", "%#{query}%").where.not(id: @tagged)
  end

end
