class User::ForgetPasswordService
  attr_accessor :user

  def initialize(email)
    @user = User.find_by(email: email)
  end

  def generate
    return if user.nil?
    generate_reset_token
    UserMailer.reset_password(user.reload).deliver_now
    user
  end

  private

    def generate_reset_token
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.update(
        reset_password_token: enc,
        reset_password_sent_at: DateTime.now
      )
    end

end
