class UserMailer < ApplicationMailer

  def register_email(user, url)
    @user = user
    @url = url
    mail(to: @user.email, subject: 'Confirm your bandapp registration')
  end
end
