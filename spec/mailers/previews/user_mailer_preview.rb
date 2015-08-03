# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def register
    UserMailer.register_email(User.first, "http://localhost:3000/register/confirm?token=#{User.first.registration_token}")
  end
end
