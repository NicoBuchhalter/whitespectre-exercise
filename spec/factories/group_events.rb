FactoryBot.define do
  factory :group_event do
    association :creator, factory: :user
    start_date { Faker::Date.between(from: 10.days.ago, to: Date.today) }
    end_date { Faker::Date.between(from: 2.days.from_now, to: 10.days.from_now) }
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    published { false }
    location { Faker::Address.full_address }
    discarded_at { nil }
  end
end
