require "rails_helper"

RSpec.describe Match, type: :model do
  let(:organizer) { create(:user) }
  let(:partner) { create(:user) }
  let(:post_record) { create(:post, user: organizer, event_at: 1.day.ago) }

  before do
    create(:application, post: post_record, user: partner, status: "approved")
  end

  describe ".find_or_create_from_mutual!" do
    context "片方だけが「また遊びたい」と回答している場合" do
      before do
        create(:want_again_response, post: post_record, user: organizer, target_user: partner, wants_again: true)
      end

      it "Matchは作られない" do
        result = described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id,
                                                             user2_id: partner.id)
        expect(result).to be_nil
        expect(described_class.count).to eq(0)
      end
    end

    context "双方が「また遊びたい」と回答している場合" do
      before do
        create(:want_again_response, post: post_record, user: organizer, target_user: partner, wants_again: true)
        create(:want_again_response, post: post_record, user: partner, target_user: organizer, wants_again: true)
      end

      it "Matchが作られる" do
        expect do
          described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id, user2_id: partner.id)
        end.to change(described_class, :count).by(1)
      end

      it "同じペアに対して2回呼んでも、Matchは1件しか作られない" do
        described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id, user2_id: partner.id)

        expect do
          described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id, user2_id: partner.id)
        end.not_to change(described_class, :count)
      end

      it "user1とuser2の順序を入れ替えても、同じMatchとして扱われる" do
        described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id, user2_id: partner.id)

        expect do
          described_class.find_or_create_from_mutual!(post: post_record, user1_id: partner.id, user2_id: organizer.id)
        end.not_to change(described_class, :count)
      end
    end

    context "片方が「見送る」と回答している場合" do
      before do
        create(:want_again_response, post: post_record, user: organizer, target_user: partner, wants_again: true)
        create(:want_again_response, post: post_record, user: partner, target_user: organizer, wants_again: false)
      end

      it "Matchは作られない" do
        result = described_class.find_or_create_from_mutual!(post: post_record, user1_id: organizer.id,
                                                             user2_id: partner.id)
        expect(result).to be_nil
        expect(described_class.count).to eq(0)
      end
    end
  end

  describe "#partner_for" do
    let(:match) { create(:match, user_a: organizer, user_b: partner) }

    it "user_aのIDを渡すとuser_bを返す" do
      expect(match.partner_for(organizer.id)).to eq(partner)
    end

    it "user_bのIDを渡すとuser_aを返す" do
      expect(match.partner_for(partner.id)).to eq(organizer)
    end
  end
end
