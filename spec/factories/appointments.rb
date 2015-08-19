FactoryGirl.define do
  factory :appointment do
    date '2015-08-19 18:54:41'
    symptoms 'FFaker::Association.symptoms'
    dentist
  end
end
