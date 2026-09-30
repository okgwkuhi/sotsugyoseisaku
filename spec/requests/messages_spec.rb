require "rails_helper"

RSpec.describe "Messages", type: :request do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:outsider) { create(:user) }
  let(:post_record) { create(:post, user: user_a) }
  let(:match) { create(:match, post: post_record, user_a: user_a, user_b: user_b) }

  describe "POST /matches/:match_id/messages" do
    context "マッチ当事者の場合" do
      it "メッセージを送信できる" do
        sign_in user_a
        expect do
          post match_messages_path(match), params: { message: { body: "また遊びましょう!" } }
        end.to change(Message, :count).by(1)
        expect(response).to redirect_to(match_path(match))
      end
    end

    context "マッチ当事者でない場合" do
      it "メッセージを送信できない" do
        sign_in outsider
        expect do
          post match_messages_path(match), params: { message: { body: "割り込みメッセージ" } }
        end.not_to change(Message, :count)
      end
    end

    context "本文が空の場合" do
      it "送信できずエラーになる" do
        sign_in user_a
        expect do
          post match_messages_path(match), params: { message: { body: "" } }
        end.not_to change(Message, :count)
      end
    end
  end

  describe "GET /matches/:id" do
    it "マッチ当事者以外はマッチ一覧にリダイレクトされる" do
      sign_in outsider
      get match_path(match)
      expect(response).to redirect_to(matches_path)
    end
  end
end
