require 'rails_helper'

RSpec.describe Workspace do
  subject {
    described_class.new(
      title: "This name is 31 characters long",
    )
  }

  include_examples "a valid model"
end

