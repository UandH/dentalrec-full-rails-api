FactoryGirl.define do
  factory :appointment do
    date { FFaker::Time.date }
    symptoms { FFaker::Lorem.paragraph }
    dentist
  end
end
