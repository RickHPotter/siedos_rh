require 'rails_helper'

RSpec.describe Employee do
  let!(:job_roles) { FactoryBot.create_list(:job_role, 2) }
  let!(:workspaces) { FactoryBot.create_list(:workspace, 2) }
  let!(:subject) { FactoryBot.create(:employee) }
  let!(:helper) { FactoryBot.create(:employee) }

  # Best-Case-Scenario
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  # model validation specs
  %i[ full_name workspace_id job_role_id ].each do |att|
    it "is not valid without #{att}" do
      not_null(subject, att)
    end
  end

  it "validates length of full_name (8 .. 36)" do
    validate_length(subject, :full_name, [8, 36])
  end

  it "is not valid with a date_of_birth of someone's who's under 14" do
    subject.date_of_birth = Date.today - 13.years
    expect(subject).to_not be_valid
  end

  it "is not valid with an origin_city other than employee.cities" do
    subject.origin_city = "Atlantida"
    expect(subject).to_not be_valid
  end

  it "is not valid with a home_state other than employee.states" do
    subject.home_state = "Cisplatina"
    expect(subject).to_not be_valid
  end

  it "is not valid with an origin_city that does not belong to home_state" do
    subject.origin_city = "Curitiba"
    subject.home_state = "PR"
    expect(subject).to be_valid

    subject.origin_city = "Macapá"
    subject.home_state = "PR"
    expect(subject).to_not be_valid
  end

  it "is not valid with a marital status other than employee.marital_statues" do
    subject.marital_status = "dead"
    expect(subject).to_not be_valid
  end

  it "is not valid with a sex other than employee.sexes" do
    subject.sex = "robot"
    expect(subject).to_not be_valid
  end

  it "validates uniqueness of job_role_id within the scope of workspace_id" do
    opts = { }
    opts[:job_role_id] = subject.job_role_id
    opts[:workspace_id] = subject.workspace_id
    unique(subject, helper, opts)
  end

  # model specs (not validations)

  context "full_name is not PascalCase" do
    it "becomes PascalCase" do
      subject.full_name = 'a pascal case name'
      subject.save
      expect(subject.full_name).to eq("A Pascal Case Name")
    end
  end

end

