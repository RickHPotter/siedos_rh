module SharedModelSpecs
  RSpec.shared_examples "a valid model" do
    # Best-Case-Scenario
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    # model validation specs
    it "is not valid without title" do
      not_null(subject, :title)
    end

    it "validates length of title (3 .. 36)" do
      validate_length(subject, :title, 3, 36)
    end

    it "validates the uniqueness of title" do
      opt = { :title => "A Random Title" }
      unique(subject, [opt])
    end

  end
end

