FactoryBot.define do
  factory :patient do
    name {"Patient"}
    sex {"male"}
    address{"I am from Gandhipuram south"}
    sequence (:email){|n| "patient#{n}@gmail.com"}
    mobile_number{"6383703693"}
    age{22}


  end
end