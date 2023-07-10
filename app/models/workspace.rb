# Workspace model
class Workspace < ApplicationRecord
  include PascalCase

  has_many :employees
  validates :title, presence: true, uniqueness: true, length: { in: 3..36 }

  scope :all_available, -> {
    joins('LEFT OUTER JOIN employees ON employees.workspace_id = workspaces.id')
      .group('workspaces.id')
      .having('COUNT(employees.id) < ?', JobRole.all.count)
  }
end

