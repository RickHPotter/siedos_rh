require 'rails_helper'

RSpec.describe "CREATE of Employee CRUD", type: :system do
  describe "new page" do
    let!(:job_roles) { FactoryBot.create_list(:job_role, 2) }
    let!(:workspaces) { FactoryBot.create_list(:workspace, 2) }
    let!(:employee) { FactoryBot.build(:employee) }

    before do
      visit new_employee_path
    end

    it "does not create a new employee without filled in attributes" do
      count_before = Employee.count
      click_link_or_button I18n.t('create.employee')
      Employee.create.errors.full_messages.each do |msg|
        expect(page).to have_content(msg) 
      end
      expect(count_before).to eq(Employee.count)
    end

    it "does create a new employee with valid filled in attributes" do
      fill_in 'employee[id]', with: employee.id
      fill_in 'employee[full_name]', with: employee.full_name
      fill_in 'employee[date_of_birth]', with: employee.date_of_birth.strftime("%m/%d/%Y") if employee.date_of_birth.present?
      select employee.origin_city || '', from: 'employee[origin_city]'
      select employee.home_state || '', from: 'employee[home_state]'
      select employee.marital_status_label || '', from: 'employee[marital_status]'
      select employee.sex_label || '', from: 'employee[sex]'
      select employee.workspace.title, from: 'employee[workspace_id]'
      select employee.job_role.title, from: 'employee[job_role_id]'

      click_link_or_button(I18n.t('create.employee'))

      expect(Employee.last.id).to eq(employee.id)
    end
  end
end

