require "rails_helper"

RSpec.describe User, type: :model do
  it "有効なfactoryであること" do
    expect(build(:user)).to be_valid
  end

  describe "name" do
    it "空だと無効であること" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "256文字以上だと無効であること" do
      user = build(:user, name: "a" * 256)
      expect(user).not_to be_valid
    end

    it "255文字以内だと有効であること" do
      user = build(:user, name: "a" * 255)
      expect(user).to be_valid
    end
  end

  describe "email" do
    it "空だと無効であること" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "重複していると無効であること" do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "style" do
    it "じっくり系・ワイワイ系以外だと無効であること" do
      user = build(:user, style: "その他")
      expect(user).not_to be_valid
    end

    it "じっくり系だと有効であること" do
      user = build(:user, style: "じっくり系")
      expect(user).to be_valid
    end
  end

  describe "level" do
    it "初心者・中級者・上級者以外だと無効であること" do
      user = build(:user, level: "エキスパート")
      expect(user).not_to be_valid
    end
  end
end
