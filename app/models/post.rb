class Post < ApplicationRecord
  belongs_to :user

  STYLES = ["じっくり系", "ワイワイ系"].freeze
  STATUSES = ["open", "closed", "cancelled"].freeze

  validates :title, :game_name, :event_at, :area, presence: true
  validates :capacity, numericality: { greater_than: 0 }
  validates :style, inclusion: { in: STYLES }
  validates :status, inclusion: { in: STATUSES }

  scope :upcoming, -> { where("event_at >= ?", Time.current).order(:event_at) }
  scope :by_game, ->(game_name) { where(game_name: game_name) if game_name.present? }
  scope :by_style, ->(style) { where(style: style) if style.present? }

  def organizer?(user)
    user.present? && user_id == user.id
  end
end
