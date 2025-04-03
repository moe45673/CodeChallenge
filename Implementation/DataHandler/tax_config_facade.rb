require 'json'

class TaxConfigFacade
  include Facade
  def initialize(config_path)
    @config_path = config_path
    @config = JSON.parse(File.read(config_path))
  end

  # Get taxes that apply to the item
  def get(item)
    taxes = @config["taxes"].select { |tax| applies?(tax["condition"], item) } 
    rates = config["rates"]
    taxes.map do |tax|
      {
        "type" => tax["type"],
        "rate" => rates[tax["type"]] || 0.0,
        "condition" => tax["condition"]
      }
  end

  # Get modifications that apply to the item for a specific tax type
  def get(item, tax_type)
    @config["modifications"].select do |mod|
      mod["affected_tax"] == tax_type && applies?(mod["condition"], item)
    end
  end

  protected

  # Check if a condition applies to an item
  def applies?(condition, item)
    key = condition["key"]
    return true if key == "always"
    expected_value = condition["value"]
    actual_value = item[key]
    normalized_expected = normalize(expected_value)
    normalized_actual = normalize(actual_value)
    if actual_value.is_a?(Array)
      (normalized_actual & normalized_expected).any?
    else
      Array(normalized_expected).include?(normalized_actual)
    end
  end

  # Normalize values for consistent comparison
  def normalize(item)
    if item.is_a?(Array)
      item.map { |v| normalize(v) }
    else
      item.to_s.downcase
    end
  end
end