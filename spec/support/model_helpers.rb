# Model Helpers for validations that go accross, pretty much, every model, DRY
module ModelHelpers
  
  def validate_null_blank(subject, attribute)
    not_null(subject, attribute)
    not_blank(subject, attribute)
  end

  def unique(subject, helper, fields)
    fields.each do |attribute, value|
      subject[attribute] = value
      helper[attribute] = value
    end
    should_be_valid(subject)
    should_not_be_valid(helper)
  end

  def validate_length(subject, attribute, range)
    range.each do |len|
      subject[attribute] = 'x' * (len)
      expect(subject).to be_valid
    end
  end

  private

  def should_be_valid(subject)
    subject.save
    expect(subject).to be_valid
  end

  def should_not_be_valid(subject)
    subject.save
    expect(subject).to_not be_valid
  end

  def not_blank(subject, attribute)
    subject[attribute] = " " * 8
    expect(subject).to_not be_valid
  end

  def not_null(subject, attribute)
    subject[attribute] = nil
    expect(subject).to_not be_valid
    not_blank(subject, attribute)
  end
end

