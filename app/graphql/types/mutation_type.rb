Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :authenticate, field: SessionMutations::Create.field

  field :create_user, field: UserMutations::Create.field
  field :addAdmin, field: UserMutations::AddAdmin.field
end
