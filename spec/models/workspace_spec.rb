require 'rails_helper'

RSpec.describe Workspace do
  let!(:subject) { FactoryBot.create(:workspace) }
  let!(:helper) { FactoryBot.create(:workspace) }

  include_examples "a valid model"
end

