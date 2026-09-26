require "rails_helper"

RSpec.describe "FactoryBotの動作確認" do
  it "userのfactoryでレコードを作成できる" do
    user = create(:user)
    expect(user).to be_persisted
  end

  it "postのfactoryでレコードを作成できる" do
    post = create(:post)
    expect(post).to be_persisted
  end
end
