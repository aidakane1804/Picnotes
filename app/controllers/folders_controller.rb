class FoldersController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:user_id]
      # if params[:user_id] != current_user.id.to_s
      user = User.find_by(id: params[:user_id])
      @user = user
      @folders = Folder.where(user: user)
    else
      @user = current_user
      @folders = Folder.where(user: current_user)
    end
  end

  def show
    if params[:user_id]
      # if params[:user_id] != current_user.id.to_s
      user = User.find_by(id: params[:user_id])
      @user = user
      @folder = Folder.find(params[:id])
    else
      @user = current_user
      @folder = Folder.find(params[:id])
    end
    @notes = @folder.notes.where(archived: false).order(id: :asc)

    @count = 0
    my_array = []
    @notes.each do |favorite|
      @count = @count + 1
      if @count < 15
        my_array.push favorite.title_slug
      end
    end
    session[:picnotes] = my_array
  end

  def new
    @user = current_user
    @folder = Folder.new
  end
  def create
    @user = current_user
    @folder = Folder.new(folder_params)
    @folder.user = @user
  
    respond_to do |format|
      if @folder.save
        format.html { redirect_to feed_index_path }
        format.js { render 'create_success', locals: { folder: @folder } }
      else
        format.html { render :new }
        format.js { render 'create_failure', locals: { errors: @folder.errors.full_messages } }
      end
    end
  end
  

  def destroy

    @folder = Folder.find(params[:id])
    @folder.destroy
    redirect_to feed_index_path
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :user_id)
  end
end
