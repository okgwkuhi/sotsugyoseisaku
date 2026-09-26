class Application < ApplicationRecord
  belongs_to :post
  belongs_to :user

  STATUSES = %w[pending approved rejected].freeze

  validates :comment, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: { scope: :post_id, message: "はすでにこの募集に応募しています" }

  validate :cannot_apply_to_own_post

  private

  def cannot_apply_to_own_post
    return unless post && user

    errors.add(:base, "自分の投稿には応募できません") if post.user_id == user_id
  end
end
