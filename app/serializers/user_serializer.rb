class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :admin, :created_at
end