class RoadmapItem < ApplicationRecord
  belongs_to :idea, optional: true

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :status, inclusion: { in: %w(planned in_progress completed) }
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :target_date, presence: true

  enum :status, { planned: 0, in_progress: 1, completed: 2 }

  scope :upcoming, -> { where("target_date >= ?", Date.today).order(target_date: :asc) }
  scope :overdue, -> { where("target_date < ? AND status != ?", Date.today, :completed) }
  scope :by_priority, ->(priority) { order(priority: :desc) if priority.present? }
end
