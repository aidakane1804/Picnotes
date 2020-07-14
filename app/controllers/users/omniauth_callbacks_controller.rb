class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      session[:user_id] = User.find_by_uid(@user.uid).id
    elsif  !(@user.persisted?)
      @user = User.find_by_email(request.env['omniauth.auth'].info.email)
      if @user.persisted?
        @user.provider= request.env['omniauth.auth'].provider
        @user.uid=request.env['omniauth.auth'].uid
        @user.save
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
        session[:user_id] = User.find_by_uid(@user.uid).id
      end
    else
      Rails.logger.info "###################{@user.errors.messages.inspect}@@@@@@@@@@@@@@@@@@@@"
      flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
      redirect_to root_path
    end
  end
  def failure
    redirect_to root_path
  end
end
