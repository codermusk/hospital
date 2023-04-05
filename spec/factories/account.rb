FactoryBot.define do
  factory :account do
    sequence :email do |n|
      "doc#{n}@gmail.com"
    end
    password { "1234567" }
    password_confirmation { "1234567"}
    acc_doc
    trait :acc_doc do
      association :accountable , factory: :doctor
    end

    trait :acc_pat do
      association :accountable , factory: :patient
    end

  end
end