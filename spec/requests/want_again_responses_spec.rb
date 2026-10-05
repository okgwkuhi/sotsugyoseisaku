require "rails_helper"

RSpec.describe "WantAgainResponses", type: :request do
  let(:organizer) { create(:user) }
  let(:partner) { create(:user) }
  let(:outsider) { create(:user) }
  let(:post_record) do
    create(:post, user: organizer).tap { |p| p.update_column(:event_at, 1.day.ago) }
  end

  before do
    create(:application, post: post_record, user: partner, status: "approved")
  end

  describe "GET /posts/:post_id/want-again/new" do
    it "主催者・承認済み参加者はアクセスできる" do
      sign_in organizer
      get new_post_want_again_response_path(post_record)
      expect(response).to have_http_status(:ok)
    end

    it "承認されていないユーザーはアクセスできない" do
      sign_in outsider
      get new_post_want_again_response_path(post_record)
      expect(response).to redirect_to(post_path(post_record))
    end
  end

  describe "POST /posts/:post_id/want-again" do
    context "片方だけが回答した場合" do
      it "Matchは作られない" do
        sign_in organizer
        post post_want_again_responses_path(post_record),
             params: { target_user_id: partner.id, wants_again: "true" }

        expect(Match.count).to eq(0)
      end
    end

    context "双方が「また遊びたい」と回答した場合" do
      it "Matchが作られる" do
        sign_in organizer
        post post_want_again_responses_path(post_record),
             params: { target_user_id: partner.id, wants_again: "true" }

        sign_out organizer
        sign_in partner
        post post_want_again_responses_path(post_record),
             params: { target_user_id: organizer.id, wants_again: "true" }

        expect(Match.count).to eq(1)
      end
    end
  end
end
