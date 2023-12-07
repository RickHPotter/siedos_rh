# Employee model
class Employee < ApplicationRecord
  include PascalCase
  include Filterable

  # CONSTANTS
  MARITAL_STATUSES = %w[single married widow]
  SEXES = %w[masculine feminine]
  CEP = Cep.instance

  has_many :contacts, inverse_of: :employee
  accepts_nested_attributes_for :contacts, reject_if: :all_blank, allow_destroy: true

  # VALIDATIONS
  belongs_to :workspace
  belongs_to :job_role

  validate :minimum_age
  validate :cep_validations

  validates :id, presence: true, uniqueness: true, format: {
    with: /\A\d+\z/, message: I18n.t('errors.invalid')
  }, length: { minimum: 1, maximum: 8 }

  validates :full_name, presence: true, length: { in: 8..36 }
  validates :origin_city, inclusion: {
    in: CEP.cities, message: :inclusion, allow_blank: true
  }
  validates :home_state, inclusion: {
    in: CEP.states, message: :inclusion, allow_blank: true
  }
  validates :marital_status, inclusion: {
    in: MARITAL_STATUSES, message: :inclusion, allow_blank: true
  }
  validates :sex, inclusion: {
    in: SEXES, message: :inclusion, allow_blank: true
  }
  validates :job_role_id, uniqueness: { scope: :workspace_id }

  # SEARCH
  scope :filter_by_id_name, lambda { |id_name|
    return unless id_name.present?

    id = id_name.to_i
    id = id > 0 ? "id = #{id} or" : ''
    where("#{id} lower(full_name) LIKE ?", "%#{id_name.downcase}%")
  }
  scope :filter_by_sex, ->(sex) { where sex: sex if sex.present? }
  scope :filter_by_workspace_id, ->(id) { where workspace_id: id if id.present? }
  scope :filter_by_job_role_id, ->(id) { where job_role_id: id if id.present? }

  def marital_status_label
    I18n.t("employee.marital_statuses.#{marital_status}")
  end

  def sex_label
    I18n.t("employee.sexes.#{sex}")
  end

  private

  def minimum_age
    return unless date_of_birth.present?

    age = (Time.zone.now - date_of_birth.to_time) / 1.year
    return unless age < 14

    errors.add(:date_of_birth, I18n.t('errors.too_young'))
  end

  def city_state_validations
    errors.add(:origin_city, I18n.t('errors.invalid')) unless CEP.does_city_exist?
    errors.add(:home_state, I18n.t('errors.invalid')) unless CEP.does_state_exist?
    errors.add(:origin_city, I18n.t('errors.city_not_in_state')) unless CEP.does_city_belong?
  end

  def cep_validations
    return unless origin_city.present? && home_state.present?

    CEP.city = origin_city
    CEP.state = home_state
    city_state_validations
  end
end
