FactoryBot.define do
  factory :post do
    association :user
    title { "テスト募集" }
    game_name { "カタン" }
    event_at { 3.days.from_now }
    area { "渋谷" }
    capacity { 4 }
    style { "じっくり系" }
  end
end