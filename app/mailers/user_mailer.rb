class UserMailer < ApplicationMailer
  def invitation(user)
    @user = user
    mail(to: @user.email, subject: 'You are invited!!!')
  end

  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password reset request')
  end
end
