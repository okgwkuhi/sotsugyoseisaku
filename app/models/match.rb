class Match < ApplicationRecord
  belongs_to :post
  belongs_to :user_a, class_name: "User"
  belongs_to :user_b, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :matched_at, presence: true

  # 双方一致を検知し、なければMatchを作成する
  # (post, user1, user2 の3つを渡す。順不同でOK)
  def self.find_or_create_from_mutual!(post:, user1_id:, user2_id:)
    a_id, b_id = [user1_id, user2_id].sort

    response1 = post.want_again_responses.find_by(user_id: a_id, target_user_id: b_id, wants_again: true)
    response2 = post.want_again_responses.find_by(user_id: b_id, target_user_id: a_id, wants_again: true)

    return nil unless response1 && response2

    find_or_create_by!(post: post, user_a_id: a_id, user_b_id: b_id) do |match|
      match.matched_at = Time.current
    end
  end

  # このユーザーが関わるマッチを取得するスコープ
  scope :for_user, ->(user_id) { where("user_a_id = :id OR user_b_id = :id", id: user_id) }

  # マッチ相手を返す(自分ではない方)
  def partner_for(user_id)
    user_a_id == user_id ? user_b : user_a
  end
end
