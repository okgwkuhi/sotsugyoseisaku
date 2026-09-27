FactoryBot.define do
  factory :message do
    match { nil }
    sender { nil }
    body { "MyText" }
  end
end
