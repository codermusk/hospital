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

    trait :for_admin do
      association :accountable , factory: :admin_user
    end

  end
  factory :admin_user do
    sequence :email do |v|
      "admin#{v}@hospitals.com"
    end
    password { "1234567" }
    password_confirmation { "1234567"}
  end
end