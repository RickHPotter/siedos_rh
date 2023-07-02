class Employee < ApplicationRecord
  include PascalCase

  # CONSTANTS
  MARITAL_STATUSES = [ 'single', 'married', 'widow' ]
  SEXES = [ 'masculine', 'feminine' ]
  STATES_AND_CITIES = YAML.load_file(Rails.root.join('config', 'states_and_cities.yml'))['estados']

  # VALIDATIONS
  belongs_to :workspace
  belongs_to :job_role
  validate :not_younger_than_14
  validate :city_should_belong_to_state

  validates :full_name, presence: true, length: { in: 8..36 }
  validates :origin_city, inclusion: {
    in: :cities, message: :inclusion
  }
  validates :home_state, inclusion: {
    in: :states, message: :inclusion
  }
  validates :marital_status, inclusion: {
    in: MARITAL_STATUSES, message: :inclusion
  }
  validates :sex, inclusion: {
    in: SEXES, message: :inclusion
  }
  validates :job_role_id, uniqueness: { scope: :workspace_id }

  # SEARCH
  scope :filter_by, -> (conditions) {
    filter_by_id_or_name(conditions[:id_name])
      .filter_by_sex(conditions[:sex])
      .filter_by_workspace_id(conditions[:workspace_id])
      .filter_by_job_role_id(conditions[:job_role_id])
  }
  scope :filter_by_id_or_name, -> (id_name) {
    where("id = ? or lower(full_name) LIKE ?", id_name.to_i, "%#{id_name.downcase}%")
  }
  scope :filter_by_sex, -> (sex) { where sex: sex if sex.present? }
  scope :filter_by_workspace_id, -> (id) { where workspace_id: id if id.present? }
  scope :filter_by_job_role_id, -> (id) { where job_role_id: id if id.present? }

  def cities
    # TODO: look for cookies first
    STATES_AND_CITIES.flat_map { |state| state['cidades'] }  
  end

  def specific_cities
    states = STATES_AND_CITIES.find do |state|
      state['sigla'] == home_state
    end
    states['cidades']
  end

  def states
    STATES_AND_CITIES.map { |state| state['sigla'] }  
  end

  def marital_status_label
    I18n.t("employee.marital_statuses.#{marital_status}")
  end

  def sex_label
    I18n.t("employee.sexes.#{sex}")
  end

  private

  def not_younger_than_14
    return unless date_of_birth.present?

    age = (Time.zone.now - date_of_birth.to_time) / 1.year
    if age < 14 
      errors.add(:date_of_birth, I18n.t('errors.too_young'))
    end
  end

  def city_should_belong_to_state
    return unless origin_city.present? && home_state.present?

    cities_of_state = specific_cities
    if cities_of_state.nil?
      errors.add(:home_state, I18n.t('errors.invalid_state'))
    else
      if cities_of_state.exclude? origin_city
        errors.add(:origin_city, I18n.t('errors.city_not_in_state'))
      end
    end

  end
end

