class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :current_user

  def index
    
      @users = current_user.followers rescue []
  
  end

  def followers
    @user = User.find(params[:id])
    @dash = @user == current_user ? 1 : 2
    @followers = @user.followers
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
    @user = User.new
  end

  def create_session
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Signed in successfully.'
    else
      flash.now[:alert] = user ? 'Invalid email or password.' : 'Email not found. Please sign up first.'
      render :sign_in
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      session[:user_id] = @user.id

      begin
        aida = User.find_by(id: 2)
        @user.follow(aida)
      rescue => e
      end

      flash[:notice] = 'Thank you for signing up!'
      redirect_to feed_index_path
    else
      render :new
    end
  end

  def show

    if params[:search].present?
      search_notes_and_users(params[:search])
      logger.debug "Users Found: #{@users.inspect}"
      respond_to do |format|
        format.html { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
        format.js { render partial: 'searching_result', locals: { search_results: render_to_string(partial: 'searching_result', locals: { search_results: @users }) } }
      end
    else
        default_meta_tags
        @user = User.find params[:id]
        @notes = @user.notes.where(archived: false)
        @count = 0
        my_array = []
        @notes.each do |favorite|
          @count = @count + 1
          if @count < 15
            my_array.push favorite.title_slug
          end
        end
        session[:picnotes] = my_array
        respond_to do |format|
          format.html 
          format.js
        end
    end
    @searchresult = params[:search]

  end

  def edit


  end

  def update
    if @user.update(user_params)
      @user.update(nationality: params[:nationality]) if params[:nationality].present?
      @user.update(about_me: params[:about_me]) if params[:about_me].present?
      redirect_to feed_index_path, notice: 'Profile updated successfully.'
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit
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
  def search_notes_and_users(query)
    @notesTagged = Note.tagged_with(query, wild: true, any: true)
    @users = User.where("CONCAT_WS(' ', first_name, last_name, username) ILIKE ?", "%#{query}%")
    @tagged = @notesTagged.pluck(:id)
    @notes = Note.where("title ILIKE ?", "%#{query}%").where.not(id: @tagged)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password,
                                 :password_confirmation, :avatar, :about_me, :nationality)
  end
end
