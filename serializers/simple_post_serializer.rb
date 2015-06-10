class SimplePostSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at, :updated_at, :creator_id

  has_many :tags
end