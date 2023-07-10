require 'rails_helper'

RSpec.describe "READS of Employee CRUD", type: :system do
  describe "index page" do
    before do
      @workspace = FactoryBot.create(:workspace)
      @job_role = FactoryBot.create(:job_role)
      @employee = FactoryBot.create(:employee)
      visit employees_path
    end

    it "shows a button to create an Employee" do
      expect(page).to have_content(I18n.t('new.employee'))
    end

    it "takes you to the new_employee_path when the button is clicked" do
      click_link_or_button(I18n.t('new.employee'))
      expect(page).to have_current_path(new_employee_path)
    end

    it "takes you to the show_path when the button Show is clicked" do
      click_link_or_button(I18n.t('links.show'))
      expect(page).to have_current_path(employee_path(@employee.id))
    end

    it "takes you to the edit_path when the button Edit is clicked" do
      click_link_or_button(I18n.t('links.edit'))
      expect(page).to have_current_path(edit_employee_path(@employee.id))
    end

    it "asks and does not perform the delete when the delete-confirm is dismissed" do
      count_before = Employee.count
      dismiss_confirm { click_link_or_button(I18n.t('links.destroy')) }
      sleep 1 # without this, the following lines always succeeds
      expect(Employee.count).to eq(count_before)
    end

    it "asks and performs the delete when the delete-confirm is accepted" do
      count_before = Employee.count
      accept_confirm { click_link_or_button(I18n.t('links.destroy')) }
      sleep 1 # without this, the following lines always fails
      expect(Employee.count).to eq(count_before - 1)
    end
  end
end

