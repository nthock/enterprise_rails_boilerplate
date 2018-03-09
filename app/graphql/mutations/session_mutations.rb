module SessionMutations
  Create = GraphQL::Relay::Mutation.define do
    name "Authenticate"

    input_field :email, types.String
    input_field :password, types.String

    return_type Types::UserType

    resolve ->(_obj, inputs, _ctx) {
      SessionService.authenticate(inputs)
    }
  end
end
