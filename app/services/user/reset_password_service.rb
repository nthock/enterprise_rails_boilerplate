class User::ResetPasswordService
  attr_accessor :user, :password, :password_confirmation

  def initialize(reset_password_params)
    @user = User.find_by(reset_password_token: reset_password_params[:reset_password_token])
    @password = reset_password_params[:password]
    @password_confirmation = reset_password_params[:password_confirmation]
  end

  def reset_password_and_clear_token
    user.update(
      password: password,
      password_confirmation: password_confirmation,
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
    user
  end
end
