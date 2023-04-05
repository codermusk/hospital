FactoryBot.define do
  factory :rating do
    rating{10}
    review{"such a wonderful doc and a friendly doc "}
    patient
    for_doctor
    trait :for_hospital do
      association :ratable , factory: :hospital
    end

    trait :for_doctor  do
      association :ratable , factory: :doctor
    end

  end
end