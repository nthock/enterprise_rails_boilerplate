class Invitation::AcceptService
  attr_accessor :user, :accept_params

  def initialize(accept_params)
    @user = User.find_by(invitation_token: accept_params[:invitation_token])
    @accept_params = accept_params
  end

  def update
    return invalid_user_invitation if user.nil?
    user.update(
      password: accept_params[:password],
      password_confirmation: accept_params[:password_confirmation],
      invitation_accepted_at: DateTime.now,
      invitation_accepted: true,
      invitation_token: nil
    )
    user
  end

  private

    def invalid_user_invitation
      invalid_user = User.new
      invalid_user.errors[:invalid_user] << 'User is not valid or invitation has been accepted'
      invalid_user
    end
end
