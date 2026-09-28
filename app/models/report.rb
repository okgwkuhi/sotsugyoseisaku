class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reported_user, class_name: "User"
  belongs_to :post, optional: true

  REASONS = ["迷惑行為", "なりすまし", "不適切な内容", "その他"].freeze
  STATUSES = %w[pending reviewed].freeze

  validates :reason, inclusion: { in: REASONS }
  validates :status, inclusion: { in: STATUSES }

  validate :cannot_report_self

  private

  def cannot_report_self
    return unless reporter_id.present? && reported_user_id.present?

    errors.add(:reported_user, "自分自身を通報することはできません") if reporter_id == reported_user_id
  end
end
