Employee.destroy_all
Workspace.destroy_all
JobRole.destroy_all

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
12.times do |index|
  begin
    Workspace.create!(title: Faker::Creature::Horse.name)
  rescue ActiveRecord::RecordNotUnique => e
    puts "Error creating Workspace because it already exists."
  rescue => e
    puts "Error #{e} - #{e.message}."
  end
end

p "Created #{Workspace.count} workspaces."

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

12.times do |index|
  begin
    JobRole.create!(
      title: [
        "#{Faker::ProgrammingLanguage.name} Developer",
        Faker::Company.profession.upcase,
        Faker::Company.profession.upcase
      ].sample
    )
  rescue ActiveRecord::RecordNotUnique => e
    puts "Error creating JobRole because it already exists."
  rescue => e
    puts "Error #{e} - #{e.message}."
  end
end

p "Created #{JobRole.count} job roles."

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
fake = Employee.new
marital_statuses = [ 'married', 'single', 'widow' ]

66.times do |index|
  fake_state = fake.states.sample
  fake.home_state = fake_state
  fake_city = fake.specific_cities.sample

  workspace_id = Workspace.all.sample.id

  jr_ids = JobRole.all.map { |j| j.id }
  taken_jr_ids = Employee.where(workspace_id: workspace_id).map { |e| e.job_role_id }
  jr_options = jr_ids - taken_jr_ids
  next if jr_options.empty?
  job_role_id = jr_options.sample
  
  Employee.create!(
    full_name: Faker::Name.name,
    date_of_birth: Faker::Date.birthday(min_age: 14, max_age: 56),
    home_state: fake_state,
    origin_city: fake_city,
    marital_status: marital_statuses.sample,
    sex: [ 'masculine', 'feminine' ].sample,
    workspace_id: workspace_id,
    job_role_id: job_role_id
  )
end

p "Created #{Employee.count} employees."

