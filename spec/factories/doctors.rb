FactoryBot.define do
  factory :doctor do
    name {"Doctor " }
    age {22}
    address {"Coimbatore West, Coimbatore  "}
    sequence (:email) {|n| "doctor#{n}@gmail.com"}
  end
end
