class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    Rails.logger.info "##########--------#{request.env['omniauth.auth'].inspect}--------"
    provider_data = request.env['omniauth.auth']
    Rails.logger.info "Email: --------#{provider_data.info.email}--------"
    name_slices = provider_data.info.name.gsub(/\s+/m, ' ').strip.split(" ")
    Rails.logger.info "Slices: ----#{name_slices.inspect}-----"
    Rails.logger.info "Username: ----#{provider_data.info.name}-----"
    Rails.logger.info "FirsNmae: ----#{name_slices[0]}-----"
    Rails.logger.info "lastname: ----#{name_slices[1]}-----"
    Rails.logger.info "avatar: ----#{provider_data.info.image}-----"
    Rails.logger.info "avatar: ----#{provider_data.info.image}-----"
    Rails.logger.info "password: ----#{provider_data.info.name}-----"
    Rails.logger.info "password: ----#{Devise.friendly_token[0, 20]}-----"

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      session[:user_id] = User.find_by_uid(@user.uid).id
      aida = User.find_by(id: 2)
      cuser = User.find_by(id: User.find_by_uid(@user.uid).id)
      cuser.follow(aida)
    elsif  !(@user.persisted?)
      @user = User.find_by_email(request.env['omniauth.auth'].info.email)
      if @user.persisted?
        @user.provider= request.env['omniauth.auth'].provider
        @user.uid=request.env['omniauth.auth'].uid
        @user.save

        aida = User.find_by(id: 2)
        cuser = User.find_by(id: User.find_by_uid(@user.uid).id)
        cuser.follow(aida)

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

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, :event => :authentication
        session[:user_id] = @user.id
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      redirect_to root_path, alert: @user.errors.full_messages.join("\n")
    end
  end
end
