class WantAgainResponse < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :target_user, class_name: "User"

  validates :wants_again, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: [:post_id, :target_user_id] }

  validate :cannot_target_self
  validate :post_must_be_finished
  validate :both_must_be_approved_participants

  private

  def cannot_target_self
    return unless user_id.present? && target_user_id.present?

    errors.add(:target_user, "自分自身を選択することはできません") if user_id == target_user_id
  end

  def post_must_be_finished
    return unless post

    errors.add(:post, "開催前の募集には回答できません") if post.event_at.present? && post.event_at > Time.current
  end

  def both_must_be_approved_participants
    return unless post && user_id.present? && target_user_id.present?

    unless approved_participant?(user_id) && approved_participant?(target_user_id)
      errors.add(:base, "承認された参加者同士でのみ回答できます")
    end
  end

  def approved_participant?(uid)
    post.organizer_id_or_approved_applicant?(uid)
  end
end
