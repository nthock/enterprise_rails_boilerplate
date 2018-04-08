class UserMailer < ApplicationMailer
  def invitation(user)
    @user = user
    mail(to: @user.email, subject: 'You are invited!!!')
  end
end
