require 'rails_helper'

RSpec.describe "READ(S) of Employee CRUD", type: :system do
  describe "index page" do
    before do
      @workspace = FactoryBot.create(:workspace)
      @job_role = FactoryBot.create(:job_role)
      @employee = FactoryBot.create(:employee)
      visit employees_path
    end

    it "searches using the id_name input search" do
      fill_in 'id_name', with: '0\a@%@ROE34@342k3jskd'
      click_link_or_button('search_button')
      expect(page).to_not have_css('tbody > tr')

      fill_in 'id_name', with: @employee.full_name[1..4]
      click_link_or_button('search_button')
      expect(page).to have_css('tbody > tr', minimum: 1)
    end

    it "searches using the id_name input search and sex" do
      fill_in 'id_name', with: @employee.full_name[1..4]
      select @employee.sex_label, from: 'sex'
      click_link_or_button('search_button')

      expect(page).to have_css('tbody > tr', minimum: 1)
      expect(page).to have_content(@employee.full_name)
    end

    it "searches using the id_name input search and sex and w_id" do
      fill_in 'id_name', with: @employee.full_name[1..4]
      select @employee.sex_label, from: 'sex'
      select @employee.workspace.title, from: 'workspace_id'
      click_link_or_button('search_button')

      expect(page).to have_css('tbody > tr', minimum: 1)
      expect(page).to have_content(@employee.full_name)
    end

    it "searches using the id_name input search and sex and w_id and jr_id" do
      fill_in 'id_name', with: @employee.full_name[1..4]
      select @employee.sex_label, from: 'sex'
      select @employee.workspace.title, from: 'workspace_id'
      select @employee.job_role.title, from: 'job_role_id'
      click_link_or_button('search_button')

      expect(page).to have_css('tbody > tr', minimum: 1)
      expect(page).to have_content(@employee.full_name)
    end
  end
end
