require 'rails_helper'

RSpec.describe Contact do
  let(:employee) {
    Employee.create(
      full_name: "This name is 31 characters long",
      date_of_birth: Date.today - 17.years,
      origin_city: "Rio Branco",
      home_state: "AC",
      marital_status: "single",
      sex: "masculine",
      workspace_id: Workspace.create(title: "Rapidash").id,
      job_role_id: JobRole.create(title: "Ruby Developer").id
    )

    subject {
      described_class.new(
        phone: "6232322323",
        mobile_phone: "62981309721",
        email: "luis.bastos@siedos.com",
        employee_id: employee.id
      )
    }

    # Best-Case-Scenario
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    # model validation specs
    %i[ phone mobile email ].each do |att|
      it "is not valid without #{att}" do
        not_null(subject, att)
      end
    end

    it "validates uniqueness of email" do
      opt = { :email => "siedos@rhchallenge.com" }
      unique(subject, [opt])
    end
  
    %i[ phone mobile_phone ].each do |att|
      it "validates uniqueness of #{att} within the scope of employee_id" do
        opts = { :employee_id => employee.id, att => "62981309721" }
        unique(subject, [opts])
      end
    end

    it "validates the uniqueness of email" do
      unique(subject, :email, "rh@challenge.com")
    end

    it "is not valid with an invalid phone" do
      subject.phone: "Nz^7*(7/03"
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid mobile" do
      subject.mobile: "Nz^7*(7/03"
      expect(subject).to_not be_valid
    end

    it "is not valid with an invalid email" do
      subject.email: "something that's not an email"
      expect(subject).to_not be_valid
    end

    # model specs (not validations)

    context "phone and mobile_phone are not only numbers" do
      they "becomes only numbers" do
        subject.phone = " .6/232 322-323"
        subject.mobile_phone = " 62-323 22.32/3"
        subject.save
        expect(subject.phone).to eq("6232322323")
        expect(subject.mobile_phone).to eq("6232322323")
      end
    end

end

