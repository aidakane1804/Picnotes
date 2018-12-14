class ReferencesController < ApplicationController
  before_action :find_note, only: [:create]
  before_action :find_reference, only: [:destroy]

  def create
    @reference = @note.references.build(reference_params)
    @references_unordered = Reference.where(note_id: @note.id)
    @textbooks = @references_unordered.where(:file_type => 't')
    @videos = @references_unordered.where(:file_type => 'v')
    @papers = @references_unordered.where(:file_type => 'p')
    respond_to do |format|
      if @reference.save
        format.html {redirect_to note_path(@note)}
        format.js
      else
        render @note
      end
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
    params.require(:reference).permit(:title, :author, :link, :file_type)
  end
end
