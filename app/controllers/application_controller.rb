class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :initiate_instance_variables

  def user_signed_in?
    if session[:user_id].present? && current_user.nil?
      session[:user_id] = nil
    end

    session[:user_id].present?
  end

  helper_method :user_signed_in?

  def initiate_instance_variables
    @note = Note.find_by_id(params[:id]) || Note.new
    @notes = Note.all
    @user = User.new
  end
  helper_method :initiate_instance_variables

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :current_user

  private

  def authenticate_user!
    if !user_signed_in?
      redirect_to new_session_path, alert: 'You must sign in or sign up first!'
    end
  end

end
