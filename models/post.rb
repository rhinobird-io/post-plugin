class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :creator_id, presence: true
  default_scope {order('created_at DESC')}

  has_and_belongs_to_many :tags, -> { uniq }
end