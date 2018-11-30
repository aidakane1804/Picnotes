class ReferencesController < ApplicationController
  before_action :find_note, only: [:create]
  before_action :find_reference, only: [:destroy]

  def create
    @reference = @note.references.build(reference_params)
    if @reference.save
      redirect_to note_path(@note)
    else
      render 'notes/show'
    end
  end

  def destroy
    @reference.destroy
    redirect_to note_path(@reference.note)
  end

  private

  def find_note
    @note = Note.find(params[:note_id])
  end

  def find_reference
    @reference = Reference.find(params[:id])
  end

  def reference_params
    params.require(:reference).permit(:title, :author, :link)
  end
end
