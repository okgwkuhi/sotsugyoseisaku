FactoryBot.define do
  factory :want_again_response do
    association :post
    association :user
    association :target_user, factory: :user
    wants_again { true }
  end
end
