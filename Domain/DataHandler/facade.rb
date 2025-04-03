require 'json'

module Facade
  # Get taxes that apply to the item
  def get_relevant_taxes(item)
    @config["taxes"].select { |tax| applies?(tax["condition"], item) }
  end

  # Get modifications that apply to the item for a specific tax type
  def get_relevant_modifications(item, tax_type)
    @config["modifications"].select do |mod|
      mod["affected_tax"] == tax_type && applies?(mod["condition"], item)
    end
  end

  # Get the base rate for a tax type
  def get_rate(tax_type)
    @config["rates"][tax_type] || 0.0
  end

  private

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