Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :users do
    type types[Types::UserType]

    resolve ->(_obj, _args, ctx) {
      return GraphQL::ExecutionError.new('Not authorised to query all users') unless ctx[:current_user]['admin']
      User.all
    }
  end

  field :admins do
    type types[Types::UserType]

    resolve ->(_obj, _args, _ctx) { User::Admin.all }
  end

  field :verifyToken do
    type Types::UserType

    argument :token, types.String

    resolve ->(_obj, args, _ctx) {
      hmac_secret = Rails.application.secrets.hmac_secret
      decoded = JWT.decode(args[:token], hmac_secret, true, algorithm: 'HS256')
      user = User.find(decoded[0]['id'])
    }
  end
end
