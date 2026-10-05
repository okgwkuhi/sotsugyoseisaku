require "rails_helper"

RSpec.describe Report, type: :model do
  describe "通報理由" do
    it "空だと無効になる" do
      report = build(:report, reason: "")
      expect(report).not_to be_valid
      expect(report.errors[:reason]).to be_present
    end

    it "一覧にない値だと無効になる" do
      report = build(:report, reason: "存在しない理由")
      expect(report).not_to be_valid
    end

    it "一覧にある値なら有効になる" do
      report = build(:report, reason: "迷惑行為")
      expect(report).to be_valid
    end
  end
end
