class FoldersController < ApplicationController
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
    params.require(:folder).permit(:name, :user_id)
  end
end
