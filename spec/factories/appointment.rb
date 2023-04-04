FactoryBot.define  do
  factory :appointment do
    appointment_date{Date.today}
    time{'12 AM'}
    patient
    doctor
  end
end