BackendRailsSchema = GraphQL::Schema.define do
  mutation(Types::MutationType)
  query(Types::QueryType)

  Types::UserType = GraphQL::ObjectType.define do
    name "User"
    description "A User"
    field :id, types.ID
    field :name, types.String
    field :email, types.String
    field :designation, types.String
    field :admin, types.Boolean
    field :super_admin, types.Boolean
  end
end
