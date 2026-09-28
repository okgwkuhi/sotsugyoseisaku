FactoryBot.define do
  factory :match do
    association :post
    association :user_a, factory: :user
    association :user_b, factory: :user
    matched_at { Time.current }
  end
end
