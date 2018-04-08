class Invitation::CreateService
  attr_accessor :invitation_params, :invited_by_id

  def initialize(invitation_params, invited_by_id)
    @invitation_params = invitation_params
    @invited_by_id = invited_by_id
  end

  def invite(options = {})
    user = User.new(
      name: invitation_params[:name],
      email: invitation_params[:email],
      invited_by_id: invited_by_id,
      invitation_created_at: DateTime.now,
      invitation_token: generate_token(User),
      status: 'invited',
      admin: options[:admin]
    )
    user.skip_password_validation = true
    UserMailer.invitation(user).deliver_now if user.save
    user
  end

  private

    def generate_token(klass)
      _raw, enc = Devise.token_generator.generate(User, :invitation_token)
      enc
    end
end
