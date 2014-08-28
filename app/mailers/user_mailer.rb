class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def confirm_email(user)
    @user = user
    mail to: user.email, subject: "Email confirmation"
  end

  def follow_user(user, current_user)
    @user = user
    @current_user = current_user
    mail to: user.email, subject: "New follower"
  end

end
