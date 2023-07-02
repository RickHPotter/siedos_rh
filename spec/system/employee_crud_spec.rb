require 'rails_helper'

RSpec.describe "Employee CRUD", type: :system do
  describe "index page" do
    it "shows a button to create an Employee" do
      visit employees_path
      expect(page).to have_content(I18n.t('new.employee'))
    end
  end
end

