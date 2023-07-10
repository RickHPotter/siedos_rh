require 'rails_helper'

RSpec.describe "EDIT of Employee CRUD", type: :system do
  describe "edit page" do
    before do
      @workspace = FactoryBot.create(:workspace)
      @job_role = FactoryBot.create(:job_role)
      @employee = FactoryBot.create(:employee)
      visit edit_employee_path(@employee)
    end

    it "does not save an existing employee without necessary attributes" do
      fill_in 'employee[full_name]', with: ''

      click_link_or_button(I18n.t('update.employee'))
      Employee.create.errors[:full_name].each do |msg|
        expect(page).to have_content(msg)
      end
    end

    it "does save a new employee with valid filled in attributes" do
      origin_city = @employee.specific_cities.sample
      fill_in "employee[full_name]", with: 'a pascal case name'
      select origin_city, from: 'employee[origin_city]'

      click_link_or_button(I18n.t('update.employee'))

      expect(page).to have_content('A Pascal Case Name')
      expect(page).to have_content(origin_city)
    end
  end
end

