class Api::V1::NotesController < Api::BaseController
  def index
    @notes = Note.order(created_at: :desc)
    render json: @notes
  end

  def show
    @note = Note.find params[:id]
    p @note
    render json: @note
  end

end
