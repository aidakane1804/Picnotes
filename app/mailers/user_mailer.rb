class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Picnotes')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: 'Reset Password')
  end

  def contact_us_mail(email,message)
    @email = email
    @message = message
    mail(to: "info@picnotes.org", subject: "Picnotes Contact US ")
  end
end
