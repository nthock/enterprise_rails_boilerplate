Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :authenticate, field: SessionMutations::Create.field

  field :create_user, field: UserMutations::Create.field
  field :addAdmin, field: UserMutations::AddAdmin.field
  field :acceptInvite, field: UserMutations::AcceptInvite.field
  field :sendInvite, field: UserMutations::SendInvite.field
end
