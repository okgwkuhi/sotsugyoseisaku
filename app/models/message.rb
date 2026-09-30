class Message < ApplicationRecord
  belongs_to :match
  belongs_to :sender, class_name: "User"

  validates :body, presence: true

  validate :sender_must_be_match_participant

  private

  def sender_must_be_match_participant
    return unless match && sender_id.present?

    return if [match.user_a_id, match.user_b_id].include?(sender_id)

    errors.add(:sender, "はこのマッチの参加者ではありません")
  end
end
