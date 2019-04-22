class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :initiate_instance_variables
  include UsersHelper
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

  def about_us_meta_tags
    @page_title = 'About Our Online Learning Platform | Picnotes'
    @page_description = 'Picnotes is an online platform for lifelong learners. It is an open knowledge source guide where you can find notes, resources, article and relevant study material for a given topic.'
  end

  def default_meta_tags
    @page_title = 'Online Knowledge Sharing Platform | Picnotes'
    @page_description = 'Sign up to Picnotes, an online knowledge sharing hub on which you can share educational study material and notes on a variety of topics. It is a complete learning hotspot for learners, students and researchers.'
  end

  helper_method :current_user

  private

  def authenticate_user!
    if !user_signed_in?
      redirect_to new_session_path, alert: 'You must sign in or sign up first!'
    end
  end

end
