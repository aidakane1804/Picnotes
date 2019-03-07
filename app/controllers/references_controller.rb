class ReferencesController < ApplicationController
  before_action :find_note, only: [:create]
  before_action :find_reference, only: [:destroy]

  def create
    @reference = @note.references.build(reference_params)
    @references_unordered = Reference.where(note_id: @note.id)
    @textbooks = @references_unordered.where(:file_type => 't')
    @videos = @references_unordered.where(:file_type => 'v')
    @papers = @references_unordered.where(:file_type => 'p')
    # if @reference.save
    #   flash[:notice] = "Note Saved"
    #   redirect_to note_path(@note)
    # else
    #   flash[:notice] = "Error"
    #   render :new
    # end
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
    redirect_to note_path(@reference.note), turbolinks: false
  end

  def new
    @note = Note.find(params[:note_id])
    @reference = Reference.new
    @folders = Folder.where(user: current_user)
    @similar = Note.tagged_with(@note.tags, :any => true)

    @references_unordered = Reference.where(note_id: @note.id)
    
    @textbooks = @references_unordered.where(:file_type => 't')
    @videos = @references_unordered.where(:file_type => 'v')
    @papers = @references_unordered.where(:file_type => 'p')
  end

  def edit
    @note = Note.find(params[:note_id])
    @reference = @note.references.find(params[:id])
    @user = current_user
  end

  def update
    @note = Note.find(params[:note_id])
    @reference = @note.references.find(params[:id])
    if @reference.update reference_params
      redirect_to note_path(@note)
    else
      render :edit
    end
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
