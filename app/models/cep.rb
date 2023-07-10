require 'singleton'

# PORO CEP Class for handling states and cities
class Cep
  include Singleton

  attr_accessor :states_and_cities, :state, :city

  def initialize
    @states_and_cities = YAML
      .load_file(Rails.root.join('config', 'states_and_cities.yml'))['estados']
    @state = nil
    @city = nil
  end

  def cities
    states_and_cities.flat_map { |state| state['cidades'] }  
  end

  def states
    states_and_cities.map { |state| state['sigla'] }  
  end

  def specific_cities
    available_states = states
    if (available_states.include? state)
      states_hash = states_and_cities.find do |state_hash|
        state_hash['sigla'] == state
      end
      return states_hash['cidades']
    end
    return []
  end

  def does_state_exist?
    states.include? state 
  end

  def does_city_exist?
    cities.include? city 
  end

  def does_city_belong?
    specific_cities.include? city
  end
end

