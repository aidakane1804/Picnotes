class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :current_user

  def index
    @users = current_user.followers rescue []
  end

  def followers
    @user = User.find params[:id]
    if @user == current_user
      @dash = 1
    else
      @dash = 2
    end
    @follower = @user.followers
  end

  def following
    @user = User.find params[:id]
    if @user == current_user
      @dash = 1
    else
      @dash = 2
    end
    @following = @user.following
  end

  def new
    @user = User.new user_params
  end

  def create
    @user = User.new user_params

    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      session[:user_id] = @user.id

      flash[:notice] = 'Thank you for signing ups!'
      redirect_to feed_index_path
    else
      render :new
    end
  end

  def show
    default_meta_tags
    @user = User.find params[:id]
  end

  def edit
  end

  def update
    if @user.update(user_params)
      @user.update(nationality: params[:nationality]) if params[:nationality].present?
      @user.update(about_me: params[:about_me]) if params[:about_me].present?
      redirect_to feed_index_path
    else
      redirect_to edit_user_path(@user)
    end
  end

  def destroy
    current_user.notes.each do |note|
      note.update_attributes(archived: true)
    end
    loop do
      number = rand(10_000..99_999)
      @email = "archivedaccount"+number.to_s+"@"+"gmail.com"
      break @email unless User.exists?(email: @email)
    end
    current_user.update_attributes(:email => @email)
    flash[:success] = "User archived."
    session.delete(:user_id)
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password,
                                 :password_confirmation, :city, :date_of_birth, :avatar,
                                 :message, :about_me, :nationality)
  end
end
