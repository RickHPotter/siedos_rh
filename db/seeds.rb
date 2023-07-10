require 'factory_bot_rails'

Employee.destroy_all
Workspace.destroy_all
JobRole.destroy_all

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

12.times do |index|
  begin
    FactoryBot.create(:workspace)
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
    FactoryBot.create(:job_role)
  rescue ActiveRecord::RecordNotUnique => e
    puts "Error creating JobRole because it already exists."
  rescue => e
    puts "Error #{e} - #{e.message}."
  end
end

p "Created #{JobRole.count} job roles."

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

66.times do |index|
  FactoryBot.create(:employee)
end

p "Created #{Employee.count} employees."

