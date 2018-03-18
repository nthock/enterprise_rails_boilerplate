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
end
