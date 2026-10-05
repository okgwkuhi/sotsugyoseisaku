FactoryBot.define do
  factory :report do
    association :reporter, factory: :user
    association :reported_user, factory: :user
    reason { "迷惑行為" }
    detail { "詳細の内容" }
    status { "pending" }
  end
end
