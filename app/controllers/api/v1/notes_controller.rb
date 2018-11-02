class Api::V1::NotesController < Api::BaseController
  before_action :authenticate_api_user, except: [:index, :show]
  def index
    @notes = Note.order(created_at: :desc)
    render json: @notes
  end

  def show
    @note = Note.find params[:id]
    render json: @note
  end



  def create
    note = Note.new note_params
    note.user = current_user
    if note.save
      render json: note
    else
      render json: { errors: note.errors.full_messages }
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :image)
  end

end
