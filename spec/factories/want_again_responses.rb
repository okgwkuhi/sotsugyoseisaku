FactoryBot.define do
  factory :want_again_response do
    post { nil }
    user { nil }
    target_user { nil }
    wants_again { false }
  end
end
