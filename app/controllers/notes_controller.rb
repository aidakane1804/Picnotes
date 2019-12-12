class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, except: [:index, :show, :new, :create, :upvote, :community_guideline, :about_us, :contact_us, :freelance_research, :educational_organizations, :downvote, :addfolder, :empty, :terms_and_conditions, :what_is_picnotes, :message_from_the_founder, :sharing_your_knowledge, :communication_and_interaction, :optimizing_your_dashboard, :what_type_of_topics_you_should_share, :contact_us_form]

  def empty
  end

  def index
    default_meta_tags
    if params[:search]
      if params[:search].blank? && params[:searchtest] == '1'
        redirect_to search_index_path
      elsif params[:search].blank? && params[:searchtest] == '2'
        redirect_to search_index_path
      elsif params[:search].blank? && params[:searchtest] == '3'
        redirect_to search_index_path
      elsif params[:searchtest] == '1'
        # @notes = Note.tagged_with(params[:search])
        @notes = Note.tagged_with(params[:search], wild: true, any: true)
      elsif params[:searchtest] == '2'
        @users = User.where("first_name ILIKE ?", "%#{params[:search]}%").or(User.where("last_name ILIKE ?", "%#{params[:search]}%")).or(User.where("username ILIKE ?", "%#{params[:search]}%"))
      elsif params[:searchtest] == '3'
        @notes = Note.where("title ILIKE ?", "%#{params[:search]}%")
      end
      @searchresult = params[:search]
      @searchmodel = params[:searchtest]
    else
      @notes = Note.order(id: :desc).paginate(page: params[:page], per_page: 20)
      respond_to do |format|
        format.html
        format.js
      end
      # @notes = Note.order(id: :desc)
    end
    @user = current_user
  end

  def show
    default_meta_tags
    @tags = @note.tags.order(created_at: :desc)
    @references_unordered = Reference.where(note_id: @note.id)
    # @references = @references_unordered.sort_by &:file_type
    @references = @references_unordered.where(:file_type => 't')

    @textbooks = @references_unordered.where(:file_type => 't')
    @videos = @references_unordered.where(:file_type => 'v')
    @papers = @references_unordered.where(:file_type => 'p')

    @reference = Reference.new
    @like = @note.likes.find_by_user_id current_user
    @dislike = @note.dislikes.find_by_user_id current_user
    @user = current_user
    @folders = Folder.where(user: current_user)
    @previous_note = @note.next
    @next_note = @note.previous
    @similar = Note.tagged_with(@note.tags, :any => true)
    respond_to do |format|
      format.js
      format.html
    end
  end

  # def show
  #   @note = Note.find params[:id]
  #   @boards = Board.where(user: current_user)
  #   @board = Board.find_by_id(params[:board_id])
  #   respond_to do |format|
  #     format.js
  #     format.html
  #   end
  # end

  def new
    @user = current_user
    @note = Note.new
  end

  def create
    @note = Note.new note_params
    @note.user = current_user
    if @note.save
      flash[:notice] = "Note Saved"
      redirect_to new_note_reference_path(@note)
    else
      flash[:notice] = "Error"
      render :new
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
    about_us_meta_tags
  end

  def about_us
    about_us_meta_tags
  end

  def contact_us
    about_us_meta_tags
  end

  def contact_us_form
    if params[:Email].present? && params[:Message].present?
      email = params[:Email]
      message = params[:Message]
      UserMailer.contact_us_mail(email, message).deliver_now rescue '""'
      redirect_to contact_us_notes_path
    else
      redirect_to contact_us_notes_path
    end
  end

  def community_guideline
    about_us_meta_tags
  end

  def freelance_research
    about_us_meta_tags
  end

  def educational_organizations
    about_us_meta_tags
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
    redirect_to notes_path
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
    @note = Note.find params[:note_id]
    @folder = Folder.find params[:folder_id]
    @note.folders.push(@folder)
    redirect_to note_path(@note)
  end

  private


  def note_params
    params.require(:note).permit(:title, :body, :likes, :dislikes, :image, :tag_list, :search, :searchtest, :remote_image_url)
  end

  def find_note
    @note = Note.find params[:id]
  end

  def authorize_user!
    unless can?(:crud, @note)
      flash[:alert] = "Access Denied!"
      redirect_to root_path
    end
  end


end
