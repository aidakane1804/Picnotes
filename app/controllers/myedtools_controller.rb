class MyedtoolsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :comment_section, :fetch_model_form1]

  def  new
     if params[:user_id]
       fetch_data_by_user(params[:user_id])
      # if params[:user_id] != current_user.id.to_s
      # @current_user_id = current_user.id
      user_myedtool = User.find_by(id: params[:user_id])
      @user = user_myedtool
      @myedtool = Myedtool.new
    elsif params[:id]
      fetch_data_by_user(params[:id])
      @user = current_user
      @myedtool = Myedtool.new
    end
  end

  def fetch_data_by_user(user_id)
    @myedtool= Myedtool.where(user_id: user_id )
    @books = Myedtool.where(myedtool_type: "book", user_id: user_id).order('created_at DESC')
    @articles = Myedtool.where(myedtool_type: "article" , user_id: user_id).order('created_at DESC')
    @blogs = Myedtool.where(myedtool_type: "blog", user_id: user_id).order('created_at DESC')
    @podcasts = Myedtool.where(myedtool_type: "podcast", user_id: user_id).order('created_at DESC')
    @courses = Myedtool.where(myedtool_type: "online_course", user_id: user_id).order('created_at DESC')
    @documentaries = Myedtool.where(myedtool_type: "documentary", user_id: user_id).order('created_at DESC')
  end

  def create
    @myedtool = Myedtool.new(myedtool_params)
    @myedtool.myedtool_type = params['myedtool_type']
    @myedtool.user = current_user
    if @myedtool.save!
      redirect_to new_myedtool_path(id: current_user.id)
    else
      flash[:error] = 'Could not save record inside Database, Please try again later!'
      redirect_to new_myedtool_path(id: current_user.id)
    end
  end

  def  card_likes_ed
    @myedtool = Myedtool.find(params[:myedtool_id])
    current_user_card_like = CardLike.where(myedtool: @myedtool, user: current_user)
    if current_user_card_like.empty?
    CardLike.create(myedtool: @myedtool, user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end

  def card_comment_likes_ed
    @myedtool = Myedtool.find(params[:myedtool_id])
    comment = CardCommentLike.where(myedtool: @myedtool, user: current_user )
    if comment.empty?
      CardCommentLike.create(myedtool: @myedtool, user: current_user)
    end
    respond_to do |format|
      format.js
    end
  end

  def card_likes_destroy_ed
    @myedtool = Myedtool.find(params[:myedtool_id])
    CardLike.where(myedtool: @myedtool, user: current_user).first.destroy
    respond_to do |format|
      format.js
    end
  end

  def update
    @myedtool = Myedtool.find(params[:id])
    if @myedtool.user_id.to_s == current_user.id.to_s
      @myedtool.update(myedtool_params)
      @myedtool.save
    end
    redirect_to new_myedtool_path(id: current_user.id)
  end

  def fetch_model_form1
    @card = Myedtool.find_by_id(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def comment_section
    @card = Myedtool.find_by_id(params[:id])
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  def create_ed_tool_comment
    @card = Myedtool.find_by_id(params['id'])
    if @card && !params["card_comment"].empty?
    @my_ed_tool_comment = CardCommentLike.new(myedtool_id: @card.id.to_s, body: params["card_comment"], user_id: current_user.id)
    @my_ed_tool_comment.save
    end
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  def comment_delete_edtools
    @card = Myedtool.find(params[:card_id])
    card_comment  = CardCommentLike.find(params[:id])
    card_comment.destroy
    @likes = @card.card_likes.count
    @comments = @card.card_comment_likes.count
    respond_to do |format|
      format.js
    end
  end

  private

    def myedtool_params
      params.require(:myedtool).permit(:myedtool_type,:addtitle, :chooseacategory, :tag_list,:notes, :link ,:hashtag)
    end

end
