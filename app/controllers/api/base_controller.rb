class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  def current_user
    # headers: { 'authorization': 'JWT <token>' }
    # headers: { 'authorization': 'API_KEY <token>' }

    token_type, token = request.headers['AUTHORIZATION']&.split(" ") || []
    case token_type&.downcase
    when 'api_key'
      @user ||= User.find_by(api_key: token)
    when 'jwt'
      begin
        payload = JWT.decode(token, Rails.application.secrets.secret_key_base)&.first
        @user ||= User.find_by(id: payload["id"])
      rescue JWT::DecodeError => error
        nil
      end
    end
  end

  private

  def authenticate_api_user
    head :unauthorized unless current_user
  end
end
