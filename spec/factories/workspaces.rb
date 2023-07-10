FactoryBot.define do

  factory :workspace do
    title do
      res = nil
      loop do
        res = "#{Faker::Space.planet} #{Faker::Creature::Horse.name}" 
        break if Workspace.new(title: res).valid?
      end
      res
    end 
  end
end

