class FoldersController < ApplicationController
  def index
    @user = current_user
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

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    redirect_to folders_path
  end

  private
  def folder_params
    params.require(:folder).permit(:name)
  end
end
