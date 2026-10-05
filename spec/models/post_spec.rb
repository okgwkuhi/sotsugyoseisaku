require "rails_helper"

RSpec.describe Post, type: :model do
  describe "開催日時" do
    it "作成時に過去の日時だと無効になる" do
      post = build(:post, event_at: 1.hour.ago)
      expect(post).not_to be_valid
      expect(post.errors[:event_at]).to be_present
    end

    it "作成時に未来の日時なら有効になる" do
      post = build(:post, event_at: 1.hour.from_now)
      expect(post).to be_valid
    end

    it "開催済みの募集でも、他の項目を更新できる" do
      post = create(:post, event_at: 1.hour.from_now)
      post.update_column(:event_at, 1.hour.ago)
      post.title = "更新後のタイトル"
      expect(post).to be_valid
    end
  end
end
