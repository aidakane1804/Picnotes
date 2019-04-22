#app/controller/chats_controller.rb
require 'securerandom'
class ChatsController < ApplicationController
  before_action :require_login
  def index
    chats = current_user.chats
    @existing_chats_users = current_user.existing_chats_users
    # @existing_chats_users = current_user.existing_chats_users
    # @message = Message.new
    # @other_user = User.find(params[:other_user])
    # @chat = Chat.find_by(id: params[:id])
    # @message = Message.new
  end
  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    redirect_to user_chat_path(current_user, @chat,  :other_user => @other_user.id)
  end
  def show
    chats = current_user.chats
    @existing_chats_users = current_user.existing_chats_users
    @other_user = User.find(params[:other_user])
    @chat = Chat.find_by(id: params[:id])
    @message = Message.new
    # {"other_user"=>"35", "user_id"=>"2", "id"=>"7"}

    if Chat.find_by(id: params[:id]).subscriptions.last.user_id == current_user.id
       x = Chat.find_by(id: params[:id]).subscriptions.first.user_id


    Message.where("user_id = ? AND chat_id = ? AND new = ?", x , params[:id], TRUE).any?
    b =  Message.where("user_id = ? AND chat_id = ? AND new = ?", x , params[:id], TRUE)
     b.each do |z|
       b.update(new: false)

     end

    else
      y = Chat.find_by(id: params[:id]).subscriptions.last.user_id
     if Message.where("user_id = ? AND chat_id = ? AND new = ?", y , params[:id], TRUE).any?
      b =  Message.where("user_id = ? AND chat_id = ? AND new = ?",y , params[:id], TRUE)
      b.each do |z|
        b.update(new: false)


      end
       end


    end
  end


  private
  def find_chat(second_user)
    chats = current_user.chats
    chats.each do |chat|
      chat.subscriptions.each do |s|
        if s.user_id == second_user.id
          return chat
        end
      end
    end
    nil
  end
  def require_login
    redirect_to new_session_path unless logged_in?
  end
end