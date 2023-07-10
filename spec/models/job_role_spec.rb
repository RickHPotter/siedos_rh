require 'rails_helper'

RSpec.describe JobRole do
  let!(:subject) { FactoryBot.create(:job_role) }
  let!(:helper) { FactoryBot.create(:job_role) }

  include_examples "a valid model"
end

