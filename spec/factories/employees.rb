FactoryBot.define do

  factory :employee do
    id { Faker::Number.between(from: 1, to: 99999) }
    full_name { Faker::Name.name.ljust(8, 'x') }
    date_of_birth { Faker::Date.between(from: 60.years.ago, to: 14.years.ago) }
    marital_status { [ 'married', 'single', 'widow' ].sample }
    sex { [ 'masculine', 'feminine' ].sample }
    association :workspace
    association :job_role

    before(:create) do |employee|
      cep = Cep.instance
      cep.state = cep.states.sample
      cep.city = cep.specific_cities.sample

      employee.home_state = cep.state
      employee.origin_city = cep.city
    end

    after(:build) do |employee|
      employee.workspace = create(:workspace)
      employee.job_role = create(:job_role)
    end
  end
end

