# Model that subjects all other models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
