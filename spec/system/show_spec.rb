require 'rails_helper'

RSpec.describe "READ of Employee CRUD", type: :system do
  describe "show page" do
    before do
      @workspace = FactoryBot.create(:workspace)
      @job_role = FactoryBot.create(:job_role)
      @employee = FactoryBot.create(:employee)
      visit employee_path(@employee.id)
    end

    it "shows the Workspace and JobRole titles" do
      expect(page).to have_content(@employee.job_role.title)
      expect(page).to have_content(@employee.workspace.title)
    end

    it "shows a button to edit an Employee" do
      expect(page).to have_content(I18n.t('update.employee'))
    end

    it "takes you to the new_employee_path when the button is clicked" do
      click_link_or_button(I18n.t('update.employee'))
      expect(page).to have_current_path(edit_employee_path(@employee.id))
    end
  end
end

