# require 'pry'

class BoardsController < ApplicationController
  def index
    @user = current_user
    @boards = Board.where(user: current_user)
  end

  def show
    @user = current_user
    @board = Board.find_by(id: params[:id])
  end

  def new
    @user = current_user
    @board = Board.new
  end

  def create
    @user = current_user
    @board = Board.new board_params
    @board.user = @user

    if @board.save
      redirect_to user_boards_path
    else
      render :new
    end
  end

  def toggle_note
    @board = Board.find_by_id(params[:board_id])
    @board.toggle_note(Note.find_by_id(params[:note_id]))
    @note = Note.find_by_id(params[:note_id])
    redirect_to note_path(@note)
  end

  private
  def board_params
    params.require(:board).permit(:name)
  end
end
