FactoryBot.define do
  factory :report do
    reporter { nil }
    reported_user { nil }
    post { nil }
    reason { "MyString" }
    detail { "MyText" }
    status { "MyString" }
  end
end
