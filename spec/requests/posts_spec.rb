require "rails_helper"

RSpec.describe "Posts", type: :request do
  let(:organizer) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_params) do
    {
      post: {
        title: "テスト募集",
        game_name: "カタン",
        event_at: 3.days.from_now,
        area: "渋谷",
        capacity: 4,
        style: "じっくり系"
      }
    }
  end

  describe "GET /posts" do
    it "未ログインでも一覧を表示できる" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/:id" do
    it "未ログインでも詳細を表示できる" do
      post_record = create(:post, user: organizer)
      get post_path(post_record)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    context "ログイン済みの場合" do
      before { sign_in organizer }

      it "募集を作成できる" do
        expect { post posts_path, params: valid_params }.to change(Post, :count).by(1)
        expect(response).to redirect_to(posts_path)
      end

      it "必須項目が空だと作成できない" do
        invalid = valid_params.deep_merge(post: { title: "" })
        expect { post posts_path, params: invalid }.not_to change(Post, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "未ログインの場合" do
      it "作成できず、ログイン画面にリダイレクトされる" do
        expect { post posts_path, params: valid_params }.not_to change(Post, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /posts/:id" do
    let!(:post_record) { create(:post, user: organizer) }

    it "主催者本人は編集できる" do
      sign_in organizer
      patch post_path(post_record), params: { post: { title: "更新後のタイトル" } }
      expect(post_record.reload.title).to eq("更新後のタイトル")
    end

    it "主催者以外は編集できない" do
      sign_in other_user
      patch post_path(post_record), params: { post: { title: "不正な更新" } }
      expect(post_record.reload.title).to eq("テスト募集")
      expect(response).to redirect_to(post_path(post_record))
    end
  end

  describe "DELETE /posts/:id" do
    let!(:post_record) { create(:post, user: organizer) }

    it "主催者本人は削除できる" do
      sign_in organizer
      expect { delete post_path(post_record) }.to change(Post, :count).by(-1)
    end

    it "主催者以外は削除できない" do
      sign_in other_user
      expect { delete post_path(post_record) }.not_to change(Post, :count)
    end
  end
end
