FactoryBot.define do
  factory :hospital do
    name{"My hospital"}
    address{"Chennai , West south"}
    sequence (:mail) {|n| "hosp#{n}@gmail.com"}
  end
end
