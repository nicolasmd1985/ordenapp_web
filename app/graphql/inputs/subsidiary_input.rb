class CreateSubsidiaryInput < ::GraphQL::Types::JSON::Node::InputType
  field :name, ::GraphQL::Types::String
  field :phone, ::GraphQL::Types::String
  field :address, ::GraphQL::Types::String
  field :email, ::GraphQL::Types::String
  field :status, ::GraphQL::Types::String
  field :corporation, ::GraphQL::Types::String
end