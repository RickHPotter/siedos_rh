# Shared Model Specs for DRYing out both Job Role and Workspace
module SharedModelSpecs
  RSpec.shared_examples "a valid model" do
    # Best-Case-Scenario
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    # model validation specs
    it "is not valid without title" do
      validate_null_blank(subject, :title)
    end

    it "validates length of title (3 .. 36)" do
      validate_length(subject, :title, [3, 36])
    end

    it "validates the uniqueness of title" do
      unique(subject, helper, { :title => subject.title })
    end

  end
end

