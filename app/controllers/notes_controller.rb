class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, except: [:index, :show, :new, :create, :upvote, :downvote, :addfolder]


  def index
    if params[:search]
      if params[:searchtest] == '1'
        # @notes = Note.tagged_with(params[:search])
        @notes = Note.tagged_with(params[:search], wild: true, any: true)
      elsif params[:searchtest] == '2'
        @users = User.where("username ILIKE ?", "%#{params[:search]}%")
      elsif params[:searchtest] == '3'
        @notes = Note.where("title ILIKE ?", "%#{params[:search]}%")
      end
      @searchresult = params[:search]
      @searchmodel = params[:searchtest]
    else
      @notes = Note.all
    end
    @user = current_user
  end

  def show
    @tags = @note.tags.order(created_ad: :desc)
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
    @boards = Board.where(user: current_user)
    @folders = Folder.where(user: current_user)
    @board = Board.find_by_id(params[:board_id])
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
      redirect_to notes_path
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
      redirect_to user_notes_session_path
    else
      render :edit
    end
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
