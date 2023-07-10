FactoryBot.define do

  factory :contact do
    phone { Faker::Number.between(from: 11111111, to: 99999999999) }
    mobile_phone { Faker::Number.between(from: 11111111, to: 99999999999) }
    email { "#{Faker::File.extension.downcase}#{Faker::Number.between(from: 100, to: 999)}@siedos.com" }
    employee { Employee.all.sample }
  end
end

