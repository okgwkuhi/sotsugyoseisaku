require "rails_helper"

RSpec.describe "Applications", type: :request do
  let(:organizer) { create(:user) }
  let(:applicant) { create(:user) }
  let(:post_record) { create(:post, user: organizer, capacity: 4) }

  describe "POST /posts/:post_id/applications" do
    context "ログイン済みで、自分以外の投稿の場合" do
      before { sign_in applicant }

      it "コメント付きで応募できる" do
        expect do
          post post_applications_path(post_record), params: { application: { comment: "参加希望です" } }
        end.to change(Application, :count).by(1)
        expect(response).to redirect_to(post_path(post_record))
      end

      it "同じ募集に重複して応募できない" do
        create(:application, post: post_record, user: applicant)

        expect do
          post post_applications_path(post_record), params: { application: { comment: "2回目です" } }
        end.not_to change(Application, :count)
      end
    end

    context "自分自身の投稿に応募しようとした場合" do
      before { sign_in organizer }

      it "応募できない" do
        expect do
          post post_applications_path(post_record), params: { application: { comment: "自分の投稿です" } }
        end.not_to change(Application, :count)
      end
    end
  end

  describe "PATCH /posts/:post_id/applications/:id" do
    let!(:application) { create(:application, post: post_record, user: applicant, status: "pending") }

    context "主催者本人の場合" do
      before { sign_in organizer }

      it "承認できる" do
        patch post_application_path(post_record, application), params: { status: "approved" }
        expect(application.reload.status).to eq("approved")
      end

      it "非承認にできる" do
        patch post_application_path(post_record, application), params: { status: "rejected" }
        expect(application.reload.status).to eq("rejected")
      end
    end

    context "主催者以外の場合" do
      it "ステータスを変更できない" do
        sign_in applicant
        patch post_application_path(post_record, application), params: { status: "approved" }
        expect(application.reload.status).to eq("pending")
      end
    end
  end

  describe "GET /posts/:post_id/applications" do
    it "主催者以外はアクセスできない" do
      sign_in applicant
      get post_applications_path(post_record)
      expect(response).to redirect_to(post_path(post_record))
    end
  end
end
