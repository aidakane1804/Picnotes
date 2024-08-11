class FlashcardSetsController < ApplicationController
  before_action :set_flashcard_set, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :set_user, only: %i[index show create_flashcard new create]

  def index
    @flashcard_sets = current_user.flashcard_sets
  end

  def show
    @flashcard_set = FlashcardSet.find(params[:id])
    respond_to do |format|
      format.html { render partial: 'show', locals: { flashcard_set: @flashcard_set } }
      format.js
    end
  end

  def create_flashcard
    @flashcard_sets = current_user.flashcard_sets
    user = params[:user_id] ? User.find_by(id: params[:user_id]) : current_user
    @flashcard_sets = FlashcardSet.where(user: user)
    
    respond_to do |format|
      format.js
      format.html { redirect_to new_flashcard_set_path, notice: 'Flashcard was successfully created.' }
    end
  end

  def new
    @flashcard_set = FlashcardSet.new
    @flashcard_set.flashcard = {}
    respond_to do |format|
      format.html { render partial: 'new', locals: { flashcard_set: @flashcard_set } }
      format.js   
    end
  end

  def create
    @flashcard_set = current_user.flashcard_sets.build(flashcard_set_params)
    if @flashcard_set.save
      respond_to do |format|
        format.html { redirect_to feed_index_path, notice: 'Flashcard set was successfully created.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @flashcard_set.update(flashcard_set_params)
      redirect_to @flashcard_set, notice: 'Flashcard set was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @flashcard_set.destroy
    redirect_to feed_index_path, notice: 'Flashcard set was successfully destroyed.'
  end

  private

  def flashcard_set_params
    params.require(:flashcard_set).permit(:title, :user_id, flashcard: {})
  end

  def set_flashcard_set
    @flashcard_set = FlashcardSet.find(params[:id])
  end

  def set_user
    @user = current_user
  end
end
