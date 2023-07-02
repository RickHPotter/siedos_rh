# yeah, i get it, ironic that pascal_case.rb is in SnakeCase.
module PascalCase
  extend ActiveSupport::Concern

  included do
    before_validation :pascal_case

    def pascal_case
      if respond_to?(:title) && title.present?
        self.title = apply_pascal_case(title)
      elsif respond_to?(:full_name) && full_name.present?
        self.full_name = apply_pascal_case(full_name)
      end
    end

    def apply_pascal_case(field)
      field = field.gsub(/([_\&\/\\-])/) { ' ' + $1 + ' ' }.split.map(&:capitalize).join(' ')
    end
  end

end

