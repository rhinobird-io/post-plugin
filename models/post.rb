class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :creator_id, presence: true
end