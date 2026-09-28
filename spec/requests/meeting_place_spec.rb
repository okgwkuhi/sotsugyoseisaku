require "rails_helper"

RSpec.describe "詳細な場所の表示", type: :request do
  let(:organizer) { create(:user) }
  let(:approved_user) { create(:user) }
  let(:pending_user) { create(:user) }
  let(:meeting_place_text) { "会議室B302" }
  let(:post_record) do
    create(:post, user: organizer, meeting_place: meeting_place_text)
  end

  before do
    create(:application, post: post_record, user: approved_user, status: "approved")
    create(:application, post: post_record, user: pending_user, status: "pending")
  end

  it "主催者には詳細な場所が表示される" do
    sign_in organizer
    get post_path(post_record)
    expect(response.body).to include(meeting_place_text)
  end

  it "承認済みの参加者には詳細な場所が表示される" do
    sign_in approved_user
    get post_path(post_record)
    expect(response.body).to include(meeting_place_text)
  end

  it "承認待ちの応募者には詳細な場所が表示されない" do
    sign_in pending_user
    get post_path(post_record)
    expect(response.body).not_to include(meeting_place_text)
  end

  it "未ログインには詳細な場所が表示されない" do
    get post_path(post_record)
    expect(response.body).not_to include(meeting_place_text)
  end
end
