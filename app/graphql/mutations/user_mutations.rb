module UserMutations
  Create = GraphQL::Relay::Mutation.define do
    name "CreateUser"

    input_field :name, types.String
    input_field :email, types.String
    input_field :password, types.String
    input_field :password_confirmation, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, _ctx) {
      User.create(
        name: inputs[:name],
        email: inputs[:email],
        password: inputs[:password],
        password_confirmation: inputs[:password_confirmation]
      )
    }
  end

  AddAdmin = GraphQL::Relay::Mutation.define do
    name "AddAdmin"

    input_field :name, types.String
    input_field :email, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, ctx) {
      return GraphQL::ExecutionError.new('Not authorised to create admin') unless ctx[:current_user]['super_admin']
      Invitation::CreateService.new(inputs, ctx[:current_user]['id']).invite(admin: true)
    }
  end

  AcceptInvite = GraphQL::Relay::Mutation.define do
    name "AcceptInvite"

    input_field :invitation_token, types.String
    input_field :password, types.String
    input_field :password_confirmation, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, _ctx) {
      Invitation::AcceptService.new(inputs).update
    }
  end

  SendInvite = GraphQL::Relay::Mutation.define do
    name "SendInvite"

    input_field :id, types.ID

    return_type Types::UserType

    resolve ->(_obj, inputs, ctx) {
      user = User.find(inputs[:id])
      return GraphQL::ExecutionError.new('Not authorised to send another invitation') unless ctx[:current_user]['id'] == user.invited_by_id
      return GraphQL::ExecutionError.new("#{user.name} has already accepted the invitation") unless user.status == 'invited'
      UserMailer.invitation(user).deliver_now
    }
  end

  ForgetPassword = GraphQL::Relay::Mutation.define do
    name "ForgotPassword"

    input_field :email, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, _ctx) {
      user = User.find_by(email: inputs[:email])
      return GraphQL::ExecutionError.new('Not a valid user') if user.nil?
      user.send_reset_password_request
    }
  end

  ResetForgotPassword = GraphQL::Relay::Mutation.define do
    name "ResetForgotPassword"

    input_field :reset_password_token, types.String
    input_field :password, types.String
    input_field :password_confirmation, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, _ctx) {
      user = User.find_by(reset_password_token: reset_password_token)
      user.reset_password(inputs[:password], inputs[:password_confirmation])
    }
  end
end
