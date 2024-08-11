class FlashcardsController < ApplicationController
    before_action :set_flashcard, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
  
    # GET /flashcards
    def index
      @flashcards = current_user.flashcards
    end

    def new_field
      index = params[:index].to_i
      @flashcard = Flashcard.new
      render partial: 'flashcard_fields', locals: { f: @flashcard, index: index }
    end
  
    # GET /flashcards/1
    def show
    end
  
    # GET /flashcards/new
    def new
      @flashcard = Flashcard.new
      respond_to do |format|
        format.html { render partial: 'new', locals: { flashcard: @flashcard } }
        format.js
      end
    end

    def create_flashcard
      @flashcards = Flashcard.all 
      respond_to do |format|
        format.js  
        format.html { redirect_to new_flashcard_path, notice: 'Flashcard was successfully created.' }
      end
    end
  
    def edit
    end
  
    def create
      @flashcard = current_user.flashcards.build(flashcard_params)
      if @flashcard.save
        flashcard_count = current_user.flashcards.count
        @flashcards = current_user.flashcards
        respond_to do |format|
          format.js
          format.html { redirect_to feed_index_path, notice: 'Flashcard was successfully created.' }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.js { render :new }
        end
      end
    end   


    def update
      if @flashcard.update(flashcard_params)
        redirect_to @flashcard, notice: 'Flashcard was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /flashcards/1
    def destroy
      @flashcard.destroy
    #   redirect_to flashcards_url, notice: 'Flashcard was successfully destroyed.'
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
    def flashcard_set_params
        # Permit flashcard as a hash with dynamic keys
      params.require(:flashcard_set).permit(:title, :user_id, flashcard: {})
    end

    def questions_and_answers
      params.permit(:flashcard => {}).to_h[:flashcard].select { |k, v| k.start_with?('question_') || k.start_with?('answer_') }
    end

    def set_flashcard
      @flashcard = Flashcard.find(params[:id])
    end
  end