class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :idea, counter_cache: true

  validates :user_id, presence: true, uniqueness: { scope: :idea_id }
  validates :idea_id, presence: true

  after_create :increment_idea_votes
  after_destroy :decrement_idea_votes

  private

  def increment_idea_votes
    idea.increment!(:votes_count)
  end

  def decrement_idea_votes
    idea.decrement!(:votes_count)
  end
end
