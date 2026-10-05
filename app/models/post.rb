class Post < ApplicationRecord
  belongs_to :user
  has_many :applications, dependent: :destroy
  has_many :want_again_responses, dependent: :destroy
  has_many :reports, dependent: :nullify

  STYLES = %w[じっくり系 ワイワイ系].freeze
  STATUSES = %w[open closed cancelled].freeze

  validates :title, :game_name, :event_at, :area, presence: true
  validates :capacity, numericality: { greater_than: 0 }
  validates :style, inclusion: { in: STYLES }
  validates :status, inclusion: { in: STATUSES }
  validate :event_at_must_be_in_the_future, on: :create

  scope :upcoming, -> { where(event_at: Time.current..).order(:event_at) }
  scope :by_game, ->(game_name) { where(game_name: game_name) if game_name.present? }
  scope :by_style, ->(style) { where(style: style) if style.present? }

  def organizer?(user)
    user.present? && user_id == user.id
  end

  def approved_count
    applications.where(status: "approved").count
  end

  def spots_left
    [capacity - approved_count, 0].max
  end

  def full?
    spots_left.zero?
  end

  def approved_user_ids
    applications.where(status: "approved").pluck(:user_id)
  end

  def organizer_id_or_approved_applicant?(uid)
    user_id == uid || approved_user_ids.include?(uid)
  end

  private

  def event_at_must_be_in_the_future
    return if event_at.blank?

    errors.add(:event_at, "は現在より後の日時を指定してください") if event_at < Time.current
  end
end
