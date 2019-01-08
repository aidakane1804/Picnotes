class FoldersController < ApplicationController
  def index
    @folders = Folder.where(user: current_user)
  end

  def show
    @folder = Folder.find(params[:id])
  end

  def new
    @user = current_user
    @folder = Folder.new
  end

  def create
    @user = current_user
    @folder = Folder.new folder_params
    @folder.user = @user

    if @folder.save
      redirect_to folders_path
    else
      render :new
    end
  end

  private
  def folder_params
    params.require(:folder).permit(:name)
  end
end
