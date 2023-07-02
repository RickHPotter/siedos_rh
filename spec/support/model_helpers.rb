module ModelHelpers
  def not_null(subject, attribute)
    subject[attribute] = nil
    expect(subject).to_not be_valid

    # I suppose we should consider blank as null
    subject[attribute] = " " * 8
    expect(subject).to_not be_valid
  end

  def unique(subject, fields)
    fields.each do |hash|
      hash.each { |attribute, value| subject[attribute] = value }
    end
    subject.save
    expect(subject).to be_valid

    duplicate = subject.dup
    duplicate.save
    expect(duplicate).to_not be_valid
  end

  def validate_length(subject, attribute, min_length, max_length)
    subject[attribute] = 'x' * (min_length - 1)
    expect(subject).to_not be_valid

    subject[attribute] = 'x' * min_length
    expect(subject).to be_valid

    subject[attribute] = 'x' * (max_length + 1)
      expect(subject).to_not be_valid

      subject[attribute] = 'x' * max_length
      expect(subject).to be_valid
    end
  end

