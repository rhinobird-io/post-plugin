class CompletePostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :creator_id

  has_many :tags
end