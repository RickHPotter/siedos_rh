require 'rails_helper'

RSpec.describe Contact do
  let!(:job_roles) { FactoryBot.create_list(:job_role, 2) }
  let!(:workspaces) { FactoryBot.create_list(:workspace, 2) }
  let!(:employee) { FactoryBot.create(:employee) }

  let!(:subject) { FactoryBot.create(:contact) }
  let!(:helper) { FactoryBot.create(:contact) }

  # Best-Case-Scenario
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  # model validation specs
  %i[ phone mobile_phone email ].each do |att|
    it "is not valid without #{att}" do
      not_null(subject, att)
    end
  end

  it "validates uniqueness of email" do
    opt = { :email => "siedos@rhchallenge.com" }
    unique(subject, helper, opt)
  end
  
  %i[ phone mobile_phone ].each do |att|
    it "validates uniqueness of #{att} within the scope of employee_id" do
      subject.employee = employee
      helper.employee = employee
      unique(subject, helper, { att => subject[att] })
    end
  end

  it "is not valid with an invalid phone" do
    subject.phone = "703"
    expect(subject).to_not be_valid
  end

  it "is not valid with an invalid mobile phone" do
    subject.mobile_phone = "703"
    expect(subject).to_not be_valid
  end

  it "is not valid with an invalid email" do
    subject.email = "something that's not an email"
    expect(subject).to_not be_valid
  end

  # model specs (not validations)

  context "phone and mobile_phone are not only numbers" do
    it "becomes only numbers" do
      subject.phone = " .6/232 322-323"
      subject.mobile_phone = " 62-323 22.32/3"
      subject.save
      expect(subject.phone).to eq("6232322323")
      expect(subject.mobile_phone).to eq("6232322323")
    end
  end

  context "phone and mobile_phone are only numbers" do
    it "becomes formatted numbers" do
      subject.phone = " .6/232 322-323"
      subject.mobile_phone = " 62-993 22.32/3"
      subject.save
      expect(subject.phone_human).to eq("(62) 3232 2323")
      expect(subject.mobile_phone_human).to eq("(62) 9 9932 2323")
    end
  end
end

