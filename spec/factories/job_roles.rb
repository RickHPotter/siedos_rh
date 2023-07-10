FactoryBot.define do

  factory :job_role do
    title do
      res = nil
      loop do
        res = "#{Faker::ProgrammingLanguage.name.split(' (')[0]} Dev" 
        break if JobRole.new(title: res).valid?
      end
      res
    end 
  end
end

