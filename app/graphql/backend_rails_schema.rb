ErrorFormatter = Struct.new(:key, :value)

BackendRailsSchema = GraphQL::Schema.define do
  mutation(Types::MutationType)
  query(Types::QueryType)

  Types::ErrorType = GraphQL::ObjectType.define do
    name "Error"
    description "A Error"
    field :key, types.String
    field :value, types.String
  end

  Types::UserType = GraphQL::ObjectType.define do
    name "User"
    description "A User"
    field :id, types.ID
    field :name, types.String
    field :email, types.String
    field :designation, types.String
    field :admin, types.Boolean
    field :super_admin, types.Boolean
    field :status, types.String
    field :token, types.String do
      hmac_secret = Rails.application.secrets.hmac_secret
      resolve ->(obj, _args, _ctx) { JWT.encode(obj.as_json, hmac_secret, 'HS256') }
    end
    field :errors, types[Types::ErrorType] do
      resolve ->(obj, _args, _ctx) { obj.errors.map { |k, v| ErrorFormatter.new(k, v) } }
    end
  end
end
