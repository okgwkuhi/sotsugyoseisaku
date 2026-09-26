FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { "テストユーザー" }
    level { "初心者" }
    style { "じっくり系" }
  end
end