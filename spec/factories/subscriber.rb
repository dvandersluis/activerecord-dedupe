FactoryBot.define do
  factory :subscriber do
    sequence(:user_id) { |n| n }
    sequence(:newsletter_id) { |n| n }
  end
end
