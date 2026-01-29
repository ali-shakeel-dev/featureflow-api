class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :user_id, presence: true
  validates :idea_id, presence: true
end
