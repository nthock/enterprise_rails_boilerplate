MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  field :authenticate, field: SessionMutations::Create.field
end
