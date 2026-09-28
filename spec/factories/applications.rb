FactoryBot.define do
  factory :application do
    association :post
    association :user
    comment { "はじめまして、参加させてください" }
    status { "pending" }
  end
end
