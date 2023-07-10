# Job Role model
class JobRole < ApplicationRecord
  include PascalCase

  has_many :employees
  validates :title, presence: true, uniqueness: true, length: { in: 3..36 }
end
