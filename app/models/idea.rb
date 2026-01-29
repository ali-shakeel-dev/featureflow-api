class Idea < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user
  has_many :comments, dependent: :destroy
  has_many :roadmap_items, dependent: :nullify

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :description, presence: true, length: { minimum: 20, maximum: 5000 }
  validates :user_id, presence: true
  validates :status, inclusion: { in: %w(submitted planned in_progress completed rejected) }
  validates :category, inclusion: { in: %w(feature improvement bug other) }, allow_blank: true

  enum :status, { submitted: 0, planned: 1, in_progress: 2, completed: 3, rejected: 4 }
  enum :category, { feature: 0, improvement: 1, bug: 2, other: 3 }

  scope :trending, -> { order(votes_count: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  after_create :increment_user_contribution_count

  private

  def increment_user_contribution_count
    user.increment!(:ideas_count) if user
  end
end
