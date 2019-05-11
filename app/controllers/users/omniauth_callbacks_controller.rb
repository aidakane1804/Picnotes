class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      session[:user_id] = User.find_by_uid(@user.uid).id
    else
      flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
      redirect_to root_path
    end
  end
  def failure
    redirect_to root_path
  end
end
