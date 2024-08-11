class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  
  before_action :initiate_instance_variables
  after_action :track_action

  include UsersHelper

  helper_method :user_signed_in?, :current_user

  def user_signed_in?
    if session[:user_id].present? && current_user.nil?
      session[:user_id] = nil
    end
    session[:user_id].present?
  end

  def initiate_instance_variables
    @note = Note.find_by_id(params[:id]) || Note.new
    @notes = Note.all
    @user = User.new
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  protected

  def track_action
    ahoy.track "Ran action", request.path_parameters
  end

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to new_session_path, alert: 'You must sign in or sign up first!'
    end
  end

  def set_meta_tags(title:, description:, keywords:, image: nil)
    @page_title = title
    @page_description = description
    @page_keywords = keywords
    @page_image = image if image.present?
  end

  def default_meta_tags
    set_meta_tags(
      title: 'Picnotes | Knowledge Sharing Hub for Lifelong Learners',
      description: 'Create and share educational notes. Join a platform full of knowledge essentials. We connect people through general knowledge and education.',
      keywords: 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    )
  end

  def about_us_meta_tags
    set_meta_tags(
      title: 'About Us | Picnotes',
      description: 'Conscious lifelong learners have found a place to call home. Join an education community for lifelong leaners and share topics that you love. Be part of a worldwide learning hub. Free online general knowledge filled with general knowledge',
      keywords: 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    )
  end

  def community_guideline_meta_tags
    set_meta_tags(
      title: 'Guidelines | Picnotes',
      description: 'Try to treat others as you would want them to treat you.',
      keywords: 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    )
  end

  def for_schools_meta_tags
    set_meta_tags(
      title: 'For Schools | Picnotes',
      description: 'We build private Picnotes portals for educational organizations such as K-12 schools, tutoring companies, online course providers.',
      keywords: 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    )
  end

  def ed_fluencers_meta_tags
    set_meta_tags(
      title: 'EdFluencers | Picnotes',
      description: 'Conversations with thoughtful educational leaders and passionate lifelong learners.',
      keywords: 'free online general knowledge,free online knowledge base platform,general knowledge hub,knowledge hub,knowledge sharing websites,knowledge websites,online knowledge portal,online knowledge sharing hub,open knowledge,share your knowledge online,Educational Knowledge,research topics in education,intellectual knowledge,intellectual assets in knowledge management,intellectual knowledge management,best knowledge base platform,knowledge exchange platform,free knowledge base platform,free knowledge sharing platform,online knowledge sharing platform,intellectually stimulating books,hemoglobin study material,Respiratory system study guide,biology study material,philosophical books,How small scale mining works study notes,Raspberry pi study material,meditation books,Polity resources,science and technology study guide,technology study material,geopolitics study material,formation of stars study material,astronomy study material,academic notes astronomy,astronomy academic resources,star formation notes,DNA Study guide,philosophy academic resources,non fictional books,academic climate resources,industrial revolution study material,history study notes,tidal energy study notes,Business management study material,renewable energy study material,renewable energy academic resources,Technology academic notes,enterprenuer study material,climate change study material,picnotes'
    )
  end

  def note_meta_tags
    set_meta_tags(
      title: @note.title,
      description: @note.body.slice(0, 120) + "...",
      keywords: @note.body,
      image: @note.image.url
    )
  end
end
