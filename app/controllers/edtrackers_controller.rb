class EdtrackersController < ApplicationController
  protect_from_forgery except: :fetch_model_form
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, except: [:new, :update_status, :fetch_model_form, :show, :comment_section_edtracker]

  def new
    @edtrackers = Edtracker.all
    @want_to_learn = Edtracker.where(edtracker_type: "Want To Learn").order('created_at DESC')
    @curr_learning = Edtracker.where(edtracker_type: "Currently Learning").order('created_at DESC')
    @learned = Edtracker.where(edtracker_type: "Learned").order('created_at DESC')
    if params[:user_id]
      # if params[:user_id] != current_user.id.to_s
      @current_user_id = current_user.id
      user_edtracker = User.find_by(id: params[:user_id])
      @user = user_edtracker
      @edtracker = Edtracker.new
    else
      @user = current_user
      @edtracker = Edtracker.new
    end
  end

  def create
    @edtracker = Edtracker.new(edtracker_params)
    @edtracker.edtracker_type = params['edtracker_type']
    @edtracker.user = current_user
    if @edtracker.save!
      redirect_to new_edtracker_path
    else
      flash[:error] = 'Could not save record inside Database, Please try again later!'
      redirect_to new_edtracker_path
    end
  end

  def card_liked
    @edtracker = Edtracker.find(params[:edtracker_id])
    @selected_ed_tracker = params[:edtracker_id]
    card_like = @edtracker.card_likes.where(user: current_user).last
    unless card_like.present?
      CardLike.create(edtracker: @edtracker, user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end

  def card_comment_likes
    edtracker = Edtracker.find(params[:edtracker_id])
    CardCommentLike.create(edtracker: edtracker, user: current_user)
    respond_to do |format|
      format.js
    end
  end

  def card_liked_destroy
    @edtracker = Edtracker.find(params[:edtracker_id])
    card_like = @edtracker.card_likes.where(user: current_user).last
    if card_like.present?
      card_like.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  def show
    @edtracker = Edtracker.find_by(:id)
  end

  def fetch_model_form
    @card = Edtracker.find_by_id(params[:id])
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  def comment_section_edtracker
    @card = Edtracker.find_by_id(params[:id])
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  def update
    @edtracker = Edtracker.find(params[:id])
    if @edtracker.user_id.to_s == current_user.id.to_s
    @edtracker.update(edtracker_params)
    @edtracker.save
    end
    redirect_to new_edtracker_path

  end

  def update_status
    @edtracker = Edtracker.find(params[:edtracker_id])
    if @edtracker && params[:current_user_id]
      if @edtracker.user_id.to_s == params[:current_user_id]
      @edtracker.edtracker_type = params[:status]
      @edtracker.save
      end
    end
  end

  def create_comment
    @card = Edtracker.find_by_id(params[:id])
    if !params["card_comment"].empty? && @card
    @ed_tracker_comment = CardCommentLike.new(edtracker_id: @card.id, body: params["card_comment"], user_id: current_user.id)
    @ed_tracker_comment.save
    end
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  private

  def edtracker_params
    params.require(:edtracker).permit(:edtracker_type, :topic, :category, :card_like, :hashtag, :notes, :link)
  end
end
