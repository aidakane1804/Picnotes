class SignupMailer < ApplicationMailer
  default from: 'cowfun87@gmail.com'

  def signup_email(user)
    @user = user
    mail(to: @user.email, subject: 'Signed Up for Picnotes')
  end
end
